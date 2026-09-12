Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA232A3DA;
	Sat, 12 Sep 2026 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223327; cv=none; b=nm+/HVCf+KZKdF29v1ZkmT36QgAiejXBJtv84Zra/T9Itb8lt3G0raArkeKRpl/XAfXgj0QsoqPbFw7kp9zA56fWr2uimQiqfhga3EbJmw6+9yYGI3TzCjRUMCBtzoHhIi+Crld+ABqjkl/r439IlsoMlgq2v9Er/tFvYthQS04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223327; c=relaxed/simple;
	bh=kkCTZxZXDesJXMlgJK4m/eYsaF0gA8BWnOiLEL3UwMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aww/V1O2MH8iliEuQssC0A6KwoTQOV3cWUUTqGg3XodA3c/jdjUmMf+s+Nts0pDZo4UHpI0pty+/UcYjjFsqqT2VbuUNVkY+cNjOINltCQcxaGBbXjQjMIw+hRLNbME7cTcl9OL718Zrhrlgka5gwOwnHFfP26VECG32OSOuo00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4yDYx+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4yDYx+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1971F000FF;
	Sat, 12 Sep 2026 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223326;
	bh=cvedlXzuFIajrUDMQH8fg3+30i6xOf9hUCvJmXAKpxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4yDYx+hdeAEG0Zn8Lnxlv4Z0bSFR8dhHiQRrMzP4YxH7U701yB6xAmo5Gz4eYgBG
	 +SNikR7OjkMjlehJJnwXbfYXmrrMGqY/DuYr5ZkfmFmQ5Wld69xsVyCXnSW59mhPr9
	 eANpt240NIjy8Jdc4ZuBtCejdX4YifFG9zrQjhOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0765/1424] irqdomain: Introduce init() and exit() hooks
Date: Sat, 12 Sep 2026 08:53:17 +0200
Message-ID: <20260912065624.429734923@linuxfoundation.org>
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

[ Upstream commit 44b68de9b8e3dfde12308e8567548799d7ded0de ]

The current API does not allow additional initialization before the
domain is published. This can lead to a race condition between consumers
and supplier as a domain can be available for consumers before being
fully ready.

Introduce the init() hook to allow additional initialization before
plublishing the domain. Also introduce the exit() hook to revert
operations done in init() on domain removal.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-13-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h |  8 ++++++++
 kernel/irq/irqdomain.c    | 15 +++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index a2a55882253b7..386d7b0bcc5c5 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -141,6 +141,7 @@ struct irq_domain_chip_generic;
  *		purposes related to the irq domain.
  * @parent:	Pointer to parent irq_domain to support hierarchy irq_domains
  * @msi_parent_ops: Pointer to MSI parent domain methods for per device domain init
+ * @exit:	Function called when the domain is destroyed
  *
  * Revmap data, used internally by the irq domain code:
  * @revmap_size:	Size of the linear map table @revmap[]
@@ -169,6 +170,7 @@ struct irq_domain {
 #ifdef CONFIG_GENERIC_MSI_IRQ
 	const struct msi_parent_ops	*msi_parent_ops;
 #endif
+	void				(*exit)(struct irq_domain *d);
 
 	/* reverse map data. The linear map gets appended to the irq_domain */
 	irq_hw_number_t			hwirq_max;
@@ -267,6 +269,10 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
  *			Use ~0 for no limit; 0 for no direct mapping
  * @ops:		Domain operation callbacks
  * @host_data:		Controller private data pointer
+ * @init:		Function called when the domain is created.
+ *			Allow to do some additional domain initialisation.
+ * @exit:		Function called when the domain is destroyed.
+ *			Allow to do some additional cleanup operation.
  */
 struct irq_domain_info {
 	struct fwnode_handle			*fwnode;
@@ -282,6 +288,8 @@ struct irq_domain_info {
 	 */
 	struct irq_domain			*parent;
 #endif
+	int					(*init)(struct irq_domain *d);
+	void					(*exit)(struct irq_domain *d);
 };
 
 struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6ff6c6e11aa0c..7bb8c5a5856a1 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -254,6 +254,7 @@ static void irq_domain_free(struct irq_domain *domain)
 struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 {
 	struct irq_domain *domain;
+	int err;
 
 	domain = __irq_domain_create(info->fwnode, info->size, info->hwirq_max,
 				     info->direct_max, info->ops, info->host_data);
@@ -261,6 +262,7 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 		return ERR_PTR(-ENOMEM);
 
 	domain->flags |= info->domain_flags;
+	domain->exit = info->exit;
 
 #ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
 	if (info->parent) {
@@ -269,9 +271,19 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 	}
 #endif
 
+	if (info->init) {
+		err = info->init(domain);
+		if (err)
+			goto err_domain_free;
+	}
+
 	__irq_domain_publish(domain);
 
 	return domain;
+
+err_domain_free:
+	irq_domain_free(domain);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(irq_domain_instantiate);
 
@@ -318,6 +330,9 @@ EXPORT_SYMBOL_GPL(__irq_domain_add);
  */
 void irq_domain_remove(struct irq_domain *domain)
 {
+	if (domain->exit)
+		domain->exit(domain);
+
 	mutex_lock(&irq_domain_mutex);
 	debugfs_remove_domain_dir(domain);
 
-- 
2.53.0



