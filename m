Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9A4190063;
	Mon, 28 Oct 2024 06:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097215; cv=none; b=YiQhvcg1ZLjbfYK/1LJJxGHseA6cKVEqkygXGfpH5Tn6c+2ZNP6aJfb6FbL8uIzsMy+eV/gy2WKy+Kj5QOGOCrQtVj+R5k+ccZfkxxmJkrOy8s9pPMthoEx7Ses/OJwyaN+z7u9sPMrfCLY0lZl1cu0fU5DUB+VP/IfVfLDUa6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097215; c=relaxed/simple;
	bh=4D+oZXQBQPqpTMbwIifq7WhMs3bXpkFFzfosPBgq3tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMDRAQV9kqEdveM85RSA3v4Q8gpl8af7MnqmQDeAn+k7a9cjXRwfRnxd+ejmniLWdNpT8+yPcV3B9Kk0exuWTS3JrgGDt6pj6xZyacMNwhwln10v4H6XvG0eZcOolnk2WVMQ3mhdt3ZNxeecWqewA6Ghemmih8uwVacNAmkFec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVGt0pAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVGt0pAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDF8C4CECD;
	Mon, 28 Oct 2024 06:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097215;
	bh=4D+oZXQBQPqpTMbwIifq7WhMs3bXpkFFzfosPBgq3tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVGt0pAqxVSecB9aCGctD5GlpSvjlOHQaxHIhSLMYe9QBDJ/hZienv913uDaJOnG4
	 GnQHBoU9xY/x4JLGcHtGEuzx6ufRPzBMHecJcsdHl4rG9vP9ZZsAytcMIe0ST5XDdJ
	 AA0qEzsWsuniSIBhfCr488OIzn0LdF4ikHa6yqM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/137] net: xilinx: axienet: fix potential memory leak in axienet_start_xmit()
Date: Mon, 28 Oct 2024 07:24:31 +0100
Message-ID: <20241028062259.677416194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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
index 0b6f0908f3e1c..ce0dd78826af0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -844,6 +844,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 	desc_set_phys_addr(lp, phys, cur_p);
@@ -864,6 +865,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
 					      true, NULL, 0);
+			dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
-- 
2.43.0



