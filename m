Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194C04FECCC;
	Wed, 30 Sep 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783557; cv=none; b=qsqKWnQPlpJ899IXu3PWlzNR860iWvIZS0tDPFOZe53eqOhyfwWPR3elzT5i+e/zQ2TTX4fMdNGIUVkq8Eu7SW6gBGiWC5SD/XsOaS06tfFKfAmcfky3dt0mDFzX/IJlu9VOV0TOjGiwQPDSyQdbJa37PGiMWGDvUD1LteEsiuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783557; c=relaxed/simple;
	bh=6qa3PJBbELZOKI/10P1XhnJcg51OrVu291pXUt7c6JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIJp29pb9H3DaFBZdYm9N9XUZOmOO+rB1AKgeVhfyWAU7NWHhRZvYb8cVhtBM+hgN4U8iGyP0ybD2+Lv0AcccKLWyoTy/S/69bEpC4b2aOZAd16O5LAdsnk/EgiM0nTMMhavhjvRu9oTy/oNiXLywnF34RCvmvGSInKGt9DgUcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKOFfKkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKOFfKkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204C31F00893;
	Wed, 30 Sep 2026 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783554;
	bh=wU836wOXHvcIQ0n5G4aNHPtOuy9UvGbR5ThYk4h4Xwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKOFfKkABKqg6yf5ou5whPgK2cKrtFBejzBJE4uQvAscXvjDWzv37IExQUa/79P1z
	 +K9xwIQUbwvK4J4W1wNCM9KTkTsYmiuN8SFsSE2mZBsOiQ6nSrIKrqx67KAOoPVTyP
	 dhdQwNiIL8jfSGJ/3mbsgYo0E8Z2fUxN2E/HR35o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/595] tcp: do not let tcp_rmem be set below 4096
Date: Wed, 30 Sep 2026 17:24:56 +0200
Message-ID: <20260930152356.342586556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e912a47765f36..fbe902b72fb9e 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -642,6 +642,8 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 	case this value is ignored.
 	Default: between 131072 and 6MB, depending on RAM size.
 
+	Each of the three values cannot be set below 4096.
+
 tcp_sack - BOOLEAN
 	Enable select acknowledgments (SACKS).
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 8de1a9d5fc154..6861d3ecec649 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -51,6 +51,8 @@ static int comp_sack_nr_max = 255;
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 
+static int tcp_min_rcvbuf = 4096;
+
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
 
@@ -1262,7 +1264,7 @@ static struct ctl_table ipv4_net_table[] = {
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



