Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C056533D4E2;
	Thu, 30 Jul 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421475; cv=none; b=fPy/SQ4SowcLmbXVarguVYIZkvtxJ7giQwVcb/AgDYtLkhMx4Hcra5JYVK+GT2tJNGeKoZyje3En0zby2fR5S/nofBwnATltDwN7ep6rGDP/OaHGSKFH4CaG6T8Rg2gREO7HpaI+6W9IB9rbJSdOfyfkws6A+PTldMnFzclMtwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421475; c=relaxed/simple;
	bh=2Qx607c6a8rV2jvUgBTCVAWAdS5KdzrgMuBU6QhJK38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imYgASRJ5M3na2ra/mQrzrMX9CbNwrN6HhmAQ3c0r5/3GO0xwCnd+gq39DUXd80cLLioWSO3pY+oSSqUzlG1ge9T+vh2TUrEH7Q5n+b/d7ZKMouQnHjGRHvwJFcltoKaep4XQl6eJbL2GaeLOsxZ4S0mkKZHg//tfuUjY7KH724=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZSgmvqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZSgmvqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC51F000E9;
	Thu, 30 Jul 2026 14:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421474;
	bh=UQwo6+vCz36mAggW3C8oOgndecX+8wxn8mbeviqIsk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZSgmvqk41py7Dkl5nVjDmPowpDLvl5ggNgNwQ52lQbiYvjkOWKiYV1SmeGhVtGUY
	 rxGmcE0tp7ZMHI4Yigr68aG6G/q7yUTPsz0e0twWmFt6tw8fPaLgV50PkTmZVbuZ3l
	 35+wDbxZBjF8ksFDkIKHwlu8NWJnLcoFoLk3qfU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 115/744] bpf, sockmap: Reject unhashed UDP sockets on sockmap update
Date: Thu, 30 Jul 2026 16:06:28 +0200
Message-ID: <20260730141446.723657643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 66efd3368ae10d05e08fbe6425b50fdec7186ac7 ]

UDP sockets get SOCK_RCU_FREE set when (auto-)bound. This means
sk_is_refcounted(unbound) = true, while sk_is_refcounted(bound) = false.

Because sockmap accepts unbound UDP sockets, a BPF program can increment a
socket's refcount via lookup. If the socket is subsequently bound, the
transition from unbound to bound causes bpf_sk_release() to skip the
decrement of the refcount, causing a memory leak.

unreferenced object 0xffff88810bc2eb40 (size 1984):
  comm "test_progs", pid 2451, jiffies 4295320596
  hex dump (first 32 bytes):
    7f 00 00 01 7f 00 00 01 d2 04 1b b7 04 d2 00 00  ................
    02 00 01 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace (crc bdee079d):
    kmem_cache_alloc_noprof+0x557/0x660
    sk_prot_alloc+0x69/0x240
    sk_alloc+0x30/0x460
    inet_create+0x2ce/0xf80
    __sock_create+0x25b/0x5c0
    __sys_socket+0x119/0x1d0
    __x64_sys_socket+0x72/0xd0
    do_syscall_64+0xa1/0x5f0
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Instead of special-casing for refcounted sockets, reject unhashed UDP
sockets during sockmap updates, as there is no benefit to supporting those.
This effectively reverts the commit under Fixes, with two exceptions:

1. sock_map_sk_state_allowed() maintains a fall-through `return true`.
2. In the spirit of commit b8b8315e39ff ("bpf, sockmap: Remove unhash
   handler for BPF sockmap usage"), the proto::unhash BPF handler is not
   reintroduced.

Historical note: this issue is related to commit 67312adc96b5 ("bpf: reject
unhashed sockets in bpf_sk_assign").

Fixes: 0c48eefae712 ("sock_map: Lift socket state restriction for datagram sockets")
Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20260707-sockmap-lookup-udp-leak-v4-2-f878346f27ab@rbox.co
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 99e3789492a09e..9ece7bafe27c91 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -542,6 +542,8 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+	if (sk_is_udp(sk))
+		return sk_hashed(sk);
 	if (sk_is_stream_unix(sk))
 		return (1 << READ_ONCE(sk->sk_state)) & TCPF_ESTABLISHED;
 	if (sk_is_vsock(sk) &&
-- 
2.53.0



