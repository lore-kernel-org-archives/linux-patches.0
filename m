Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E231168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ED7C433EF;
	Mon,  8 May 2023 10:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540229;
	bh=AlFRwerBujaAN6XJ8MPrTEWH5vhx7qYEuUhT9Ho2d0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLKohJRrCmZUQHxD3llxhME/LG3ckbz9EVmWlOeZ02QGx1lt+8Ix0CDk+VmFAbTOU
	 Xfs7ZWoslTjBqE4AQcNpGvckQHafcXkobzI6uRFXbQWHJi7p/X9JlYxh/WbmxhAFZd
	 De2I3B0jIT5KUeSVwYNed6YvvQ03ncE6iDFzMeqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/611] net/packet: annotate accesses to po->xmit
Date: Mon,  8 May 2023 11:42:08 +0200
Message-Id: <20230508094431.677966863@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b9d83ab8a708f23a4001d60e9d8d0b3be3d9f607 ]

po->xmit can be set from setsockopt(PACKET_QDISC_BYPASS),
while read locklessly.

Use READ_ONCE()/WRITE_ONCE() to avoid potential load/store
tearing issues.

Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1ab65f7f2a0ae..b5487bd8ffc9d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -307,7 +307,8 @@ static void packet_cached_dev_reset(struct packet_sock *po)
 
 static bool packet_use_direct_xmit(const struct packet_sock *po)
 {
-	return po->xmit == packet_direct_xmit;
+	/* Paired with WRITE_ONCE() in packet_setsockopt() */
+	return READ_ONCE(po->xmit) == packet_direct_xmit;
 }
 
 static u16 packet_pick_tx_queue(struct sk_buff *skb)
@@ -2866,7 +2867,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		packet_inc_pending(&po->tx_ring);
 
 		status = TP_STATUS_SEND_REQUEST;
-		err = po->xmit(skb);
+		/* Paired with WRITE_ONCE() in packet_setsockopt() */
+		err = READ_ONCE(po->xmit)(skb);
 		if (unlikely(err != 0)) {
 			if (err > 0)
 				err = net_xmit_errno(err);
@@ -3069,7 +3071,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
-	err = po->xmit(skb);
+	/* Paired with WRITE_ONCE() in packet_setsockopt() */
+	err = READ_ONCE(po->xmit)(skb);
 	if (unlikely(err != 0)) {
 		if (err > 0)
 			err = net_xmit_errno(err);
@@ -4006,7 +4009,8 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		po->xmit = val ? packet_direct_xmit : dev_queue_xmit;
+		/* Paired with all lockless reads of po->xmit */
+		WRITE_ONCE(po->xmit, val ? packet_direct_xmit : dev_queue_xmit);
 		return 0;
 	}
 	default:
-- 
2.39.2



