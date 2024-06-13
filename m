Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFC7145A0E;
	Thu, 13 Jun 2024 11:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279463; cv=none; b=Z30AnVJE2ZSe0+t6tRVba2s3EOnVdgZ9XtiAHfT/my+Ehfwu0SlPP6ANR9HtES+K2wH8rZWF4Vaq4GYmVOy+fuIWEMUHbVKaGvkfjg0iEZDjjFW73i4cZXvGk4gGD/n74vphIyJtMUSHtv70JJDu2kVyWBxVkMlJ9J4okxnrgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279463; c=relaxed/simple;
	bh=idu300iTYzkbbA93/ACjpt+mW1HKmahsbaUbK4jsQnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1nPTSDRi1fjqgRZB8n1wsmln5ntIZwPGzmrKdr1X89NH4rkflq7dtf0kVmL7akjb6PdzemukUT/ytKzmPcYUICMN3w6obXnemenJRdyHChNxDUmgrzpoHisANN2UIrbGTCEJgvoOQ9jKTdg7i3/03p/pxgZhqjyntT98jN+YIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kV5xb5yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kV5xb5yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A5BC4AF1C;
	Thu, 13 Jun 2024 11:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279463;
	bh=idu300iTYzkbbA93/ACjpt+mW1HKmahsbaUbK4jsQnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kV5xb5yt8RPIGRzbjJx/Z5WmsKC0H7/KeFUUdqyyFQ3gcgua369UZTxDwPTT3kLge
	 EMkEEK5Y5eirYf/87nawyzvLW1b/rSmEu2cJTVl9Jad05Ya/8U7M7JWh2I027ZieAX
	 1pkmcw7j1Qk+Sn0R/WkLFL94QhNcVI3elQtST9iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 084/157] net/tcp: Dont consider TCP_CLOSE in TCP_AO_ESTABLISHED
Date: Thu, 13 Jun 2024 13:33:29 +0200
Message-ID: <20240613113230.674419188@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <0x7f454c46@gmail.com>

commit 33700a0c9b562700c28d31360a5f04508f459a45 upstream.

TCP_CLOSE may or may not have current/rnext keys and should not be
considered "established". The fast-path for TCP_CLOSE is
SKB_DROP_REASON_TCP_CLOSE. This is what tcp_rcv_state_process() does
anyways. Add an early drop path to not spend any time verifying
segment signatures for sockets in TCP_CLOSE state.

Cc: stable@vger.kernel.org # v6.7
Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://lore.kernel.org/r/20240529-tcp_ao-sk_state-v1-1-d69b5d323c52@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp_ao.h |    7 ++++---
 net/ipv4/tcp_ao.c    |   13 +++++++++----
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -86,7 +86,8 @@ static inline int tcp_ao_sizeof_key(cons
 struct tcp_ao_info {
 	/* List of tcp_ao_key's */
 	struct hlist_head	head;
-	/* current_key and rnext_key aren't maintained on listen sockets.
+	/* current_key and rnext_key are maintained on sockets
+	 * in TCP_AO_ESTABLISHED states.
 	 * Their purpose is to cache keys on established connections,
 	 * saving needless lookups. Never dereference any of them from
 	 * listen sockets.
@@ -201,9 +202,9 @@ struct tcp6_ao_context {
 };
 
 struct tcp_sigpool;
+/* Established states are fast-path and there always is current_key/rnext_key */
 #define TCP_AO_ESTABLISHED (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2 | \
-			    TCPF_CLOSE | TCPF_CLOSE_WAIT | \
-			    TCPF_LAST_ACK | TCPF_CLOSING)
+			    TCPF_CLOSE_WAIT | TCPF_LAST_ACK | TCPF_CLOSING)
 
 int tcp_ao_transmit_skb(struct sock *sk, struct sk_buff *skb,
 			struct tcp_ao_key *key, struct tcphdr *th,
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -933,6 +933,7 @@ tcp_inbound_ao_hash(struct sock *sk, con
 	struct tcp_ao_key *key;
 	__be32 sisn, disn;
 	u8 *traffic_key;
+	int state;
 	u32 sne = 0;
 
 	info = rcu_dereference(tcp_sk(sk)->ao_info);
@@ -948,8 +949,9 @@ tcp_inbound_ao_hash(struct sock *sk, con
 		disn = 0;
 	}
 
+	state = READ_ONCE(sk->sk_state);
 	/* Fast-path */
-	if (likely((1 << sk->sk_state) & TCP_AO_ESTABLISHED)) {
+	if (likely((1 << state) & TCP_AO_ESTABLISHED)) {
 		enum skb_drop_reason err;
 		struct tcp_ao_key *current_key;
 
@@ -988,6 +990,9 @@ tcp_inbound_ao_hash(struct sock *sk, con
 		return SKB_NOT_DROPPED_YET;
 	}
 
+	if (unlikely(state == TCP_CLOSE))
+		return SKB_DROP_REASON_TCP_CLOSE;
+
 	/* Lookup key based on peer address and keyid.
 	 * current_key and rnext_key must not be used on tcp listen
 	 * sockets as otherwise:
@@ -1001,7 +1006,7 @@ tcp_inbound_ao_hash(struct sock *sk, con
 	if (th->syn && !th->ack)
 		goto verify_hash;
 
-	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_NEW_SYN_RECV)) {
+	if ((1 << state) & (TCPF_LISTEN | TCPF_NEW_SYN_RECV)) {
 		/* Make the initial syn the likely case here */
 		if (unlikely(req)) {
 			sne = tcp_ao_compute_sne(0, tcp_rsk(req)->rcv_isn,
@@ -1018,14 +1023,14 @@ tcp_inbound_ao_hash(struct sock *sk, con
 			/* no way to figure out initial sisn/disn - drop */
 			return SKB_DROP_REASON_TCP_FLAGS;
 		}
-	} else if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
+	} else if ((1 << state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		disn = info->lisn;
 		if (th->syn || th->rst)
 			sisn = th->seq;
 		else
 			sisn = info->risn;
 	} else {
-		WARN_ONCE(1, "TCP-AO: Unexpected sk_state %d", sk->sk_state);
+		WARN_ONCE(1, "TCP-AO: Unexpected sk_state %d", state);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 verify_hash:


