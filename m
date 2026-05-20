Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981203D8129;
	Wed, 20 May 2026 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296488; cv=none; b=llU2i/YOB8l33X0dE19kVLZPNXHKF2yMKfiARCO377pOZY7op2i0xACX0ah1t2mt6uIEu1d7wM73j3IaZaa7IV/p4/cCccrHRVondAHLgCLlfuBoyw7dbSWDHAoiCyfFMJ+BJ3igDHkK//X2K4FyALNIRsE+HwcqdH7sW+ll8hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296488; c=relaxed/simple;
	bh=10WUarqBQaELT1Dkkl5XDL9j9D1fhcr6ufsA68ZKy+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHye4OTKb7MdhGFAnfoT99byXCNNlsKK3CSwOISS7dON705UxCwAY+OVnraFUwjocb6tjRNzJrJc3DI+jV2W7+AHSx+SEERxUdgtvJbya5QWOzOoH4QWqt1uedbjRkRli6gpPRaMANF/ENxcjUYBNddXWnAAOekPTHG3p6LIuG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPCrUiu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPCrUiu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A96B1F000E9;
	Wed, 20 May 2026 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296487;
	bh=m6Ni/CdFDw/gzcFtH+ExzYjwIVMAf3Zr1KDO+WDf9U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPCrUiu5Ar5x0xuT1KX0Y8/dPgazU+bPgZov0GMwhaFK33n2yc36oiZHV+qwbrYYH
	 Q4SkP3imY2fjBL8TlDnfuxoUHrwxYvDD83WuX93ur/k98NfMQzhZOiPUZBBc3KA/e5
	 9k28IetCgh2vB7jE/KkcVnjl/+An/rV/LWKeRmyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0781/1146] tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans
Date: Wed, 20 May 2026 18:17:11 +0200
Message-ID: <20260520162205.890393582@linuxfoundation.org>
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
index a8ff76c40f79b..d1953c6376f8b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4468,9 +4468,9 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
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
index 7b8a2c8213e18..87fa26603276c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1668,7 +1668,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
 	if (skb->len != tcp_header_size) {
 		tcp_event_data_sent(tp, sk);
-		tp->data_segs_out += tcp_skb_pcount(skb);
+		WRITE_ONCE(tp->data_segs_out,
+			   tp->data_segs_out + tcp_skb_pcount(skb));
 		tp->bytes_sent += skb->len - tcp_header_size;
 	}
 
@@ -3624,7 +3625,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	TCP_ADD_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS, segs);
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
-	tp->total_retrans += segs;
+	WRITE_ONCE(tp->total_retrans, tp->total_retrans + segs);
 	tp->bytes_retrans += skb->len;
 
 	/* make sure skb->data is aligned on arches that require it
@@ -4628,7 +4629,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
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



