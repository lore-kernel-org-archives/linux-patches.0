Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0A5168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C10C4339E;
	Mon,  8 May 2023 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545195;
	bh=EBo/OFPfS9SqhsmetU9okX0SmvsBLHGShQFTYjksyBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkwyBmUj+ff/cwwsGP4YZEw5f/iEFSiMm2zfx16JWjowuDq42Z0gwr7VsD9YIVNEB
	 vX5CaVzTNY5QT3fw7KRwRiT7inD0ie36d5GDZc2MhX9X1sWYlCQgbphudYtIpG48TS
	 I0WCJg1T0En5rkGx1nBnUjkOYRS48j+Xf7tcpssc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 656/694] dmaengine: at_xdmac: do not enable all cyclic channels
Date: Mon,  8 May 2023 11:48:11 +0200
Message-Id: <20230508094457.247633553@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit f8435befd81dd85b7b610598551fadf675849bc1 ]

Do not global enable all the cyclic channels in at_xdmac_resume(). Instead
save the global status in at_xdmac_suspend() and re-enable the cyclic
channel only if it was active before suspend.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230214151827.1050280-6-claudiu.beznea@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 34c004a4b23cb..96f1b69f8a75e 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -246,6 +246,7 @@ struct at_xdmac {
 	int			irq;
 	struct clk		*clk;
 	u32			save_gim;
+	u32			save_gs;
 	struct dma_pool		*at_xdmac_desc_pool;
 	const struct at_xdmac_layout	*layout;
 	struct at_xdmac_chan	chan[];
@@ -2162,6 +2163,7 @@ static int __maybe_unused atmel_xdmac_suspend(struct device *dev)
 		}
 	}
 	atxdmac->save_gim = at_xdmac_read(atxdmac, AT_XDMAC_GIM);
+	atxdmac->save_gs = at_xdmac_read(atxdmac, AT_XDMAC_GS);
 
 	at_xdmac_off(atxdmac, false);
 	pm_runtime_mark_last_busy(atxdmac->dev);
@@ -2224,7 +2226,8 @@ static int __maybe_unused atmel_xdmac_resume(struct device *dev)
 			at_xdmac_chan_write(atchan, AT_XDMAC_CNDC, atchan->save_cndc);
 			at_xdmac_chan_write(atchan, AT_XDMAC_CIE, atchan->save_cim);
 			wmb();
-			at_xdmac_write(atxdmac, AT_XDMAC_GE, atchan->mask);
+			if (atxdmac->save_gs & atchan->mask)
+				at_xdmac_write(atxdmac, AT_XDMAC_GE, atchan->mask);
 		}
 	}
 
-- 
2.39.2



