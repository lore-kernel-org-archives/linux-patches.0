Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2330079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C52FC433D6;
	Wed, 30 Nov 2022 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833444;
	bh=8FYuWY4IAK1BNa2B+OdHqpZNlGvefKaUWtkv3wFmVT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIQnBPi0ozbl3qtBbtllljbPGVCvsanBkcs4WeLPvAhJbdmHOQ/cyWGRCAvb1w4mn
	 6EQcm1flOJXMY2ONJztQm9ZzutZUES9nAzAaq/WGvzkhnevfsN8ypvBfeKO3bYU0//
	 wJ6sR9pHkRT5r5D3SUbDkV+UwbZzvNJRG4W1og8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/206] net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
Date: Wed, 30 Nov 2022 19:22:12 +0100
Message-Id: <20221130180535.034943346@linuxfoundation.org>
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 2360f9b8c4e81d242d4cbf99d630a2fffa681fab ]

In pch_gbe_xmit_frame(), NETDEV_TX_OK will be returned whether
pch_gbe_tx_queue() sends data successfully or not, so pch_gbe_tx_queue()
needs to free skb before returning. But pch_gbe_tx_queue() returns without
freeing skb in case of dma_map_single() fails. Add dev_kfree_skb_any()
to fix it.

Fixes: 77555ee72282 ("net: Add Gigabit Ethernet driver of Topcliff PCH")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ec3e558f890e..5a42ef6ca762 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1148,6 +1148,7 @@ static void pch_gbe_tx_queue(struct pch_gbe_adapter *adapter,
 		buffer_info->dma = 0;
 		buffer_info->time_stamp = 0;
 		tx_ring->next_to_use = ring_num;
+		dev_kfree_skb_any(skb);
 		return;
 	}
 	buffer_info->mapped = true;
-- 
2.35.1



