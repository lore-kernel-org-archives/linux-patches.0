Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFE01F76AA;
	Tue,  3 Dec 2024 15:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238768; cv=none; b=RJT8gWPb3zJxqiRCKeQn60A3pJZT2vVcp8cxhJo+nzwVUUfsrebPtmOJwy77ZUfJObgtZ9GtW1MsIC1VIhwxp2Lnh3CnrRTu/6+EEriNsTd0Wx6q2ZQslOPnynQbS9oPM3nC4VQBNN8u88m156QEI1tzbbv7To3aaf5N6vwwcVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238768; c=relaxed/simple;
	bh=wbmhcT6MEXv6mat0eFYGVXZikLGgmk7zeAzWa6UukK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcZeUCbSuUUfC07fuJ1j61fQqJUw+6wmbWr7hw8O2DdFSVmECVtAwqDW8XvVXFIq7782xQqfq28kO8NUvkzMbQLxdsb4KaLzI6lKnMpcHA1brzH6R9fTWJ1VOHJp57ZFZ/4XIqxtUCs7gWq7zMore8UcLraiUv0+rIhfTwph78k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZoWSnmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZoWSnmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08215C4CECF;
	Tue,  3 Dec 2024 15:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238768;
	bh=wbmhcT6MEXv6mat0eFYGVXZikLGgmk7zeAzWa6UukK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZoWSnmLSlu5xMl5HnHxs2FB2XJdc9ixjW+bcFxBNS6t7kBPKaigxTNoxqa764sT6
	 +g5nMlwmCG7XOLSd0H+wzMS6vbqelkuefsl7s+791mgHiUL2VlINsk41DELjbqF3u9
	 s8VMWw5Pirffm76/IsvH6YQQZUNskAXCVXau94jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 391/817] irqdomain: Simplify simple and legacy domain creation
Date: Tue,  3 Dec 2024 15:39:23 +0100
Message-ID: <20241203144011.133460175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 70114e7f7585ef078c2b7033ee14218f95f55e22 ]

irq_domain_create_simple() and irq_domain_create_legacy() use
__irq_domain_instantiate(), but have extra handling of allocating interrupt
descriptors and associating interrupts in them. Some of that is duplicated.

There are also call sites which have conditonals to invoke different
interrupt domain creator functions, where one of them is usually
irq_domain_create_legacy(). Alternatively they associate the interrupts for
the legacy case after creating the domain.

Moving the extra logic of irq_domain_create_simple()/legacy() into
__irq_domain_instantiate() allows to consolidate that.

Introduce hwirq_base and virq_base members in the irq_domain_info
structure, which allows to transport the required information and add the
conditional interrupt descriptor allocation and interrupt association into
__irq_domain_instantiate().

This reduces irq_domain_create_legacy() and irq_domain_create_simple() to
trivial wrappers which fill in the info structure and allows call sites
which must support the legacy case along with more modern mechanism to
select the domain type via the parameters of the info struct.

[ tglx: Massaged change log ]

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/32d07bd79eb2b5416e24da9e9e8fe5955423dcf9.1723120028.git.mazziesaccount@gmail.com
Stable-dep-of: 3727c0b4ff6b ("mfd: intel_soc_pmic_bxtwc: Fix IRQ domain names duplication")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h |  5 +++
 kernel/irq/irqdomain.c    | 74 ++++++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index de6105f68fecd..bfcffa2c7047a 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -291,6 +291,9 @@ struct irq_domain_chip_generic_info;
  * @hwirq_max:		Maximum number of interrupts supported by controller
  * @direct_max:		Maximum value of direct maps;
  *			Use ~0 for no limit; 0 for no direct mapping
+ * @hwirq_base:		The first hardware interrupt number (legacy domains only)
+ * @virq_base:		The first Linux interrupt number for legacy domains to
+ *			immediately associate the interrupts after domain creation
  * @bus_token:		Domain bus token
  * @ops:		Domain operation callbacks
  * @host_data:		Controller private data pointer
@@ -307,6 +310,8 @@ struct irq_domain_info {
 	unsigned int				size;
 	irq_hw_number_t				hwirq_max;
 	int					direct_max;
+	unsigned int				hwirq_base;
+	unsigned int				virq_base;
 	enum irq_domain_bus_token		bus_token;
 	const struct irq_domain_ops		*ops;
 	void					*host_data;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cea8f6874b1fb..7625e424f85a6 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -267,13 +267,20 @@ static void irq_domain_free(struct irq_domain *domain)
 	kfree(domain);
 }
 
