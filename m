Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89658364BA;
	Fri, 24 Nov 2023 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQgxK8b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53BBC433C8;
	Fri, 24 Nov 2023 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853297;
	bh=Sk0kr52vgfiKYgMFhNa5WnzD+ZsImGy/dzyu4ScSQD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQgxK8b+5nK1LQju8sg+g+WK5/4/ED8ZAf9blpUGPjKTBk9ryuGt3zQuOCD63WUU7
	 oHvp5Zg1/Bzuw9KljdsslS5ju7LqoGFxfDx5CqllZjDTTqwQLlMheFnOZt+rhTHsM6
	 qDnkTzls3aYHmLAOPQaydFCItHagsiD9YXSWpgn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <kafai@fb.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/297] net: inet: Remove count from inet_listen_hashbucket
Date: Fri, 24 Nov 2023 17:52:20 +0000
Message-ID: <20231124172003.686126019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 8ea1eebb49a2dfee1dce621a638cc1626e542392 ]

After commit 0ee58dad5b06 ("net: tcp6: prefer listeners bound to an address")
and commit d9fbc7f6431f ("net: tcp: prefer listeners bound to an address"),
the count is no longer used.  This patch removes it.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 871019b22d1b ("net: set SOCK_RCU_FREE before inserting socket into hashtable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_hashtables.h | 1 -
 net/ipv4/inet_hashtables.c    | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 53c22b64e9724..405670d7661da 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -111,7 +111,6 @@ struct inet_bind_hashbucket {
 #define LISTENING_NULLS_BASE (1U << 29)
 struct inet_listen_hashbucket {
 	spinlock_t		lock;
-	unsigned int		count;
 	union {
 		struct hlist_head	head;
 		struct hlist_nulls_head	nulls_head;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2936676f86eb8..8e0451248fc05 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -209,7 +209,6 @@ static void inet_hash2(struct inet_hashinfo *h, struct sock *sk)
 	else
 		hlist_add_head_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
 				   &ilb2->head);
-	ilb2->count++;
 	spin_unlock(&ilb2->lock);
 }
 
@@ -225,7 +224,6 @@ static void inet_unhash2(struct inet_hashinfo *h, struct sock *sk)
 
 	spin_lock(&ilb2->lock);
 	hlist_del_init_rcu(&inet_csk(sk)->icsk_listen_portaddr_node);
-	ilb2->count--;
 	spin_unlock(&ilb2->lock);
 }
 
@@ -652,7 +650,6 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	else
 		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
 	inet_hash2(hashinfo, sk);
-	ilb->count++;
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 unlock:
@@ -684,7 +681,6 @@ static void __inet_unhash(struct sock *sk, struct inet_listen_hashbucket *ilb)
 		struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 
 		inet_unhash2(hashinfo, sk);
-		ilb->count--;
 	}
 	__sk_nulls_del_node_init_rcu(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
@@ -867,7 +863,6 @@ void inet_hashinfo_init(struct inet_hashinfo *h)
 		spin_lock_init(&h->listening_hash[i].lock);
 		INIT_HLIST_NULLS_HEAD(&h->listening_hash[i].nulls_head,
 				      i + LISTENING_NULLS_BASE);
-		h->listening_hash[i].count = 0;
 	}
 
 	h->lhash2 = NULL;
@@ -881,7 +876,6 @@ static void init_hashinfo_lhash2(struct inet_hashinfo *h)
 	for (i = 0; i <= h->lhash2_mask; i++) {
 		spin_lock_init(&h->lhash2[i].lock);
 		INIT_HLIST_HEAD(&h->lhash2[i].head);
-		h->lhash2[i].count = 0;
 	}
 }
 
-- 
2.42.0



