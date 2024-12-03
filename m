Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438071D9341;
	Tue,  3 Dec 2024 15:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238774; cv=none; b=FVmiFn6LlpkTAbLIT+MmeHgBp+v4tpUc5cOL2oJexd/BWMfz9Xz1zz73ueztELb41FYg4N6PRtVrVAas4l2ntiFARsJHIKGJRif9spmKGGem8W0zGA5F8n42cL1DkSaF42XLQb+SxwzobaJwVxmTs5eNU1oRDLaO2yp0yzlEaZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238774; c=relaxed/simple;
	bh=e99pi0gJ97rMwLBSdubv6xV1UMUd6MUQTd1nltUuMkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2d0aARprOtWNDg4HpiOx2NfGrvotUuRf2tfWbG2bE7WaAwiIBz39juOAAFyHO7UHMLRfetKZyBciAN56dI5+qVmvA1z0RkA08DOE/7JJL8+UCgiv1/2KarajMa9Y+KLhXMn4GvpJH0X8NhOjxkMajUkjCGuhJEGMIAcxG7s4Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mG7s+ZuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mG7s+ZuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3298C4CECF;
	Tue,  3 Dec 2024 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238774;
	bh=e99pi0gJ97rMwLBSdubv6xV1UMUd6MUQTd1nltUuMkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG7s+ZuUxZ1BTOVipg9dS6EldP+r1BnsVF/f6yYRd67B9SSVy0eMbBsEKd0RQLInO
	 2Ufajh1CFTXtMWcDhj6a61vgYfIOO7dP+HIDTA/FSyg/UF4XOqNm5JpOdYQGk94JG8
	 m/fnYUZTMmAyIvqt9mICMM5jevcrVQXjpBfRgtcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 393/817] irqdomain: Allow giving name suffix for domain
Date: Tue,  3 Dec 2024 15:39:25 +0100
Message-ID: <20241203144011.213299781@linuxfoundation.org>
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

[ Upstream commit 1e7c05292531e5b6bebe409cd531ed4ec0b2ff56 ]

Devices can provide multiple interrupt lines. One reason for this is that
a device has multiple subfunctions, each providing its own interrupt line.
Another reason is that a device can be designed to be used (also) on a
system where some of the interrupts can be routed to another processor.

A line often further acts as a demultiplex for specific interrupts
and has it's respective set of interrupt (status, mask, ack, ...)
registers.

Regmap supports the handling of these registers and demultiplexing
interrupts, but the interrupt domain code ends up assigning the same name
for the per interrupt line domains. This causes a naming collision in the
debugFS code and leads to confusion, as /proc/interrupts shows two separate
interrupts with the same domain name and hardware interrupt number.

Instead of adding a workaround in regmap or driver code, allow giving a
name suffix for the domain name when the domain is created.

Add a name_suffix field in the irq_domain_info structure and make
irq_domain_instantiate() use this suffix if it is given when a domain is
created.

[ tglx: Adopt it to the cleanup patch and fixup the invalid NULL return ]

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/871q2yvk5x.ffs@tglx
Stable-dep-of: 3727c0b4ff6b ("mfd: intel_soc_pmic_bxtwc: Fix IRQ domain names duplication")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h |  3 +++
 kernel/irq/irqdomain.c    | 30 +++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index bfcffa2c7047a..e432b6a12a32f 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -295,6 +295,8 @@ struct irq_domain_chip_generic_info;
  * @virq_base:		The first Linux interrupt number for legacy domains to
  *			immediately associate the interrupts after domain creation
  * @bus_token:		Domain bus token
+ * @name_suffix:	Optional name suffix to avoid collisions when multiple
+ *			domains are added using same fwnode
  * @ops:		Domain operation callbacks
  * @host_data:		Controller private data pointer
  * @dgc_info:		Geneneric chip information structure pointer used to
@@ -313,6 +315,7 @@ struct irq_domain_info {
 	unsigned int				hwirq_base;
 	unsigned int				virq_base;
 	enum irq_domain_bus_token		bus_token;
+	const char				*name_suffix;
 	const struct irq_domain_ops		*ops;
 	void					*host_data;
 #ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 72ab601871034..01001eb615ecc 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -140,11 +140,14 @@ static int alloc_name(struct irq_domain *domain, char *base, enum irq_domain_bus
 }
 
 static int alloc_fwnode_name(struct irq_domain *domain, const struct fwnode_handle *fwnode,
-			     enum irq_domain_bus_token bus_token)
+			     enum irq_domain_bus_token bus_token, const char *suffix)
 {
-	char *name = bus_token ? kasprintf(GFP_KERNEL, "%pfw-%d", fwnode, bus_token) :
-				 kasprintf(GFP_KERNEL, "%pfw", fwnode);
+	const char *sep = suffix ? "-" : "";
+	const char *suf = suffix ? : "";
+	char *name;
 
+	name = bus_token ? kasprintf(GFP_KERNEL, "%pfw-%s%s%d", fwnode, suf, sep, bus_token) :
+			   kasprintf(GFP_KERNEL, "%pfw-%s", fwnode, suf);
 	if (!name)
 		return -ENOMEM;
 
@@ -172,12 +175,25 @@ static int alloc_unknown_name(struct irq_domain *domain, enum irq_domain_bus_tok
 	return 0;
 }
 
-static int irq_domain_set_name(struct irq_domain *domain, const struct fwnode_handle *fwnode,
-			       enum irq_domain_bus_token bus_token)
+static int irq_domain_set_name(struct irq_domain *domain, const struct irq_domain_info *info)
 {
+	enum irq_domain_bus_token bus_token = info->bus_token;
+	const struct fwnode_handle *fwnode = info->fwnode;
+
 	if (is_fwnode_irqchip(fwnode)) {
 		struct irqchip_fwid *fwid = container_of(fwnode, struct irqchip_fwid, fwnode);
 
+		/*
+		 * The name_suffix is only intended to be used to avoid a name
+		 * collision when multiple domains are created for a single
+		 * device and the name is picked using a real device node.
+		 * (Typical use-case is regmap-IRQ controllers for devices
+		 * providing more than one physical IRQ.) There should be no
+		 * need to use name_suffix with irqchip-fwnode.
+		 */
+		if (info->name_suffix)
+			return -EINVAL;
+
 		switch (fwid->type) {
 		case IRQCHIP_FWNODE_NAMED:
 		case IRQCHIP_FWNODE_NAMED_ID:
@@ -189,7 +205,7 @@ static int irq_domain_set_name(struct irq_domain *domain, const struct fwnode_ha
 		}
 
 	} else if (is_of_node(fwnode) || is_acpi_device_node(fwnode) || is_software_node(fwnode)) {
-		return alloc_fwnode_name(domain, fwnode, bus_token);
+		return alloc_fwnode_name(domain, fwnode, bus_token, info->name_suffix);
 	}
 
 	if (domain->name)
@@ -215,7 +231,7 @@ static struct irq_domain *__irq_domain_create(const struct irq_domain_info *info
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	err = irq_domain_set_name(domain, info->fwnode, info->bus_token);
+	err = irq_domain_set_name(domain, info);
 	if (err) {
 		kfree(domain);
 		return ERR_PTR(err);
-- 
2.43.0



