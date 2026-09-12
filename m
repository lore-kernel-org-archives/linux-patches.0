Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E7F331EC0;
	Sat, 12 Sep 2026 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223366; cv=none; b=Ma/3x9mPyL6zTR/tcq9THvj9q2yXfQL/bRoNggXMg+odqPbdS2z1sXu4sZc2YB1BRxM1ZCDdKUEgiDk8z81lCd24fwn/akEaVyJ/XY/B8ma0euD4fsmdJjNKdLKxYvztyJh3Qf0582DoUL8tTX9pbLdbqGDphBDXr9MQc6AGbQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223366; c=relaxed/simple;
	bh=s+J1dvAyWXUk3PCql6VjD1td0U+KRiHJGMqpeb0DP8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1mOXLpe0dgp6BWTX6DO2vzTWZ8ofol5jSGMK3WpGAw4WlDUK2kAlihyKgmPq88HM7Nar9l4/WBRSIMtkve8YQ3Brmq5yQDHS4WZpnBROZotbIw6M9SQVlM2xWADeevZxE11+3Ew4Mh21xLmJdJZzDPmebHbjNy3xmDWEtJ06EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHGTcfJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHGTcfJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031451F000FF;
	Sat, 12 Sep 2026 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223361;
	bh=7Y59Zc1FQkgdr4xxRae+3bXxzMCK2y9esgcmYj4xUSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHGTcfJH3y0aGLWmEmEibCU9S4BDjnRUFoTncDmZk/m5Ipi6CsIcp8kyh0yQ6ahwp
	 eQKmGSnua35oDn8B2HZkZ5RVTemmigV5ad/gFVGy4MUAi7z4/Nu9pR37EYoqpeu/NO
	 B7e5J/huf3BW3k1Nwx68gmVcSHmie5AdtiBOh5yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0767/1424] irqdomain: Add support for generic irq chips creation before publishing a domain
Date: Sat, 12 Sep 2026 08:53:19 +0200
Message-ID: <20260912065624.472554015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit e6f67ce32e8e6dcbadf42dc435fbc9002cabf1f9 ]

The current API functions create an irq_domain and also publish this
newly created to domain. Once an irq_domain is published, consumers can
request IRQ in order to use them.

Some interrupt controller drivers have to perform some more operations
with the created irq_domain in order to have it ready to be used.
For instance:
   - Allocate generic irq chips with irq_alloc_domain_generic_chips()
   - Retrieve the generic irq chips with irq_get_domain_generic_chip()
   - Initialize retrieved chips: set register base address and offsets,
     set several hooks such as irq_mask, irq_unmask, ...

With the newly introduced irq_domain_alloc_generic_chips(), an interrupt
controller driver can use the irq_domain_chip_generic_info structure and
set the init() hook to perform its generic chips initialization.

In order to avoid a window where the domain is published but not yet
ready to be used, handle the generic chip creation (i.e the
irq_domain_alloc_generic_chips() call) before the domain is published.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-16-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h |  9 +++++++++
 kernel/irq/irqdomain.c    | 14 +++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 386d7b0bcc5c5..4b7cbaeeff948 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -210,6 +210,9 @@ enum {
 	/* Irq domain is a MSI device domain */
 	IRQ_DOMAIN_FLAG_MSI_DEVICE	= (1 << 9),
 
+	/* Irq domain must destroy generic chips when removed */
+	IRQ_DOMAIN_FLAG_DESTROY_GC	= (1 << 10),
+
 	/*
 	 * Flags starting from IRQ_DOMAIN_FLAG_NONCORE are reserved
 	 * for implementation specific purposes and ignored by the
@@ -259,6 +262,9 @@ static inline struct fwnode_handle *irq_domain_alloc_fwnode(phys_addr_t *pa)
 }
 
 void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
+
+struct irq_domain_chip_generic_info;
+
 /**
  * struct irq_domain_info - Domain information structure
  * @fwnode:		firmware node for the interrupt controller
@@ -269,6 +275,8 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
  *			Use ~0 for no limit; 0 for no direct mapping
  * @ops:		Domain operation callbacks
  * @host_data:		Controller private data pointer
+ * @dgc_info:		Geneneric chip information structure pointer used to
+ *			create generic chips for the domain if not NULL.
  * @init:		Function called when the domain is created.
  *			Allow to do some additional domain initialisation.
  * @exit:		Function called when the domain is destroyed.
@@ -288,6 +296,7 @@ struct irq_domain_info {
 	 */
 	struct irq_domain			*parent;
 #endif
+	struct irq_domain_chip_generic_info	*dgc_info;
 	int					(*init)(struct irq_domain *d);
 	void					(*exit)(struct irq_domain *d);
 };
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7bb8c5a5856a1..11af2877e7523 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -271,16 +271,25 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 	}
 #endif
 
+	if (info->dgc_info) {
+		err = irq_domain_alloc_generic_chips(domain, info->dgc_info);
+		if (err)
+			goto err_domain_free;
+	}
+
 	if (info->init) {
 		err = info->init(domain);
 		if (err)
-			goto err_domain_free;
+			goto err_domain_gc_remove;
 	}
 
 	__irq_domain_publish(domain);
 
 	return domain;
 
+err_domain_gc_remove:
+	if (info->dgc_info)
+		irq_domain_remove_generic_chips(domain);
 err_domain_free:
 	irq_domain_free(domain);
 	return ERR_PTR(err);
@@ -348,6 +357,9 @@ void irq_domain_remove(struct irq_domain *domain)
 
 	mutex_unlock(&irq_domain_mutex);
 
+	if (domain->flags & IRQ_DOMAIN_FLAG_DESTROY_GC)
+		irq_domain_remove_generic_chips(domain);
+
 	pr_debug("Removed domain %s\n", domain->name);
 	irq_domain_free(domain);
 }
-- 
2.53.0



