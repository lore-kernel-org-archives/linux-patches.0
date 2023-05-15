Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB8BE573
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3165C4339B;
	Mon, 15 May 2023 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168887;
	bh=hAABR0kpMdIctDfWtCBTGa0StvGurFhcmCnd/RuacnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfFof/ngL6nVc+QXz4ruULl/jXHWrlOh9XIVeyqXKY2y6FSBRw/Vb9E9+qjJwok89
	 73ftSgbYG1iYXjGanwOfCpvLhtREF1fM6tTMyH0r4lVHsBld8JutmnxZniLMXgancb
	 cLQRHfzjRUfjJzKR2gICnNz4fROFE/WY0VvV5M3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/191] net/packet: convert po->auxdata to an atomic flag
Date: Mon, 15 May 2023 18:24:53 +0200
Message-Id: <20230515161709.249420244@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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

[ Upstream commit fd53c297aa7b077ae98a3d3d2d3aa278a1686ba6 ]

po->auxdata can be read while another thread
is changing its value, potentially raising KCSAN splat.

Convert it to PACKET_SOCK_AUXDATA flag.

Fixes: 8dc419447415 ("[PACKET]: Add optional checksum computation for recvmsg")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 8 +++-----
 net/packet/diag.c      | 2 +-
 net/packet/internal.h  | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 91c35d45e43ca..60986c209311f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3444,7 +3444,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
-	if (pkt_sk(sk)->auxdata) {
+	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_AUXDATA)) {
 		struct tpacket_auxdata aux;
 
 		aux.tp_status = TP_STATUS_USER;
@@ -3827,9 +3827,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, char __user *optv
 		if (copy_from_user(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		lock_sock(sk);
-		po->auxdata = !!val;
-		release_sock(sk);
+		packet_sock_flag_set(po, PACKET_SOCK_AUXDATA, val);
 		return 0;
 	}
 	case PACKET_ORIGDEV:
@@ -3971,7 +3969,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 
 		break;
 	case PACKET_AUXDATA:
-		val = po->auxdata;
+		val = packet_sock_flag(po, PACKET_SOCK_AUXDATA);
 		break;
 	case PACKET_ORIGDEV:
 		val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
diff --git a/net/packet/diag.c b/net/packet/diag.c
index bf5928e5df035..d9f912ad23dfa 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -22,7 +22,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 	pinfo.pdi_flags = 0;
 	if (po->running)
 		pinfo.pdi_flags |= PDI_RUNNING;
-	if (po->auxdata)
+	if (packet_sock_flag(po, PACKET_SOCK_AUXDATA))
 		pinfo.pdi_flags |= PDI_AUXDATA;
 	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
 		pinfo.pdi_flags |= PDI_ORIGDEV;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index f39dcc7608bc6..3d871cae85b8c 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -117,8 +117,7 @@ struct packet_sock {
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
-	unsigned int		auxdata:1,	/* writer must hold sock lock */
-				has_vnet_hdr:1,
+	unsigned int		has_vnet_hdr:1, /* writer must hold sock lock */
 				tp_loss:1,
 				tp_tx_has_off:1;
 	int			pressure;
@@ -144,6 +143,7 @@ static struct packet_sock *pkt_sk(struct sock *sk)
 
 enum packet_sock_flags {
 	PACKET_SOCK_ORIGDEV,
+	PACKET_SOCK_AUXDATA,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.39.2



