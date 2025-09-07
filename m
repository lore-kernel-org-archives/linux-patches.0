Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B3E1A0BFD;
	Sun,  7 Sep 2025 20:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277255; cv=none; b=AfITr7LI4kNGQK1bokYn6C6f84e4OyrWmpL4/nLySW40EUaY6nWV794nGgs29sMmhy7a6LE4lcO0a+ZvAR44TUIIDqgi9lf9hCPvVQWcyHERDFkmdt85bmHq1EK4nAcp+cQlgFE88SP2tu+xIJxU72NjIskW7HjgdhW55PaHs3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277255; c=relaxed/simple;
	bh=XLpqoV3p7ineqnA0xhVJAl/Nwsc4wjfnZpy8dlajidM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISWVH/LcuIhEvq0TjGyiL6EzDMWau4hXpd/gN/eZYZaUNFqmGbuv9840FRWWIWiuII4yWnqszZSCcMrk2eY8bO3F4lVWVldSar/yzAo39gPiGohIxWzCHAjvYNStJHchOZkuMqqazWLEyVjKDbVxdKQFcDFVw+arV7p4JRlaBvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGVvuSSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGVvuSSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC02C4CEF0;
	Sun,  7 Sep 2025 20:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277255;
	bh=XLpqoV3p7ineqnA0xhVJAl/Nwsc4wjfnZpy8dlajidM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGVvuSSgEhJzqVTiZkgGEZPrAU5y9ODeNID0HGD4NHFP9/qubjuhx/Ror7Q89V1pw
	 B1xQwvUeEosu5oo75ZZrOgUm+gtLWcy5GaPHXVZbdDqKBOxlnp30ZBfURUSnEpwF3B
	 ozM+AxB/4KYiA0qZ7h7pqt6z4WIQPJ8NFC1Dud5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abin Joseph <abin.joseph@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/175] net: xilinx: axienet: Add error handling for RX metadata pointer retrieval
Date: Sun,  7 Sep 2025 21:58:02 +0200
Message-ID: <20250907195616.894246168@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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
index 1775e060d39d3..3339c5e1a57a9 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1127,6 +1127,15 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
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
@@ -1139,6 +1148,7 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 	u64_stats_add(&lp->rx_bytes, rx_len);
 	u64_stats_update_end(&lp->rx_stat_sync);
 
+rx_submit:
 	for (i = 0; i < CIRC_SPACE(lp->rx_ring_head, lp->rx_ring_tail,
 				   RX_BUF_NUM_DEFAULT); i++)
 		axienet_rx_submit_desc(lp->ndev);
-- 
2.50.1



