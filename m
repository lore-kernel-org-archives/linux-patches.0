Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54D1611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730D1C433EF;
	Sun, 28 May 2023 19:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302967;
	bh=0Y83a4s5ot+uW57xjM1fD4xENqSAW0uajHqlLgWu9xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kI8BnRgHf2AjprLc1Mh1/9tQ+wYPtgAOUhhkUxT7NSSnUjvffCG9v4xM7h0+qAFgZ
	 U9iZlW6nr3Qaid50POHsDyARXfslpGDwWN6eRAHCiSP70tUZQjclXXIo1Klc2v5ZWt
	 PAN8DvNWdyavkN263qxaQf7Adr2Bzuz7Ey7hn3No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/211] tcp: fix possible sk_priority leak in tcp_v4_send_reset()
Date: Sun, 28 May 2023 20:10:21 +0100
Message-Id: <20230528190846.076396433@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
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

[ Upstream commit 1e306ec49a1f206fd2cc89a42fac6e6f592a8cc1 ]

When tcp_v4_send_reset() is called with @sk == NULL,
we do not change ctl_sk->sk_priority, which could have been
set from a prior invocation.

Change tcp_v4_send_reset() to set sk_priority and sk_mark
fields before calling ip_send_unicast_reply().

This means tcp_v4_send_reset() and tcp_v4_send_ack()
no longer have to clear ctl_sk->sk_mark after
their call to ip_send_unicast_reply().

Fixes: f6c0f5d209fa ("tcp: honor SO_PRIORITY in TIME_WAIT state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1995d46afb214..270b20e0907c2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -805,6 +805,9 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
 		xfrm_sk_clone_policy(ctl_sk, sk);
+	} else {
+		ctl_sk->sk_mark = 0;
+		ctl_sk->sk_priority = 0;
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -812,7 +815,6 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      &arg, arg.iov[0].iov_len,
 			      transmit_time);
 
-	ctl_sk->sk_mark = 0;
 	xfrm_sk_free_policy(ctl_sk);
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
@@ -911,7 +913,6 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      &arg, arg.iov[0].iov_len,
 			      transmit_time);
 
-	ctl_sk->sk_mark = 0;
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	local_bh_enable();
-- 
2.39.2



