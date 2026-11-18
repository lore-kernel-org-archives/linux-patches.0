Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039053;
	b=dG2ovg1I80Bhiizek55FFkyfUuHDyQdwCRccqK5O/jPyl6DKxPV+zQLlIXbyPazjfLug
	 NjVgwGD9fb+v1FuRy4R05BDo1GZizNKsdYcjXQy13a/ValFUV7tpW+rpU0alCitq0dQ4B
	 g/vCCVvC41f2iRdebUaLSzh1RCf8nz0JwmIPEcQW01Fcl+ZNjYR8jzVjlHk4z0ZYApXay
	 ohytDK17jkZMSXvvhJExZQHZkOKEjjWf2jf8TgmwKiuTL4+3b6Hd4LVeIhXv1rv+Hlj9W
	 NxM2URmt9Xuk+MP+xgAhiUWqeglnYjSN4QRW9J0JLTRN+P1NYU2RQzoiyGCRpmeCxIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lnjl42usiebYwrjzJfj78Y+9PJCPsVMGKnLq+Y76Pc0=;
	b=ZRbg72gDM2HM/REv1Rk/sgD5IHQzlSTMY+m9uCGLmt5mGib8bT+JATYjhbv/uvPHi6Jl
	 YwwIkHZsubIHBxj5rB6Ka5RgqZpbgjAWjeq9RDEy2UxH2qyk3SahruHDS+g5XHUqTPBIc
	 IuMn6rdotQAFx+5vEUUN9XF358quT/pxUX8IZZIe3UqkVMd7t59NfL8qrrkm/4Xa0Qx0G
	 gbA4M0kR0CpQapms/DekaGlwb/d13oAGRUBj20wDEay2O5y+3G7lYkt8YCLXZK7qqaYk7
	 8TUVK1WvaeXr0hQ27b16QIYKHCw7QL6kjfDmump3kRMp0Z8avzKOmpblTgCNzKwNdwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZj44WVI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F7B606A33B;
	Wed, 18 Nov 2026 21:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZj44WVI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFF61F000CE;
	Wed, 18 Nov 2026 21:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039053;
	bh=lnjl42usiebYwrjzJfj78Y+9PJCPsVMGKnLq+Y76Pc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZj44WVIECMO/ZOa4TTGVRd7or6Jw4PICVFgnM/GW2Fe77rvwHKkHRsvnfhELZGXC
	 T/YNVZwrm1nO9MdIbNLLPL7I0BBUO0Up83Ji/6mPbHaFyEPWYSmOMxYKJCZsLJo3Lq
	 g5vjwZia2210HvesKf/8ZY6t2obb+L6+w85RF+gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1920/3318] l2tp: snapshot sequencing state when building transmit headers
Date: Wed, 18 Nov 2026 15:42:22 +0100
Message-ID: <20261118150419.606501206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit d06ae66516e1aaf023808912af6292aef09d46c3 ]

Updates to send_seq from netlink, PPP setsockopt and receive-side
negotiation race with packet transmission. The header length is updated
separately, while transmit reads both fields repeatedly without
synchronization.

For example, transmit can push a ten-byte L2TPv2 header, then a concurrent
writer clears send_seq before the header builder reads it. The builder
writes only six bytes, leaving four bytes of uninitialized skb headroom
in the outgoing packet. The reverse mismatch overwrites the beginning of
the payload. A later hdr_len read can also make the UDP length disagree
with the skb length.

KCSAN reported:

  BUG: KCSAN: data-race in l2tp_session_set_header_len / l2tp_xmit_skb

  write to 0xffff888100d0944a of 2 bytes by task 116 on cpu 1:
   l2tp_session_set_header_len+0x81/0xc0
   l2tp_nl_cmd_session_modify+0x122/0x2c0
   genl_family_rcv_msg_doit+0x170/0x1d0

  read to 0xffff888100d0944a of 2 bytes by task 115 on cpu 0:
   l2tp_xmit_skb+0x9c/0xc80
   pppol2tp_sendmsg+0x21c/0x2a0
   __sys_sendto+0x28c/0x2a0

The bug can lead to leak kernel base address for KASLR bypass, the
corresponding reproducer can be provided per request.

Initialize hdr_len to the maximum header size and leave it unchanged
when sequencing is toggled. Snapshot send_seq once per packet and use
that snapshot for the actual header length and header construction,
including the sequence flag. Use the same length for headroom, the header
push and the UDP length. PPP callers can safely reserve the maximum size;
L2TPv3 header sizes do not depend on sequencing.

