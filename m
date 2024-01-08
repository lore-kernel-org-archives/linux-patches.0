Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7BC4C3AD;
	Mon,  8 Jan 2024 15:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h06jtnWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B359C433C7;
	Mon,  8 Jan 2024 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726672;
	bh=TrCZydRD0dB8M8Q1iRgXeg+/Ty+8IL1/1cMGun0bXRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h06jtnWIgvz8/sqZ4EX4weHdhnQpQaoDqrOS1GloITn6LwJT+hyAS/Q3SVNnbQjWo
	 nfqusFduPWbaU1b5VHp6dlC1ByikUmJ0+CzpP8Lat/a1HkWsKyU0ATibL8aWA3hvrN
	 T8M1nND7O3C/MH2CBJ9jNYJKO0FD6/fs1WU+3bYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Cinal <adriancinal1@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/124] net: bcmgenet: Fix FCS generation for fragmented skbuffs
Date: Mon,  8 Jan 2024 16:07:47 +0100
Message-ID: <20240108150604.872100026@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Cinal <adriancinal@gmail.com>

[ Upstream commit e584f2ff1e6cc9b1d99e8a6b0f3415940d1b3eb3 ]

The flag DMA_TX_APPEND_CRC was only written to the first DMA descriptor
in the TX path, where each descriptor corresponds to a single skbuff
fragment (or the skbuff head). This led to packets with no FCS appearing
on the wire if the kernel allocated the packet in fragments, which would
always happen when using PACKET_MMAP/TPACKET (cf. tpacket_fill_skb() in
net/af_packet.c).

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Adrian Cinal <adriancinal1@gmail.com>
Acked-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20231228135638.1339245-1-adriancinal1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 24bade875ca6a..89c8ddc6565ae 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2132,8 +2132,10 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		/* Note: if we ever change from DMA_TX_APPEND_CRC below we
 		 * will need to restore software padding of "runt" packets
 		 */
+		len_stat |= DMA_TX_APPEND_CRC;
+
 		if (!i) {
-			len_stat |= DMA_TX_APPEND_CRC | DMA_SOP;
+			len_stat |= DMA_SOP;
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				len_stat |= DMA_TX_DO_CSUM;
 		}
-- 
2.43.0



