Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B04450EBF3;
	Wed, 30 Sep 2026 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785908; cv=none; b=edW5l+UYdwt2a0OkOmE85cu+JbpKtQsfrRNsHdXsj11NW1B8vBhtMu1DztUvo3AAePn44jrUgZ3RpdRxBo1FNYsXA5nr1hz+9FXHIghhsjNGriwTHl9Pfia/3sXXAb0NDGtatexQb5XyirrlV9XqIcIALAaWu//RVnzwMFF9N6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785908; c=relaxed/simple;
	bh=zbC2pqlmXMtc9ZFgb9UTUt9sqqohISQYhS9j3qL+H14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+Gzwr0wkj5hLWJ9FmhJywAAfelc81lJUN7q26jgvy5QHpWQ2LhJK/rftCQDdyawSkjc49x+S2q8j7oW5Nqgay1behAFhnvrUsdxb5tnVzayzhHrLB2DKzZm4XMJSWcOEXFkbbAimffmEdrG/tYfCej1mGy02pkJ/MDThkgfrXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yt0SNLxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yt0SNLxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DD21F000FF;
	Wed, 30 Sep 2026 16:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785907;
	bh=cnB0yrx1hgWUvImonMM6ED8bKHUrRm/kNT/z1qQlPKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yt0SNLxZYWHNzwRV+1BsjwfCOWZaZ459e2P34HWITjdilGhEtkNVIWAEvGzd90wx4
	 BpmnXwYGEWHgzML418IIomnahVPbhFSnp7sz2/jjOulbBmj8wyU6V5RoLLwgDEGz/9
	 Yihd7oEbUT6K8abvZF2AiwRI6efz4nT+40pq04wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 673/982] tcp: do not let tcp_rmem be set below 4096
Date: Wed, 30 Sep 2026 17:23:29 +0200
Message-ID: <20260930152431.220443409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 83a945a529d6e002dd7339c532288a931f463dba ]

We can hit a division by zero crash in tcp_rcvbuf_grow()
and tcp_rcv_space_adjust():

divide error: 0000 [#1] PREEMPT SMP
RIP: 0010:tcp_rcvbuf_grow+0x187/0x450 net/ipv4/tcp_input.c:939
...
grow = div_u64(((u64)rcvwin << 1) * (newval - oldval), oldval);

The division uses oldval = tp->rcvq_space.space as divisor.
When tp->rcvq_space.space is zero, this leads to a divide-by-zero
exception.

tp->rcvq_space.space is initialized in tcp_init_buffer_space():
    tp->rcvq_space.space = min3(tp->rcv_ssthresh, tp->rcv_wnd,
                                (u32)TCP_INIT_CWND * tp->advmss);

If tcp_rmem[1] is configured to very small values (such as 1),
sk->sk_rcvbuf is initialized to 1. Then tcp_full_space(sk), which
computes (sk->sk_rcvbuf * scaling_ratio) >> 8, truncates to 0.
This sets tp->window_clamp = 0, tp->rcv_ssthresh = 0, and
tp->rcvq_space.space = 0. Later, when data arrives and DRS is invoked,
tcp_rcvbuf_grow() divides by oldval == 0.

Back in 2015, commit b1cb59cf2efe ("net: sysctl_net_core: check SNDBUF
and RCVBUF for min length") ensured that net.core.rmem_default and
net.core.rmem_max cannot be set below SOCK_MIN_RCVBUF. Similarly,
SO_RCVBUF setsockopt enforces max_t(int, val * 2, SOCK_MIN_RCVBUF).

However, net.ipv4.tcp_rmem still had .extra1 = SYSCTL_ONE, allowing
arbitrarily small values.

Because SOCK_MIN_RCVBUF depends on sizeof(struct sk_buff) and cacheline
alignment, its value varies across architectures and configuration options.
Using a fixed constant of 4096 ensures a predictable, architecture-
independent lower bound that is safely above SOCK_MIN_RCVBUF everywhere
and matches the documented 4K default.

Fix this by setting tcp_rmem.extra1 to 4096 and updating the documentation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260912144848.3448026-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 2 ++
 net/ipv4/sysctl_net_ipv4.c             | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b47b3d0ce5596..0a5ae93b44617 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -717,6 +717,8 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 	case this value is ignored.
 	Default: between 131072 and 6MB, depending on RAM size.
 
+	Each of the three values cannot be set below 4096.
+
 tcp_sack - BOOLEAN
 	Enable select acknowledgments (SACKS).
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5d6ded54e237a..49c94650712ee 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -42,6 +42,8 @@ static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
 	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
 static unsigned int tcp_child_ehash_entries_max = 16 * 1024 * 1024;
 
+static int tcp_min_rcvbuf = 4096;
+
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
 
@@ -1317,7 +1319,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(init_net.ipv4.sysctl_tcp_rmem),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
+		.extra1		= &tcp_min_rcvbuf,
 	},
 	{
 		.procname	= "tcp_comp_sack_delay_ns",
-- 
2.53.0



