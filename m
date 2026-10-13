Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5091336B937;
	Tue, 13 Oct 2026 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894927; cv=none; b=itNfHR52M5cuIlEZJ3CrouTRCunJJueP3y5duK4wOAyG3fekkdBDpyMy/hU0fJEsfN53Mp5Ro6unsb5duL8vcwtw96fUMyH5jhVi3Lv2ezfhEM5xMxSbmkgLT1JXieakJ91SOOKtR1jrmPPBuw8Nt0R71TFsnN+JWRSw5opXF3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894927; c=relaxed/simple;
	bh=OiEKkNSjifSM0/pTbX/B9mYHDoZAjX0k2IBFNsWPB10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/idtuwTiLqQTdBseynlYDy9L4HcPVwwW3LA720Z4VM55AWx6iR8+Mszpe2SeWdqT56O2wEfnYOi+MaUh3pGOS+iBsrhHB5qlbzCOzvr//AbHIYB7OHQz+rKsCGG9h9NQF3p4OmsXnfdza9V8g5T4yXC4g+cHO/1zOYJLnYqG4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqcK0J1W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqcK0J1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEA11F000FF;
	Tue, 13 Oct 2026 12:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894926;
	bh=8rRiPbAuK/jIz9J0/Tg34we84WXYkGpPJupGybvcyfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqcK0J1WjcCXT4MIRDY9cDFiqJdiEfxuDpdPi13n91WgT4rZWHiR3FrnVMh/FX2df
	 jMR99wEri7tWFc751qkPbYIzkD8MIn1/Ny0OwLD/lFhNS2e7PtoLgv/WBNJEXdosYK
	 VJZVDnq4Dj0MhkHnL4G1YMU8wALD18v6nWE6mqrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/497] net-memcg: Introduce mem_cgroup_sk_enabled().
Date: Tue, 13 Oct 2026 13:34:13 +0200
Message-ID: <20261013112909.929648332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 43049b0db03823c2cd003ca7d3dddcd3924da8dc ]

The socket memcg feature is enabled by a static key and
only works for non-root cgroup.

We check both conditions in many places.

Let's factorise it as a helper function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20250815201712.1745332-8-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 37e02c42a00b ("net: restrict SO_RESERVE_MEM to TCP sockets and cap max value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/proto_memory.h |  2 +-
 include/net/sock.h         | 10 ++++++++++
 include/net/tcp.h          |  2 +-
 net/core/sock.c            |  6 +++---
 net/ipv4/tcp_output.c      |  2 +-
 5 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/proto_memory.h b/include/net/proto_memory.h
index a6ab2f4f5e28a..859e63de81c49 100644
--- a/include/net/proto_memory.h
+++ b/include/net/proto_memory.h
@@ -31,7 +31,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
+	if (mem_cgroup_sk_enabled(sk) &&
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 6738c6cd3ff5a..efa549885b7f8 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2587,11 +2587,21 @@ static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
 	return sk->sk_memcg;
 }
+
+static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
+{
+	return mem_cgroup_sockets_enabled && mem_cgroup_from_sk(sk);
+}
 #else
 static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
 	return NULL;
 }
+
+static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
+{
+	return false;
+}
 #endif
 
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 85f8102aa9da3..ad9af706085ab 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -275,7 +275,7 @@ extern unsigned long tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
+	if (mem_cgroup_sk_enabled(sk) &&
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index e226ebae9a599..5790d18ef2348 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1016,7 +1016,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	bool charged;
 	int pages;
 
-	if (!mem_cgroup_sockets_enabled || !sk->sk_memcg || !sk_has_account(sk))
+	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
 		return -EOPNOTSUPP;
 
 	if (!bytes)
@@ -3216,7 +3216,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+	if (mem_cgroup_sk_enabled(sk)) {
 		memcg = sk->sk_memcg;
 		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
 		if (!charged)
@@ -3343,7 +3343,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 {
 	sk_memory_allocated_sub(sk, amount);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
+	if (mem_cgroup_sk_enabled(sk))
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
 
 	if (sk_under_global_memory_pressure(sk) &&
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index aa00a9fb2506c..feb94fd45c594 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3583,7 +3583,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk_forward_alloc_add(sk, amt << PAGE_SHIFT);
 	sk_memory_allocated_add(sk, amt);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
+	if (mem_cgroup_sk_enabled(sk))
 		mem_cgroup_charge_skmem(sk->sk_memcg, amt,
 					gfp_memcg_charge() | __GFP_NOFAIL);
 }
-- 
2.53.0



