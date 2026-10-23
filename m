Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774844;
	b=xndc7rW6huZdNR1m0PNsXvy9XHoezq3dMvlzlYjl7GgzdZ2s8WqVhmG+QeciNnbYyyNE
	 n1NI1RaOzCQtMITaL+99TPoodB9tabtcUTeDkjdhtTnTmuTzSXH2CDl2AFxDa769U72nO
	 MGIztP4SHb48CxBSoK/8IhETPlIjN4v7VQqkgT2q83U4HLnV4PmMz7Vvl5hQiXmxQdaaI
	 rn5GTT0XkHr3/j8/ybrTwkFIVX15DCJKm3nbfw8P0ciL4k5fukjAW2XaEdKAzvCh1bY8T
	 Sh8SvtkJM1Ls6iRa7r79BlNkUhhcOQHWH0kHoqYE1nK7TAza54Ty8sZ4PfzXacGF/Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UHKqIwFRL5OtQgims6F/evyJ54NKE10QBsiY6XHuVbI=;
	b=iZqQ77zt+wzNyWUsfMc4hJMaGtSUeaMsJgew7Y4190KBvZbm+Xirqu8Lv693xLZIX6U5
	 S6p0VjVIDzl3vOVEQ/FuLH8RE+9WCqDvnjRPOwxtzW8/pX6CQKQP9lkKe7GO3p9itX/fW
	 ACpc0ZIKNNPmaLnOrcn6TrI4dhq2bAZ71GThAga8sNVj7XaOTAId27Que6pl5bFJQAHmK
	 23MIP7cWIawtpYSbaGoAyqaLAhQPwKSll3WRqKVZYGESzcrZchbURtU04KX1R3LABYUXf
	 hVZS7VddRKIbItajyJwMwwTJMk2GrQcYpMyVvGcG/Ra08mvHrtHrcOc3uWNqCT5yGkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqTW6WPl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA86C606A31A;
	Fri, 23 Oct 2026 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqTW6WPl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD2C1F01825;
	Fri, 23 Oct 2026 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774843;
	bh=UHKqIwFRL5OtQgims6F/evyJ54NKE10QBsiY6XHuVbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqTW6WPlvUcV8zcIBfeU0MXQqd3J8scRJfiu+jRAwUmUwLGYPhoEpv028yMFMJOL1
	 xJ4Iclijx+awuuMaGcd0rntqEGsWcco40Te/Cau+hXDkcAKwe/rRUj//0qtQt7holl
	 mgpuDKDBUUnyChOCnFrOEIlFwAWMvQo6XHoAUYUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 178/242] tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_INFO)
Date: Fri, 23 Oct 2026 18:40:20 +0200
Message-ID: <20261023163717.994339699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

commit 385e474086c2e7e29e2dded690be40dc273e20ee upstream.

do_tcp_getsockopt() reads icsk->icsk_ca_ops and dereferences the
get_info function pointer without rcu_read_lock(). With BPF struct_ops
congestion control, ca_ops can point to dynamically allocated memory
that is freed concurrently, resulting in a use-after-free when the
kernel dereferences or calls through the stale pointer.

  BUG: KASAN: slab-use-after-free in do_tcp_getsockopt+0x2037/0x23e0
  Read of size 8 at addr ffff888013701258 by task exploit/149
   do_tcp_getsockopt+0x2037/0x23e0 (net/ipv4/tcp.c:4564)
   tcp_getsockopt+0x91/0xf0
   __sys_getsockopt+0xf7/0x170

Fix this by wrapping the ca_ops load and get_info call within
rcu_read_lock()/rcu_read_unlock(), and using READ_ONCE() to load
the icsk_ca_ops pointer.

Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: AutonomousCodeSecurity@microsoft.com
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/65fd3816ed5d541d9edd4bf4fcf97104a2cf907a.1787870710.git.blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c       |    4 +++-
 net/ipv4/tcp_dctcp.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4562,9 +4562,11 @@ int do_tcp_getsockopt(struct sock *sk, i
 		if (copy_from_sockptr(&len, optlen, sizeof(int)))
 			return -EFAULT;
 
-		ca_ops = icsk->icsk_ca_ops;
+		rcu_read_lock();
+		ca_ops = READ_ONCE(icsk->icsk_ca_ops);
 		if (ca_ops && ca_ops->get_info)
 			sz = ca_ops->get_info(sk, ~0U, &attr, &info);
+		rcu_read_unlock();
 
 		len = min_t(unsigned int, len, sz);
 		if (copy_to_sockptr(optlen, &len, sizeof(int)))
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -228,7 +228,7 @@ static size_t dctcp_get_info(struct sock
 	if (ext & (1 << (INET_DIAG_DCTCPINFO - 1)) ||
 	    ext & (1 << (INET_DIAG_VEGASINFO - 1))) {
 		memset(&info->dctcp, 0, sizeof(info->dctcp));
-		if (inet_csk(sk)->icsk_ca_ops != &dctcp_reno) {
+		if (READ_ONCE(inet_csk(sk)->icsk_ca_ops) != &dctcp_reno) {
 			info->dctcp.dctcp_enabled = 1;
 			info->dctcp.dctcp_ce_state = (u16) ca->ce_state;
 			info->dctcp.dctcp_alpha = ca->dctcp_alpha;


