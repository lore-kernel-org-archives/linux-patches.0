Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579FE9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1522C433C7;
	Sun, 13 Aug 2023 21:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962794;
	bh=D8WnFNVVIc5gT0iNlogvntQJ1O5pi8KzyS7M447Rb9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sn4TD2rchAPLziNZCr2JcN3mZVpSN48MqC7xufc/qt3nLFfrxD/7NhFa9jgC07Cqq
	 oixt8VXQByhs5dK91PehFCUZxaQ5gzpYcPYQVVGDVyy0QfRFbwwKLZmSjnb/YnjEG6
	 iIZogSok/ARs237U9QNdmn4EKMbPKpMTUfMU+p7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Tresidder <rtresidd@electromag.com.au>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 10/68] dmaengine: pl330: Return DMA_PAUSED when transaction is paused
Date: Sun, 13 Aug 2023 23:19:11 +0200
Message-ID: <20230813211708.472474528@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 8cda3ececf07d374774f6a13e5a94bc2dc04c26c upstream.

pl330_pause() does not set anything to indicate paused condition which
causes pl330_tx_status() to return DMA_IN_PROGRESS. This breaks 8250
DMA flush after the fix in commit 57e9af7831dc ("serial: 8250_dma: Fix
DMA Rx rearm race"). The function comment for pl330_pause() claims
pause is supported but resume is not which is enough for 8250 DMA flush
to work as long as DMA status reports DMA_PAUSED when appropriate.

Add PAUSED state for descriptor and mark BUSY descriptors with PAUSED
in pl330_pause(). Return DMA_PAUSED from pl330_tx_status() when the
descriptor is PAUSED.

Reported-by: Richard Tresidder <rtresidd@electromag.com.au>
Tested-by: Richard Tresidder <rtresidd@electromag.com.au>
Fixes: 88987d2c7534 ("dmaengine: pl330: add DMA_PAUSE feature")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-serial/f8a86ecd-64b1-573f-c2fa-59f541083f1a@electromag.com.au/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230526105434.14959-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/pl330.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -404,6 +404,12 @@ enum desc_status {
 	 */
 	BUSY,
 	/*
+	 * Pause was called while descriptor was BUSY. Due to hardware
+	 * limitations, only termination is possible for descriptors
+	 * that have been paused.
+	 */
+	PAUSED,
+	/*
 	 * Sitting on the channel work_list but xfer done
 	 * by PL330 core
 	 */
@@ -2043,7 +2049,7 @@ static inline void fill_queue(struct dma
 	list_for_each_entry(desc, &pch->work_list, node) {
 
 		/* If already submitted */
-		if (desc->status == BUSY)
+		if (desc->status == BUSY || desc->status == PAUSED)
 			continue;
 
 		ret = pl330_submit_req(pch->thread, desc);
@@ -2328,6 +2334,7 @@ static int pl330_pause(struct dma_chan *
 {
 	struct dma_pl330_chan *pch = to_pchan(chan);
 	struct pl330_dmac *pl330 = pch->dmac;
+	struct dma_pl330_desc *desc;
 	unsigned long flags;
 
 	pm_runtime_get_sync(pl330->ddma.dev);
@@ -2337,6 +2344,10 @@ static int pl330_pause(struct dma_chan *
 	_stop(pch->thread);
 	spin_unlock(&pl330->lock);
 
+	list_for_each_entry(desc, &pch->work_list, node) {
+		if (desc->status == BUSY)
+			desc->status = PAUSED;
+	}
 	spin_unlock_irqrestore(&pch->lock, flags);
 	pm_runtime_mark_last_busy(pl330->ddma.dev);
 	pm_runtime_put_autosuspend(pl330->ddma.dev);
@@ -2427,7 +2438,7 @@ pl330_tx_status(struct dma_chan *chan, d
 		else if (running && desc == running)
 			transferred =
 				pl330_get_current_xferred_count(pch, desc);
-		else if (desc->status == BUSY)
+		else if (desc->status == BUSY || desc->status == PAUSED)
 			/*
 			 * Busy but not running means either just enqueued,
 			 * or finished and not yet marked done
@@ -2444,6 +2455,9 @@ pl330_tx_status(struct dma_chan *chan, d
 			case DONE:
 				ret = DMA_COMPLETE;
 				break;
+			case PAUSED:
+				ret = DMA_PAUSED;
+				break;
 			case PREP:
 			case BUSY:
 				ret = DMA_IN_PROGRESS;


