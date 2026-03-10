Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD6B36D512;
	Tue, 10 Mar 2026 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141297; cv=none; b=jBAfWLw+lx8n+rlocCEbO7sTHZWse9zBeQXqdx4MtsGM+Sca+exRZ5amth91r7zFYuJsZEoOQ0iIUFNZSIynZgWU9PfuKFJhk5d8CPy040TRbwkQY1yAnE05z3ZeN37m8QIlQqlMB1qNWciaa/4wM6yH8Ts4ST8kFubJFDlK5rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141297; c=relaxed/simple;
	bh=W2fEaDeMNvM4um/mDg9I+9YnqIBPQDTOp4QHZI3+f3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uELV//1zUZue8WdYsr5g5s1tDv4EqRID8LG1u0VdcZ6GFfmNWV8DwdkUuc9znxeXggOdxJAaD0ep1X05WDw7nwe2RIjLbS9IhPVly9wzKboFdDHPX7clobepMuu8tXCrxy9nen4VfIVNHJnf1283k1u761vKDJha2JAGBBtg7mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOZ2q3ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOZ2q3ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFD3C19423;
	Tue, 10 Mar 2026 11:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141297;
	bh=W2fEaDeMNvM4um/mDg9I+9YnqIBPQDTOp4QHZI3+f3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOZ2q3ejyaDcOJ1v5viygrXD8rzOt4g9DZxJfHYExJENlH1XluC9g1uLG83J8JWVX
	 +eJtr9xyqRwIfvCu7bHxgTAO9b+rFGPeB6RSFk64dxjEnyONy4z//M/kZLz+lNZzbn
	 lpZiOVa0USq9/xfljIQAuhPO4kYm+IgIsNCZ1Ng+W8A6/4fs1zomhSUP3aD6t8FEZ5
	 7JcwYxPU9uaZQ+0SwxLxadiQ/enZG5xSFy4iEeC2C+kBWOe6l5ZarVDPK2n8AYvwB7
	 vJxyLfesDvaXckVWjuJFBH9sGHxCCFbYS20KE9FbK905MvYXIRUFmmjz8FXej50rNs
	 BG/r3xlO1qpyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 301/311] i40e: fix registering XDP RxQ info
Date: Tue, 10 Mar 2026 07:05:48 -0400
Message-ID: <c4d8bb26df3abf00e525953b6f5279e3c1fb735a.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 8f497dc8a61429cc004720aa8e713743355d80cf ]

Current way of handling XDP RxQ info in i40e has a problem, where frag_size
is not updated when xsk_buff_pool is detached or when MTU is changed, this
leads to growing tail always failing for multi-buffer packets.

Couple XDP RxQ info registering with buffer allocations and unregistering
with cleaning the ring.

Fixes: a045d2f2d03d ("i40e: set xdp_rxq_info::frag_size")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260305111253.2317394-6-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 34 ++++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |  5 +--
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 02de186dcc8f5..bc00bd4f439be 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3583,18 +3583,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	if (ring->vsi->type != I40E_VSI_MAIN)
 		goto skip;
 
-	if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
-		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-					 ring->queue_index,
-					 ring->q_vector->napi.napi_id,
-					 ring->rx_buf_len);
-		if (err)
-			return err;
-	}
-
 	ring->xsk_pool = i40e_xsk_pool(ring);
 	if (ring->xsk_pool) {
-		xdp_rxq_info_unreg(&ring->xdp_rxq);
 		ring->rx_buf_len = xsk_pool_get_rx_frame_size(ring->xsk_pool);
 		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 					 ring->queue_index,
@@ -3606,17 +3596,23 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 						 MEM_TYPE_XSK_BUFF_POOL,
 						 NULL);
 		if (err)
-			return err;
+			goto unreg_xdp;
 		dev_info(&vsi->back->pdev->dev,
 			 "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 			 ring->queue_index);
 
 	} else {
+		err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+					 ring->queue_index,
+					 ring->q_vector->napi.napi_id,
+					 ring->rx_buf_len);
+		if (err)
+			return err;
 		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 						 MEM_TYPE_PAGE_SHARED,
 						 NULL);
 		if (err)
-			return err;
+			goto unreg_xdp;
 	}
 
 skip:
@@ -3654,7 +3650,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		dev_info(&vsi->back->pdev->dev,
 			 "Failed to clear LAN Rx queue context on Rx ring %d (pf_q %d), error: %d\n",
 			 ring->queue_index, pf_q, err);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto unreg_xdp;
 	}
 
 	/* set the context in the HMC */
@@ -3663,7 +3660,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		dev_info(&vsi->back->pdev->dev,
 			 "Failed to set LAN Rx queue context on Rx ring %d (pf_q %d), error: %d\n",
 			 ring->queue_index, pf_q, err);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto unreg_xdp;
 	}
 
 	/* configure Rx buffer alignment */
@@ -3671,7 +3669,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		if (I40E_2K_TOO_SMALL_WITH_PADDING) {
 			dev_info(&vsi->back->pdev->dev,
 				 "2k Rx buffer is too small to fit standard MTU and skb_shared_info\n");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto unreg_xdp;
 		}
 		clear_ring_build_skb_enabled(ring);
 	} else {
@@ -3701,6 +3700,11 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	}
 
 	return 0;
+unreg_xdp:
+	if (ring->vsi->type == I40E_VSI_MAIN)
+		xdp_rxq_info_unreg(&ring->xdp_rxq);
+
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index cc0b9efc2637a..816179c7e2712 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1470,6 +1470,9 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 	if (!rx_ring->rx_bi)
 		return;
 
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+
 	if (rx_ring->xsk_pool) {
 		i40e_xsk_clean_rx_ring(rx_ring);
 		goto skip_free;
@@ -1527,8 +1530,6 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 void i40e_free_rx_resources(struct i40e_ring *rx_ring)
 {
 	i40e_clean_rx_ring(rx_ring);
-	if (rx_ring->vsi->type == I40E_VSI_MAIN)
-		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	rx_ring->xdp_prog = NULL;
 	kfree(rx_ring->rx_bi);
 	rx_ring->rx_bi = NULL;
-- 
2.51.0

