Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E3736B923;
	Sat, 12 Sep 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238745; cv=none; b=feO0WfnwD/K8VcI19oBc9CIuTU7DBVjt1qD8yzZVHUWHttbhgPynKNvATg/3f0c1Qwzjs/u9W6r5zK4ft1RTnf8kh3pIkQ9fCkAeVPgDuWmoiFIUEsIDRXvOT5sWMhvKmm9TbsZhGCt1ruDyFM1v79nf6pcSxfdNnjmyZXvY1H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238745; c=relaxed/simple;
	bh=0R8dP5EVV8LHul2cxO9p2+kiWj8jwt7uB4OXSYoFnyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpGAJLTLwzZvXz7Scjolzt5gf4gvz9hzrnmGsC6VS7wMyx5Y4VFUR7buuUC3Cbd4NGZ0ZNyg5BRUO6V7o37yIlIVlUOnJVjPD0AuLjqL/k/YqucNyt63PpchrtOeu5OXD7prDV+ReLj8iju1wqkix/W7iEmr+u8f6R5S80UN9fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLwDNn8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLwDNn8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7E21F000FF;
	Sat, 12 Sep 2026 18:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238744;
	bh=EIcCSvKq7khHTMocNb20pbUl5AN56WdJAeSkBFwA8+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLwDNn8js3HwJQWhHx0qNQHnjrAE20Fnz2CoN4tTFr9mlx/1oKKb+OpqZkeLAr2hv
	 K6UaqJa7vErh6rxSpZAQWi7jzYs0vWmgaEt7WJC6EYG8JSXTHhDfpE7vdlNFjwVpfq
	 TPnMU9ggwXXy38Wn9WeumZgW98AQpRlA2QLnIg+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 523/935] irqdomain: Introduce irq_domain_instantiate()
Date: Sat, 12 Sep 2026 08:59:13 +0200
Message-ID: <20260912065538.818828317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 299d623f5c9ab48e53255cf6b510627f1ef26dfe ]

The existing irq_domain_add_*() functions used to instantiate an IRQ
domain are wrappers built on top of __irq_domain_add() and describe the
domain properties using a bunch of parameters.

Adding more parameters and wrappers to hide new parameters in the
existing code lead to more and more code without any relevant value and
without any flexibility.

Introduce irq_domain_instantiate() where the interrupt domain properties
are given using a irq_domain_info structure instead of the bunch of
parameters to allow flexibility and easy evolution.

irq_domain_instantiate() performs the same operation as the one done by
__irq_domain_add(). For compatibility reason with existing code, keep
__irq_domain_add() but convert it to irq_domain_instantiate().

[ tglx: Fixed up struct initializer coding style ]

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-3-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h | 21 +++++++++++++++++++++
 kernel/irq/irqdomain.c    | 39 ++++++++++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index a7c80bd4b45b6..c3ef4ce5c9f80 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -261,6 +261,27 @@ static inline struct fwnode_handle *irq_domain_alloc_fwnode(phys_addr_t *pa)
 }
 
 void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
+/**
+ * struct irq_domain_info - Domain information structure
+ * @fwnode:		firmware node for the interrupt controller
+ * @size:		Size of linear map; 0 for radix mapping only
+ * @hwirq_max:		Maximum number of interrupts supported by controller
+ * @direct_max:		Maximum value of direct maps;
+ *			Use ~0 for no limit; 0 for no direct mapping
+ * @ops:		Domain operation callbacks
+ * @host_data:		Controller private data pointer
+ */
+struct irq_domain_info {
+	struct fwnode_handle			*fwnode;
+	unsigned int				size;
+	irq_hw_number_t				hwirq_max;
+	int					direct_max;
+	const struct irq_domain_ops		*ops;
+	void					*host_data;
+};
+
+struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info);
+
 struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
 				    irq_hw_number_t hwirq_max, int direct_max,
 				    const struct irq_domain_ops *ops,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index be9f67647595a..7ae53e4534cee 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -238,6 +238,27 @@ static void irq_domain_free(struct irq_domain *domain)
 	kfree(domain);
 }
 
+/**
+ * irq_domain_instantiate() - Instantiate a new irq domain data structure
+ * @info: Domain information pointer pointing to the information for this domain
+ *
+ * Return: A pointer to the instantiated irq domain or an ERR_PTR value.
+ */
+struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
+{
+	struct irq_domain *domain;
+
+	domain = __irq_domain_create(info->fwnode, info->size, info->hwirq_max,
+				     info->direct_max, info->ops, info->host_data);
+	if (!domain)
+		return ERR_PTR(-ENOMEM);
+
+	__irq_domain_publish(domain);
+
+	return domain;
+}
+EXPORT_SYMBOL_GPL(irq_domain_instantiate);
+
 /**
  * __irq_domain_add() - Allocate a new irq_domain data structure
  * @fwnode: firmware node for the interrupt controller
@@ -256,14 +277,18 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int s
 				    const struct irq_domain_ops *ops,
 				    void *host_data)
 {
-	struct irq_domain *domain;
-
-	domain = __irq_domain_create(fwnode, size, hwirq_max, direct_max,
-				     ops, host_data);
-	if (domain)
-		__irq_domain_publish(domain);
+	struct irq_domain_info info = {
+		.fwnode		= fwnode,
+		.size		= size,
+		.hwirq_max	= hwirq_max,
+		.direct_max	= direct_max,
+		.ops		= ops,
+		.host_data	= host_data,
+	};
+	struct irq_domain *d;
 
-	return domain;
+	d = irq_domain_instantiate(&info);
+	return IS_ERR(d) ? NULL : d;
 }
 EXPORT_SYMBOL_GPL(__irq_domain_add);
 
-- 
2.53.0



