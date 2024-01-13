Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007C21846;
	Sat, 13 Jan 2024 09:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/dPi+Av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E84C43394;
	Sat, 13 Jan 2024 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139797;
	bh=tzj56keJp0lkxeoK2IlXn0jbI8kLo1tE/ONyG9DE0jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/dPi+AvaevjN9jZeCWsL+676b4D5JAT9veUenOC8JOCrfaoENs32T+vTP8juFHUI
	 NhctL8be8/Wu5vfwACbFFrEKAXr4hmEWgbep5V11SVH0VV2CFFUtcXdrJjS8Kt+65V
	 f6zQdM5ENJuyWmzM6wB4Ym2j9PqjacMchZJrE4a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Cinal <adriancinal1@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/38] net: bcmgenet: Fix FCS generation for fragmented skbuffs
Date: Sat, 13 Jan 2024 10:49:45 +0100
Message-ID: <20240113094206.739447640@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 750acbf294640..eeadeeec17bab 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1648,8 +1648,10 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
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



