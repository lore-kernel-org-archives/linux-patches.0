Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E58251C4F;
	Mon,  8 Jan 2024 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz2GtM75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6479C433CD;
	Mon,  8 Jan 2024 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728314;
	bh=PNGcQB34gjoJvUW8wVmE1JTetmxCAmjNhAe0eF8bmJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kz2GtM75nur/71+1eyF1eVyaixESoIM0h5nDu3nBsvl7/RrGQcALOeK7VPJiezw5h
	 +/Hu9w+VlLzqJ6tSZ+apQC23maB/OedwFuz4bTgCWHf1+MYbvy1irGs5AUjy+yFBN8
	 LNI1cbnN/hAGqFlvyes0oweM3VywtTklF0XEkDvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Cinal <adriancinal1@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/150] net: bcmgenet: Fix FCS generation for fragmented skbuffs
Date: Mon,  8 Jan 2024 16:34:49 +0100
Message-ID: <20240108153513.052408993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1ae082eb9e905..c2a9913082153 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2131,8 +2131,10 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
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



