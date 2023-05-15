Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8EBFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7D6C433D2;
	Mon, 15 May 2023 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169135;
	bh=SSDsLax/oxSZpWirU66ATXQyxPSeqpHAfv/U2GK4HIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTE4BiSB9Nt42QbP/RFSz0OOmffmeiQjOlIMLroP7xc7gsK7TlseMzFJrNN+6s8Om
	 +QxtiZo9k3lnsW/JOCVVkxEgRK/o1gCKjyy9PNovtR8dp5EFFmFj+YGLQEyN+0N+WS
	 Dc+cDSVhR7D2C01wOPu8nm5pWjg3wj1KF8gvJ2WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/191] dmaengine: at_xdmac: do not enable all cyclic channels
Date: Mon, 15 May 2023 18:26:01 +0200
Message-Id: <20230515161711.818772531@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
index a451ecae16692..33ea7abd8cc97 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -223,6 +223,7 @@ struct at_xdmac {
 	int			irq;
 	struct clk		*clk;
 	u32			save_gim;
+	u32			save_gs;
 	struct dma_pool		*at_xdmac_desc_pool;
 	struct at_xdmac_chan	chan[0];
 };
@@ -1878,6 +1879,7 @@ static int atmel_xdmac_suspend(struct device *dev)
 		}
 	}
 	atxdmac->save_gim = at_xdmac_read(atxdmac, AT_XDMAC_GIM);
+	atxdmac->save_gs = at_xdmac_read(atxdmac, AT_XDMAC_GS);
 
 	at_xdmac_off(atxdmac);
 	clk_disable_unprepare(atxdmac->clk);
@@ -1914,7 +1916,8 @@ static int atmel_xdmac_resume(struct device *dev)
 			at_xdmac_chan_write(atchan, AT_XDMAC_CNDC, atchan->save_cndc);
 			at_xdmac_chan_write(atchan, AT_XDMAC_CIE, atchan->save_cim);
 			wmb();
-			at_xdmac_write(atxdmac, AT_XDMAC_GE, atchan->mask);
+			if (atxdmac->save_gs & atchan->mask)
+				at_xdmac_write(atxdmac, AT_XDMAC_GE, atchan->mask);
 		}
 	}
 	return 0;
-- 
2.39.2



