Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DD31863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E1EC433EF;
	Wed, 28 Dec 2022 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240218;
	bh=Tacn1Scr7WCtRrRR+AhaqadldxsQPr8WJg4OpZOivFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCbZ7vaoI954PKTMj8BEYbI6iaD566sX4rU4zUFG01vVwvbOe+h083IC9dgsFnAMr
	 VLVrzLPeiqnWCzDYQdG5w/LfWLlBT555b68/WQQPuLYfOmrkPw57A54/eZjU6XfJu/
	 uUb6uJsbVcugs+moLJBRg8VAS4Fs3SpAhw4nQW7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0135/1073] irqchip/loongson-pch-pic: Fix translate callback for DT path
Date: Wed, 28 Dec 2022 15:28:43 +0100
Message-Id: <20221228144331.698614541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit c7c00138015975c8f0e268564249cc47d8de632c ]

In DT path of translate callback, if fwspec->param_count==1
and of_node is non-null, fwspec->param[1] will be accessed,
which is introduced from previous commit bcdd75c596c8
(irqchip/loongson-pch-pic: Add ACPI init support).

Before the patch, for non-null of_node, translate callback
(use irq_domain_translate_twocell()) will return -EINVAL if
fwspec->param_count < 2, so the check in the patch is added.

Fixes: bcdd75c596c8 ("irqchip/loongson-pch-pic: Add ACPI init support")
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221022075955.11726-3-lvjianmin@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index c01b9c257005..03493cda65a3 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -159,6 +159,9 @@ static int pch_pic_domain_translate(struct irq_domain *d,
 		return -EINVAL;
 
 	if (of_node) {
+		if (fwspec->param_count < 2)
+			return -EINVAL;
+
 		*hwirq = fwspec->param[0] + priv->ht_vec_base;
 		*type = fwspec->param[1] & IRQ_TYPE_SENSE_MASK;
 	} else {
-- 
2.35.1



