Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F98618CC1F;
	Mon, 28 Oct 2024 06:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096868; cv=none; b=lIaFuYKwjBWetVKigq4yTJtby1sBOvZI59//rf4Rl+D7Wau7BkcCAa2kJ0WU3ks4N9mQuu4GeoXQ6y0vBbc/d3iUN83igziNmndpVkM1NUKj8fg41KmK6lG9mVF+9GL+VIxMGBlXVVHlZgvGYl1Qo0rDTWWpuwL7aSo7XHy4RWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096868; c=relaxed/simple;
	bh=D45FU/gn8XofmQPxnVp8MCPMmBBxBUxMKrFA3uZDOb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sez24uj+qKR7rnRLzaNXE/gkjwC+MGSggwYEzQqL2shDMdiwJx7pnrPWeoqTCthRMsP6oKJ6OelWu7QNV5C3Y/DjFwatojSZBDZRyKcrGOEBNVjXIvewXwepBIuIiTGsfJfve0Kfk347r8SKDDDJQc+TMzJwvNHqTHjE86feLVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K72V7OXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K72V7OXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BCAC4CEC3;
	Mon, 28 Oct 2024 06:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096868;
	bh=D45FU/gn8XofmQPxnVp8MCPMmBBxBUxMKrFA3uZDOb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K72V7OXa5c/PGhX1brbOBftedC8vPRbaEIOSjyeRWdXKt7tnjhaSJEDE4dQOi/Fre
	 f23hPrLgTdgLZqELjNbEMb4A32b8Ex8qLwPs7jIyJp6kKltVQlJLfuwEWiL8hhIpY0
	 NMmgRQ183ibd8H9IqPBWFjps1wIHwRKNZxIYfWxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/80] net: xilinx: axienet: fix potential memory leak in axienet_start_xmit()
Date: Mon, 28 Oct 2024 07:25:01 +0100
Message-ID: <20241028062253.214769528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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
index f9921e372a2f4..56a970357f450 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -868,6 +868,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 	desc_set_phys_addr(lp, phys, cur_p);
@@ -888,6 +889,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
 					      true, NULL, 0);
+			dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
-- 
2.43.0



