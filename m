Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3B7223302;
	Thu, 12 Dec 2024 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023502; cv=none; b=bhDkgZETaKoDlL9RYmpI4KCpLcKr0q6HQU3wsRDsplEfhweJ/FK+sxsl5XldPNAvXSw38VAzOOh5xqlYa8DPRM6kMiZBe+RDVjJKvaKBVCtOQmBTfIoa9WjUWmfLqvAYkMkgM3v/4LV3fWZFhsviJhWNY2FvOcuWuNXkSNKV/4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023502; c=relaxed/simple;
	bh=o5L2ZGXgv4GKcllwKCttSAIFGQFLbH7UeJQZ6oUeQxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAyYeqbIjkuqVsCzmgkRcqyZEC/dbXgyc6UZpONHuHy+62P3m5ghegAEbI63EuK28dRJDhOzwJI558Ea/ASJz4x+rdJe3JbEOdMZP3rVImantmSEnZT/ucO2OmzrJehmSjYuW98Xf5a7dvVDR+PCePvZD9xs6YFiUbI8oPLij74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6wtVHmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6wtVHmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CD1C4CED0;
	Thu, 12 Dec 2024 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023502;
	bh=o5L2ZGXgv4GKcllwKCttSAIFGQFLbH7UeJQZ6oUeQxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6wtVHmWxlnI0+ELTBvycObBaHSFa1Dav/XVhDFzMRm8fhUj5UEr2wV7mw0KYu1oW
	 60Y0EVK0E+HHwLnfo+Dy+TX44FzpCzVwVRC9QUaqw1KBaL4BN/BqDybwLbH31Rh8Me
	 QsXoa+bfcviqqemap1RRdsDIg6CAg0wqeoterYYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziwei Xiao <ziweixiao@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Praveen Kaligineedi <pkaligineedi@google.com>
Subject: [PATCH 5.15 555/565] gve: Fixes for napi_poll when budget is 0
Date: Thu, 12 Dec 2024 16:02:30 +0100
Message-ID: <20241212144333.800452202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziwei Xiao <ziweixiao@google.com>

commit 278a370c1766060d2144d6cf0b06c101e1043b6d upstream.

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
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |    7 +++++++
 drivers/net/ethernet/google/gve/gve_rx.c   |    4 ----
 drivers/net/ethernet/google/gve/gve_tx.c   |    4 ----
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -201,6 +201,10 @@ static int gve_napi_poll(struct napi_str
 
 	if (block->tx)
 		reschedule |= gve_tx_poll(block, budget);
+
+	if (!budget)
+		return 0;
+
 	if (block->rx)
 		reschedule |= gve_rx_poll(block, budget);
 
@@ -236,6 +240,9 @@ static int gve_napi_poll_dqo(struct napi
 	if (block->tx)
 		reschedule |= gve_tx_poll_dqo(block, /*do_clean=*/true);
 
+	if (!budget)
+		return 0;
+
 	if (block->rx) {
 		work_done = gve_rx_poll_dqo(block, budget);
 		reschedule |= work_done == budget;
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -606,10 +606,6 @@ bool gve_rx_poll(struct gve_notify_block
 
 	feat = block->napi.dev->features;
 
-	/* If budget is 0, do all the work */
-	if (budget == 0)
-		budget = INT_MAX;
-
 	if (budget > 0)
 		repoll |= gve_clean_rx_done(rx, budget, feat);
 	else
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -686,10 +686,6 @@ bool gve_tx_poll(struct gve_notify_block
 	u32 nic_done;
 	u32 to_do;
 
-	/* If budget is 0, do all the work */
-	if (budget == 0)
-		budget = INT_MAX;
-
 	/* Find out how much work there is to be done */
 	tx->last_nic_done = gve_tx_load_event_counter(priv, tx);
 	nic_done = be32_to_cpu(tx->last_nic_done);


