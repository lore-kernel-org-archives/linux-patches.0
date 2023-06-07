Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0480019E58
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD26C433D2;
	Wed,  7 Jun 2023 20:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170343;
	bh=cAYpqj3jGG9J/nAauFXpc8b/u6u2kYNqKBCPov9tBj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehIll/8NF5/via7zTLIkSlWVOB23Eq/09N1akkD8V0pRI+LOEROtijlR/i/k78Dil
	 9oz89c7Awl3uVHckHlyzg71BctnomhCOae++Jp4bjKsi3n7/NhPwcxVGTbsO/f+zWA
	 UDiGe7TEdTY9/zu59hqE1iHOZT1ihsLNrvPVRBy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	fuyuanli <fuyuanli@didiglobal.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/225] tcp: fix mishandling when the sack compression is deferred.
Date: Wed,  7 Jun 2023 22:14:01 +0200
Message-ID: <20230607200915.920644380@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: fuyuanli <fuyuanli@didiglobal.com>

[ Upstream commit 30c6f0bf9579debce27e45fac34fdc97e46acacc ]

In this patch, we mainly try to handle sending a compressed ack
correctly if it's deferred.

Here are more details in the old logic:
When sack compression is triggered in the tcp_compressed_ack_kick(),
if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED
and then defer to the release cb phrase. Later once user releases
the sock, tcp_delack_timer_handler() should send a ack as expected,
which, however, cannot happen due to lack of ICSK_ACK_TIMER flag.
Therefore, the receiver would not sent an ack until the sender's
retransmission timeout. It definitely increases unnecessary latency.

Fixes: 5d9f4262b7ea ("tcp: add SACK compression")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: fuyuanli <fuyuanli@didiglobal.com>
Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://lore.kernel.org/netdev/20230529113804.GA20300@didi-ThinkCentre-M920t-N000/
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230531080150.GA20424@didi-ThinkCentre-M920t-N000
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    |  1 +
 net/ipv4/tcp_input.c |  2 +-
 net/ipv4/tcp_timer.c | 16 +++++++++++++---
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0744717f5caa7..5eedd476a38d7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -632,6 +632,7 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb);
 void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
 void tcp_check_space(struct sock *sk);
+void tcp_sack_compress_send_ack(struct sock *sk);
 
 /* tcp_timer.c */
 void tcp_init_xmit_timers(struct sock *);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ac44edd6f52e6..5dabb38b857ff 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4529,7 +4529,7 @@ static void tcp_sack_maybe_coalesce(struct tcp_sock *tp)
 	}
 }
 
-static void tcp_sack_compress_send_ack(struct sock *sk)
+void tcp_sack_compress_send_ack(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index cb79127f45c34..0b5d0a2867a8c 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -290,9 +290,19 @@ static int tcp_write_timeout(struct sock *sk)
 void tcp_delack_timer_handler(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
-	    !(icsk->icsk_ack.pending & ICSK_ACK_TIMER))
+	if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
+		return;
+
+	/* Handling the sack compression case */
+	if (tp->compressed_ack) {
+		tcp_mstamp_refresh(tp);
+		tcp_sack_compress_send_ack(sk);
+		return;
+	}
+
+	if (!(icsk->icsk_ack.pending & ICSK_ACK_TIMER))
 		return;
 
 	if (time_after(icsk->icsk_ack.timeout, jiffies)) {
@@ -312,7 +322,7 @@ void tcp_delack_timer_handler(struct sock *sk)
 			inet_csk_exit_pingpong_mode(sk);
 			icsk->icsk_ack.ato      = TCP_ATO_MIN;
 		}
-		tcp_mstamp_refresh(tcp_sk(sk));
+		tcp_mstamp_refresh(tp);
 		tcp_send_ack(sk);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKS);
 	}
-- 
2.39.2



