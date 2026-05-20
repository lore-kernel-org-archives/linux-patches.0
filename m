Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33423D88FC;
	Wed, 20 May 2026 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296509; cv=none; b=dx5ICWZnItdESqyU02QJ+BjLCdej7jlojUWS+5HbtzzWyFxRnHTKyfefIViO6iv4ATSDJ6wiI2sM1FMq7E3bt6jjDQ32NPTcKbdnY7io+LDshFAuoEvysxm2UhEr2+om3p2ZsvP5fC+MafYqamLyS3wIgie1WIaInDzSBHs4NBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296509; c=relaxed/simple;
	bh=IPt7oxmc3YcGHmDmRUsVR+QnwtEcjrK3R0MqeeDFVAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbEyv/nbJkGaLMup3qerMSiTQnQBdVjDNivJSD2E4OomO2mTTauyTbwYcgHh798k8Nt1flggSyZ5D5xkHaywdAD51nco6DjYrIdVKwT0p1UX6Ma83Ooa50QpU13pw5agR0toJ0YPK2rw6fa74I51xzRFt2xFtwwZ1X3UDU/s/+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ad1QuW2L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ad1QuW2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342CF1F000E9;
	Wed, 20 May 2026 17:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296508;
	bh=MroQVWw6Zjrw+SJACCh9gb4jn1ShDVY72NizEmLZ8pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ad1QuW2Lmx4J//48vOVsr7SQKxnBrIGkDIl/foVgEw/HzcPbvD5BM7NY8+t4NPxKq
	 kYO1ugk/0WwNI+D09/xL7JDN0/qD4lUIBZRAVUjQsh7GNBRnhAYtqmnIVms5RrGdSD
	 iviSGh8SCP7VyqGpZLQnYkUIFNMWuPhcjyHFkgeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0785/1146] tcp: add data-race annotations for TCP_NLA_SNDQ_SIZE
Date: Wed, 20 May 2026 18:17:15 +0200
Message-ID: <20260520162205.985446515@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index ee50b2d3ed976..75164510b4232 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4490,7 +4490,9 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_DELIVERED, READ_ONCE(tp->delivered));
 	nla_put_u32(stats, TCP_NLA_DELIVERED_CE, READ_ONCE(tp->delivered_ce));
 
-	nla_put_u32(stats, TCP_NLA_SNDQ_SIZE, tp->write_seq - tp->snd_una);
+	nla_put_u32(stats, TCP_NLA_SNDQ_SIZE,
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_una)));
 	nla_put_u8(stats, TCP_NLA_CA_STATE, inet_csk(sk)->icsk_ca_state);
 
 	nla_put_u64_64bit(stats, TCP_NLA_BYTES_SENT, tp->bytes_sent,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f1bb0ad2eead1..b9bd42f9d08b5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3914,7 +3914,7 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_acked += delta;
 	tcp_snd_sne_update(tp, ack);
-	tp->snd_una = ack;
+	WRITE_ONCE(tp->snd_una, ack);
 }
 
 static void tcp_rcv_sne_update(struct tcp_sock *tp, u32 seq)
@@ -7297,7 +7297,7 @@ tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_socket)
 			sk_wake_async(sk, SOCK_WAKE_IO, POLL_OUT);
 
-		tp->snd_una = TCP_SKB_CB(skb)->ack_seq;
+		WRITE_ONCE(tp->snd_una, TCP_SKB_CB(skb)->ack_seq);
 		tp->snd_wnd = ntohs(th->window) << tp->rx_opt.snd_wscale;
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6603331ec589e..1bb46aafe4049 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4136,7 +4136,7 @@ static void tcp_connect_init(struct sock *sk)
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



