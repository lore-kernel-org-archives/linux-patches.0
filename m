Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C58651A15D;
	Wed, 30 Sep 2026 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788437; cv=none; b=J5OK9SSIUPKbU3bFSMq5rZI7fEgnRfAKb/fcgl9LLZQr6VjsUOBD2c6+NGB2/9Sqn3zuBC4mc8fGBIJxusG3KmM9Ju5oNQR2ELUeANyIo4HIJQXnPa7xK1abt/z3l2vK6AWjbd0Cmpyig69v4aQFKzZKt/hlT9yljwNF15wm+V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788437; c=relaxed/simple;
	bh=Jcck3lFWCx6gzti30v1vh9XqE3/ZrM4d1Vz75TwW8Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpsbexfBvBE3JVDdE23LDTe973GRg+xjJlJwkeZsl02JeAGRDaWLUXp9xn4HrngDcKNoja1Z2YmpL/PXea8BetCzhIMnBYgoOBxMTCxG+GsA9iyxvzWiZUHwEoLpK503dt5pIl7YbfcHBoVNSBU2fCw2kzi3Hay4LPzZMtTBnlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIDNFJ1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIDNFJ1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E461F000FF;
	Wed, 30 Sep 2026 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788436;
	bh=O+c5Sm+PxYSg0zvAIUID4GzFD6vpK4bw+Z7S0GckWao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIDNFJ1GZaVfCvCY2eEOKpI76idMyjeHr3o8uLjQzTRaXCVlkVnwNnIgzRkWBC9a+
	 p5sGp5vCgUvwAwy5+8le6jIzIXGdS7QSfGd+dSSRjG2B6kjar7uAAiGdrtAJt9NnN0
	 NX4ak8kcl7w3ZTTe6g3Z7/etX8Zj6G5uHceZ7EJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/877] tcp: do not let tcp_rmem be set below 4096
Date: Wed, 30 Sep 2026 17:17:16 +0200
Message-ID: <20260930152417.436133492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index dcbb6f6caf6de..eb2c136be63da 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -735,6 +735,8 @@ tcp_rmem - vector of 3 INTEGERs: min, default, max
 	case this value is ignored.
 	Default: between 131072 and 6MB, depending on RAM size.
 
+	Each of the three values cannot be set below 4096.
+
 tcp_sack - BOOLEAN
 	Enable select acknowledgments (SACKS).
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 63625a5038af4..00d3be968a53d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -46,6 +46,8 @@ static unsigned int udp_child_hash_entries_max = UDP_HTABLE_SIZE_MAX;
 static int tcp_plb_max_rounds = 31;
 static int tcp_plb_max_cong_thresh = 256;
 
+static int tcp_min_rcvbuf = 4096;
+
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
 
@@ -1405,7 +1407,7 @@ static struct ctl_table ipv4_net_table[] = {
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



