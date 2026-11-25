Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624619;
	b=jxYyENSy6QjOXGPxjYvKTs6GsfhkafF2J8mzh5eEsd5GVOtbw1OKEl91kR2Bp+vuqfgg
	 jKVPAFhQbfpGa3T9Y5685GQglsVho88/5yLT96iPBFJkcToTdzGqgtWnHoixhk6M1nLwk
	 +zsqGtE0YHQ+U9q88hUJW1TD8OH5nRGU+G1lZy/dDjVXeyEDR7DCrFqZQtmecZLvwJhVH
	 IeItDxomEB47+a8NMIFGK41OfG73cIWNGGrxniADf5OVnni10nCKoKTasjm7wZT/FotRW
	 q3qJ9eZSEiuQJCmKXPgxx7/Ok127qaoLKAIBqttcFP9edplalMnV1v4VUVzSzaH2nNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5q/LbUnirju8zOh8QRKEDuIQAHxKEKpTqW0bbimAc4=;
	b=y62kJwgk6bC4DgDFnKac06kCg3+eotgACiDF4F+dPDJbpoT7UxKVz3kfROyMdlZ7OnO8
	 jbXa3/ITTxtqddeYObIrcy/QrbAYvMGC9FKz6ZY3lVmheU6VfszBbm1+Sj0ilOvDM82+o
	 Ep7Pk0MiyR3N2SJjWikzLbmq/zv46VtndNqeyjnx6CB1gWZGQKcP9BlfAClLU/oCNcyE6
	 f96K/HsMaqlfVNPOkf8623TDc1+n8YJaXj7NdDMmYgpNch8j0g1PTUR7WuwroNvzSOA/N
	 zZO6yLQMG0T9t79/8+zCsOeVIo8kKXt6BfPgwtMLmM6t/KJuTyerefsIzuYalnJL2dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RjJYZcp8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE51606A338;
	Wed, 25 Nov 2026 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RjJYZcp8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBA01F000C4;
	Wed, 25 Nov 2026 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624619;
	bh=c5q/LbUnirju8zOh8QRKEDuIQAHxKEKpTqW0bbimAc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjJYZcp8LPA34r0mh1F4iDQMY7LGOgbrYmNbvZnMLYhIvQUIDxDzjR+vUcck/Lczt
	 Dz6X+AOtBOWsnvpIRL4kADoVdUNj6Yfkc0LNsaQJvJ4dK63+YTVA/naEoletMwHT83
	 0xWlKxQO0N46d84t1ahzyspXFsZVSBNWxnGCLVTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/816] tcp: bound snd_cwnd_clamp to TCP_MAX_SND_CWND
Date: Wed, 25 Nov 2026 15:30:00 +0100
Message-ID: <20261125143855.042626677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 475ff14ba558bb8857bca878f1d593784ccc4f0f ]

snd_cwnd has no practical upper bound: snd_cwnd_clamp defaults to ~0,
and RTAX_INITCWND, a locked RTAX_CWND metric, TCP_BPF_IW and
TCP_BPF_SNDCWND_CLAMP accept any positive value.

Congestion control modules do u32 arithmetic on cwnd that assumes
much smaller values. For instance, ssthresh() handlers compute:

  CUBIC, BIC, ROCCET:  cwnd * (BICTCP_BETA_SCALE + beta), up to 2047
  DCTCP:               cwnd * dctcp_alpha, up to 1024
  CDG, NV, CUBIC, ...: cwnd * beta, below 1024

With a large initcwnd route or TCP_BPF_IW, cwnd is set directly to
such values, and the next RTO or recovery calls ->ssthresh() with it.
The product then wraps: DCTCP with cwnd = 2^24 and alpha = 1024 gets
ssthresh == cwnd, and CUBIC computes a wrong ssthresh and Wmax.
CUBIC bictcp_update() also expects cwnd below about one million packets.

The paths that can grow cwnd by large amounts (tcp_slow_start(),
tcp_cong_avoid_ai(), bbr_set_cwnd() and tcp_init_cwnd()) already
bound it by snd_cwnd_clamp, so give snd_cwnd_clamp a finite default
of 2^20 packets, and cap the metric and BPF paths that set it or set
cwnd directly.

2^20 packets do not limit real flows: with the maximum window scale
of 14, a peer can not advertise more than 65535 << 14 bytes (~1GB),
which is less than 2^20 packets for any MSS of 1024 bytes or more.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261030111528.2850082-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h      | 9 +++++++++
 net/core/filter.c      | 3 ++-
 net/ipv4/tcp.c         | 2 +-
 net/ipv4/tcp_metrics.c | 3 ++-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 77f6c40ead438..23f619a1b41a6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1312,6 +1312,15 @@ static inline unsigned int tcp_packets_in_flight(const struct tcp_sock *tp)
 
 #define TCP_INFINITE_SSTHRESH	0x7fffffff
 
+/* Default and maximum snd_cwnd_clamp, in packets.
+ * A peer can not advertise more than 65535 << 14 bytes, so a larger
+ * cwnd is useless with any MSS of 1024 bytes or more.
+ * Congestion control modules multiply cwnd by u32 factors up to 2047
+ * (cwnd * (BICTCP_BETA_SCALE + beta) in CUBIC), and CUBIC's
+ * bictcp_update() expects cwnd to stay below about one million packets.
+ */
+#define TCP_MAX_SND_CWND	(1U << 20)
+
 static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
 {
 	return tp->snd_cwnd;
diff --git a/net/core/filter.c b/net/core/filter.c
index 044595be4217a..9c53e79d87501 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5415,11 +5415,12 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
 	case TCP_BPF_IW:
 		if (val <= 0 || tp->data_segs_out > tp->syn_data)
 			return -EINVAL;
-		tcp_snd_cwnd_set(tp, val);
+		tcp_snd_cwnd_set(tp, min_t(u32, val, tp->snd_cwnd_clamp));
 		break;
 	case TCP_BPF_SNDCWND_CLAMP:
 		if (val <= 0)
 			return -EINVAL;
+		val = min_t(u32, val, TCP_MAX_SND_CWND);
 		tp->snd_cwnd_clamp = val;
 		tp->snd_ssthresh = val;
 		break;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba4e7ffa18761..242efac9123bc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -451,7 +451,7 @@ void tcp_init_sock(struct sock *sk)
 	 * initialization of these values.
 	 */
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
-	tp->snd_cwnd_clamp = ~0;
+	tp->snd_cwnd_clamp = TCP_MAX_SND_CWND;
 	tp->mss_cache = TCP_MSS_DEFAULT;
 
 	tp->reordering = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering);
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index ef81765a0831d..ecec29fec56c2 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -495,7 +495,8 @@ void tcp_init_metrics(struct sock *sk)
 	}
 
 	if (tcp_metric_locked(tm, TCP_METRIC_CWND))
-		tp->snd_cwnd_clamp = tcp_metric_get(tm, TCP_METRIC_CWND);
+		tp->snd_cwnd_clamp = min(tcp_metric_get(tm, TCP_METRIC_CWND),
+					 TCP_MAX_SND_CWND);
 
 	val = READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) ?
 	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
-- 
2.53.0