-/**
- * irq_domain_instantiate() - Instantiate a new irq domain data structure
- * @info: Domain information pointer pointing to the information for this domain
- *
- * Return: A pointer to the instantiated irq domain or an ERR_PTR value.
- */
-struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
+static void irq_domain_instantiate_descs(const struct irq_domain_info *info)
+{
+	if (!IS_ENABLED(CONFIG_SPARSE_IRQ))
+		return;
+
+	if (irq_alloc_descs(info->virq_base, info->virq_base, info->size,
+			    of_node_to_nid(to_of_node(info->fwnode))) < 0) {
+		pr_info("Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
+			info->virq_base);
+	}
+}
+
+static struct irq_domain *__irq_domain_instantiate(const struct irq_domain_info *info,
+						   bool cond_alloc_descs)
 {
 	struct irq_domain *domain;
 	int err;
@@ -306,6 +313,15 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 
 	__irq_domain_publish(domain);
 
+	if (cond_alloc_descs && info->virq_base > 0)
+		irq_domain_instantiate_descs(info);
+
+	/* Legacy interrupt domains have a fixed Linux interrupt number */
+	if (info->virq_base > 0) {
+		irq_domain_associate_many(domain, info->virq_base, info->hwirq_base,
+					  info->size - info->hwirq_base);
+	}
+
 	return domain;
 
 err_domain_gc_remove:
@@ -315,6 +331,17 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 	irq_domain_free(domain);
 	return ERR_PTR(err);
 }
+
+/**
+ * irq_domain_instantiate() - Instantiate a new irq domain data structure
+ * @info: Domain information pointer pointing to the information for this domain
+ *
+ * Return: A pointer to the instantiated irq domain or an ERR_PTR value.
+ */
+struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
+{
+	return __irq_domain_instantiate(info, false);
+}
 EXPORT_SYMBOL_GPL(irq_domain_instantiate);
 
 /**
@@ -413,28 +440,13 @@ struct irq_domain *irq_domain_create_simple(struct fwnode_handle *fwnode,
 		.fwnode		= fwnode,
 		.size		= size,
 		.hwirq_max	= size,
+		.virq_base	= first_irq,
 		.ops		= ops,
 		.host_data	= host_data,
 	};
-	struct irq_domain *domain;
-
-	domain = irq_domain_instantiate(&info);
-	if (IS_ERR(domain))
-		return NULL;
+	struct irq_domain *domain = __irq_domain_instantiate(&info, true);
 
-	if (first_irq > 0) {
-		if (IS_ENABLED(CONFIG_SPARSE_IRQ)) {
-			/* attempt to allocated irq_descs */
-			int rc = irq_alloc_descs(first_irq, first_irq, size,
-						 of_node_to_nid(to_of_node(fwnode)));
-			if (rc < 0)
-				pr_info("Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
-					first_irq);
-		}
-		irq_domain_associate_many(domain, first_irq, 0, size);
-	}
-
-	return domain;
+	return IS_ERR(domain) ? NULL : domain;
 }
 EXPORT_SYMBOL_GPL(irq_domain_create_simple);
 
@@ -476,18 +488,14 @@ struct irq_domain *irq_domain_create_legacy(struct fwnode_handle *fwnode,
 		.fwnode		= fwnode,
 		.size		= first_hwirq + size,
 		.hwirq_max	= first_hwirq + size,
+		.hwirq_base	= first_hwirq,
+		.virq_base	= first_irq,
 		.ops		= ops,
 		.host_data	= host_data,
 	};
-	struct irq_domain *domain;
+	struct irq_domain *domain = irq_domain_instantiate(&info);
 
-	domain = irq_domain_instantiate(&info);
-	if (IS_ERR(domain))
-		return NULL;
-
-	irq_domain_associate_many(domain, first_irq, first_hwirq, size);
-
-	return domain;
+	return IS_ERR(domain) ? NULL : domain;
 }
 EXPORT_SYMBOL_GPL(irq_domain_create_legacy);
 
-- 
2.43.0



