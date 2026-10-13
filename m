Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0541A4F799A;
	Tue, 13 Oct 2026 12:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895032; cv=none; b=oppIHxOmjNfgODFt8iAtRQ5Pk5KIetid1Q6kN5/05RWj/fEsP7L/5cMeguL1yboU08eS8y24FafpqlTL15acIreOePwLIexkAOY0Q8QQ4Omq2Kc4kgyprsD9JlLRC/q1U8H8J2GcEmGWlTC7lvndkhk2I6glknrDiQqHKabTN7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895032; c=relaxed/simple;
	bh=WbLOZMWuJ3yKI3kPSBWRiWbRds4TIZWMdKSo6tZpjxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrukjU7cJgDQ4OO1Sr18yWKsUD/5lbffniLn0pLi3JEvj6WNBIAL+R0mxq51IgRdK70ALhODd28S8xPc/GPzBphrt4fX6pphKxMN1Q2T7suu+0LDUWlIb+Kw4tSOne//7aRlVrieQWd2OZsoSHhnf78xCY2M4M5Nv6z8h5A4TLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCVVGNFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCVVGNFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596881F000FF;
	Tue, 13 Oct 2026 12:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895030;
	bh=3Z+F+gKpC5ABoEgGKvJyPdxL7JahOT9t47bAyDHiBmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCVVGNFeeJb1lzhmQLvyFSuNgGMifMl1omZSxZytAxkdCV5XzKNJLys1ZQYcG4Brc
	 rVRY1RtqobJLHLsK9+IYxLmoL/RVJ1ROls9fgRr1LNhGaDhVDlIbMZ7U22mXt4DuCA
	 UdYSsuRHuorDguRqFvHD3r/lQSgXarRkkwNwKJdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/497] net: Clean up __sk_mem_raise_allocated().
Date: Tue, 13 Oct 2026 13:34:11 +0200
Message-ID: <20261013112909.879665318@linuxfoundation.org>
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

[ Upstream commit bd4aa2337374dd04b8627efd26227ebd49f69285 ]

In __sk_mem_raise_allocated(), charged is initialised as true due
to the weird condition removed in the previous patch.

It makes the variable unreliable by itself, so we have to check
another variable, memcg, in advance.

Also, we will factorise the common check below for memcg later.

    if (mem_cgroup_sockets_enabled && sk->sk_memcg)

As a prep, let's initialise charged as false and memcg as NULL.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20250815201712.1745332-6-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 37e02c42a00b ("net: restrict SO_RESERVE_MEM to TCP sockets and cap max value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index ef8faa6bddf98..e226ebae9a599 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3208,15 +3208,16 @@ EXPORT_SYMBOL(sk_wait_data);
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
-	struct mem_cgroup *memcg = mem_cgroup_sockets_enabled ? sk->sk_memcg : NULL;
 	struct proto *prot = sk->sk_prot;
-	bool charged = true;
+	struct mem_cgroup *memcg = NULL;
+	bool charged = false;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
-	if (memcg) {
+	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+		memcg = sk->sk_memcg;
 		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
 		if (!charged)
 			goto suppress_allocation;
@@ -3303,7 +3304,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_sub(sk, amt);
 
-	if (memcg && charged)
+	if (charged)
 		mem_cgroup_uncharge_skmem(memcg, amt);
 
 	return 0;
-- 
2.53.0



