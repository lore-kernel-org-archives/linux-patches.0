Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815B42C697;
	Mon, 28 Oct 2024 06:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097586; cv=none; b=Qyqj3okLRGdGh7UdJG3/I/rgC3ylsNqeaY0dxiZFCAjsXXNfUD8xMwSEj+w5VpC2iqjc64bC57rIktktcmW1/HRLj6uliUjxfqPNcIPsu25Pkvehy/3k/D5cPz8mQEgklHTX/yq4Fdp2AJlQsQZVpR+tDhQ/JAb2uGIo5osWY0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097586; c=relaxed/simple;
	bh=p4wJmBduhxpAmjKUktIHObOC9opLKy0sd8Ww3zD3law=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4iw2CI1D7CAbpe+LJa4EFzqVEgtgEW4JJX4K/K1Nh56yGTvZ17/XcWls4FI0FM169xaA4q+r92EypmAdun3rCqGrYKBqKeh5bVfnjQUOATTY4XqN0PXiCjvizXTzvVrbEwUjbei7DRtxaVAClFe1hRvp73Idh6JAcPROJyMsT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDx53L4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDx53L4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204CAC4CEC3;
	Mon, 28 Oct 2024 06:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097586;
	bh=p4wJmBduhxpAmjKUktIHObOC9opLKy0sd8Ww3zD3law=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDx53L4qJpCkx9evb9QRAtbDNW60grw7jTOAaWu4Q/nOQskGSAV+OEObhNi9oJYAf
	 BtQzbgEUP65/RerZils4p448KcnJoyHtWwgZa4W3ov8ybKK0FDqWQ7JPCj4t2Mtsem
	 IAtS+GAMgBqinoRnF0AtIGi6VovQgd2FiPiAbDfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/208] net: xilinx: axienet: fix potential memory leak in axienet_start_xmit()
Date: Mon, 28 Oct 2024 07:23:57 +0100
Message-ID: <20241028062308.060132991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 99714e37e8333bbc22496fe80f241d5b35380e83 ]

The axienet_start_xmit() returns NETDEV_TX_OK without freeing skb
in case of dma_map_single() fails, add dev_kfree_skb_any() to fix it.

Fixes: 71791dc8bdea ("net: axienet: Check for DMA mapping errors")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20241014143704.31938-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 62c10eb4f0adf..9f779653ed622 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -845,6 +845,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 	desc_set_phys_addr(lp, phys, cur_p);
@@ -865,6 +866,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
 					      true, NULL, 0);
+			dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
-- 
2.43.0



