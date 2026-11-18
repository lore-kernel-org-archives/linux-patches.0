Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061755;
	b=DGEmMHbp12GX09tTihcns+O0mFqEcD1Df6JuGdE7WatpF+FWypoKxxkHn6OsOXyTgHZ2
	 Uycx2OrwGoO8YDXbIpqRRqHN+uYMg4Pl4VF5vekP9LvDdNhqRqSdYYZ7gdvUMeySXg+Y4
	 hfy7msHMz91flhenEFQkyxW/W2WMqcrIzb8tHCwJbtida8lKkxWVD34prnZz34KKfXobR
	 nz8qq/62jb8iRFG1p6agRhk6w6L7penOUX4+lLvfQJ7/2VWt+CfYGqw3YoKUpMKleCXSq
	 x98aDXZz3LKQjLJZrgT07gm6xeiLwoA6ypVx4l9l57t7c51xJbdguyBpjNOJpU/uo/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tv9IJJKawPqK09AVwBFN1oj2lFqjNfueQ9GNyuAlxro=;
	b=t75Jqp46Zkqb3WEV1AvXFndNgG5sBel04RFLdJU6kpVqL7WX/GvkNa4Geq1oRD1IUEk6
	 HkT5lXWgWgv0WQ6KaeohFKQz8CFAbXwr5hOjBjjcDMkdteMdI9LuPlGINyeemL8IB8eBQ
	 qr/n2fWI6anWes5mpDX8LBb6+8Tp/k5TGOCnLEdbMLu7ZzVesY54VQc1BnNGDjgrk1RLj
	 /mxhwpvOtBUHK/Bc4EsEGm2SKBCSwFT7QnGUPdmNfHTEGTPtPZnPk+LI/FJSo3Txec0h1
	 WI2iSIiCVHk0ii4Qpbi+uWFdRgsSR5vZooh9qg99LwH7dYAsNCTw5jJ7mf6DMZsmqcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OWAr/unl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682A1606A330;
	Thu, 19 Nov 2026 04:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWAr/unl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17371F000C4;
	Thu, 19 Nov 2026 04:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061755;
	bh=Tv9IJJKawPqK09AVwBFN1oj2lFqjNfueQ9GNyuAlxro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWAr/unl60n3aiA9+JtvYfDvE00I5kEbcKzG5cEjA/YZ/yZl/INg9v3Op7z9gbAEm
	 ZpwgqTMkjFwnpu7ZC474fKg6RZhROWSB/IkjX5p720H23zVK3Qfkc/3paxgIEmvbAN
	 CvwZUGfmBdTmmAheYEHy2tb7jz7cgURDZ2JFOm5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1666/1848] irqchip/gic-v3-its: Split allocation from initialisation of its_node
Date: Wed, 18 Nov 2026 16:01:44 +0100
Message-ID: <20261118150029.588804837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 9585a495ac936049dba141e8f9d99159ca06d46a ]

In order to pave the way for more fancy quirk handling without making
more of a mess of this terrible driver, split the allocation of the
ITS descriptor (its_node) from the actual probing.

This will allow firmware-specific hooks to be added between these
two points.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231006125929.48591-4-lpieralisi@kernel.org
Stable-dep-of: 32e056cc1d15 ("irqchip/gic-v3-its: Don't free a vPE table shared with another ITS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 149 ++++++++++++++++++-------------
 1 file changed, 89 insertions(+), 60 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 620a446d4e435..575c680605e17 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4908,7 +4908,7 @@ static void __init __iomem *its_map_one(struct resource *res, int *err)
 	return NULL;
 }
 
