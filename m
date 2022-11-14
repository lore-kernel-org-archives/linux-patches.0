Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BC34C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6BBC433C1;
	Mon, 14 Nov 2022 12:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430123;
	bh=AmC6SWLQpycyWMTHoLh+kSTNdTTY02B8nw0QpKdJHXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSnC3s0BIWZ2KCCGVOCgVc5homvBcwrpqveR1Brh4HUB0Ket5RBONM8gui3iJDIxc
	 0gNKmVy9Xsk45x+1hl03/TEXNWyOEsIdEI295lq3Lzx6m3Scz1qrLpBPiCmVK2JXqO
	 Ite8F8OGBvJzVvHt8c7/p+qVmZktc4Ch0cQhYgXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/95] dmaengine: pxa_dma: use platform_get_irq_optional
Date: Mon, 14 Nov 2022 13:45:27 +0100
Message-Id: <20221114124443.940655475@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Doug Brown <doug@schmorgal.com>

[ Upstream commit b3d726cb8497c6b12106fd617d46eef11763ea86 ]

The first IRQ is required, but IRQs 1 through (nb_phy_chans - 1) are
optional, because on some platforms (e.g. PXA168) there is a single IRQ
shared between all channels.

This change inhibits a flood of "IRQ index # not found" messages at
startup. Tested on a PXA168-based device.

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20220906000709.52705-1-doug@schmorgal.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pxa_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pxa_dma.c b/drivers/dma/pxa_dma.c
index b4ef4f19f7de..68d9d60c051d 100644
--- a/drivers/dma/pxa_dma.c
+++ b/drivers/dma/pxa_dma.c
@@ -1249,14 +1249,14 @@ static int pxad_init_phys(struct platform_device *op,
 		return -ENOMEM;
 
 	for (i = 0; i < nb_phy_chans; i++)
-		if (platform_get_irq(op, i) > 0)
+		if (platform_get_irq_optional(op, i) > 0)
 			nr_irq++;
 
 	for (i = 0; i < nb_phy_chans; i++) {
 		phy = &pdev->phys[i];
 		phy->base = pdev->base;
 		phy->idx = i;
-		irq = platform_get_irq(op, i);
+		irq = platform_get_irq_optional(op, i);
 		if ((nr_irq > 1) && (irq > 0))
 			ret = devm_request_irq(&op->dev, irq,
 					       pxad_chan_handler,
-- 
2.35.1



