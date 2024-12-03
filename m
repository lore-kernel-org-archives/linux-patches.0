Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E081F7540;
	Tue,  3 Dec 2024 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238771; cv=none; b=VMElIt0rnWtS98tkdd1H1abYdKV47a6JBKD6rIYIb384RWJe2OMnKivd5o9owFIgQ7ScFokL9O/0HRu5Bn+NRCxwwwcpOdDTS/caMKGjV7TFl6/J7bGjMLf0RzFo4q0AGl3QqmjPnFEAbWNE5TeFYf+Fh1Ad8Zh52KyDh2HGJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238771; c=relaxed/simple;
	bh=ktEugaCFHSyfOc7QNGw26R+zuwMd/EweQLDwsDmSePA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN72otZyroQQU6P2q3USB9RyM6+co2dcnk13wJQNGTkxsbmQuGnzebxXHhfJmp5TbceEsyaGSExu28uLmf10V/q+qqNCSBPyb3votEHDV7G4i0DWl+1knB/zdIWVBVozDtCOsTmNJGRVDWLeP7zSmYvqju9Ip3MNQ5Egm13UrjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frZ/EK4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frZ/EK4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9E7C4CECF;
	Tue,  3 Dec 2024 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238771;
	bh=ktEugaCFHSyfOc7QNGw26R+zuwMd/EweQLDwsDmSePA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frZ/EK4MHHG+IWoPyXkI+1zG4J/7IsDRsZPy2F9iQK/o4aVR/vr+U+roHh2odKeUI
	 KJyStXkWNahgzZnZcQs7c9Dr0w/dg4XdFwOjSJMimq3g8LPIdn6X5Jc143kR1MFEZd
	 0MXhADbXCEBM6uSryKpFvxnYj7FsriTckEuY0OuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 392/817] irqdomain: Cleanup domain name allocation
Date: Tue,  3 Dec 2024 15:39:24 +0100
Message-ID: <20241203144011.174520900@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 1bf2c92829274e7c815d06d7b3196a967ff70917 ]

irq_domain_set_name() is truly unreadable gunk. Clean it up before adding
more.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/all/874j7uvkbm.ffs@tglx
Stable-dep-of: 3727c0b4ff6b ("mfd: intel_soc_pmic_bxtwc: Fix IRQ domain names duplication")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 106 +++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 51 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7625e424f85a6..72ab601871034 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -128,72 +128,76 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(irq_domain_free_fwnode);
 
-static int irq_domain_set_name(struct irq_domain *domain,
-			       const struct fwnode_handle *fwnode,
-			       enum irq_domain_bus_token bus_token)
+static int alloc_name(struct irq_domain *domain, char *base, enum irq_domain_bus_token bus_token)
+{
+	domain->name = bus_token ? kasprintf(GFP_KERNEL, "%s-%d", base, bus_token) :
+				   kasprintf(GFP_KERNEL, "%s", base);
+	if (!domain->name)
+		return -ENOMEM;
+
+	domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
+	return 0;
+}
+
+static int alloc_fwnode_name(struct irq_domain *domain, const struct fwnode_handle *fwnode,
+			     enum irq_domain_bus_token bus_token)
+{
+	char *name = bus_token ? kasprintf(GFP_KERNEL, "%pfw-%d", fwnode, bus_token) :
+				 kasprintf(GFP_KERNEL, "%pfw", fwnode);
+
+	if (!name)
+		return -ENOMEM;
+
+	/*
+	 * fwnode paths contain '/', which debugfs is legitimately unhappy
+	 * about. Replace them with ':', which does the trick and is not as
+	 * offensive as '\'...
+	 */
+	domain->name = strreplace(name, '/', ':');
+	domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
+	return 0;
+}
+
+static int alloc_unknown_name(struct irq_domain *domain, enum irq_domain_bus_token bus_token)
 {
 	static atomic_t unknown_domains;
-	struct irqchip_fwid *fwid;
+	int id = atomic_inc_return(&unknown_domains);
+
+	domain->name = bus_token ? kasprintf(GFP_KERNEL, "unknown-%d-%d", id, bus_token) :
+				   kasprintf(GFP_KERNEL, "unknown-%d", id);
 
+	if (!domain->name)
+		return -ENOMEM;
+	domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
+	return 0;
+}
+
+static int irq_domain_set_name(struct irq_domain *domain, const struct fwnode_handle *fwnode,
+			       enum irq_domain_bus_token bus_token)
+{
 	if (is_fwnode_irqchip(fwnode)) {
-		fwid = container_of(fwnode, struct irqchip_fwid, fwnode);
+		struct irqchip_fwid *fwid = container_of(fwnode, struct irqchip_fwid, fwnode);
 
 		switch (fwid->type) {
 		case IRQCHIP_FWNODE_NAMED:
 		case IRQCHIP_FWNODE_NAMED_ID:
-			domain->name = bus_token ?
-					kasprintf(GFP_KERNEL, "%s-%d",
-						  fwid->name, bus_token) :
-					kstrdup(fwid->name, GFP_KERNEL);
-			if (!domain->name)
-				return -ENOMEM;
-			domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
-			break;
+			return alloc_name(domain, fwid->name, bus_token);
 		default:
 			domain->name = fwid->name;
-			if (bus_token) {
-				domain->name = kasprintf(GFP_KERNEL, "%s-%d",
-							 fwid->name, bus_token);
-				if (!domain->name)
-					return -ENOMEM;
-				domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
-			}
-			break;
+			if (bus_token)
+				return alloc_name(domain, fwid->name, bus_token);
 		}
-	} else if (is_of_node(fwnode) || is_acpi_device_node(fwnode) ||
-		   is_software_node(fwnode)) {
-		char *name;
 
-		/*
-		 * fwnode paths contain '/', which debugfs is legitimately
-		 * unhappy about. Replace them with ':', which does
-		 * the trick and is not as offensive as '\'...
-		 */
-		name = bus_token ?
-			kasprintf(GFP_KERNEL, "%pfw-%d", fwnode, bus_token) :
-			kasprintf(GFP_KERNEL, "%pfw", fwnode);
-		if (!name)
-			return -ENOMEM;
-
-		domain->name = strreplace(name, '/', ':');
-		domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
+	} else if (is_of_node(fwnode) || is_acpi_device_node(fwnode) || is_software_node(fwnode)) {
+		return alloc_fwnode_name(domain, fwnode, bus_token);
 	}
 
-	if (!domain->name) {
-		if (fwnode)
-			pr_err("Invalid fwnode type for irqdomain\n");
-		domain->name = bus_token ?
-				kasprintf(GFP_KERNEL, "unknown-%d-%d",
-					  atomic_inc_return(&unknown_domains),
-					  bus_token) :
-				kasprintf(GFP_KERNEL, "unknown-%d",
-					  atomic_inc_return(&unknown_domains));
-		if (!domain->name)
-			return -ENOMEM;
-		domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
-	}
+	if (domain->name)
+		return 0;
 
-	return 0;
+	if (fwnode)
+		pr_err("Invalid fwnode type for irqdomain\n");
+	return alloc_unknown_name(domain, bus_token);
 }
 
 static struct irq_domain *__irq_domain_create(const struct irq_domain_info *info)
-- 
2.43.0



