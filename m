Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468A36FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2938C433F1;
	Tue, 10 Jan 2023 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374647;
	bh=TbJShuApEJ00R3MELDpxXoGrBbRwqF37F6xGQfTNIxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVKhqbfG7xO+iMJvlaTYPVrvLZlLfDm2lNU53jnTT4ElEhTkoCG3zYPunch4ImdLH
	 ROpRQCaGDVIu1OKCFT6TWyiF1+Rg63wJttP5PFZLL21Fe05CnALf0C3OykJqp73k0D
	 JFRVeTZgUT9RMMqMNFwZWfArQTUZTe4/I85A8sx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/159] net: ena: Dont register memory info on XDP exchange
Date: Tue, 10 Jan 2023 19:03:36 +0100
Message-Id: <20230110180020.462563955@linuxfoundation.org>
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
index 5a454b58498f..e313bb45319c 100644
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



