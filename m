Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F96FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D74BC433EF;
	Mon, 15 May 2023 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170632;
	bh=K/Uc1Qew+EOtzMn7u7OausJfPLAxBJk5Q0SumE7KAUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktNjLYC+wRZy4/hKdYmLWScrRc9UbZ+mIyiEskaLotRGNUvw9VIkYXzmLP67Afj6E
	 hGb3hSsausuL3q+NHMPSLvZs88Uw5myuHBaC0Xy1X/izL8CePhxwqR6ZR83UhlE1v9
	 qA99BIPi0kMBfUm1OnkeFcgnZ29j8RtlYeVzmzqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/239] irqchip/loongarch: Adjust acpi_cascade_irqdomain_init() and sub-routines
Date: Mon, 15 May 2023 18:27:36 +0200
Message-Id: <20230515161727.526955078@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 3d12938dbc048ecb193fec69898d95f6b4813a4b ]

1, Adjust the return of acpi_cascade_irqdomain_init() and check its
   return value.
2, Combine unnecessary short lines to one long line.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221020142514.1725514-1-chenhuacai@loongson.cn
Stable-dep-of: 64cc451e45e1 ("irqchip/loongson-eiointc: Fix incorrect use of acpi_get_vec_parent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongarch-cpu.c    | 30 +++++++++++++++-----------
 drivers/irqchip/irq-loongson-eiointc.c | 30 +++++++++++++++-----------
 drivers/irqchip/irq-loongson-pch-pic.c | 15 +++++++------
 3 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/irqchip/irq-loongarch-cpu.c b/drivers/irqchip/irq-loongarch-cpu.c
index 741612ba6a520..fdec3e9cfacfb 100644
--- a/drivers/irqchip/irq-loongarch-cpu.c
+++ b/drivers/irqchip/irq-loongarch-cpu.c
@@ -92,18 +92,16 @@ static const struct irq_domain_ops loongarch_cpu_intc_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-static int __init
-liointc_parse_madt(union acpi_subtable_headers *header,
-		       const unsigned long end)
+static int __init liointc_parse_madt(union acpi_subtable_headers *header,
+					const unsigned long end)
 {
 	struct acpi_madt_lio_pic *liointc_entry = (struct acpi_madt_lio_pic *)header;
 
 	return liointc_acpi_init(irq_domain, liointc_entry);
 }
 
-static int __init
-eiointc_parse_madt(union acpi_subtable_headers *header,
-		       const unsigned long end)
+static int __init eiointc_parse_madt(union acpi_subtable_headers *header,
+					const unsigned long end)
 {
 	struct acpi_madt_eio_pic *eiointc_entry = (struct acpi_madt_eio_pic *)header;
 
@@ -112,16 +110,24 @@ eiointc_parse_madt(union acpi_subtable_headers *header,
 
 static int __init acpi_cascade_irqdomain_init(void)
 {
-	acpi_table_parse_madt(ACPI_MADT_TYPE_LIO_PIC,
-			      liointc_parse_madt, 0);
-	acpi_table_parse_madt(ACPI_MADT_TYPE_EIO_PIC,
-			      eiointc_parse_madt, 0);
+	int r;
+
+	r = acpi_table_parse_madt(ACPI_MADT_TYPE_LIO_PIC, liointc_parse_madt, 0);
+	if (r < 0)
+		return r;
+
+	r = acpi_table_parse_madt(ACPI_MADT_TYPE_EIO_PIC, eiointc_parse_madt, 0);
+	if (r < 0)
+		return r;
+
 	return 0;
 }
 
 static int __init cpuintc_acpi_init(union acpi_subtable_headers *header,
 				   const unsigned long end)
 {
+	int ret;
+
 	if (irq_domain)
 		return 0;
 
@@ -139,9 +145,9 @@ static int __init cpuintc_acpi_init(union acpi_subtable_headers *header,
 	set_handle_irq(&handle_cpu_irq);
 	acpi_set_irq_model(ACPI_IRQ_MODEL_LPIC, lpic_get_gsi_domain_id);
 	acpi_set_gsi_to_irq_fallback(lpic_gsi_to_irq);
-	acpi_cascade_irqdomain_init();
+	ret = acpi_cascade_irqdomain_init();
 
-	return 0;
+	return ret;
 }
 
 IRQCHIP_ACPI_DECLARE(cpuintc_v1, ACPI_MADT_TYPE_CORE_PIC,
diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index ab49cd15699f4..7e601a5f7d9f8 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -301,9 +301,8 @@ static struct irq_domain *acpi_get_vec_parent(int node, struct acpi_vector_group
 	return NULL;
 }
 
-static int __init
-pch_pic_parse_madt(union acpi_subtable_headers *header,
-		       const unsigned long end)
+static int __init pch_pic_parse_madt(union acpi_subtable_headers *header,
+					const unsigned long end)
 {
 	struct acpi_madt_bio_pic *pchpic_entry = (struct acpi_madt_bio_pic *)header;
 	unsigned int node = (pchpic_entry->address >> 44) & 0xf;
@@ -315,9 +314,8 @@ pch_pic_parse_madt(union acpi_subtable_headers *header,
 	return 0;
 }
 
-static int __init
-pch_msi_parse_madt(union acpi_subtable_headers *header,
-		       const unsigned long end)
+static int __init pch_msi_parse_madt(union acpi_subtable_headers *header,
+					const unsigned long end)
 {
 	struct acpi_madt_msi_pic *pchmsi_entry = (struct acpi_madt_msi_pic *)header;
 	struct irq_domain *parent = acpi_get_vec_parent(eiointc_priv[nr_pics - 1]->node, msi_group);
@@ -330,17 +328,23 @@ pch_msi_parse_madt(union acpi_subtable_headers *header,
 
 static int __init acpi_cascade_irqdomain_init(void)
 {
-	acpi_table_parse_madt(ACPI_MADT_TYPE_BIO_PIC,
-			      pch_pic_parse_madt, 0);
-	acpi_table_parse_madt(ACPI_MADT_TYPE_MSI_PIC,
-			      pch_msi_parse_madt, 1);
+	int r;
+
+	r = acpi_table_parse_madt(ACPI_MADT_TYPE_BIO_PIC, pch_pic_parse_madt, 0);
+	if (r < 0)
+		return r;
+
+	r = acpi_table_parse_madt(ACPI_MADT_TYPE_MSI_PIC, pch_msi_parse_madt, 1);
+	if (r < 0)
+		return r;
+
 	return 0;
 }
 
 int __init eiointc_acpi_init(struct irq_domain *parent,
 				     struct acpi_madt_eio_pic *acpi_eiointc)
 {
-	int i, parent_irq;
+	int i, ret, parent_irq;
 	unsigned long node_map;
 	struct eiointc_priv *priv;
 
@@ -386,9 +390,9 @@ int __init eiointc_acpi_init(struct irq_domain *parent,
 
 	acpi_set_vec_parent(acpi_eiointc->node, priv->eiointc_domain, pch_group);
 	acpi_set_vec_parent(acpi_eiointc->node, priv->eiointc_domain, msi_group);
-	acpi_cascade_irqdomain_init();
+	ret = acpi_cascade_irqdomain_init();
 
-	return 0;
+	return ret;
 
 out_free_handle:
 	irq_domain_free_fwnode(priv->domain_handle);
diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 9d2250e277581..679e2b68e6e9d 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -328,9 +328,8 @@ int find_pch_pic(u32 gsi)
 	return -1;
 }
 
-static int __init
-pch_lpc_parse_madt(union acpi_subtable_headers *header,
-		       const unsigned long end)
+static int __init pch_lpc_parse_madt(union acpi_subtable_headers *header,
+					const unsigned long end)
 {
 	struct acpi_madt_lpc_pic *pchlpc_entry = (struct acpi_madt_lpc_pic *)header;
 
@@ -339,8 +338,12 @@ pch_lpc_parse_madt(union acpi_subtable_headers *header,
 
 static int __init acpi_cascade_irqdomain_init(void)
 {
-	acpi_table_parse_madt(ACPI_MADT_TYPE_LPC_PIC,
-			      pch_lpc_parse_madt, 0);
+	int r;
+
+	r = acpi_table_parse_madt(ACPI_MADT_TYPE_LPC_PIC, pch_lpc_parse_madt, 0);
+	if (r < 0)
+		return r;
+
 	return 0;
 }
 
@@ -370,7 +373,7 @@ int __init pch_pic_acpi_init(struct irq_domain *parent,
 	}
 
 	if (acpi_pchpic->id == 0)
-		acpi_cascade_irqdomain_init();
+		ret = acpi_cascade_irqdomain_init();
 
 	return ret;
 }
-- 
2.39.2



