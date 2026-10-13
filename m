Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE0233D6F8;
	Tue, 13 Oct 2026 12:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894894; cv=none; b=hTX7n9FKFS5ZhdAshsvSpV8HzvD6a6gXeSD3h6wEpsJjNNpFTZK9IU4wX7+H2XCPeOyJNuaaX63ahYJBvFz4IaBOcDAtjVaYDoAfoHCwBwDjCzanzRidp6NczkW9YXqAHDh6sd3RsvH0RVQWhc1PEz/XJ9tcmtqc37bHda8KhpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894894; c=relaxed/simple;
	bh=jEutVfdAGy35HBScfMmw0PzxBxCTGLBCDAjR4ZaRnLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNACLsh7hc1cFK5vpIrdsmU04YQdo2DPwx1ScWXiF/2HnixjdnbeREdYBL94Ye6B2MBUcF0YmhzIxCt7SZNz2/KAqp4gVwmNZlTHXmwgjbQG3XHu07qf3XXNRjFqWjUxwsqMmr5WdcXl2qo9MEHg78NOK5oqrTHbzBi2ZfpDTjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rd6cAy/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rd6cAy/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EEA1F000FF;
	Tue, 13 Oct 2026 12:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894892;
	bh=94DobuZe+djGkY4D/X+F6I4mkSvfOPyQ4v1Duv6U7hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rd6cAy/f1z9vpqyV8oDH9+Rbqsy0/nGvdIKRNp5fm3PqFcd/rPsELo3rezdSIcbt+
	 6uQhFmGIPc7Ftd66Tt/s/7xaSiDnjk5tPcDxggMpvDyZREJZB+17+4ny/a83qjzqMA
	 DotWgw9rDjkChYySTpZILzPQ02mWPJzotAjTv9rA=
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
Subject: [PATCH 6.12 085/497] net-memcg: Introduce mem_cgroup_from_sk().
Date: Tue, 13 Oct 2026 13:34:12 +0200
Message-ID: <20261013112909.905582062@linuxfoundation.org>
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

[ Upstream commit f7161b234f2ec7f18999009c4becc04eeb6b12a7 ]

We will store a flag in the lowest bit of sk->sk_memcg.

Then, directly dereferencing sk->sk_memcg will be illegal, and we
do not want to allow touching the raw sk->sk_memcg in many places.

Let's introduce mem_cgroup_from_sk().

Other places accessing the raw sk->sk_memcg will be converted later.

Note that we cannot define the helper as an inline function in
memcontrol.h as we cannot access any fields of struct sock there
due to circular dependency, so it is placed in sock.h.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20250815201712.1745332-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 37e02c42a00b ("net: restrict SO_RESERVE_MEM to TCP sockets and cap max value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h              | 12 ++++++++++++
 mm/memcontrol.c                 | 13 +++++++++----
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 73353ee313ad2..6738c6cd3ff5a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2582,6 +2582,18 @@ static inline gfp_t gfp_memcg_charge(void)
 	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
 }
 
+#ifdef CONFIG_MEMCG
+static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
+{
+	return sk->sk_memcg;
+}
+#else
+static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
+{
+	return NULL;
+}
+#endif
+
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
 {
 	return noblock ? 0 : sk->sk_rcvtimeo;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 473e9696e47c6..50a1fd9087fae 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4846,19 +4846,24 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 
 void mem_cgroup_sk_free(struct sock *sk)
 {
-	if (sk->sk_memcg)
-		css_put(&sk->sk_memcg->css);
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
+	if (memcg)
+		css_put(&memcg->css);
 }
 
 void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
 {
+	struct mem_cgroup *memcg;
+
 	if (sk->sk_memcg == newsk->sk_memcg)
 		return;
 
 	mem_cgroup_sk_free(newsk);
 
-	if (sk->sk_memcg)
-		css_get(&sk->sk_memcg->css);
+	memcg = mem_cgroup_from_sk(sk);
+	if (memcg)
+		css_get(&memcg->css);
 
 	newsk->sk_memcg = sk->sk_memcg;
 }
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index bd671653273e7..eeee6f7583376 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -707,7 +707,7 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 		lock_sock(newsk);
 
 		mem_cgroup_sk_alloc(newsk);
-		if (newsk->sk_memcg) {
+		if (mem_cgroup_from_sk(newsk)) {
 			/* The socket has not been accepted yet, no need
 			 * to look at newsk->sk_wmem_queued.
 			 */
-- 
2.53.0



