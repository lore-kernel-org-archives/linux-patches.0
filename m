Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AE02EAFB;
	Fri, 24 Nov 2023 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHZl2WrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D77C433C8;
	Fri, 24 Nov 2023 18:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850820;
	bh=uYtmQxkh3tEwcbB3lo8MilB7QIWXD4BN94mrYABf/QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHZl2WrOqXkPCxYDG1jD6A4TAg9KLI6vSsWuy+/e19PwAvPaO67HqSXTZZFXF6Rtw
	 l/bqTSTODvth1xjxKnIqUhVv3o5Hkk3Zn1Uzps/yvU+CZOk3CCLDzsIj2cwxfVOCEe
	 FJ5gufQ4ybz3ClrbbzitNJFJhdPn6FGoQcXvI2BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziwei Xiao <ziweixiao@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 202/491] gve: Fixes for napi_poll when budget is 0
Date: Fri, 24 Nov 2023 17:47:18 +0000
Message-ID: <20231124172030.574481059@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziwei Xiao <ziweixiao@google.com>

[ Upstream commit 278a370c1766060d2144d6cf0b06c101e1043b6d ]

Netpoll will explicilty pass the polling call with a budget of 0 to
indicate it's clearing the Tx path only. For the gve_rx_poll and
gve_xdp_poll, they were mistakenly taking the 0 budget as the indication
to do all the work. Add check to avoid the rx path and xdp path being
called when budget is 0. And also avoid napi_complete_done being called
when budget is 0 for netpoll.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Link: https://lore.kernel.org/r/20231114004144.2022268-1-ziweixiao@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 8 +++++++-
 drivers/net/ethernet/google/gve/gve_rx.c   | 4 ----
 drivers/net/ethernet/google/gve/gve_tx.c   | 4 ----
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 465a6db5a40a8..79bfa2837a0e6 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -255,10 +255,13 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
 	if (block->tx) {
 		if (block->tx->q_num < priv->tx_cfg.num_queues)
 			reschedule |= gve_tx_poll(block, budget);
-		else
+		else if (budget)
 			reschedule |= gve_xdp_poll(block, budget);
 	}
 
+	if (!budget)
+		return 0;
+
 	if (block->rx) {
 		work_done = gve_rx_poll(block, budget);
 		reschedule |= work_done == budget;
@@ -299,6 +302,9 @@ static int gve_napi_poll_dqo(struct napi_struct *napi, int budget)
 	if (block->tx)
 		reschedule |= gve_tx_poll_dqo(block, /*do_clean=*/true);
 
+	if (!budget)
+		return 0;
+
 	if (block->rx) {
 		work_done = gve_rx_poll_dqo(block, budget);
 		reschedule |= work_done == budget;
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index e84a066aa1a40..73655347902d2 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -1007,10 +1007,6 @@ int gve_rx_poll(struct gve_notify_block *block, int budget)
 
 	feat = block->napi.dev->features;
 
-	/* If budget is 0, do all the work */
-	if (budget == 0)
-		budget = INT_MAX;
-
 	if (budget > 0)
 		work_done = gve_clean_rx_done(rx, budget, feat);
 
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 6957a865cff37..9f6ffc4a54f0b 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -925,10 +925,6 @@ bool gve_xdp_poll(struct gve_notify_block *block, int budget)
 	bool repoll;
 	u32 to_do;
 
-	/* If budget is 0, do all the work */
-	if (budget == 0)
-		budget = INT_MAX;
-
 	/* Find out how much work there is to be done */
 	nic_done = gve_tx_load_event_counter(priv, tx);
 	to_do = min_t(u32, (nic_done - tx->done), budget);
-- 
2.42.0



