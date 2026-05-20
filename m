Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5541A36405A;
	Wed, 20 May 2026 17:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299018; cv=none; b=N8eoBYUaMyvD8cFGKUg0S8K70E5hv1FVryzIAqH8hJ34+txySZ7n13KtR7zP52V/sA27K8xxdjEwAFzafU3KoJFeMREmfa2i0iK2FVNPITnN9EsQml9dGDv6Z7Y/2334wyW59BCeaLOq9i2jGqj0vSYfbc9cyCUbYU2/0TZqSz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299018; c=relaxed/simple;
	bh=c5QXf9bjb++iSuqSdXQg7E7nFY+Ks0gWAUpEMRviGyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JG49y74C+Y7YIYUMG7sllCgofwqmT9jxXAH/OvdOiOHsipyO5tLGWQIQLogHDIQobQrFAH1oY/SHrWj/N4mO+cbaov4p9LokmuOMGJ8XCMkjwFokRuEoIvY1sRaQroZgZ3rFlc3MVqOVyLA1doEFR6NO+4/xcBLMtjUPuARdxRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHl+jbZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHl+jbZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CDC1F000E9;
	Wed, 20 May 2026 17:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299017;
	bh=0hREojop8e6KO+4QsmoW8ChvHdMciiC4rEf5QfS2V7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHl+jbZQn2kXAKHbqv7tR5G2ngKH19do8agAdK12rE7hGjaKNhfHaCmEcU1ZFnmTm
	 stxrvI9XEkF6sZDzO5WDCwO4MAVixpATl2Jv2aeW8Gvxz8WfT0IOzGRNeec7aPPGTF
	 zrK387geY7bn4gVfL1w4qpIup4hHlkxH3+4NVmGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 632/957] tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans
Date: Wed, 20 May 2026 18:18:35 +0200
Message-ID: <20260520162148.235850555@linuxfoundation.org>
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

[ Upstream commit 21e92a38cfd891538598ba8f805e0165a820d532 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 7e98102f4897 ("tcp: record pkts sent and retransmistted")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        | 4 ++--
 net/ipv4/tcp_output.c | 8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a33641b9ed7e4..4695b03f866f8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4386,9 +4386,9 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u64_64bit(stats, TCP_NLA_SNDBUF_LIMITED,
 			  info.tcpi_sndbuf_limited, TCP_NLA_PAD);
 	nla_put_u64_64bit(stats, TCP_NLA_DATA_SEGS_OUT,
-			  tp->data_segs_out, TCP_NLA_PAD);
+			  READ_ONCE(tp->data_segs_out), TCP_NLA_PAD);
 	nla_put_u64_64bit(stats, TCP_NLA_TOTAL_RETRANS,
-			  tp->total_retrans, TCP_NLA_PAD);
+			  READ_ONCE(tp->total_retrans), TCP_NLA_PAD);
 
 	rate = READ_ONCE(sk->sk_pacing_rate);
 	rate64 = (rate != ~0UL) ? rate : ~0ULL;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b00bd5044b322..c4cf76f71520f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1603,7 +1603,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
 	if (skb->len != tcp_header_size) {
 		tcp_event_data_sent(tp, sk);
-		tp->data_segs_out += tcp_skb_pcount(skb);
+		WRITE_ONCE(tp->data_segs_out,
+			   tp->data_segs_out + tcp_skb_pcount(skb));
 		tp->bytes_sent += skb->len - tcp_header_size;
 	}
 
@@ -3556,7 +3557,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	TCP_ADD_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS, segs);
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
-	tp->total_retrans += segs;
+	WRITE_ONCE(tp->total_retrans, tp->total_retrans + segs);
 	tp->bytes_retrans += skb->len;
 
 	/* make sure skb->data is aligned on arches that require it
@@ -4581,7 +4582,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 			 * However in this case, we are dealing with a passive fastopen
 			 * socket thus we can change total_retrans value.
 			 */
-			tcp_sk_rw(sk)->total_retrans++;
+			WRITE_ONCE(tcp_sk_rw(sk)->total_retrans,
+				   tcp_sk_rw(sk)->total_retrans + 1);
 		}
 		trace_tcp_retransmit_synack(sk, req);
 		WRITE_ONCE(req->num_retrans, req->num_retrans + 1);
-- 
2.53.0