-static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
+static int its_init_domain(struct its_node *its)
 {
 	struct irq_domain *inner_domain;
 	struct msi_domain_info *info;
@@ -4922,7 +4922,7 @@ static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
 
 	inner_domain = irq_domain_create_hierarchy(its_parent,
 						   its->msi_domain_flags, 0,
-						   handle, &its_domain_ops,
+						   its->fwnode_handle, &its_domain_ops,
 						   info);
 	if (!inner_domain) {
 		kfree(info);
@@ -4975,8 +4975,7 @@ static int its_init_vpe_domain(void)
 	return 0;
 }
 
-static int __init its_compute_its_list_map(struct resource *res,
-					   void __iomem *its_base)
+static int __init its_compute_its_list_map(struct its_node *its)
 {
 	int its_number;
 	u32 ctlr;
@@ -4990,15 +4989,15 @@ static int __init its_compute_its_list_map(struct resource *res,
 	its_number = find_first_zero_bit(&its_list_map, GICv4_ITS_LIST_MAX);
 	if (its_number >= GICv4_ITS_LIST_MAX) {
 		pr_err("ITS@%pa: No ITSList entry available!\n",
-		       &res->start);
+		       &its->phys_base);
 		return -EINVAL;
 	}
 
-	ctlr = readl_relaxed(its_base + GITS_CTLR);
+	ctlr = readl_relaxed(its->base + GITS_CTLR);
 	ctlr &= ~GITS_CTLR_ITS_NUMBER;
 	ctlr |= its_number << GITS_CTLR_ITS_NUMBER_SHIFT;
-	writel_relaxed(ctlr, its_base + GITS_CTLR);
-	ctlr = readl_relaxed(its_base + GITS_CTLR);
+	writel_relaxed(ctlr, its->base + GITS_CTLR);
+	ctlr = readl_relaxed(its->base + GITS_CTLR);
 	if ((ctlr & GITS_CTLR_ITS_NUMBER) != (its_number << GITS_CTLR_ITS_NUMBER_SHIFT)) {
 		its_number = ctlr & GITS_CTLR_ITS_NUMBER;
 		its_number >>= GITS_CTLR_ITS_NUMBER_SHIFT;
@@ -5006,75 +5005,50 @@ static int __init its_compute_its_list_map(struct resource *res,
 
 	if (test_and_set_bit(its_number, &its_list_map)) {
 		pr_err("ITS@%pa: Duplicate ITSList entry %d\n",
-		       &res->start, its_number);
+		       &its->phys_base, its_number);
 		return -EINVAL;
 	}
 
 	return its_number;
 }
 
-static int __init its_probe_one(struct resource *res,
-				struct fwnode_handle *handle, int numa_node)
+static int __init its_probe_one(struct its_node *its)
 {
-	struct its_node *its;
-	void __iomem *its_base;
-	u64 baser, tmp, typer;
+	u64 baser, tmp;
 	struct page *page;
 	u32 ctlr;
 	int err;
 
-	its_base = its_map_one(res, &err);
-	if (!its_base)
-		return err;
-
-	pr_info("ITS %pR\n", res);
-
-	its = kzalloc(sizeof(*its), GFP_KERNEL);
-	if (!its) {
-		err = -ENOMEM;
-		goto out_unmap;
-	}
-
-	raw_spin_lock_init(&its->lock);
-	mutex_init(&its->dev_alloc_lock);
-	INIT_LIST_HEAD(&its->entry);
-	INIT_LIST_HEAD(&its->its_device_list);
-	typer = gic_read_typer(its_base + GITS_TYPER);
-	its->typer = typer;
-	its->base = its_base;
-	its->phys_base = res->start;
 	if (is_v4(its)) {
-		if (!(typer & GITS_TYPER_VMOVP)) {
-			err = its_compute_its_list_map(res, its_base);
+		if (!(its->typer & GITS_TYPER_VMOVP)) {
+			err = its_compute_its_list_map(its);
 			if (err < 0)
-				goto out_free_its;
+				goto out;
 
 			its->list_nr = err;
 
 			pr_info("ITS@%pa: Using ITS number %d\n",
-				&res->start, err);
+				&its->phys_base, err);
 		} else {
-			pr_info("ITS@%pa: Single VMOVP capable\n", &res->start);
+			pr_info("ITS@%pa: Single VMOVP capable\n", &its->phys_base);
 		}
 
 		if (is_v4_1(its)) {
-			u32 svpet = FIELD_GET(GITS_TYPER_SVPET, typer);
+			u32 svpet = FIELD_GET(GITS_TYPER_SVPET, its->typer);
 
-			its->sgir_base = ioremap(res->start + SZ_128K, SZ_64K);
+			its->sgir_base = ioremap(its->phys_base + SZ_128K, SZ_64K);
 			if (!its->sgir_base) {
 				err = -ENOMEM;
-				goto out_free_its;
+				goto out;
 			}
 
-			its->mpidr = readl_relaxed(its_base + GITS_MPIDR);
+			its->mpidr = readl_relaxed(its->base + GITS_MPIDR);
 
 			pr_info("ITS@%pa: Using GICv4.1 mode %08x %08x\n",
-				&res->start, its->mpidr, svpet);
+				&its->phys_base, its->mpidr, svpet);
 		}
 	}
 
-	its->numa_node = numa_node;
-
 	page = alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
 				get_order(ITS_CMD_QUEUE_SZ));
 	if (!page) {
@@ -5083,12 +5057,9 @@ static int __init its_probe_one(struct resource *res,
 	}
 	its->cmd_base = (void *)page_address(page);
 	its->cmd_write = its->cmd_base;
-	its->fwnode_handle = handle;
 	its->get_msi_base = its_irq_get_msi_base;
 	its->msi_domain_flags = IRQ_DOMAIN_FLAG_MSI_REMAP;
 
-	its_enable_quirks(its);
-
 	err = its_alloc_tables(its);
 	if (err)
 		goto out_free_cmd;
@@ -5129,7 +5100,7 @@ static int __init its_probe_one(struct resource *res,
 		ctlr |= GITS_CTLR_ImDe;
 	writel_relaxed(ctlr, its->base + GITS_CTLR);
 
-	err = its_init_domain(handle, its);
+	err = its_init_domain(its);
 	if (err)
 		goto out_free_collection;
 
@@ -5148,11 +5119,8 @@ static int __init its_probe_one(struct resource *res,
 out_unmap_sgir:
 	if (its->sgir_base)
 		iounmap(its->sgir_base);
-out_free_its:
-	kfree(its);
-out_unmap:
-	iounmap(its_base);
-	pr_err("ITS@%pa: failed probing (%d)\n", &res->start, err);
+out:
+	pr_err("ITS@%pa: failed probing (%d)\n", &its->phys_base, err);
 	return err;
 }
 
@@ -5299,10 +5267,53 @@ static const struct of_device_id its_device_id[] = {
 	{},
 };
 
+static struct its_node __init *its_node_init(struct resource *res,
+					     struct fwnode_handle *handle, int numa_node)
+{
+	void __iomem *its_base;
+	struct its_node *its;
+	int err;
+
+	its_base = its_map_one(res, &err);
+	if (!its_base)
+		return NULL;
+
+	pr_info("ITS %pR\n", res);
+
+	its = kzalloc(sizeof(*its), GFP_KERNEL);
+	if (!its)
+		goto out_unmap;
+
+	raw_spin_lock_init(&its->lock);
+	mutex_init(&its->dev_alloc_lock);
+	INIT_LIST_HEAD(&its->entry);
+	INIT_LIST_HEAD(&its->its_device_list);
+
+	its->typer = gic_read_typer(its_base + GITS_TYPER);
+	its->base = its_base;
+	its->phys_base = res->start;
+
+	its->numa_node = numa_node;
+	its->fwnode_handle = handle;
+
+	return its;
+
+out_unmap:
+	iounmap(its_base);
+	return NULL;
+}
+
+static void its_node_destroy(struct its_node *its)
+{
+	iounmap(its->base);
+	kfree(its);
+}
+
 static int __init its_of_probe(struct device_node *node)
 {
 	struct device_node *np;
 	struct resource res;
+	int err;
 
 	/*
 	 * Make sure *all* the ITS are reset before we probe any, as
@@ -5312,8 +5323,6 @@ static int __init its_of_probe(struct device_node *node)
 	 */
 	for (np = of_find_matching_node(node, its_device_id); np;
 	     np = of_find_matching_node(np, its_device_id)) {
-		int err;
-
 		if (!of_device_is_available(np) ||
 		    !of_property_read_bool(np, "msi-controller") ||
 		    of_address_to_resource(np, 0, &res))
@@ -5326,6 +5335,8 @@ static int __init its_of_probe(struct device_node *node)
 
 	for (np = of_find_matching_node(node, its_device_id); np;
 	     np = of_find_matching_node(np, its_device_id)) {
+		struct its_node *its;
+
 		if (!of_device_is_available(np))
 			continue;
 		if (!of_property_read_bool(np, "msi-controller")) {
@@ -5339,7 +5350,17 @@ static int __init its_of_probe(struct device_node *node)
 			continue;
 		}
 
-		its_probe_one(&res, &np->fwnode, of_node_to_nid(np));
+
+		its = its_node_init(&res, &np->fwnode, of_node_to_nid(np));
+		if (!its)
+			return -ENOMEM;
+
+		its_enable_quirks(its);
+		err = its_probe_one(its);
+		if (err)  {
+			its_node_destroy(its);
+			return err;
+		}
 	}
 	return 0;
 }
@@ -5453,6 +5474,7 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
 {
 	struct acpi_madt_generic_translator *its_entry;
 	struct fwnode_handle *dom_handle;
+	struct its_node *its;
 	struct resource res;
 	int err;
 
@@ -5477,11 +5499,18 @@ static int __init gic_acpi_parse_madt_its(union acpi_subtable_headers *header,
 		goto dom_err;
 	}
 
-	err = its_probe_one(&res, dom_handle,
-			acpi_get_its_numa_node(its_entry->translation_id));
+	its = its_node_init(&res, dom_handle,
+			    acpi_get_its_numa_node(its_entry->translation_id));
+	if (!its) {
+		err = -ENOMEM;
+		goto node_err;
+	}
+
+	err = its_probe_one(its);
 	if (!err)
 		return 0;
 
+node_err:
 	iort_deregister_domain_token(its_entry->translation_id);
 dom_err:
 	irq_domain_free_fwnode(dom_handle);
-- 
2.53.0