Make send_seq a separate bool so READ_ONCE() and WRITE_ONCE() can be used
without sharing a bitfield storage unit with other configuration flags.
Preserve the netlink attribute's existing low-bit truncation.

Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6 Astra
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Link: https://patch.msgid.link/20261013090500.1180376-1-nicoyip.dev@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: adapted the setsockopt change to preserve the existing PPP channel hdrlen update ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c    | 51 +++++++++++++++++++----------------------
 net/l2tp/l2tp_core.h    |  6 ++---
 net/l2tp/l2tp_debugfs.c |  4 ++--
 net/l2tp/l2tp_netlink.c | 11 ++++-----
 net/l2tp/l2tp_ppp.c     |  8 +++----
 5 files changed, 35 insertions(+), 45 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 717559ead628a..a0f7222a5ad0d 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -697,11 +697,9 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * check if we sre sending sequence numbers and if not,
 		 * configure it so.
 		 */
-		if (!session->lns_mode && !session->send_seq) {
+		if (!session->lns_mode && !READ_ONCE(session->send_seq)) {
 			trace_session_seqnum_lns_enable(session);
-			session->send_seq = 1;
-			l2tp_session_set_header_len(session, tunnel->version,
-						    tunnel->encap);
+			WRITE_ONCE(session->send_seq, true);
 		}
 	} else {
 		/* No sequence numbers.
@@ -719,12 +717,10 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		 * If we're the LNS and we're sending sequence numbers, the
 		 * LAC is broken. Discard the frame.
 		 */
-		if (!session->lns_mode && session->send_seq) {
+		if (!session->lns_mode && READ_ONCE(session->send_seq)) {
 			trace_session_seqnum_lns_disable(session);
-			session->send_seq = 0;
-			l2tp_session_set_header_len(session, tunnel->version,
-						    tunnel->encap);
-		} else if (session->send_seq) {
+			WRITE_ONCE(session->send_seq, false);
+		} else if (READ_ONCE(session->send_seq)) {
 			pr_debug_ratelimited("%s: recv data has no seq numbers when required. Discarding.\n",
 					     session->name);
 			atomic_long_inc(&session->stats.rx_seq_discards);
@@ -934,7 +930,8 @@ EXPORT_SYMBOL_GPL(l2tp_udp_encap_recv);
 
 /* Build an L2TP header for the session into the buffer provided.
  */
-static int l2tp_build_l2tpv2_header(struct l2tp_session *session, void *buf)
+static int l2tp_build_l2tpv2_header(struct l2tp_session *session, void *buf,
+				    bool send_seq)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 	__be16 *bufp = buf;
@@ -943,14 +940,14 @@ static int l2tp_build_l2tpv2_header(struct l2tp_session *session, void *buf)
 	u32 tunnel_id = tunnel->peer_tunnel_id;
 	u32 session_id = session->peer_session_id;
 
-	if (session->send_seq)
+	if (send_seq)
 		flags |= L2TP_HDRFLAG_S;
 
 	/* Setup L2TP header. */
 	*bufp++ = htons(flags);
 	*bufp++ = htons(tunnel_id);
 	*bufp++ = htons(session_id);
-	if (session->send_seq) {
+	if (send_seq) {
 		*bufp++ = htons(session->ns);
 		*bufp++ = 0;
 		session->ns++;
@@ -961,7 +958,8 @@ static int l2tp_build_l2tpv2_header(struct l2tp_session *session, void *buf)
 	return bufp - optr;
 }
 
-static int l2tp_build_l2tpv3_header(struct l2tp_session *session, void *buf)
+static int l2tp_build_l2tpv3_header(struct l2tp_session *session, void *buf,
+				    bool send_seq)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 	char *bufp = buf;
@@ -987,7 +985,7 @@ static int l2tp_build_l2tpv3_header(struct l2tp_session *session, void *buf)
 	if (session->l2specific_type == L2TP_L2SPECTYPE_DEFAULT) {
 		u32 l2h = 0;
 
-		if (session->send_seq) {
+		if (send_seq) {
 			l2h = 0x40000000 | session->ns;
 			session->ns++;
 			session->ns &= 0xffffff;
@@ -1021,19 +1019,24 @@ static int l2tp_xmit_queue(struct l2tp_tunnel *tunnel, struct sk_buff *skb, stru
 static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, unsigned int *len)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
+	bool send_seq = READ_ONCE(session->send_seq);
 	unsigned int data_len = skb->len;
 	struct sock *sk = tunnel->sock;
+	u16 hdr_len = session->hdr_len;
 	int headroom, uhlen, udp_len;
 	int ret = NET_XMIT_SUCCESS;
 	struct inet_sock *inet;
 	struct udphdr *uh;
 
+	if (tunnel->version == L2TP_HDR_VER_2 && !send_seq)
+		hdr_len -= 4;
+
 	/* Check that there's enough headroom in the skb to insert IP,
 	 * UDP and L2TP headers. If not enough, expand it to
 	 * make room. Adjust truesize.
 	 */
 	uhlen = (tunnel->encap == L2TP_ENCAPTYPE_UDP) ? sizeof(*uh) : 0;
-	headroom = NET_SKB_PAD + sizeof(struct iphdr) + uhlen + session->hdr_len;
+	headroom = NET_SKB_PAD + sizeof(struct iphdr) + uhlen + hdr_len;
 	if (skb_cow_head(skb, headroom)) {
 		kfree_skb(skb);
 		return NET_XMIT_DROP;
@@ -1041,9 +1044,9 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
 
 	/* Setup L2TP header */
 	if (tunnel->version == L2TP_HDR_VER_2)
-		l2tp_build_l2tpv2_header(session, __skb_push(skb, session->hdr_len));
+		l2tp_build_l2tpv2_header(session, __skb_push(skb, hdr_len), send_seq);
 	else
-		l2tp_build_l2tpv3_header(session, __skb_push(skb, session->hdr_len));
+		l2tp_build_l2tpv3_header(session, __skb_push(skb, hdr_len), send_seq);
 
 	/* Reset skb netfilter state */
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
@@ -1086,7 +1089,7 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
 		uh = udp_hdr(skb);
 		uh->source = inet->inet_sport;
 		uh->dest = inet->inet_dport;
-		udp_len = uhlen + session->hdr_len + data_len;
+		udp_len = uhlen + hdr_len + data_len;
 		if (udp_len > U16_MAX) {
 			kfree_skb(skb);
 			ret = NET_XMIT_DROP;
@@ -1580,16 +1583,11 @@ void l2tp_session_delete(struct l2tp_session *session)
 }
 EXPORT_SYMBOL_GPL(l2tp_session_delete);
 
-/* We come here whenever a session's send_seq, cookie_len or
- * l2specific_type parameters are set.
- */
-void l2tp_session_set_header_len(struct l2tp_session *session, int version,
-				 enum l2tp_encap_type encap)
+static void l2tp_session_set_header_len(struct l2tp_session *session, int version,
+					enum l2tp_encap_type encap)
 {
 	if (version == L2TP_HDR_VER_2) {
-		session->hdr_len = 6;
-		if (session->send_seq)
-			session->hdr_len += 4;
+		session->hdr_len = 10;
 	} else {
 		session->hdr_len = 4 + session->cookie_len;
 		session->hdr_len += l2tp_get_l2specific_len(session);
@@ -1597,7 +1595,6 @@ void l2tp_session_set_header_len(struct l2tp_session *session, int version,
 			session->hdr_len += 4;
 	}
 }
-EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 
 struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id,
 					 u32 peer_session_id, struct l2tp_session_cfg *cfg)
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 61f402c3e7f46..84d1cff323ec0 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -79,7 +79,7 @@ struct l2tp_session {
 	u8			peer_cookie[8];
 	int			peer_cookie_len;
 	u16			l2specific_type;
-	u16			hdr_len;
+	u16			hdr_len;	/* maximum L2TP header length */
 	u32			nr;		/* session NR state (receive) */
 	u32			ns;		/* session NR state (send) */
 	struct sk_buff_head	reorder_q;	/* receive reorder queue */
@@ -93,8 +93,8 @@ struct l2tp_session {
 
 	char			name[L2TP_SESSION_NAME_MAX]; /* for logging */
 	char			ifname[IFNAMSIZ];
+	bool			send_seq;	/* send packets with sequence numbers? */
 	unsigned int		recv_seq:1;	/* expect receive packets with sequence numbers? */
-	unsigned int		send_seq:1;	/* send packets with sequence numbers? */
 	unsigned int		lns_mode:1;	/* behave as LNS?
 						 * LAC enables sequence numbers under LNS control.
 						 */
@@ -261,8 +261,6 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb);
 
 /* Transmit path helpers for sending packets over the tunnel socket. */
-void l2tp_session_set_header_len(struct l2tp_session *session, int version,
-				 enum l2tp_encap_type encap);
 int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb);
 
 /* Pseudowire management.
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index fe56dbae43bea..c4d10eb3923ef 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -183,12 +183,12 @@ static void l2tp_dfs_seq_session_show(struct seq_file *m, void *v)
 		   session->pwtype == L2TP_PWTYPE_ETH ? "ETH" :
 		   session->pwtype == L2TP_PWTYPE_PPP ? "PPP" :
 		   "");
-	if (session->send_seq || session->recv_seq)
+	if (READ_ONCE(session->send_seq) || session->recv_seq)
 		seq_printf(m, "   nr %u, ns %u\n", session->nr, session->ns);
 	seq_printf(m, "   refcnt %d\n", refcount_read(&session->ref_count));
 	seq_printf(m, "   config 0/0/%c/%c/-/%s %08x %u\n",
 		   session->recv_seq ? 'R' : '-',
-		   session->send_seq ? 'S' : '-',
+		   READ_ONCE(session->send_seq) ? 'S' : '-',
 		   session->lns_mode ? "LNS" : "LAC",
 		   0,
 		   jiffies_to_msecs(session->reorder_timeout));
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 25800de8b4825..9fdaeb4cbc745 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -689,12 +689,9 @@ static int l2tp_nl_cmd_session_modify(struct sk_buff *skb, struct genl_info *inf
 	if (info->attrs[L2TP_ATTR_RECV_SEQ])
 		session->recv_seq = nla_get_u8(info->attrs[L2TP_ATTR_RECV_SEQ]);
 
-	if (info->attrs[L2TP_ATTR_SEND_SEQ]) {
-		struct l2tp_tunnel *tunnel = session->tunnel;
-
-		session->send_seq = nla_get_u8(info->attrs[L2TP_ATTR_SEND_SEQ]);
-		l2tp_session_set_header_len(session, tunnel->version, tunnel->encap);
-	}
+	if (info->attrs[L2TP_ATTR_SEND_SEQ])
+		WRITE_ONCE(session->send_seq,
+			   nla_get_u8(info->attrs[L2TP_ATTR_SEND_SEQ]) & 1);
 
 	if (info->attrs[L2TP_ATTR_LNS_MODE])
 		session->lns_mode = nla_get_u8(info->attrs[L2TP_ATTR_LNS_MODE]);
@@ -737,7 +734,7 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 	    (session->peer_cookie_len &&
 	     nla_put(skb, L2TP_ATTR_PEER_COOKIE, session->peer_cookie_len, session->peer_cookie)) ||
 	    nla_put_u8(skb, L2TP_ATTR_RECV_SEQ, session->recv_seq) ||
-	    nla_put_u8(skb, L2TP_ATTR_SEND_SEQ, session->send_seq) ||
+	    nla_put_u8(skb, L2TP_ATTR_SEND_SEQ, READ_ONCE(session->send_seq)) ||
 	    nla_put_u8(skb, L2TP_ATTR_LNS_MODE, session->lns_mode) ||
 	    (l2tp_tunnel_uses_xfrm(tunnel) &&
 	     nla_put_u8(skb, L2TP_ATTR_USING_IPSEC, 1)) ||
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 21b1016020f3a..92049b9020106 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1205,15 +1205,13 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 			err = -EINVAL;
 			break;
 		}
-		session->send_seq = !!val;
+		WRITE_ONCE(session->send_seq, !!val);
 		{
 			struct pppox_sock *po = pppox_sk(sk);
 
 			po->chan.hdrlen = val ? PPPOL2TP_L2TP_HDR_SIZE_SEQ :
 				PPPOL2TP_L2TP_HDR_SIZE_NOSEQ;
 		}
-		l2tp_session_set_header_len(session, session->tunnel->version,
-					    session->tunnel->encap);
 		break;
 
 	case PPPOL2TP_SO_LNSMODE:
@@ -1323,7 +1321,7 @@ static int pppol2tp_session_getsockopt(struct sock *sk,
 		break;
 
 	case PPPOL2TP_SO_SENDSEQ:
-		*val = session->send_seq;
+		*val = READ_ONCE(session->send_seq);
 		break;
 
 	case PPPOL2TP_SO_LNSMODE:
@@ -1569,7 +1567,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
 		   state, user_data_ok);
 	seq_printf(m, "   0/0/%c/%c/%s %08x %u\n",
 		   session->recv_seq ? 'R' : '-',
-		   session->send_seq ? 'S' : '-',
+		   READ_ONCE(session->send_seq) ? 'S' : '-',
 		   session->lns_mode ? "LNS" : "LAC",
 		   0,
 		   jiffies_to_msecs(session->reorder_timeout));
-- 
2.53.0



