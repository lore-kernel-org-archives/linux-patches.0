Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A215442C;
	Thu,  3 Jul 2025 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555667; cv=none; b=pHXa1Xrx8j+/zcCaMdIwd6VqazeuRjRQvMthhvdFJx7lrxi+Auf75DTzRHTv4Roijt4/a2z2ATs7rZfW2xPZBXkAhtHWQNhTvg6mc25BpsM9z2Tgte6PjzjErZJ3Pk0RVR9GVNiCAOK+3z3TYdd0w2k89qpWDykh2UrSBcPOlLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555667; c=relaxed/simple;
	bh=y2EglgTEmPgKPUh2kQAt22WrZH+fE383Qn1bPLH9bwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PexvBOYJUhaRQ7L5D/N0hlXZ7Zd3oltumjZil3t8OP9kA3aNH73OMUao+nNiWfK2uK6gGwv1C5n/FbcrTJt/csxqDXm5H7p6/2ixvOoHkrW5nzW9/YBEf3wlO4uuuIHWDei6nnmypyaIQVTl/rnHRW/Z5Acswu53sYKWx/iLQvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPm3eFuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPm3eFuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FCBC4CEE3;
	Thu,  3 Jul 2025 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555667;
	bh=y2EglgTEmPgKPUh2kQAt22WrZH+fE383Qn1bPLH9bwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPm3eFuVszsbbQqbOV9gFaLnql3vvYTPuUmpGS8vuYAzF5hZUNSDskjoom7Xouj3D
	 65lQvYXUm0+kGwsHaR7Fh71V+CHYp9fJ1eCovfJB4T+5jFYOOm+C+1pHEI9Ozow5Em
	 WPtWK9d29NeRUAcw49YvwW0EIqx7vDdhjaSOf9hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/139] af_unix: Define locking order for unix_table_double_lock().
Date: Thu,  3 Jul 2025 16:42:09 +0200
Message-ID: <20250703143943.748803452@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 3955802f160b5c61ac00d7e54da8d746f2e4a2d5 ]

When created, AF_UNIX socket is put into net->unx.table.buckets[],
and the hash is stored in sk->sk_hash.

  * unbound socket  : 0 <= sk_hash <= UNIX_HASH_MOD

When bind() is called, the socket could be moved to another bucket.

  * pathname socket : 0 <= sk_hash <= UNIX_HASH_MOD
  * abstract socket : UNIX_HASH_MOD + 1 <= sk_hash <= UNIX_HASH_MOD * 2 + 1

Then, we call unix_table_double_lock() which locks a single bucket
or two.

Let's define the order as unix_table_lock_cmp_fn() instead of using
spin_lock_nested().

The locking is always done in ascending order of sk->sk_hash, which
is the index of buckets/locks array allocated by kvmalloc_array().

  sk_hash_A < sk_hash_B
  <=> &locks[sk_hash_A].dep_map < &locks[sk_hash_B].dep_map

So, the relation of two sk->sk_hash can be derived from the addresses
of dep_map in the array of locks.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 32ca245464e1 ("af_unix: Don't leave consecutive consumed OOB skbs.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 236a2cd2bc93d..4f839d687c1e4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -125,6 +125,15 @@ static spinlock_t bsd_socket_locks[UNIX_HASH_SIZE / 2];
  *    hash table is protected with spinlock.
  *    each socket state is protected by separate spinlock.
  */
+#ifdef CONFIG_PROVE_LOCKING
+#define cmp_ptr(l, r)	(((l) > (r)) - ((l) < (r)))
+
+static int unix_table_lock_cmp_fn(const struct lockdep_map *a,
+				  const struct lockdep_map *b)
+{
+	return cmp_ptr(a, b);
+}
+#endif
 
 static unsigned int unix_unbound_hash(struct sock *sk)
 {
@@ -167,7 +176,7 @@ static void unix_table_double_lock(struct net *net,
 		swap(hash1, hash2);
 
 	spin_lock(&net->unx.table.locks[hash1]);
-	spin_lock_nested(&net->unx.table.locks[hash2], SINGLE_DEPTH_NESTING);
+	spin_lock(&net->unx.table.locks[hash2]);
 }
 
 static void unix_table_double_unlock(struct net *net,
@@ -3598,6 +3607,7 @@ static int __net_init unix_net_init(struct net *net)
 
 	for (i = 0; i < UNIX_HASH_SIZE; i++) {
 		spin_lock_init(&net->unx.table.locks[i]);
+		lock_set_cmp_fn(&net->unx.table.locks[i], unix_table_lock_cmp_fn, NULL);
 		INIT_HLIST_HEAD(&net->unx.table.buckets[i]);
 	}
 
-- 
2.39.5



