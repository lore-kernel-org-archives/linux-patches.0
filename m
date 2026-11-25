Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619194;
	b=kk0ulMTx/5AiIyn/jpipLu5YoKglp8P25r+Wq6CAbyBWnbS70Dy/ZlWSk9y3ZIw/y73C
	 Sz71f8BRfyH+GbpyizTo509i1ImHC3UOmqjcwUVwjvPW2zKoM2c6zHgMG9sKaaqlotzhb
	 oT7vGRDQH2fpowLnxsWfE3DarLipJS7OUaDN83JK3VYDS+7oG7Kul0mjscPoW3gYgsns1
	 RmkMRZ/IWuYiAyzsIOoaCQC30boViLGZdDvgdfKo7nQKa0oncYw40DJLANO2ZIdg+BRA+
	 1Ai8VYqn/sQ062sIQ9m3//dMPMEfLluEADH3Ck0bTp2huvZSlIH3/oPPEygH67uE6hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w2AFm7HOd7WjZXp/yineGvT1hyVnnGfJpzO4ALJEVyI=;
	b=wCa6FFH1nQ0pJNygMYL4XHvDPiyc7arawPffHVVSOC40Xl3uQCIayq/cd5VrezJjXSTo
	 8hUNS8XirSvs0iCuAAYS5K/6yqICOVxUtVAnpAO+HV0TfLnCrUym008pn31+kojRDjANv
	 x+z5bzDYEGR7UcvoVxMCMgQEcIdNCStz9zZgSe28VaCYi31Z3dHz60hIuRc7GNWWq1BDF
	 iJwf5a2WCVImrROtHfiTjCJo847xgl+AoNUFUKT/FBBKPBN7frNV7U05NA5vFE5rrUy53
	 ZFySmoOqt4d3USfNf+rUH3NshnKBsLOaSXJXyjEAb04R8Q7pSDy5ZE9Juj9OatvqzCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FXDfnMx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE30C606A689;
	Wed, 25 Nov 2026 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FXDfnMx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F345D1F000D3;
	Wed, 25 Nov 2026 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619194;
	bh=w2AFm7HOd7WjZXp/yineGvT1hyVnnGfJpzO4ALJEVyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FXDfnMxrzRYqmKosZvOptI0y0mWsnEWuPhPRMmuTleub/KqunDBaoJAikkF7SNZB
	 OUwslOdzQT1mev6UqwNUlc2FWk23cG/yRrxuuh4Q0ptokKP2fR+Bi/AK94BLohqJfK
	 /OkRdNqJIeXcnD9kHeEepkLVjD674L5l5mL1WGGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0520/1005] tcp: Drop any segments if DEFER_CONNECT is set.
Date: Wed, 25 Nov 2026 15:30:58 +0100
Message-ID: <20261125143833.926583181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 44809e49177992b15708a150437d9aebc5beea9c ]

TCP Fast Open lets a client send data in its SYN. With
TCP_FASTOPEN_CONNECT and a cached Fast Open cookie, which the server
sent in the SYN-ACK of an earlier connection, the connection is set up
in two steps:

- connect() sends nothing, so that the SYN can carry the data of the
  first write(). It only sets DEFER_CONNECT and inserts the socket into
  the hash table in SYN_SENT.
- The first write() calls tcp_connect(), which runs tcp_connect_init()
  and sends the SYN.

A socket must not accept any segment before it has sent its SYN. But
nothing on the receive path checks DEFER_CONNECT. So until the write(),
the half-initialised socket processes segments like any socket in
SYN_SENT, and a forged SYN is accepted.

Similarly, ICMP with seq matching ISN is accepted in the state.
Before commit 57889a8f6d49 ("tcp: initialize send sequence numbers
before deferring TFO"), even seq 0 message was accepted.

Drop any segments if DEFER_CONNECT is set.

Fixes: 19f6d3f3c842 ("net/tcp-fastopen: Add new API support")
Signed-off-by: Chris Mason <mason@kernel.org>
[kuniyu: revised DEFER_CONNECT tests and the commit message]
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261107235720.3129212-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 9 +++++++++
 net/ipv4/tcp_ipv4.c  | 2 +-
 net/ipv6/tcp_ipv6.c  | 2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ce8ac1d1cd0c7..4465ecba26140 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -7236,6 +7236,15 @@ tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		goto discard;
 
 	case TCP_SYN_SENT:
+		/* We sent nothing yet, so no segment belongs to this connection.
+		 * Send no RST: it would be built from this socket, whose TCP-AO
+		 * keys are not set up either.
+		 */
+		if (unlikely(inet_test_bit(DEFER_CONNECT, sk))) {
+			SKB_DR_SET(reason, NOT_SPECIFIED);
+			goto discard;
+		}
+
 		tp->rx_opt.saw_tstamp = 0;
 		tcp_mstamp_refresh(tp);
 		queued = tcp_rcv_synsent_state_process(sk, skb, th);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index df2763f31dde6..c5567dd8c7126 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -541,7 +541,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		if (!(type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED))
 			__NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
 	}
-	if (sk->sk_state == TCP_CLOSE)
+	if (sk->sk_state == TCP_CLOSE || inet_test_bit(DEFER_CONNECT, sk))
 		goto out;
 
 	if (static_branch_unlikely(&ip4_min_ttl)) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ff2a7ce78073e..ef5928885cc6b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -449,7 +449,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (sock_owned_by_user(sk) && type != ICMPV6_PKT_TOOBIG)
 		__NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
 
-	if (sk->sk_state == TCP_CLOSE)
+	if (sk->sk_state == TCP_CLOSE || inet_test_bit(DEFER_CONNECT, sk))
 		goto out;
 
 	if (static_branch_unlikely(&ip6_min_hopcount)) {
-- 
2.53.0



