Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4276A8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB17FC433C8;
	Sun, 16 Jul 2023 20:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539277;
	bh=pyKCcmR34GPaWqHbmDBJSuap48FB4GeoPOcfxZOxmt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzuG0M6jePS5Umn6nTf1Q0h84jL+uvUxf6tJvbZf6rjTo+KkOn3DvAuBdPL2s6bH6
	 WwRn1d+vwtUpqnKBc5nZ6BkU2IeG7t50s5/IGcVhXYBt8J2gkRWeEZqHhWUFPK1dhy
	 aZDQjy3ldRsZud9r02TWWKF/IoWkZESda71gwvb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	liuyun <liuyun@loongson.cn>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.4 723/800] irqchip/loongson-pch-pic: Fix initialization of HT vector register
Date: Sun, 16 Jul 2023 21:49:36 +0200
Message-ID: <20230716195005.911992840@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianmin Lv <lvjianmin@loongson.cn>

commit f679616565f1cf1a4acb245dbc0032dafcd40637 upstream.

In an ACPI-based dual-bridge system, IRQ of each bridge's
PCH PIC sent to CPU is always a zero-based number, which
means that the IRQ on PCH PIC of each bridge is mapped into
vector range from 0 to 63 of upstream irqchip(e.g. EIOINTC).

      EIOINTC N: [0 ... 63 | 64 ... 255]
                  --------   ----------
                      ^          ^
                      |          |
                  PCH PIC N      |
                             PCH MSI N

For example, the IRQ vector number of sata controller on
PCH PIC of each bridge is 16, which is sent to upstream
irqchip of EIOINTC when an interrupt occurs, which will set
bit 16 of EIOINTC. Since hwirq of 16 on EIOINTC has been
mapped to a irq_desc for sata controller during hierarchy
irq allocation, the related mapped IRQ will be found through
irq_resolve_mapping() in the IRQ domain of EIOINTC.

So, the IRQ number set in HT vector register should be fixed
to be a zero-based number.

Cc: stable@vger.kernel.org
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Co-developed-by: liuyun <liuyun@loongson.cn>
Signed-off-by: liuyun <liuyun@loongson.cn>
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230614115936.5950-2-lvjianmin@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -401,14 +401,12 @@ static int __init acpi_cascade_irqdomain
 int __init pch_pic_acpi_init(struct irq_domain *parent,
 					struct acpi_madt_bio_pic *acpi_pchpic)
 {
-	int ret, vec_base;
+	int ret;
 	struct fwnode_handle *domain_handle;
 
 	if (find_pch_pic(acpi_pchpic->gsi_base) >= 0)
 		return 0;
 
-	vec_base = acpi_pchpic->gsi_base - GSI_MIN_PCH_IRQ;
-
 	domain_handle = irq_domain_alloc_fwnode(&acpi_pchpic->address);
 	if (!domain_handle) {
 		pr_err("Unable to allocate domain handle\n");
@@ -416,7 +414,7 @@ int __init pch_pic_acpi_init(struct irq_
 	}
 
 	ret = pch_pic_init(acpi_pchpic->address, acpi_pchpic->size,
-				vec_base, parent, domain_handle, acpi_pchpic->gsi_base);
+				0, parent, domain_handle, acpi_pchpic->gsi_base);
 
 	if (ret < 0) {
 		irq_domain_free_fwnode(domain_handle);


