Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF558F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1095CC433C7;
	Sun, 16 Jul 2023 20:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540974;
	bh=WTF+Rhh+rbXklaIQQY7LS/BlqhgGQv4BvVPL7nhVPno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgpM9oS6QIPpz07tn3UA8Vi3gA99CnXAwMBix0i3WQ58X8BMOiKIPyAZ1mnI5ZoxK
	 89yBqN+op1T/EESV6uTsEYOKfc7iR8gFqWwQ1OBEyoENqROCeYzVWylK+eEjpiY7Dk
	 zl/CkNd0kdbSxrOq3+p2aVKM3hGIm6uJ4Beduns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	liuyun <liuyun@loongson.cn>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 527/591] irqchip/loongson-pch-pic: Fix initialization of HT vector register
Date: Sun, 16 Jul 2023 21:51:06 +0200
Message-ID: <20230716194937.505715331@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
@@ -350,14 +350,12 @@ static int __init acpi_cascade_irqdomain
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
@@ -365,7 +363,7 @@ int __init pch_pic_acpi_init(struct irq_
 	}
 
 	ret = pch_pic_init(acpi_pchpic->address, acpi_pchpic->size,
-				vec_base, parent, domain_handle, acpi_pchpic->gsi_base);
+				0, parent, domain_handle, acpi_pchpic->gsi_base);
 
 	if (ret < 0) {
 		irq_domain_free_fwnode(domain_handle);


