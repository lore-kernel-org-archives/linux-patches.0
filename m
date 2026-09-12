Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5E1FCFFC;
	Sat, 12 Sep 2026 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223313; cv=none; b=PIS0JYdAaIOk0ZFYU69LObL0RoPDEZyyByOnVJ0jz4Ab1Twj6HKGG6F4UgtLiOTh7dpb+33D5DaQ98noIuVvUdi/c+y+vyGEd5FOnEUHwqJmNTwrmICechCkxE5cxJmVrYHMjTxtPBe1LT1stSUApwWIMi0dMZIYXMj4nmSXE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223313; c=relaxed/simple;
	bh=YOWKetD/iPvzJqFR1gXToEIItG1qpHQxfMFZSC9fXGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM0ViJBTVVC7Ctib25Uo17e7mDVHzbyynQLZxOZADPjHzcl0OmjZpuq+mjLE/2mR7tC7aoJRC1TVRSoi9xKxRPsnsL+mWKkwguLD8K226ywVBHk7mHsrUPw2hWTlais3OIZssnkiibB3aEb53/LaLKU2o1mFw+vFk3o9Np2Vnkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3lok1mk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3lok1mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08D81F000FF;
	Sat, 12 Sep 2026 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223311;
	bh=vvBi1KBYg7DMxDnpw6T0NVNfnAoyxu0JeiQiyQwrg0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3lok1mkDTiOiTdUsJjt/xbyYJsiAxi2tFoFfUy79uUFFPdwT3/LuMf28HToyv3Uz
	 uHRXpdsmeuq1MIWFowOl/EXgRA+iXqMqC31umPiR721hirNshXrYVdlMQtM/8Nz8Jd
	 ThIGrGLMo7iiM3SSeJ7xn5B3xwW7VB34xhbeXJmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0762/1424] irqdomain: Introduce irq_domain_instantiate()
Date: Sat, 12 Sep 2026 08:53:14 +0200
Message-ID: <20260912065624.361482237@linuxfoundation.org>
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
index 51c254b7fec27..542b1bb78aa83 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -257,6 +257,27 @@ static inline struct fwnode_handle *irq_domain_alloc_fwnode(phys_addr_t *pa)
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
index 697b5280f4bff..80e0477beca2e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -245,6 +245,27 @@ static void irq_domain_free(struct irq_domain *domain)
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
@@ -263,14 +284,18 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int s
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



