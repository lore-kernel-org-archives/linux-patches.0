Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA1285043;
	Tue, 17 Jun 2025 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178998; cv=none; b=KsapPct2Y18PIKQXJ9Enn396auOL4OzyGCg0kbHA8gSl6qDzlYF+Uv3BWbcXaMR5imuu3FRwk2/d4KGWO5kJT8SNiyc3Y3+ZSZVk5ZCJno7Ub6VZyaMSvrpJg44Z+d7w/ChNQH2tCjOKgj5HcbFXREWgxE3e/QNnzp0CytzgFMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178998; c=relaxed/simple;
	bh=5Y8eoszF+tdeVA2Rg43N5vfMgA4C4nUY3aEKNTIHlMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSpozYJtBZQV2eNf+2V0/YSWuGCnmItaCwqMxxCGa3+TBeCmEGsRrkllGMbD8MbgbhdZrAeLQIg853IFyU6B/QlXpEPtEo7eExJgKwTZfvDLXEeQumdAsXOjlUx6MAAqmLnAadDADMmsgY6raZzlge6+AEeShF84ssMPPzPzYqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziKPYaj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziKPYaj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C9DC4CEE3;
	Tue, 17 Jun 2025 16:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178997;
	bh=5Y8eoszF+tdeVA2Rg43N5vfMgA4C4nUY3aEKNTIHlMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziKPYaj6JWOY5HcpRDU/uB2VZd+kCD5r3mBYT4SAw9t2nBlBuf6/skWpsYyuA0kU0
	 CdZWJ59JCiIEtjRRr399GD1n0TMPrOUC75acC+lzxTzXswS/6LA1K1G/Aq8DhEIN7I
	 mHCKMgSXtplf2/ZfEb3Hf4519w5z6g/HlfbZNh+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 617/780] net: wwan: mhi_wwan_mbim: use correct mux_id for multiplexing
Date: Tue, 17 Jun 2025 17:25:25 +0200
Message-ID: <20250617152516.608644854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 501fe52aa908c96f2c9b8d54767938a1a5960354 ]

Recent Qualcomm chipsets like SDX72/75 require MBIM sessionId mapping
to muxId in the range (0x70-0x8F) for the PCIe tethered use.

This has been partially addressed by the referenced commit, mapping
the default data call to muxId = 112, but the multiplexed data calls
scenario was not properly considered, mapping sessionId = 1 to muxId
1, while it should have been 113.

Fix this by moving the session_id assignment logic to mhi_mbim_newlink,
in order to map sessionId = n to muxId = n + WDS_BIND_MUX_DATA_PORT_MUX_ID.

Fixes: 65bc58c3dcad ("net: wwan: mhi: make default data link id configurable")
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20250603091204.2802840-1-dnlplm@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index 8755c5e6a65b3..c814fbd756a1e 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -550,8 +550,8 @@ static int mhi_mbim_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	struct mhi_mbim_link *link = wwan_netdev_drvpriv(ndev);
 	struct mhi_mbim_context *mbim = ctxt;
 
-	link->session = if_id;
 	link->mbim = mbim;
+	link->session = mhi_mbim_get_link_mux_id(link->mbim->mdev->mhi_cntrl) + if_id;
 	link->ndev = ndev;
 	u64_stats_init(&link->rx_syncp);
 	u64_stats_init(&link->tx_syncp);
@@ -607,7 +607,7 @@ static int mhi_mbim_probe(struct mhi_device *mhi_dev, const struct mhi_device_id
 {
 	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
 	struct mhi_mbim_context *mbim;
-	int err, link_id;
+	int err;
 
 	mbim = devm_kzalloc(&mhi_dev->dev, sizeof(*mbim), GFP_KERNEL);
 	if (!mbim)
@@ -628,11 +628,8 @@ static int mhi_mbim_probe(struct mhi_device *mhi_dev, const struct mhi_device_id
 	/* Number of transfer descriptors determines size of the queue */
 	mbim->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
 
-	/* Get the corresponding mux_id from mhi */
-	link_id = mhi_mbim_get_link_mux_id(cntrl);
-
 	/* Register wwan link ops with MHI controller representing WWAN instance */
-	return wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_mbim_wwan_ops, mbim, link_id);
+	return wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_mbim_wwan_ops, mbim, 0);
 }
 
 static void mhi_mbim_remove(struct mhi_device *mhi_dev)
-- 
2.39.5



