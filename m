Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633AE15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BC6C433D6;
	Mon,  5 Dec 2022 19:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268421;
	bh=JzYl8GodlosD1I2iFYSQVAbUoHFwqzI0qVhxLFGYjmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FUV/M/36UBDPD7uDo8cWZOuOcppniXehNlBTvKPdk0QNqrnCh7vmhFisotwd11gL
	 xCTez/KdX/SzHhkm13Mwi7xnEkzpaO2kvc//R1i6+Ltd3UIdCY/HtiAbH8DZYC0wRd
	 1ggVzI2RoIXJXgVEUNggrLR3zOQMlr/X0eHjqkho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 068/124] packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE
Date: Mon,  5 Dec 2022 20:09:34 +0100
Message-Id: <20221205190810.352579359@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b85f628aa158a653c006e9c1405a117baef8c868 ]

CHECKSUM_COMPLETE signals that skb->csum stores the sum over the
entire packet. It does not imply that an embedded l4 checksum
field has been validated.

Fixes: 682f048bd494 ("af_packet: pass checksum validation status to the user")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20221128161812.640098-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5cbe07116e04..5727cb7ec174 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2293,8 +2293,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
 	else if (skb->pkt_type != PACKET_OUTGOING &&
-		 (skb->ip_summed == CHECKSUM_COMPLETE ||
-		  skb_csum_unnecessary(skb)))
+		 skb_csum_unnecessary(skb))
 		status |= TP_STATUS_CSUM_VALID;
 
 	if (snaplen > res)
@@ -3520,8 +3519,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			aux.tp_status |= TP_STATUS_CSUMNOTREADY;
 		else if (skb->pkt_type != PACKET_OUTGOING &&
-			 (skb->ip_summed == CHECKSUM_COMPLETE ||
-			  skb_csum_unnecessary(skb)))
+			 skb_csum_unnecessary(skb))
 			aux.tp_status |= TP_STATUS_CSUM_VALID;
 
 		aux.tp_len = origlen;
-- 
2.35.1



