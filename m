Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9C0198A04;
	Thu,  6 Jun 2024 14:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683044; cv=none; b=ZoTowsPhczQN2Tb1CL2f33ujtO7W0RaANWJV0OFYKQ/xXVynDW8jj0tIID/8E2Hz/KUq/M6FZfqwe+kEkX+9YRKmOsyD9LUzJH4PSrIY7kJzr/0ZMjOvgRFW1CojSX7wNSvzPbDMlRsKiKbRoetfRoy7rhJx+3jf9A6wvOPj38E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683044; c=relaxed/simple;
	bh=BI8HFZkADz7U27H3YZFf3Hz8HTOjqE8U0e+Beoj8ZEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EK7mwkzC0EtJQtd4Q0wvrCHyCNW+6wiL6A01V4/Mqi0GfilLEzqEVHRqx0Q3RhV1ATYZyqJEFPlqYz+ZJ2KTc53kg/q6T1cLvsqFIfRKv4fgb3f2jO7f8RkWg7nPShlCX5w/qv9K570Xvk5xxEbMDQUFN56rRvMvG+EyOKUfl9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR2ZM/mP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR2ZM/mP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBB5C4AF09;
	Thu,  6 Jun 2024 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683044;
	bh=BI8HFZkADz7U27H3YZFf3Hz8HTOjqE8U0e+Beoj8ZEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR2ZM/mPciYRdnkfV5E2MQtlxijPGcnFnoIryLlJsC5RN96t5OFJBHGeXI9BraPO2
	 ZkN1i4krrbDjNinOo5lhAmBO36TJC9altDyMpg6kzLB7lNzm5IVpur0yQ1bNSnkYUu
	 v6/mm09Zswyjg5uhmungqQdZM71FG1qJNVe/sDlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Subject: [PATCH 6.9 282/374] tcp: reduce accepted window in NEW_SYN_RECV state
Date: Thu,  6 Jun 2024 16:04:21 +0200
Message-ID: <20240606131701.347189572@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit f4dca95fc0f6350918f2e6727e35b41f7f86fcce upstream.

Jason commit made checks against ACK sequence less strict
and can be exploited by attackers to establish spoofed flows
with less probes.

Innocent users might use tcp_rmem[1] == 1,000,000,000,
or something more reasonable.

An attacker can use a regular TCP connection to learn the server
initial tp->rcv_wnd, and use it to optimize the attack.

If we make sure that only the announced window (smaller than 65535)
is used for ACK validation, we force an attacker to use
65537 packets to complete the 3WHS (assuming server ISN is unknown)

Fixes: 378979e94e95 ("tcp: remove 64 KByte limit for initial tp->rcv_wnd value")
Link: https://datatracker.ietf.org/meeting/119/materials/slides-119-tcpm-ghost-acks-00
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://lore.kernel.org/r/20240523130528.60376-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/request_sock.h |   12 ++++++++++++
 net/ipv4/tcp_ipv4.c        |    7 +------
 net/ipv4/tcp_minisocks.c   |    7 +++++--
 net/ipv6/tcp_ipv6.c        |    7 +------
 4 files changed, 19 insertions(+), 14 deletions(-)

--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -282,4 +282,16 @@ static inline int reqsk_queue_len_young(
 	return atomic_read(&queue->young);
 }
 
+/* RFC 7323 2.3 Using the Window Scale Option
+ *  The window field (SEG.WND) of every outgoing segment, with the
+ *  exception of <SYN> segments, MUST be right-shifted by
+ *  Rcv.Wind.Shift bits.
+ *
+ * This means the SEG.WND carried in SYNACK can not exceed 65535.
+ * We use this property to harden TCP stack while in NEW_SYN_RECV state.
+ */
+static inline u32 tcp_synack_window(const struct request_sock *req)
+{
+	return min(req->rsk_rcv_wnd, 65535U);
+}
 #endif /* _REQUEST_SOCK_H */
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1143,14 +1143,9 @@ static void tcp_v4_reqsk_send_ack(const
 #endif
 	}
 
-	/* RFC 7323 2.3
-	 * The window field (SEG.WND) of every outgoing segment, with the
-	 * exception of <SYN> segments, MUST be right-shifted by
-	 * Rcv.Wind.Shift bits:
-	 */
 	tcp_v4_send_ack(sk, skb, seq,
 			tcp_rsk(req)->rcv_nxt,
-			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
+			tcp_synack_window(req) >> inet_rsk(req)->rcv_wscale,
 			tcp_rsk_tsval(tcp_rsk(req)),
 			READ_ONCE(req->ts_recent),
 			0, &key,
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -783,8 +783,11 @@ struct sock *tcp_check_req(struct sock *
 
 	/* RFC793: "first check sequence number". */
 
-	if (paws_reject || !tcp_in_window(TCP_SKB_CB(skb)->seq, TCP_SKB_CB(skb)->end_seq,
-					  tcp_rsk(req)->rcv_nxt, tcp_rsk(req)->rcv_nxt + req->rsk_rcv_wnd)) {
+	if (paws_reject || !tcp_in_window(TCP_SKB_CB(skb)->seq,
+					  TCP_SKB_CB(skb)->end_seq,
+					  tcp_rsk(req)->rcv_nxt,
+					  tcp_rsk(req)->rcv_nxt +
+					  tcp_synack_window(req))) {
 		/* Out of window: send ACK and drop. */
 		if (!(flg & TCP_FLAG_RST) &&
 		    !tcp_oow_rate_limited(sock_net(sk), skb,
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1268,15 +1268,10 @@ static void tcp_v6_reqsk_send_ack(const
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
 	 */
-	/* RFC 7323 2.3
-	 * The window field (SEG.WND) of every outgoing segment, with the
-	 * exception of <SYN> segments, MUST be right-shifted by
-	 * Rcv.Wind.Shift bits:
-	 */
 	tcp_v6_send_ack(sk, skb, (sk->sk_state == TCP_LISTEN) ?
 			tcp_rsk(req)->snt_isn + 1 : tcp_sk(sk)->snd_nxt,
 			tcp_rsk(req)->rcv_nxt,
-			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
+			tcp_synack_window(req) >> inet_rsk(req)->rcv_wscale,
 			tcp_rsk_tsval(tcp_rsk(req)),
 			READ_ONCE(req->ts_recent), sk->sk_bound_dev_if,
 			&key, ipv6_get_dsfield(ipv6_hdr(skb)), 0,


