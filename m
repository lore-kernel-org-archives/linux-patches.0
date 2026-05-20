Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A88A348C55;
	Wed, 20 May 2026 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301158; cv=none; b=WENNXE69Q3FmATbBFcpCT/ELL5v+gXrR7gLj/5wYm6y5yEtysofSDm2OCNHEI2M5SUjAlTSw+djbYUNGqrfjyXbYrFnwm88aVG0NfEcIBHoKBl2x4I2twm/08P1puAgylF1hMpxpXRbm9S9xBibdyvi0VEwtq96Z5PxFYGNaUsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301158; c=relaxed/simple;
	bh=pIMZ4j4pdc1zYrsXvn2vHs0Ob+ZYCgfrToiLBHGI9vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/zWzX2IPt+PJC0oEvoYRA1eGTAsxUXdqTiV/qiNWo5S7FlNJGvB6lyUeJiVcfCunpG2dBURVKY5r6vqKWvPKXsK9mkRsSCOSpHx4iwL30ShL3uNvNDPoC15TdGukBBrWnO2TbpEl7pdg2Fb+Tp9wpzWzvvoqgeO72Bgq3+VtSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRCtjCXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRCtjCXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED901F000E9;
	Wed, 20 May 2026 18:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301157;
	bh=oqZhHYzSgNM40pbhlbznbKY7V0EoK7htHV4Gis9EdE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRCtjCXc8MMIhvAWfQitbQEV2bsooo/8QFvs4sfNXxhAlA6oPVighqS1M7wePGm2l
	 R9unduxsqWb6mG65AD0/wOvFKralOqx5e5VIuUD2etH/gle7tyF9CUmjQGEC1z5ocL
	 0NX/8cj/VU5e38YBhJQiarw7sDdSG+phE88yBw8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/666] tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans
Date: Wed, 20 May 2026 18:21:00 +0200
Message-ID: <20260520162121.003240495@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9c5fc44647831..382c2895ec311 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4276,9 +4276,9 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
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
index 5e37dc45639db..dbe39ad886821 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1446,7 +1446,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
 	if (skb->len != tcp_header_size) {
 		tcp_event_data_sent(tp, sk);
-		tp->data_segs_out += tcp_skb_pcount(skb);
+		WRITE_ONCE(tp->data_segs_out,
+			   tp->data_segs_out + tcp_skb_pcount(skb));
 		tp->bytes_sent += skb->len - tcp_header_size;
 	}
 
@@ -3411,7 +3412,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	TCP_ADD_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS, segs);
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
-	tp->total_retrans += segs;
+	WRITE_ONCE(tp->total_retrans, tp->total_retrans + segs);
 	tp->bytes_retrans += skb->len;
 
 	/* make sure skb->data is aligned on arches that require it
@@ -4433,7 +4434,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 			 * However in this case, we are dealing with a passive fastopen
 			 * socket thus we can change total_retrans value.
 			 */
-			tcp_sk_rw(sk)->total_retrans++;
+			WRITE_ONCE(tcp_sk_rw(sk)->total_retrans,
+				   tcp_sk_rw(sk)->total_retrans + 1);
 		}
 		trace_tcp_retransmit_synack(sk, req);
 	}
-- 
2.53.0



