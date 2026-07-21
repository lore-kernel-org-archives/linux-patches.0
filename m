Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4503AA4F9;
	Tue, 21 Jul 2026 22:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673223; cv=none; b=E97rHtfTiRAF9Sqj7M8lIXm89k5IihegpxbgnpxpkzmAaY1bN5NmQdgx8vy6GQxq15BOyPxnAnFpIP0x/FeeUy4z4gWX3nNkzMOFmmT0yiu1xYnyiK8kExAps9A3tuiwDyCowASUaST6Yq1NYgjMlnw4rf2+8Wko2MjJRq1t9mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673223; c=relaxed/simple;
	bh=OeNkJITkjBQnkIkLlwBTDLGw2u5ppIWgRQzp+kZaMMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr9OK3Z2gY7FmxWJ/lUbMvVnw1O2SH8XTd2U363umTAtB1zTp8y2O+ZavD4w7wxTfciP0WfiR8C5cytTNsxA32CS4plNxRSlklpG0wfLy+jR9qPcXQUcK7QPlsOyRsJlADG4a32DfIJQBrz0yJm05vA9f2xgwtSlK3TFFjpvQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZYA+Z23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZYA+Z23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660D51F000E9;
	Tue, 21 Jul 2026 22:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673221;
	bh=Bg7ZHIvCpGLQWw+tqUCo1EwfNwt32rJoRo8wr4uvyRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZYA+Z23T6N+PESNc23LIVE2OmdUBketAcZKHPwqnqFZwvTJcF6ygcjPLFCzSGsyt
	 kwH6H5ICDXVYID3Qmp2STKeOvsde93idCZBNAepw4R1k/+MGC7A3paRlNCeN3pb8Co
	 UClSgmDhgQXnp39CFzPCaH+2NrwtG7C/I0KOiVGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 079/699] net: ipv4: bound TCP reordering sysctl writes and MTU probe sizes
Date: Tue, 21 Jul 2026 17:17:18 +0200
Message-ID: <20260721152357.486885713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Wyatt Feng <bronzed_45_vested@icloud.com>

commit efb8763d7bbb40cff4cc55a6b62c3095a038149c upstream.

Reject invalid `net.ipv4.tcp_reordering` values before they reach TCP
socket state. The sysctl is stored as an `int` but copied into the
`u32` `tp->reordering` field for new sockets, so negative writes wrap
to large values.

With `tcp_mtu_probing=2`, the wrapped value can overflow the
`tcp_mtu_probe()` size calculation and drive the MTU probing path into
an out-of-bounds read. Route `tcp_reordering` writes through
`proc_dointvec_minmax()` and require it to be at least 1. Also require
`tcp_max_reordering` to be at least 1 so the configured maximum cannot
become negative either.

When registering the table for a non-init network namespace, relocate
`extra2` pointers that refer into `init_net.ipv4` so the
`tcp_reordering` upper bound follows that namespace's
`tcp_max_reordering`.

Harden `tcp_mtu_probe()` itself by computing `size_needed` as `u64`.
This keeps the send queue and window checks from being bypassed through
signed integer overflow.

Fixes: 91cc17c0e5e5 ("[TCP]: MTUprobe: receiver window & data available checks fixed")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/1a5b7e1ef4d70fbad8c8ee0b82d8405f3c964a3d.1781395200.git.bronzed_45_vested@icloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/sysctl_net_ipv4.c |   10 ++++++++--
 net/ipv4/tcp_output.c      |    4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -892,7 +892,9 @@ static struct ctl_table ipv4_net_table[]
 		.data		= &init_net.ipv4.sysctl_tcp_reordering,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= &init_net.ipv4.sysctl_tcp_max_reordering,
 	},
 	{
 		.procname	= "tcp_retries1",
@@ -1109,7 +1111,8 @@ static struct ctl_table ipv4_net_table[]
 		.data		= &init_net.ipv4.sysctl_tcp_max_reordering,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "tcp_dsack",
@@ -1336,6 +1339,9 @@ static __net_init int ipv4_sysctl_init_n
 				 */
 				table[i].mode &= ~0222;
 			}
+			if (table[i].extra2 >= (void *)&init_net.ipv4 &&
+			    table[i].extra2 < (void *)(&init_net.ipv4 + 1))
+				table[i].extra2 += (void *)net - (void *)&init_net;
 		}
 	}
 
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2343,7 +2343,7 @@ static int tcp_mtu_probe(struct sock *sk
 	struct sk_buff *skb, *nskb, *next;
 	struct net *net = sock_net(sk);
 	int probe_size;
-	int size_needed;
+	u64 size_needed;
 	int copy, len;
 	int mss_now;
 	int interval;
@@ -2367,7 +2367,7 @@ static int tcp_mtu_probe(struct sock *sk
 	mss_now = tcp_current_mss(sk);
 	probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high +
 				    icsk->icsk_mtup.search_low) >> 1);
-	size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
+	size_needed = probe_size + (tp->reordering + 1) * (u64)tp->mss_cache;
 	interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
 	/* When misfortune happens, we are reprobing actively,
 	 * and then reprobe timer has expired. We stick with current


