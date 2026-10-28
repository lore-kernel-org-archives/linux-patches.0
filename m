Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214040;
	b=kiJvz4qNwxqekDxeA5qDeCqXAToU75k36OMbxzy4iP4QCLH9jCbY9W1Cm6DrWvpArPd8
	 XFzxvf9prQma/n4d0Q/ZIBfonvUo+lZhTIL5Yhy/zQD5lgd2OsBT3ttw0QW9sh5xypRP5
	 brX7OW8d/ahUl8Kb+JWdxUiNWf4cbuEpYQ3uDqibzqGQZviu7emqG/CniTGtxbGGg6UgW
	 ZyKuty6viMpBfWezpYc3caENRU33FneZg7q9Bk4g8wBZl4I7EaykOMq8SP1jMbRzsMtwC
	 7gPsb89AU7K5QiRixa6Pvb8K9Z7aDfDuYktPNSfPYwo56PcXERgRYAEBeNX6YiuPm5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XXJFZkpgwl+kDsN01Fn2TSNRW+a130n9Yo+wnCYVqoo=;
	b=XbdDLaZFx7CKaZaIWApoyUyWBXuCsDfc6LR3G3ysidNR3V9fj7aKKNszQczttohOWR2u
	 XvSIZG/ymuyNwKmDLeg9VCzf5C/cCHLlBvmge5nsI/ZD5CBdZqJmGykHPAcAuNz5NacUo
	 SRacf2UiE+g/Ux6K6ToPEuIho6UZRY3GTgSkCU5O39zsXeJ02i7hFRSNuvYzzEsUqVU01
	 QtEtw+8+vxnSigZKoWReHGhWaYA4RFa1UN6fjKIUWd0wA8sTE+pwjKzjPnXu1RS446oAp
	 Kw62AsaxXX/RYUF5KD8Ebo6j9k0Z6q0uFJNMGTgzrsDvTr5CcvesUYpmI8JI3fZAauA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZ6PmODb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D18606A321;
	Wed, 28 Oct 2026 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZ6PmODb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B701F01825;
	Wed, 28 Oct 2026 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214040;
	bh=XXJFZkpgwl+kDsN01Fn2TSNRW+a130n9Yo+wnCYVqoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZ6PmODb2xwvS+9SsKwBBbqGDAMMJjK6nLQlQWlAOuHGN6o79jEAzxBdYbFno3EGE
	 i+cU7yIuwkwTJmCeBNPi/MQlZsHqEvx3IWufyOvTPA8rS2TjfT5ddqDC+QvLj2+GUK
	 z3pXObDc5CnCntXyVWQF8D4vS49p3OTvrPJe9eIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Chapman <jchapman@katalix.com>,
	Tom Parkin <tparkin@katalix.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0674/1887] l2tp: prevent possible tunnel refcount underflow
Date: Wed, 28 Oct 2026 17:46:10 +0100
Message-ID: <20261028170514.748532436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Chapman <jchapman@katalix.com>

[ Upstream commit 24256415d18695b46da06c93135f5b51c548b950 ]

When a session is created, it sets a backpointer to its tunnel. When
the session refcount drops to 0, l2tp_session_free drops the tunnel
refcount if session->tunnel is non-NULL. However, session->tunnel is
set in l2tp_session_create, before the tunnel refcount is incremented
by l2tp_session_register, which leaves a small window where
session->tunnel is non-NULL when the tunnel refcount hasn't been
bumped.

Moving the assignment to l2tp_session_register is trivial but
l2tp_session_create calls l2tp_session_set_header_len which uses
session->tunnel to get the tunnel's encap. Add an encap arg to
l2tp_session_set_header_len to avoid using session->tunnel.

If l2tpv3 sessions have colliding IDs, it is possible for
l2tp_v3_session_get to race with l2tp_session_register and fetch a
session which doesn't yet have session->tunnel set. Add a check for
this case.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: Tom Parkin <tparkin@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c    | 16 ++++++++++------
 net/l2tp/l2tp_core.h    |  3 ++-
 net/l2tp/l2tp_netlink.c |  4 +++-
 net/l2tp/l2tp_ppp.c     |  3 ++-
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 3c701795fa100..717559ead628a 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -380,11 +380,13 @@ int l2tp_session_register(struct l2tp_session *session,
 			}
 
 		l2tp_tunnel_inc_refcount(tunnel);
