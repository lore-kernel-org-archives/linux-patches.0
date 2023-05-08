Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8BF168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23043C433EF;
	Mon,  8 May 2023 11:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545188;
	bh=/fIBBkCxQO9gDnjSanJK/U8C448FJxwXfzh5/MCUSwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffZKpz9jgcXmekadVTkjJ/GKSQuwPuUetPxh49umhlUlyDYHjfWttE7j6XPlx3BUI
	 Sm3bji24U4oR4su0qTY/6+/KI2BbGPvppGg12sC48CsU9aq/ngmDz7VeBzWaG5Rfnr
	 c3fWJ5D/u+MIh1R6jb/Pc7p0ViO8Rk9K/Nw8Jahg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 654/694] dmaengine: at_xdmac: do not resume channels paused by consumers
Date: Mon,  8 May 2023 11:48:09 +0200
Message-Id: <20230508094457.159825688@linuxfoundation.org>
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

[ Upstream commit 44fe8440bda545b5d167329df88c47609a645168 ]

In case there are DMA channels not paused by consumers in suspend
process (valid on AT91 SoCs for serial driver when no_console_suspend) the
driver pauses them (using at_xdmac_device_pause() which is also the same
function called by dmaengine_pause()) and then in the resume process the
driver resumes them calling at_xdmac_device_resume() which is the same
function called by dmaengine_resume()). This is good for DMA channels
not paused by consumers but for drivers that calls
dmaengine_pause()/dmaegine_resume() on suspend/resume path this may lead to
DMA channel being enabled before the IP is enabled. For IPs that needs
strict ordering with regards to DMA channel enablement this will lead to
wrong behavior. To fix this add a new set of functions
at_xdmac_device_pause_internal()/at_xdmac_device_resume_internal() to be
called only on suspend/resume.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230214151827.1050280-4-claudiu.beznea@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_xdmac.c | 52 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index af3b494f9ba9b..fa1e2e0da02f5 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -187,6 +187,7 @@
 enum atc_status {
 	AT_XDMAC_CHAN_IS_CYCLIC = 0,
 	AT_XDMAC_CHAN_IS_PAUSED,
+	AT_XDMAC_CHAN_IS_PAUSED_INTERNAL,
 };
 
 struct at_xdmac_layout {
@@ -347,6 +348,11 @@ static inline int at_xdmac_chan_is_paused(struct at_xdmac_chan *atchan)
 	return test_bit(AT_XDMAC_CHAN_IS_PAUSED, &atchan->status);
 }
 
+static inline int at_xdmac_chan_is_paused_internal(struct at_xdmac_chan *atchan)
+{
+	return test_bit(AT_XDMAC_CHAN_IS_PAUSED_INTERNAL, &atchan->status);
+}
+
 static inline bool at_xdmac_chan_is_peripheral_xfer(u32 cfg)
 {
 	return cfg & AT_XDMAC_CC_TYPE_PER_TRAN;
@@ -1898,6 +1904,26 @@ static int at_xdmac_device_config(struct dma_chan *chan,
 	return ret;
 }
 
+static void at_xdmac_device_pause_set(struct at_xdmac *atxdmac,
+				      struct at_xdmac_chan *atchan)
+{
+	at_xdmac_write(atxdmac, atxdmac->layout->grws, atchan->mask);
+	while (at_xdmac_chan_read(atchan, AT_XDMAC_CC) &
+	       (AT_XDMAC_CC_WRIP | AT_XDMAC_CC_RDIP))
+		cpu_relax();
+}
+
+static void at_xdmac_device_pause_internal(struct at_xdmac_chan *atchan)
+{
+	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
+	unsigned long		flags;
+
+	spin_lock_irqsave(&atchan->lock, flags);
+	set_bit(AT_XDMAC_CHAN_IS_PAUSED_INTERNAL, &atchan->status);
+	at_xdmac_device_pause_set(atxdmac, atchan);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+}
+
 static int at_xdmac_device_pause(struct dma_chan *chan)
 {
 	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
@@ -1915,11 +1941,8 @@ static int at_xdmac_device_pause(struct dma_chan *chan)
 		return ret;
 
 	spin_lock_irqsave(&atchan->lock, flags);
-	at_xdmac_write(atxdmac, atxdmac->layout->grws, atchan->mask);
-	while (at_xdmac_chan_read(atchan, AT_XDMAC_CC)
-	       & (AT_XDMAC_CC_WRIP | AT_XDMAC_CC_RDIP))
-		cpu_relax();
 
+	at_xdmac_device_pause_set(atxdmac, atchan);
 	/* Decrement runtime PM ref counter for each active descriptor. */
 	at_xdmac_runtime_suspend_descriptors(atchan);
 
@@ -1931,6 +1954,17 @@ static int at_xdmac_device_pause(struct dma_chan *chan)
 	return 0;
 }
 
+static void at_xdmac_device_resume_internal(struct at_xdmac_chan *atchan)
+{
+	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
+	unsigned long		flags;
+
+	spin_lock_irqsave(&atchan->lock, flags);
+	at_xdmac_write(atxdmac, atxdmac->layout->grwr, atchan->mask);
+	clear_bit(AT_XDMAC_CHAN_IS_PAUSED_INTERNAL, &atchan->status);
+	spin_unlock_irqrestore(&atchan->lock, flags);
+}
+
 static int at_xdmac_device_resume(struct dma_chan *chan)
 {
 	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
@@ -2119,7 +2153,7 @@ static int __maybe_unused atmel_xdmac_suspend(struct device *dev)
 		atchan->save_cc = at_xdmac_chan_read(atchan, AT_XDMAC_CC);
 		if (at_xdmac_chan_is_cyclic(atchan)) {
 			if (!at_xdmac_chan_is_paused(atchan)) {
-				at_xdmac_device_pause(chan);
+				at_xdmac_device_pause_internal(atchan);
 				at_xdmac_runtime_suspend_descriptors(atchan);
 			}
 			atchan->save_cim = at_xdmac_chan_read(atchan, AT_XDMAC_CIM);
@@ -2167,11 +2201,15 @@ static int __maybe_unused atmel_xdmac_resume(struct device *dev)
 
 		at_xdmac_chan_write(atchan, AT_XDMAC_CC, atchan->save_cc);
 		if (at_xdmac_chan_is_cyclic(atchan)) {
-			if (at_xdmac_chan_is_paused(atchan)) {
+			/*
+			 * Resume only channels not explicitly paused by
+			 * consumers.
+			 */
+			if (at_xdmac_chan_is_paused_internal(atchan)) {
 				ret = at_xdmac_runtime_resume_descriptors(atchan);
 				if (ret < 0)
 					return ret;
-				at_xdmac_device_resume(chan);
+				at_xdmac_device_resume_internal(atchan);
 			}
 			at_xdmac_chan_write(atchan, AT_XDMAC_CNDA, atchan->save_cnda);
 			at_xdmac_chan_write(atchan, AT_XDMAC_CNDC, atchan->save_cndc);
-- 
2.39.2



