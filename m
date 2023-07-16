Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1D48F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8459AC433C7;
	Sun, 16 Jul 2023 20:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540968;
	bh=vkIPizUY929a4wWjJF4rC4x6TmIPvV2MT5uP1R6B3KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hxn2BO8epeDi7F1vCi/LtkwLsRel4AoGnICDOwwzxIZb/AIm4390zTLH3X3YyIfRQ
	 lY3XJmwSy78fjxGUtJzQEsUvSTy+MXRzXl78vNOZkx3xvGFEhPmDkDuTAi0do4bsCu
	 VKNlFSks6wD41G6RpIbnOnMfxnIAWwaWYbwHf8RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Liu Peibao <liupeibao@loongson.cn>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 525/591] irqchip/loongson-pch-pic: Fix potential incorrect hwirq assignment
Date: Sun, 16 Jul 2023 21:51:04 +0200
Message-ID: <20230716194937.455534141@linuxfoundation.org>
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

From: Liu Peibao <liupeibao@loongson.cn>

commit 783422e704ca0fa41cb2fe9ed79e46b6fe7eae29 upstream.

In DeviceTree path, when ht_vec_base is not zero, the hwirq of PCH PIC
will be assigned incorrectly. Because when pch_pic_domain_translate()
adds the ht_vec_base to hwirq, the hwirq does not have the ht_vec_base
subtracted when calling irq_domain_set_info().

The ht_vec_base is designed for the parent irq chip/domain of the PCH PIC.
It seems not proper to deal this in callbacks of the PCH PIC domain and
let's put this back like the initial commit ef8c01eb64ca ("irqchip: Add
Loongson PCH PIC controller").

Fixes: bcdd75c596c8 ("irqchip/loongson-pch-pic: Add ACPI init support")
Cc: stable@vger.kernel.org
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Liu Peibao <liupeibao@loongson.cn>
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230614115936.5950-3-lvjianmin@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -162,7 +162,7 @@ static int pch_pic_domain_translate(stru
 		if (fwspec->param_count < 2)
 			return -EINVAL;
 
-		*hwirq = fwspec->param[0] + priv->ht_vec_base;
+		*hwirq = fwspec->param[0];
 		*type = fwspec->param[1] & IRQ_TYPE_SENSE_MASK;
 	} else {
 		*hwirq = fwspec->param[0] - priv->gsi_base;
@@ -188,7 +188,7 @@ static int pch_pic_alloc(struct irq_doma
 
 	parent_fwspec.fwnode = domain->parent->fwnode;
 	parent_fwspec.param_count = 1;
-	parent_fwspec.param[0] = hwirq;
+	parent_fwspec.param[0] = hwirq + priv->ht_vec_base;
 
 	err = irq_domain_alloc_irqs_parent(domain, virq, 1, &parent_fwspec);
 	if (err)


