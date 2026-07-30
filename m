Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49078445AF6;
	Thu, 30 Jul 2026 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425527; cv=none; b=KXdLFxKYIBbRe8EdAtHzZpyZtiLrNH7OE9HL4P1Slor3tBR/qVDiTOJKfPqJW0JvBaHAlXv1DMRQGH5ZA4QH2AhucI6hVhH5aE3riGhziSMvgN/HBK4rEz8ws01H1y9R0vOsbcUTrJGAhCWVNHA+uuu/Vo9hV2pxgjIjrlSWU4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425527; c=relaxed/simple;
	bh=1Hjo2fYZ9l0gnjs9blYXBhrD5CIOHSdcfB/BbyN7h0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+FUoS3sz1XwLYJGkYJj5zMDUHf3zCNO0D/V9Zuu0hUdOFE9++ED2RirtMEKoYmzZONrnqbJkqHnO9MTfdQRZmflgYcvniQtwwZOoE1DS3Lazrd15gS4l0Nva4tPbT+mQfbXXXzK6oUasRWVai8hgg61Uf37PW9jJuv2NeOXtv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlgLOrwX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlgLOrwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A341F000E9;
	Thu, 30 Jul 2026 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425526;
	bh=yZ2we5ZSFDDGnXieWuldSyTp37Hi5tens2fjRK1vix8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlgLOrwXo3zPDvBJVsM3T3cxdRfB4p4ywDPvw8tGcFtxiEsWdFIp8CirSUSmGuNMg
	 fiDMSRoXLkIfkm3c7gO9J9UrXz9nlQqB+aRIFBSHctpzIPxalFya4uQ5nWyGzDJqSr
	 mgD1XB4d7/scXblyw5TQyBJJqaN5QF7vBlsEX2Ns=
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
Subject: [PATCH 6.12 101/602] bpf, sockmap: Reject unhashed UDP sockets on sockmap update
Date: Thu, 30 Jul 2026 16:08:13 +0200
Message-ID: <20260730141438.116414047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 82a14f131d00c6..6440ce16fc6214 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -542,6 +542,8 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+	if (sk_is_udp(sk))
+		return sk_hashed(sk);
 	if (sk_is_stream_unix(sk))
 		return (1 << sk->sk_state) & TCPF_ESTABLISHED;
 	if (sk_is_vsock(sk) &&
-- 
2.53.0



