Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B334379C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36852C433C1;
	Wed, 30 Nov 2022 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833551;
	bh=/0psIQho1RFC+D5g8y9yrHyJwjM0n9XsrIY1ssCZiKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aO/jS1hlZYhZx+Yc4ahs7iEGqX0AY/W2Aq9P8gUs/NcMfgQMq+ubTnWG7CX0z5WD+
	 Bs3YbFVVZ3njMA4o/vhJsaKt4dzMIbs7LWasdShyQbcMb5geB3NWeX2wkoKX/PlQEH
	 a5erohqGkoRQxNwOjZOGMwg5WvP7cl6vvXwdu+UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/206] sfc: fix potential memleak in __ef100_hard_start_xmit()
Date: Wed, 30 Nov 2022 19:22:42 +0100
Message-Id: <20221130180535.843417567@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit aad98abd5cb8133507f22654f56bcb443aaa2d89 ]

The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
in error handling case, add dev_kfree_skb_any() to fix it.

Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 67fe44db6b61..63a44ee763be 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -200,6 +200,7 @@ static netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
 		   skb->len, skb->data_len, channel->channel);
 	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
 		netif_stop_queue(net_dev);
+		dev_kfree_skb_any(skb);
 		goto err;
 	}
 
-- 
2.35.1



