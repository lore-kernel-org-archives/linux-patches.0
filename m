Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC28D29BDAC;
	Tue, 26 Aug 2025 11:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208966; cv=none; b=fnrYSA5L9ZC3Z6OmgtLVmkr15vK7Rrr3LjTm8d4oa4zA3hg5zSiTqO1jw1ZuvjqG5+Ptxazu1byZG6j3mEhLvOGnIB+QUQ7PhTVC3CSJVIVDArrq+HY1DesB6H3miiY5NywuURQYePm8W3WeB7IwaQaQf8u+YFxbcn1lOmU0i6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208966; c=relaxed/simple;
	bh=/UcG3K5rMWGBMgZ724C2q1sVf4UEYIDG8XhN69UNP8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnxycNjEIanxkrGm2GAiFWewpKQaLXtZQ9Bb7pneHqUEDbP/wOfWO7q5KYDbgfNJmV6YmgEWJBsS2A3Cw4Rgt6EpxvSZax7xdx+SjUkSSz6jRFjzGLCaaaYO8P6Y9zx6KtRTNkB7gj9JNIdixTqiEG8ZYotSB155mVO8h75O8vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzoMU3c5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzoMU3c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224EEC4CEF1;
	Tue, 26 Aug 2025 11:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208966;
	bh=/UcG3K5rMWGBMgZ724C2q1sVf4UEYIDG8XhN69UNP8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzoMU3c5ufC7XDnlSiSkQ+CsDkHGwZtS1XlAUWBQY9vPzq76+KPxjCIBliWcJzDkS
	 0w08NVLdxKcSorvkSuIMpJx39odkEiXx8qrXldfXSISroyMLImqo7dqEupxXT9QDDf
	 XhxSREjpXNrxlpGtEmxcScP2blPuaK+5LhSzmu4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/322] net: xilinx: axienet: Fix RX skb ring management in DMAengine mode
Date: Tue, 26 Aug 2025 13:11:27 +0200
Message-ID: <20250826110922.643603163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit fd980bf6e9cdae885105685259421164f843ca55 ]

Submit multiple descriptors in axienet_rx_cb() to fill Rx skb ring. This
ensures the ring "catches up" on previously missed allocations.

Increment Rx skb ring head pointer after BD is successfully allocated.
Previously, head pointer was incremented before verifying if descriptor is
successfully allocated and has valid entries, which could lead to ring
state inconsistency if descriptor setup failed.

These changes improve reliability by maintaining adequate descriptor
availability and ensuring proper ring buffer state management.

Fixes: 6a91b846af85 ("net: axienet: Introduce dmaengine support")
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Link: https://patch.msgid.link/20250813135559.1555652-1-suraj.gupta2@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 2d47b35443af..1775e060d39d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1119,6 +1119,7 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 	struct axienet_local *lp = data;
 	struct sk_buff *skb;
 	u32 *app_metadata;
+	int i;
 
 	skbuf_dma = axienet_get_rx_desc(lp, lp->rx_ring_tail++);
 	skb = skbuf_dma->skb;
@@ -1137,7 +1138,10 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 	u64_stats_add(&lp->rx_packets, 1);
 	u64_stats_add(&lp->rx_bytes, rx_len);
 	u64_stats_update_end(&lp->rx_stat_sync);
-	axienet_rx_submit_desc(lp->ndev);
+
+	for (i = 0; i < CIRC_SPACE(lp->rx_ring_head, lp->rx_ring_tail,
+				   RX_BUF_NUM_DEFAULT); i++)
+		axienet_rx_submit_desc(lp->ndev);
 	dma_async_issue_pending(lp->rx_chan);
 }
 
@@ -1394,7 +1398,6 @@ static void axienet_rx_submit_desc(struct net_device *ndev)
 	if (!skbuf_dma)
 		return;
 
-	lp->rx_ring_head++;
 	skb = netdev_alloc_skb(ndev, lp->max_frm_size);
 	if (!skb)
 		return;
@@ -1419,6 +1422,7 @@ static void axienet_rx_submit_desc(struct net_device *ndev)
 	skbuf_dma->desc = dma_rx_desc;
 	dma_rx_desc->callback_param = lp;
 	dma_rx_desc->callback_result = axienet_dma_rx_cb;
+	lp->rx_ring_head++;
 	dmaengine_submit(dma_rx_desc);
 
 	return;
-- 
2.50.1



