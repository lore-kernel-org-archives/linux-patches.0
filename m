Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083734315A;
	Sun,  7 Sep 2025 20:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277688; cv=none; b=Rsy6+FB7h/srTGEyAn83c9oEiFgvtcjFRm3ePR5ZJfuNJf938U1stHnU5wKrnuwgPGzp6gOkvFyN7TTuaTbc+qqRd3D5v3Yj6C4IAC13/Y3zOJLc9IEYQYt2D35KeYO0HKKrPl3KZhMQmvU/AupJSM1Dc/5j/YtT26ItpOlWBWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277688; c=relaxed/simple;
	bh=SA+cSo8Ivf/Ah5zroxICVqCDZtasi48g0SgCzjEYoCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Flg1azEqmrNw9xCj1VW3WQFEZZ7JSghRTT4KpxoxKAZoQp8zs+oajuRhbKfqXI45FEdrUjfUgqPM+GSliqQwIOhgL3xJgInn8opfTZYJCFVoi0/ZnHnHZlBD0WATDzSqXB19r9beTn6sWRvIFoLvs/U3Mm4sHBoXEOdLRz4zg50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYUNQm1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYUNQm1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C882C4CEF8;
	Sun,  7 Sep 2025 20:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277687;
	bh=SA+cSo8Ivf/Ah5zroxICVqCDZtasi48g0SgCzjEYoCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYUNQm1XLIk/AmCVqYYanVMDQl7mIFNpGvZghxCuQCMPw95DMR6DqBwLKMXnKVdr3
	 /hv0yGLJLpyIeOpzADQkwBRjKYBneXZFev37UUmPcKeqKH24S0prQoSfZj407MQp9z
	 eKF5gE5zNifbI/U9GJZiG9ZsGxL4FqPG8YfOP758=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abin Joseph <abin.joseph@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 092/183] net: xilinx: axienet: Add error handling for RX metadata pointer retrieval
Date: Sun,  7 Sep 2025 21:58:39 +0200
Message-ID: <20250907195617.976148556@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abin Joseph <abin.joseph@amd.com>

[ Upstream commit 8bbceba7dc5090c00105e006ce28d1292cfda8dd ]

Add proper error checking for dmaengine_desc_get_metadata_ptr() which
can return an error pointer and lead to potential crashes or undefined
behaviour if the pointer retrieval fails.

Properly handle the error by unmapping DMA buffer, freeing the skb and
returning early to prevent further processing with invalid data.

Fixes: 6a91b846af85 ("net: axienet: Introduce dmaengine support")
Signed-off-by: Abin Joseph <abin.joseph@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20250903025213.3120181-1-abin.joseph@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 0d8a05fe541af..ec6d47dc984aa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1168,6 +1168,15 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 						       &meta_max_len);
 	dma_unmap_single(lp->dev, skbuf_dma->dma_address, lp->max_frm_size,
 			 DMA_FROM_DEVICE);
+
+	if (IS_ERR(app_metadata)) {
+		if (net_ratelimit())
+			netdev_err(lp->ndev, "Failed to get RX metadata pointer\n");
+		dev_kfree_skb_any(skb);
+		lp->ndev->stats.rx_dropped++;
+		goto rx_submit;
+	}
+
 	/* TODO: Derive app word index programmatically */
 	rx_len = (app_metadata[LEN_APP] & 0xFFFF);
 	skb_put(skb, rx_len);
@@ -1180,6 +1189,7 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 	u64_stats_add(&lp->rx_bytes, rx_len);
 	u64_stats_update_end(&lp->rx_stat_sync);
 
+rx_submit:
 	for (i = 0; i < CIRC_SPACE(lp->rx_ring_head, lp->rx_ring_tail,
 				   RX_BUF_NUM_DEFAULT); i++)
 		axienet_rx_submit_desc(lp->ndev);
-- 
2.50.1



