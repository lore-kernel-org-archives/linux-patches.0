Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFD3168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C18DC433A0;
	Mon,  8 May 2023 11:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544362;
	bh=4J2iWfJU2C+tt7wLi20WoTGu5dk8wMXzPsErRq+9Q9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwaoSGNrygrqI50E7R5kJHWS8n+QHNfVVE4C8lSLqg0GtXw7v6a+9+h8pXzcaNR7U
	 xrkupjoYmTNXpLcZiTyv0sEvvTVNM8IJlmUd8+RfQerVrBcCwTNnEwcesKrLsNFTji
	 r2bt3EzTWkA1/sa6au455Dh3K7cF1KNsVcKc8mD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 355/694] net/packet: convert po->auxdata to an atomic flag
Date: Mon,  8 May 2023 11:43:10 +0200
Message-Id: <20230508094444.154526508@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
index af7c44169b869..ecd9fc27e360c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3514,7 +3514,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
-	if (pkt_sk(sk)->auxdata) {
+	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_AUXDATA)) {
 		struct tpacket_auxdata aux;
 
 		aux.tp_status = TP_STATUS_USER;
@@ -3900,9 +3900,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		lock_sock(sk);
-		po->auxdata = !!val;
-		release_sock(sk);
+		packet_sock_flag_set(po, PACKET_SOCK_AUXDATA, val);
 		return 0;
 	}
 	case PACKET_ORIGDEV:
@@ -4060,7 +4058,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 
 		break;
 	case PACKET_AUXDATA:
-		val = po->auxdata;
+		val = packet_sock_flag(po, PACKET_SOCK_AUXDATA);
 		break;
 	case PACKET_ORIGDEV:
 		val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
diff --git a/net/packet/diag.c b/net/packet/diag.c
index e1ac9bb375b31..d704c7bf51b20 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -23,7 +23,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 	pinfo.pdi_flags = 0;
 	if (po->running)
 		pinfo.pdi_flags |= PDI_RUNNING;
-	if (po->auxdata)
+	if (packet_sock_flag(po, PACKET_SOCK_AUXDATA))
 		pinfo.pdi_flags |= PDI_AUXDATA;
 	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
 		pinfo.pdi_flags |= PDI_ORIGDEV;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 178cd1852238d..3bae8ea7a36f5 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -118,8 +118,7 @@ struct packet_sock {
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
-	unsigned int		auxdata:1,	/* writer must hold sock lock */
-				has_vnet_hdr:1,
+	unsigned int		has_vnet_hdr:1, /* writer must hold sock lock */
 				tp_loss:1,
 				tp_tx_has_off:1;
 	int			pressure;
@@ -146,6 +145,7 @@ static inline struct packet_sock *pkt_sk(struct sock *sk)
 
 enum packet_sock_flags {
 	PACKET_SOCK_ORIGDEV,
+	PACKET_SOCK_AUXDATA,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.39.2



