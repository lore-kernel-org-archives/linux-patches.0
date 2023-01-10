Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC506FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8021BC433F0;
	Tue, 10 Jan 2023 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374695;
	bh=QwB7vcqDxVAFRoeNhJ8OxwSw05EhsyliCxsO0gyRdfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePEYoPz/nA2+ATG0J9TQ3eFr/w72FBfzFptQK7Pt2CAX54MSvaNNoQc97qk+vFU0W
	 PMcWsaq6ibqYb6GFwOcnMbOXs5n7FForndWCmQYIeuP0WZQuf7bXqt9Ek7BWzmulct
	 7djbYWIuRMwCeu+BwEaikmJJ+f7M/I5kX1QW3g00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arinzon <darinzon@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/159] net: ena: Set default value for RX interrupt moderation
Date: Tue, 10 Jan 2023 19:03:40 +0100
Message-Id: <20230110180020.604621387@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit e712f3e4920b3a1a5e6b536827d118e14862896c ]

RX ring can be NULL in XDP use cases where only TX queues
are configured. In this scenario, the RX interrupt moderation
value sent to the device remains in its default value of 0.

In this change, setting the default value of the RX interrupt
moderation to be the same as of the TX.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 663f9cd3babf..c4aff712b5d8 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1823,8 +1823,9 @@ static void ena_adjust_adaptive_rx_intr_moderation(struct ena_napi *ena_napi)
 static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
+	u32 rx_interval = tx_ring->smoothed_interval;
 	struct ena_eth_io_intr_reg intr_reg;
-	u32 rx_interval = 0;
+
 	/* Rx ring can be NULL when for XDP tx queues which don't have an
 	 * accompanying rx_ring pair.
 	 */
-- 
2.35.1



