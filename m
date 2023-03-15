Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594844431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF723C433EF;
	Wed, 15 Mar 2023 12:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882662;
	bh=t+Fer+gp/7xRdpsGbObZHt8+dGZ4jl1LLVoM7K52w/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khuzf3s9qwhA01sugwQInrRHue8W37B3p9dOYYz+OhrircOtuTn6R7TW3YvBh94kU
	 upDNElCRIPLWKnIlWkKlZQrayZgB3voqDOH7PMTACZbO+EEgJXHR2KlzYjBjJ/wF9p
	 VwTM0j5CHiuN87cH3K8np02yFE5kzsei0bOD62II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/68] irqdomain: Fix domain registration race
Date: Wed, 15 Mar 2023 13:12:17 +0100
Message-Id: <20230315115727.003327727@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 8932c32c3053accd50702b36e944ac2016cd103c ]

Hierarchical domains created using irq_domain_create_hierarchy() are
currently added to the domain list before having been fully initialised.

This specifically means that a racing allocation request might fail to
allocate irq data for the inner domains of a hierarchy in case the
parent domain pointer has not yet been set up.

Note that this is not really any issue for irqchip drivers that are
registered early (e.g. via IRQCHIP_DECLARE() or IRQCHIP_ACPI_DECLARE())
but could potentially cause trouble with drivers that are registered
later (e.g. modular drivers using IRQCHIP_PLATFORM_DRIVER_BEGIN(),
gpiochip drivers, etc.).

Fixes: afb7da83b9f4 ("irqdomain: Introduce helper function irq_domain_add_hierarchy()")
Cc: stable@vger.kernel.org      # 3.19
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ johan: add commit message ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-8-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 62 +++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cfb5a96f023f7..d40ae18fe6617 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -114,23 +114,12 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(irq_domain_free_fwnode);
 
-/**
- * __irq_domain_add() - Allocate a new irq_domain data structure
- * @fwnode: firmware node for the interrupt controller
- * @size: Size of linear map; 0 for radix mapping only
- * @hwirq_max: Maximum number of interrupts supported by controller
- * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
- *              direct mapping
- * @ops: domain callbacks
- * @host_data: Controller private data pointer
- *
- * Allocates and initializes an irq_domain structure.
- * Returns pointer to IRQ domain, or NULL on failure.
- */
-struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
-				    irq_hw_number_t hwirq_max, int direct_max,
-				    const struct irq_domain_ops *ops,
-				    void *host_data)
+static struct irq_domain *__irq_domain_create(struct fwnode_handle *fwnode,
+					      unsigned int size,
+					      irq_hw_number_t hwirq_max,
+					      int direct_max,
+					      const struct irq_domain_ops *ops,
+					      void *host_data)
 {
 	struct device_node *of_node = to_of_node(fwnode);
 	struct irqchip_fwid *fwid;
@@ -222,12 +211,44 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int s
 	domain->revmap_direct_max_irq = direct_max;
 	irq_domain_check_hierarchy(domain);
 
+	return domain;
+}
+
+static void __irq_domain_publish(struct irq_domain *domain)
+{
 	mutex_lock(&irq_domain_mutex);
 	debugfs_add_domain_dir(domain);
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 
 	pr_debug("Added domain %s\n", domain->name);
+}
+
+/**
+ * __irq_domain_add() - Allocate a new irq_domain data structure
+ * @fwnode: firmware node for the interrupt controller
+ * @size: Size of linear map; 0 for radix mapping only
+ * @hwirq_max: Maximum number of interrupts supported by controller
+ * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
+ *              direct mapping
+ * @ops: domain callbacks
+ * @host_data: Controller private data pointer
+ *
+ * Allocates and initializes an irq_domain structure.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
+				    irq_hw_number_t hwirq_max, int direct_max,
+				    const struct irq_domain_ops *ops,
+				    void *host_data)
+{
+	struct irq_domain *domain;
+
+	domain = __irq_domain_create(fwnode, size, hwirq_max, direct_max,
+				     ops, host_data);
+	if (domain)
+		__irq_domain_publish(domain);
+
 	return domain;
 }
 EXPORT_SYMBOL_GPL(__irq_domain_add);
@@ -1068,12 +1089,15 @@ struct irq_domain *irq_domain_create_hierarchy(struct irq_domain *parent,
 	struct irq_domain *domain;
 
 	if (size)
-		domain = irq_domain_create_linear(fwnode, size, ops, host_data);
+		domain = __irq_domain_create(fwnode, size, size, 0, ops, host_data);
 	else
-		domain = irq_domain_create_tree(fwnode, ops, host_data);
+		domain = __irq_domain_create(fwnode, 0, ~0, 0, ops, host_data);
+
 	if (domain) {
 		domain->parent = parent;
 		domain->flags |= flags;
+
+		__irq_domain_publish(domain);
 	}
 
 	return domain;
-- 
2.39.2



