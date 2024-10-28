Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972882AF07;
	Mon, 28 Oct 2024 06:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098081; cv=none; b=DD8qSsN18KYHSlXB1rpF5xvVj/Lw29Eq+a+osXZryusd8QTlFEmgwETAQI719yguneD7YtJCF8oKZpXD4Yb6Iz3XA92KGe0bpgW0+kQ0TC1f8u73x0FqphaFkqfoLES6TXk6n2ndzLnu+1IB0Cu/WxuFXk9XrINi9zHrTqsrvuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098081; c=relaxed/simple;
	bh=1ukqfDLxFlBk8XCzt+5JNNspQdEAzhPDW/bsc4UqPww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFdjXvFnJD/YheD1xbFfBGSmH1rqMAq58pafFirYm9DzGip1X9xH1CbRGu9lnY/2a5BTXNqR2AY7NXyJkmmL08mxxRrpbJwQ1HlNaweyA4WCoGnSVa9lAV25FMfLw/p89fNm+H/ZyOkE9gm/4aHjPpYEP/RIJ+Bf97s3GJcjd68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRRBbqu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRRBbqu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38228C4CEC3;
	Mon, 28 Oct 2024 06:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098081;
	bh=1ukqfDLxFlBk8XCzt+5JNNspQdEAzhPDW/bsc4UqPww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRRBbqu4tebgf5mcGZ3z6v1WoRClD5XpWrN34NnWz8EkaapUnR6iWGwlot3VDEhz2
	 MgBF7XA/b23HhlvcAtSGWXkI4hZeMSDy2MAwcne0FN784+Au27DBIxD0FCQnfsZdj6
	 caKYSDkBpLGkmZvZuh3FEqObUxNf1jjb6gHN6fNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 069/261] net: xilinx: axienet: fix potential memory leak in axienet_start_xmit()
Date: Mon, 28 Oct 2024 07:23:31 +0100
Message-ID: <20241028062313.761041218@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5dbfee4aee43c..0c4c57e7fddc2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -989,6 +989,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		if (net_ratelimit())
 			netdev_err(ndev, "TX DMA mapping error\n");
 		ndev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 	desc_set_phys_addr(lp, phys, cur_p);
@@ -1009,6 +1010,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(lp, orig_tail_ptr, ii + 1,
 					      true, NULL, 0);
+			dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
-- 
2.43.0



