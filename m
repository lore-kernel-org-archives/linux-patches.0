Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEEC36405A;
	Wed, 20 May 2026 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299031; cv=none; b=LHr18qOhPP38LGRHdcWl7EF+l1DGFmWDz+7tc5jSDGFMiziqJIX2z3Hi7umrRQdeFNA0AZBFviB+K9dDq4fJNAjbychxgWcJTZmjv8M1fRV/VNGCHV597ta8VjmN8tRKJy8y0w2V4JLXRkQLsM3J8/qY4JsuDER9RrTckcWOYjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299031; c=relaxed/simple;
	bh=2gO06vcAnlkapVWG3+wlDus7AC+LrBevt4Y5SHTh1m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7sTPOfI2vy5x1s3I46z4Q+U+l5cc3LBH7RU9vF63kwwUcl6KAXhDeGltLiOHLuzmBOGj4cp0hWMswHKoPyTaJFLIUZKDm89D33TcfOhvwOm8RuZL8DnToj/0q4OdNm5fmlP1Nje4JNpYUqWr4K1yicJGmBDJJHbr6UQzq7E7xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnxFhU4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnxFhU4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24171F000E9;
	Wed, 20 May 2026 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299030;
	bh=l96v1ft4dYDOMOD/gBmUiKqdoTCuHe7ddu0TdjL+Jz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnxFhU4J7+j+iFDdxQUvlK6FnzO7u57L+ZspJo8sU4RBdEOFasi1m+qicsrrxyYgN
	 73ZZV3mK5m/AIK056344BhL0np/0eCNKX6Cn0fVtw/4yaJqF0uiOWwSPy8/qHvINfK
	 kInLNvJ6ewqtwKjKlG5d9S2u/TI/OOAyvRkuHKfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 636/957] tcp: add data-race annotations for TCP_NLA_SNDQ_SIZE
Date: Wed, 20 May 2026 18:18:39 +0200
Message-ID: <20260520162148.321380891@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 124199444de467767175a9004e1574dc42523e62 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 87ecc95d81d9 ("tcp: add send queue size stat in SCM_TIMESTAMPING_OPT_STATS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        | 4 +++-
 net/ipv4/tcp_input.c  | 4 ++--
 net/ipv4/tcp_output.c | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 515313ef0c642..0d6e991155c95 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4408,7 +4408,9 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_DELIVERED, READ_ONCE(tp->delivered));
 	nla_put_u32(stats, TCP_NLA_DELIVERED_CE, READ_ONCE(tp->delivered_ce));
 
-	nla_put_u32(stats, TCP_NLA_SNDQ_SIZE, tp->write_seq - tp->snd_una);
+	nla_put_u32(stats, TCP_NLA_SNDQ_SIZE,
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_una)));
 	nla_put_u8(stats, TCP_NLA_CA_STATE, inet_csk(sk)->icsk_ca_state);
 
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, tp->bytes_sent,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b5a3c7ca2605d..3e29134a54b19 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3694,7 +3694,7 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_acked += delta;
 	tcp_snd_sne_update(tp, ack);
-	tp->snd_una = ack;
+	WRITE_ONCE(tp->snd_una, ack);
 }
 
 static void tcp_rcv_sne_update(struct tcp_sock *tp, u32 seq)
@@ -7035,7 +7035,7 @@ tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_socket)
 			sk_wake_async(sk, SOCK_WAKE_IO, POLL_OUT);
 
-		tp->snd_una = TCP_SKB_CB(skb)->ack_seq;
+		WRITE_ONCE(tp->snd_una, TCP_SKB_CB(skb)->ack_seq);
 		tp->snd_wnd = ntohs(th->window) << tp->rx_opt.snd_wscale;
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 3c25292ae72d8..e6aa54d2335c0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4089,7 +4089,7 @@ static void tcp_connect_init(struct sock *sk)
 	tp->snd_wnd = 0;
 	tcp_init_wl(tp, 0);
 	tcp_write_queue_purge(sk);
-	tp->snd_una = tp->write_seq;
+	WRITE_ONCE(tp->snd_una, tp->write_seq);
 	tp->snd_sml = tp->write_seq;
 	tp->snd_up = tp->write_seq;
 	WRITE_ONCE(tp->snd_nxt, tp->write_seq);
-- 
2.53.0



