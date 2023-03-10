Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1ED848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89694C433D2;
	Fri, 10 Mar 2023 14:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458078;
	bh=cZxhBg16qGzB+FIpxHKUC6XRrEFLSBYyZioOKDIxHz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9gHHiOFcj4LAUHPoTTaOiHJ7vSVLcxNsxFPin+XEgEm8g794V+4nsn3V/eD4S0p3
	 IZqzkJJBHH9lPGdqNIvgM8HnP8dUDIa7YROvpdsAGEWWpVDooOBzNOYmFuQhBQxHKm
	 Neov/ov9posbqTk6gqYZnyRxlUg0tXirkTEWrx38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/252] net: bcmgenet: Add a check for oversized packets
Date: Fri, 10 Mar 2023 14:38:15 +0100
Message-Id: <20230310133722.596925462@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5c0862c2c962052ed5055220a00ac1cefb92fbcd ]

Occasionnaly we may get oversized packets from the hardware which
exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
check which drops the packet to avoid invoking skb_over_panic() and move
on to processing the next packet.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 96ef2dd46c78c..84bcb3ce00f73 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1825,6 +1825,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			  __func__, p_index, ring->c_index,
 			  ring->read_ptr, dma_length_status);
 
+		if (unlikely(len > RX_BUF_LENGTH)) {
+			netif_err(priv, rx_status, dev, "oversized packet\n");
+			dev->stats.rx_length_errors++;
+			dev->stats.rx_errors++;
+			dev_kfree_skb_any(skb);
+			goto next;
+		}
+
 		if (unlikely(!(dma_flag & DMA_EOP) || !(dma_flag & DMA_SOP))) {
 			netif_err(priv, rx_status, dev,
 				  "dropping fragmented packet!\n");
-- 
2.39.2



