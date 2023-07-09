Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B994699
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF1FC433C8;
	Sun,  9 Jul 2023 11:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901458;
	bh=CXJPnuNPVFbreSBqxV+PzZP85Lus4EBNuYijVPTflRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IW4VbQlRNdklZZML34J3r9EjON/5c5h6ONPNiYWFQwUsILSlU1w/Zb86VpfAaXvbI
	 pXo+Lc8SUyu2We1DpmjDyVxPHJAD550NbZyy9KnKqUrC5++IEdhemyz5snZH3ZKCWw
	 D1CFfFBMaSwLKjOhYdrDJBJZiBGhz0B43aiGv0Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangqiming <yangqiming@loongson.cn>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 027/431] irqchip/loongson-eiointc: Fix irq affinity setting during resume
Date: Sun,  9 Jul 2023 13:09:35 +0200
Message-ID: <20230709111451.736909026@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit fb07b8f83441febeb0daf199b5f18c6de9bbab03 ]

The hierarchy of PCH PIC, PCH PCI MSI and EIONTC is as following:

        PCH PIC ------->|
                        |---->EIOINTC
        PCH PCI MSI --->|

so the irq_data list of irq_desc for IRQs on PCH PIC and PCH PCI MSI
is like this:

irq_desc->irq_data(domain: PCH PIC)->parent_data(domain: EIOINTC)
irq_desc->irq_data(domain: PCH PCI MSI)->parent_data(domain: EIOINTC)

In eiointc_resume(), the irq_data passed into eiointc_set_irq_affinity()
should be matched to EIOINTC domain instead of PCH PIC or PCH PCI MSI
domain, so fix it.

Fixes: a90335c2dfb4 ("irqchip/loongson-eiointc: Add suspend/resume support")

Reported-by: yangqiming <yangqiming@loongson.cn>
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230614115936.5950-6-lvjianmin@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-eiointc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index 90181c42840b4..873a326ed6cbc 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -317,7 +317,7 @@ static void eiointc_resume(void)
 			desc = irq_resolve_mapping(eiointc_priv[i]->eiointc_domain, j);
 			if (desc && desc->handle_irq && desc->handle_irq != handle_bad_irq) {
 				raw_spin_lock(&desc->lock);
-				irq_data = &desc->irq_data;
+				irq_data = irq_domain_get_irq_data(eiointc_priv[i]->eiointc_domain, irq_desc_get_irq(desc));
 				eiointc_set_irq_affinity(irq_data, irq_data->common->affinity, 0);
 				raw_spin_unlock(&desc->lock);
 			}
-- 
2.39.2



