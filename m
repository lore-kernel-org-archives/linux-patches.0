Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4805515C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDDAC433C1;
	Mon,  5 Dec 2022 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267897;
	bh=viE4P24RDIv2rTdc3YeZXChecX0oKJEApwFtsA6SAS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7IqnN4dRU5ecyV0JnOsKsrf9NAvZFRy5nRQSD0gkJgyuXGX5wH94lxBTvKjDY59c
	 5piIGXVJ6+pCbHUf1APK+LtoTBCFf1LJE+6imV98p/aFij/WNKSa4HpLCZ4Y3QlYPA
	 HTVsy+ueMx7Z0tB0wP/7xO/gkZOzVyqsJzwHNeJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/105] net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()
Date: Mon,  5 Dec 2022 20:08:46 +0100
Message-Id: <20221205190803.612628295@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index 5a45648e3124..9cbed8fa505a 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1177,6 +1177,7 @@ static void pch_gbe_tx_queue(struct pch_gbe_adapter *adapter,
 		buffer_info->dma = 0;
 		buffer_info->time_stamp = 0;
 		tx_ring->next_to_use = ring_num;
+		dev_kfree_skb_any(skb);
 		return;
 	}
 	buffer_info->mapped = true;
-- 
2.35.1



