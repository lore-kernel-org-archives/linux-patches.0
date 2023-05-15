Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1268FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270E2C4339B;
	Mon, 15 May 2023 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172408;
	bh=XTjihFU6sfVE3DukRlrR1IIuLac1INxglTQfGb+cx0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLSIAWm/MxTDrbkgffIiTadO54ak95IbUN94ZqS6V/g5BO/UQkwZhm+sbtDoYAszn
	 KvW65E65kk/StOKY5acEh4cy2jvPkTm+Eqsio0wC73q9juF7XxhQ0tRU8/omrC4ZRd
	 Roo2awJ3pCENBCmGVTdM2ywunsMa8iQkGqIRB9Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/381] net/packet: convert po->auxdata to an atomic flag
Date: Mon, 15 May 2023 18:26:35 +0200
Message-Id: <20230515161743.360399548@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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
index df93f4b09ab9e..9b6f6a5e0b147 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3485,7 +3485,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
-	if (pkt_sk(sk)->auxdata) {
+	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_AUXDATA)) {
 		struct tpacket_auxdata aux;
 
 		aux.tp_status = TP_STATUS_USER;
@@ -3869,9 +3869,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		lock_sock(sk);
-		po->auxdata = !!val;
-		release_sock(sk);
+		packet_sock_flag_set(po, PACKET_SOCK_AUXDATA, val);
 		return 0;
 	}
 	case PACKET_ORIGDEV:
@@ -4032,7 +4030,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 
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
index 7fea453dc7215..3938cb413d5d3 100644
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
@@ -146,6 +145,7 @@ static struct packet_sock *pkt_sk(struct sock *sk)
 
 enum packet_sock_flags {
 	PACKET_SOCK_ORIGDEV,
+	PACKET_SOCK_AUXDATA,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.39.2



