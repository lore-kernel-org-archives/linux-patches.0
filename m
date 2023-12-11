Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A3A5101A;
	Mon, 11 Dec 2023 18:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrWxG8wI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783FBC433C7;
	Mon, 11 Dec 2023 18:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319312;
	bh=OMJ5y3Uw6+rqFGS3iW5vaeiioA+ER2/dRKdvjzL5ejY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrWxG8wILL6ohQhSR73YGk5Yh6SBTjpz1qjLNSq9PJOT0J3UF3JagDWrJSfW34LKD
	 maZyFrO7KsGJFUJokPjqb2g9cHYywPbX1RsFPkg/0Anck1KwyIhmqrom8rclgOF9Ao
	 BgCC3DBmqGzuUU7NEnbmPounWRHg2Fy0QnuP4G8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Suman Ghosh <sumang@marvell.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/244] octeontx2-pf: consider both Rx and Tx packet stats for adaptive interrupt coalescing
Date: Mon, 11 Dec 2023 19:18:54 +0100
Message-ID: <20231211182047.659500255@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Mamindlapalli <naveenm@marvell.com>

[ Upstream commit adbf100fc47001c93d7e513ecac6fd6e04d5b4a1 ]

The current adaptive interrupt coalescing code updates only rx
packet stats for dim algorithm. This patch also updates tx packet
stats which will be useful when there is only tx traffic.
Also moved configuring hardware adaptive interrupt setting to
driver dim callback.

Fixes: 6e144b47f560 ("octeontx2-pf: Add support for adaptive interrupt coalescing")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://lore.kernel.org/r/20231201053330.3903694-1-sumang@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  9 +++++++++
 .../marvell/octeontx2/nic/otx2_txrx.c         | 20 +++++++++----------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 532e324bdcc8e..0c17ebdda1487 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1688,6 +1688,14 @@ static void otx2_do_set_rx_mode(struct otx2_nic *pf)
 	mutex_unlock(&pf->mbox.lock);
 }
 
+static void otx2_set_irq_coalesce(struct otx2_nic *pfvf)
+{
+	int cint;
+
+	for (cint = 0; cint < pfvf->hw.cint_cnt; cint++)
+		otx2_config_irq_coalescing(pfvf, cint);
+}
+
 static void otx2_dim_work(struct work_struct *w)
 {
 	struct dim_cq_moder cur_moder;
@@ -1703,6 +1711,7 @@ static void otx2_dim_work(struct work_struct *w)
 		CQ_TIMER_THRESH_MAX : cur_moder.usec;
 	pfvf->hw.cq_ecount_wait = (cur_moder.pkts > NAPI_POLL_WEIGHT) ?
 		NAPI_POLL_WEIGHT : cur_moder.pkts;
+	otx2_set_irq_coalesce(pfvf);
 	dim->state = DIM_START_MEASURE;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 6ee15f3c25ede..4d519ea833b2c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -512,11 +512,18 @@ static void otx2_adjust_adaptive_coalese(struct otx2_nic *pfvf, struct otx2_cq_p
 {
 	struct dim_sample dim_sample;
 	u64 rx_frames, rx_bytes;
+	u64 tx_frames, tx_bytes;
 
 	rx_frames = OTX2_GET_RX_STATS(RX_BCAST) + OTX2_GET_RX_STATS(RX_MCAST) +
 		OTX2_GET_RX_STATS(RX_UCAST);
 	rx_bytes = OTX2_GET_RX_STATS(RX_OCTS);
-	dim_update_sample(pfvf->napi_events, rx_frames, rx_bytes, &dim_sample);
+	tx_bytes = OTX2_GET_TX_STATS(TX_OCTS);
+	tx_frames = OTX2_GET_TX_STATS(TX_UCAST);
+
+	dim_update_sample(pfvf->napi_events,
+			  rx_frames + tx_frames,
+			  rx_bytes + tx_bytes,
+			  &dim_sample);
 	net_dim(&cq_poll->dim, dim_sample);
 }
 
@@ -558,16 +565,9 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
 		if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
 			return workdone;
 
-		/* Check for adaptive interrupt coalesce */
-		if (workdone != 0 &&
-		    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
-		     OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
-			/* Adjust irq coalese using net_dim */
+		/* Adjust irq coalese using net_dim */
+		if (pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED)
 			otx2_adjust_adaptive_coalese(pfvf, cq_poll);
-			/* Update irq coalescing */
-			for (i = 0; i < pfvf->hw.cint_cnt; i++)
-				otx2_config_irq_coalescing(pfvf, i);
-		}
 
 		if (unlikely(!filled_cnt)) {
 			struct refill_work *work;
-- 
2.42.0



