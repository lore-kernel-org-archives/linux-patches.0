Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4988B223E87;
	Thu, 12 Dec 2024 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021583; cv=none; b=ZwzS6+U/psqzqZIDpLRpUysb+0aesdKChdwXrF+ByXhZski1x8ERQeUiZH+nMoVJ4CrNdPVEZJXgCLJ2naaPwMZOMqybsw8H/oJn/o+i4ynFwFptULEWBK9h00p0csuOgLo/zmZc4Qg+1NJu6MnRyraFM550tFoUz4XS748DLRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021583; c=relaxed/simple;
	bh=tgsDjW39aZkzByoFxUyRd/efzfduy6LbG/Jl9/wlm8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9OocbulhDZ9k3A2/Go6aDuZiYFLegI3mUUuCFB8I7seBSnHl1v4WI67noYNf0Iz1sluRCqWkgWz53+zjje3lbxLUFNH3NmrZ50XADtJgogVkXE1Nnp0zDQTjv6RzqTBh3UDJwkwAQpvMqiOAPEM/uFnfHaIRHa2tH8/BBPSqX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIv73pPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIv73pPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F378C4CECE;
	Thu, 12 Dec 2024 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021583;
	bh=tgsDjW39aZkzByoFxUyRd/efzfduy6LbG/Jl9/wlm8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIv73pPdjhYA4uJg6C8e7PPYP7EyUm7FakjohanpFwBLsPui+s77q7QfZJ9TpVG8P
	 HEway44ZssHf2AVQySWwhTYH5fYobckp3NhWyAVjN5frzoqj4lL2/WPuVZH/4YAvnH
	 NrradH2MdJn7Z3ZMCKKLXZwsIP/cUD+e0JJ/uNz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziwei Xiao <ziweixiao@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Praveen Kaligineedi <pkaligineedi@google.com>
Subject: [PATCH 6.1 752/772] gve: Fixes for napi_poll when budget is 0
Date: Thu, 12 Dec 2024 16:01:37 +0100
Message-ID: <20241212144421.004272484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -202,6 +202,10 @@ static int gve_napi_poll(struct napi_str
 
 	if (block->tx)
 		reschedule |= gve_tx_poll(block, budget);
+
+	if (!budget)
+		return 0;
+
 	if (block->rx) {
 		work_done = gve_rx_poll(block, budget);
 		reschedule |= work_done == budget;
@@ -242,6 +246,9 @@ static int gve_napi_poll_dqo(struct napi
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
@@ -778,10 +778,6 @@ int gve_rx_poll(struct gve_notify_block
 
 	feat = block->napi.dev->features;
 
-	/* If budget is 0, do all the work */
-	if (budget == 0)
-		budget = INT_MAX;
-
 	if (budget > 0)
 		work_done = gve_clean_rx_done(rx, budget, feat);
 
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -725,10 +725,6 @@ bool gve_tx_poll(struct gve_notify_block
 	u32 nic_done;
 	u32 to_do;
 
-	/* If budget is 0, do all the work */
-	if (budget == 0)
-		budget = INT_MAX;
-
 	/* In TX path, it may try to clean completed pkts in order to xmit,
 	 * to avoid cleaning conflict, use spin_lock(), it yields better
 	 * concurrency between xmit/clean than netif's lock.


