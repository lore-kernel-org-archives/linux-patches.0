Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6B1A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B447FC433D2;
	Tue, 10 Jan 2023 18:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374157;
	bh=XbV1oDtA0vrdU/whX4B7HGCpgg9fskSZH60Sj/vJ8YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0RkPJlfdPweGPdCQvRNTW50elF6lODH315QXlChaSbpSazRWhFw2XI86tu+ykwwN
	 wZhCosnMj3Q1H4OaYZY9YMy61NTspbcOjdYNrAqAz+RYj0MQF6qeU6EWz7L2Tdt1W6
	 5qQDZGGN3nb80uIRsSjqVnyDrDFRR6Rn0KQRchOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 065/148] net: ena: Dont register memory info on XDP exchange
Date: Tue, 10 Jan 2023 19:02:49 +0100
Message-Id: <20230110180019.290104517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

[ Upstream commit 9c9e539956fa67efb8a65e32b72a853740b33445 ]

Since the queues aren't destroyed when we only exchange XDP programs,
there's no need to re-register them again.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 41c821348476..f4ee8671b738 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -512,16 +512,18 @@ static void ena_xdp_exchange_program_rx_in_range(struct ena_adapter *adapter,
 						 struct bpf_prog *prog,
 						 int first, int count)
 {
+	struct bpf_prog *old_bpf_prog;
 	struct ena_ring *rx_ring;
 	int i = 0;
 
 	for (i = first; i < count; i++) {
 		rx_ring = &adapter->rx_ring[i];
-		xchg(&rx_ring->xdp_bpf_prog, prog);
-		if (prog) {
+		old_bpf_prog = xchg(&rx_ring->xdp_bpf_prog, prog);
+
+		if (!old_bpf_prog && prog) {
 			ena_xdp_register_rxq_info(rx_ring);
 			rx_ring->rx_headroom = XDP_PACKET_HEADROOM;
-		} else {
+		} else if (old_bpf_prog && !prog) {
 			ena_xdp_unregister_rxq_info(rx_ring);
 			rx_ring->rx_headroom = NET_SKB_PAD;
 		}
-- 
2.35.1