+		WRITE_ONCE(session->tunnel, tunnel);
 		hlist_add_head_rcu(&session->global_hlist, g_head);
 
 		spin_unlock_bh(&pn->l2tp_session_hlist_lock);
 	} else {
 		l2tp_tunnel_inc_refcount(tunnel);
+		WRITE_ONCE(session->tunnel, tunnel);
 	}
 
 	hlist_add_head_rcu(&session->hlist, head);
@@ -698,7 +700,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		if (!session->lns_mode && !session->send_seq) {
 			trace_session_seqnum_lns_enable(session);
 			session->send_seq = 1;
-			l2tp_session_set_header_len(session, tunnel->version);
+			l2tp_session_set_header_len(session, tunnel->version,
+						    tunnel->encap);
 		}
 	} else {
 		/* No sequence numbers.
@@ -719,7 +722,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		if (!session->lns_mode && session->send_seq) {
 			trace_session_seqnum_lns_disable(session);
 			session->send_seq = 0;
-			l2tp_session_set_header_len(session, tunnel->version);
+			l2tp_session_set_header_len(session, tunnel->version,
+						    tunnel->encap);
 		} else if (session->send_seq) {
 			pr_debug_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
 					     session->name);
@@ -1579,7 +1583,8 @@ EXPORT_SYMBOL_GPL(l2tp_session_delete);
 /* We come here whenever a session's send_seq, cookie_len or
  * l2specific_type parameters are set.
  */
-void l2tp_session_set_header_len(struct l2tp_session *session, int version)
+void l2tp_session_set_header_len(struct l2tp_session *session, int version,
+				 enum l2tp_encap_type encap)
 {
 	if (version == L2TP_HDR_VER_2) {
 		session->hdr_len = 6;
@@ -1588,7 +1593,7 @@ void l2tp_session_set_header_len(struct l2tp_session *session, int version)
 	} else {
 		session->hdr_len = 4 + session->cookie_len;
 		session->hdr_len += l2tp_get_l2specific_len(session);
-		if (session->tunnel->encap == L2TP_ENCAPTYPE_UDP)
+		if (encap == L2TP_ENCAPTYPE_UDP)
 			session->hdr_len += 4;
 	}
 }
@@ -1602,7 +1607,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 	session = kzalloc(sizeof(*session) + priv_size, GFP_KERNEL);
 	if (session) {
 		session->magic = L2TP_SESSION_MAGIC;
-		session->tunnel = tunnel;
 
 		session->session_id = session_id;
 		session->peer_session_id = peer_session_id;
@@ -1638,7 +1642,7 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 			memcpy(&session->peer_cookie[0], &cfg->peer_cookie[0], cfg->peer_cookie_len);
 		}
 
-		l2tp_session_set_header_len(session, tunnel->version);
+		l2tp_session_set_header_len(session, tunnel->version, tunnel->encap);
 
 		refcount_set(&session->ref_count, 1);
 
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index a88e070b431d8..9f7143d2dd31b 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -261,7 +261,8 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb);
 
 /* Transmit path helpers for sending packets over the tunnel socket. */
-void l2tp_session_set_header_len(struct l2tp_session *session, int version);
+void l2tp_session_set_header_len(struct l2tp_session *session, int version,
+				 enum l2tp_encap_type encap);
 int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb);
 
 /* Pseudowire management.
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index e27e00cb16c6b..05314419c7bbb 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -690,8 +690,10 @@ static int l2tp_nl_cmd_session_modify(struct sk_buff *skb, struct genl_info *inf
 		session->recv_seq = nla_get_u8(info->attrs[L2TP_ATTR_RECV_SEQ]);
 
 	if (info->attrs[L2TP_ATTR_SEND_SEQ]) {
+		struct l2tp_tunnel *tunnel = session->tunnel;
+
 		session->send_seq = nla_get_u8(info->attrs[L2TP_ATTR_SEND_SEQ]);
-		l2tp_session_set_header_len(session, session->tunnel->version);
+		l2tp_session_set_header_len(session, tunnel->version, tunnel->encap);
 	}
 
 	if (info->attrs[L2TP_ATTR_LNS_MODE])
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 2e856a83a7506..1573edb66ee35 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1194,7 +1194,8 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 			po->chan.hdrlen = val ? PPPOL2TP_L2TP_HDR_SIZE_SEQ :
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
-		l2tp_session_set_header_len(session, session->tunnel->version);
+		l2tp_session_set_header_len(session, session->tunnel->version,
+					    session->tunnel->encap);
 		break;
 
 	case PPPOL2TP_SO_LNSMODE:
-- 
2.53.0



