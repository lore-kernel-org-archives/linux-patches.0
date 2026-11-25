Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625506;
	b=vmnou+XSV2xSqXK3TisFoOZldxbKg971G6sTbLbwJJFr0Jj7wMOzLmgittL34hSNGFKX
	 ss/6XTfguTi8p2k0Ites/Dp3IfDGmnm9sgITU+d9BnbrjkS8lGRLGw8nhw4WalfBq/ksU
	 opBVKgQ2H5vYBicd3XO6VoEscZzCTpcv3n0uKfuEsVWO2yBg1iqGg/qY9UsiCLVkXVBUL
	 /ch70H+UJ+HSQUrmpT2TLsFFZv0BUOgYq36fbFgcX31vj0rXIc3ZpTjhsJAFygPoJufA5
	 skxBYWY0gjlT5Eb4//g/rv6qdKaSCruffheP1Ew/+4cF2dN3uEICl+zj18XPWjl7kuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=acAjRmQWdU7lkpfWMpGUiAr3HtspDurO7KFTnaUgMVg=;
	b=PfRxGMjGTDFvQimXSSQeKXxgown6wGxVBCgmamYjzY0r2+w2r0bE3NLdc0FkwocriNBA
	 SR/snfGkz02NOELNqny50ucJFLLBwr0CvYfcL+6DdYIge2ATq0KMRYrgJ+BNy1nrJvZkl
	 fwblvfwPC/hNk7DQ9y8fN9PlS9o9OwmjU7eILjVsRYeFD7Uf5WHr7PwoxC2wDYe3Iz47D
	 JEVH/AW4u+zc0KQsuuUz8pIc9fBmqvgN0UuA+lxeDci845iffVWSE1nJk31q/RyiberC9
	 03piZ1HV1LTaweCgqQ8QIvQdIZHpaHHuZ2C+BrlSUCH+LKov9gQQEaJhiuwftQ+SWEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UhySPv/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4066606A326;
	Wed, 25 Nov 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhySPv/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259321F000C0;
	Wed, 25 Nov 2026 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625506;
	bh=acAjRmQWdU7lkpfWMpGUiAr3HtspDurO7KFTnaUgMVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhySPv/A0mBkjL/sBJCsBhwG8DxXKkCsuEOECkSSwVa/MKIxKeamm6P/L13qjy8/K
	 SLCJTNTGKXjxGdZPCXgJteYHL1JQHR+X1/W4twJDGGsxUKBF8K9kjGhza7krOAsnA6
	 HNIqL0hntvbWEXL3lF8fw3TU46RN06J+3BfqMwQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Zhewei Yuan <yzwlhm@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 539/816] tcp: Fix fastreuse cache initialization on first bind
Date: Wed, 25 Nov 2026 15:34:47 +0100
Message-ID: <20261125143901.664223663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhewei Yuan <yzwlhm@gmail.com>

[ Upstream commit 947ccedf683ed6cc53c1f88ac9eb8747e4567ed6 ]

inet_csk_update_fastreuse() initializes the reuse caches only when
tb->bhash2 is empty, but both inet_csk_get_port() and
__inet_inherit_port() link tb2 before calling it, so the first-bind
branch is never taken.

As a result, SO_REUSEADDR binds never get fastreuse=1 and keep
scanning existing owners, and SO_REUSEPORT starts in STRICT instead
of ANY.

Initialize the caches when tb2 is the only entry in tb->bhash2 and has
no owners. Timewait sockets are also linked on tb2->owners, so this is
equivalent to the old hlist_empty(&tb->owners) test.

Found by manual code inspection and confirmed with GDB. Binding 16000
SO_REUSEADDR sockets to one address/port in a KVM guest takes 4.18 s
before and 19.4 ms after this patch. Existing bind/reuse selftests
pass. Analysis and testing were assisted by an AI tool (Codex).

Fixes: 8002d44fe84d ("tcp: Check hlist_empty(&tb->bhash2) instead of hlist_empty(&tb->owners).")
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Zhewei Yuan <yzwlhm@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20261026095208.58504-1-yzwlhm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Added a tb2 parameter to inet_csk_update_fastreuse() and its two callers, since the older tree's function lacks it, so the new singular-bhash2 and empty-owners check can use it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 1 +
 net/ipv4/inet_connection_sock.c    | 6 ++++--
 net/ipv4/inet_hashtables.c         | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 2ff01a8fbef2b..d97561e4bef8f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -326,6 +326,7 @@ void inet_csk_addr2sockaddr(struct sock *sk, struct sockaddr *uaddr);
 
 /* update the fast reuse flag when adding a socket */
 void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct inet_bind2_bucket *tb2,
 			       struct sock *sk);
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 5b6436e6f242c..c869986442ef3 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -443,12 +443,14 @@ static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
 }
 
 void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct inet_bind2_bucket *tb2,
 			       struct sock *sk)
 {
 	kuid_t uid = sock_i_uid(sk);
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 
-	if (hlist_empty(&tb->bhash2)) {
+	if (hlist_is_singular_node(&tb2->bhash_node, &tb->bhash2) &&
+	    hlist_empty(&tb2->owners)) {
 		tb->fastreuse = reuse;
 		if (sk->sk_reuseport) {
 			tb->fastreuseport = FASTREUSEPORT_ANY;
@@ -572,7 +574,7 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 	}
 
 success:
-	inet_csk_update_fastreuse(tb, sk);
+	inet_csk_update_fastreuse(tb, tb2, sk);
 
 	if (!inet_csk(sk)->icsk_bind_hash)
 		inet_bind_hash(sk, tb, tb2, port);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index a597c176a5e45..ca6726a8c4a1d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -277,7 +277,7 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 		}
 	}
 	if (update_fastreuse)
-		inet_csk_update_fastreuse(tb, child);
+		inet_csk_update_fastreuse(tb, tb2, child);
 	inet_bind_hash(child, tb, tb2, port);
 	spin_unlock(&head2->lock);
 	spin_unlock(&head->lock);
-- 
2.53.0



