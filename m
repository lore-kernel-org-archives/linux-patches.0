Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA83B5372C9;
	Thu, 17 Sep 2026 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664538; cv=none; b=nR/Yqi80IOllhjIXb6DspBGj1qU+1uFaQJUxbZy1zqp+qmGerzTjojr69nPOR9w71u4aJa/LOb1O0uUGe/fLuxSv/Tsu4C1iI46EMxOLnpi2+ajBLuAvzL5XiIAN4TtwMjkAz9gMPkztSLluyxko7iYViAozaUjeCnaceARrG4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664538; c=relaxed/simple;
	bh=X0HXR3k8pgXn8Xa7RBlHYwueAJxjiX1qUrEg7whcf8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajDHZLcTu13mQjpZFyI6RtIBci3+norSYdXWzjnl5wsObScjsr/fc2Vjq6f+P4katwwH9LnD2IdXBwqCv6Cc2t4i9pKreKP2sBimVnWF6DYp/hUmkKFyZPNN9vDbCTfXoFcI3BgYLNwlOOEgv5xA3/iyC6nWaE2UFXlZdyJ+PzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGTBMHym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGTBMHym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AF11F000FF;
	Thu, 17 Sep 2026 17:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664537;
	bh=UWWmRcj0T6RFq2oM96uTPsVzc6aQ4z6tFHURu/NREw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGTBMHymiDwW3R6xoSMoRbJu2BjxjJXVYfBwMYd1y6txo5Iz1Bg98p13EE7w0bn5r
	 1zFwIqpk5sgyqADHVlXSJnmY9Kauo0NpcCZJJd04iuiFIzeinD4IXCEm7zXImL5/T4
	 ixRBP9bOcbuodn4pMq5kuARdz72r0xxtYwZca5bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0406/1250] net: stmmac: xgmac2: disable RBUE in default RX interrupt mask
Date: Thu, 17 Sep 2026 16:03:21 +0100
Message-ID: <20260917151603.032380037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>

[ Upstream commit d3265c19b35d036bba327b36b5366bee76b0157c ]

Enabling the RX Buffer Unavailable (RBUE) interrupt is counterproductive
and can trigger a MAC interrupt storm under heavy RX pressure. When the
DMA runs out of RX descriptors it fires RBUE continuously until software
refills the ring.

However, RBUE is redundant: the normal RX completion interrupt (RIE)
already triggers NAPI, which processes completed descriptors and refills
the ring, causing the DMA to resume. The RBUE handler itself only sets
handle_rx - the same outcome as RIE.

On Agilex5 under heavy RX pressure, the MAC interrupt (which includes
RBUE) was observed firing 1,821,811,555 times against only 2,618,627
actual RX completions - a ~695x ratio - confirming the severity of the
storm.

RBUE does not provide OOM recovery. If page_pool is exhausted,
stmmac_rx_refill() cannot advance the DMA tail pointer, the DMA stays
suspended, and RBUE fires again on the next NAPI completion - a storm
with no forward progress. This patch trades that storm for a clean
stall with the same RX outcome. Proper OOM recovery is a pre-existing
gap outside the scope of this fix.

Note: as a consequence of disabling RBUE, the rx_buf_unav_irq ethtool
counter will always read 0 on XGMAC2 devices. This behaviour is already
inconsistent across DWMAC core versions.

Remove RBUE from XGMAC_DMA_INT_DEFAULT_EN and XGMAC_DMA_INT_DEFAULT_RX
to prevent the interrupt storm while keeping normal RX handling intact.

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260609121703.9736-1-muhammad.nazim.amirul.nazle.asmade@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 67e2d539c3385..301e5e8993e37 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -385,9 +385,9 @@
 #define XGMAC_RIE			BIT(6)
 #define XGMAC_TBUE			BIT(2)
 #define XGMAC_TIE			BIT(0)
-#define XGMAC_DMA_INT_DEFAULT_EN	(XGMAC_NIE | XGMAC_AIE | XGMAC_RBUE | \
+#define XGMAC_DMA_INT_DEFAULT_EN	(XGMAC_NIE | XGMAC_AIE | \
 					XGMAC_RIE | XGMAC_TIE)
-#define XGMAC_DMA_INT_DEFAULT_RX	(XGMAC_RBUE | XGMAC_RIE)
+#define XGMAC_DMA_INT_DEFAULT_RX	(XGMAC_RIE)
 #define XGMAC_DMA_INT_DEFAULT_TX	(XGMAC_TIE)
 #define XGMAC_DMA_CH_Rx_WATCHDOG(x)	(0x0000313c + (0x80 * (x)))
 #define XGMAC_RWT			GENMASK(7, 0)
-- 
2.53.0



