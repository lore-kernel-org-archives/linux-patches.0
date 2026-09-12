Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E847CA62;
	Sat, 12 Sep 2026 13:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219950; cv=none; b=JZDkWKHVzWXuN5Bnu7sDDICARKWnY3+zRTF1NAYXiLbZJbuaMfsF+gIEIZIdr5b7oYxDY5tSbbdQ/XmJM/aZVUgZFHI2Q0vcl8hr9JJONfo2zDZkEhbHeCtW64p3MNK7hoA3twCso/wup+pJxLk16X6+ddwi9jdOgN0Eos5WCrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219950; c=relaxed/simple;
	bh=h+wGP5N+bKcpRCRtHvCNISMm9XZxqvObgnfPT0ELkLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzDX6RrIuX6BqVUX3BcVZxc8519c1mxw5GPq02sN0lgB47/S4UzA4UyJkie6LbwgsyxoegAYy+NLLRLyDqbbQKL6MYUC0zGM1/qz479oL22UCUMCBxNwK7AqsBZ/zh6FIEGe3sT2i5HN6T9O+Gp1mnaxG2Tp03Hxcb4vmqtnn9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mYhhAyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mYhhAyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E1B1F000FF;
	Sat, 12 Sep 2026 13:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219948;
	bh=2tU9TOjqqqQSGfRyQxIRsV5W/znIDIEI2IpLG61uAik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mYhhAydi9hRLh+Gl+Dzc7K+j620GLEAU5yEwa+eaOFTtHgj5dH/RFrMQ4bkjHwI8
	 GgHmwjpkL6FYZskNHc2neBtClCD0EHQ+0rMQ0rS2EXKYIPlTb2BxUtBt2OoPYVBkF3
	 0dAddhI+pXWBcl1EY3qem8Qf22kN7gV86Pc7oXr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfgang Walter <linux@stwm.de>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0070/1424] NFSD: Prevent lock owner use-after-free during client teardown
Date: Sat, 12 Sep 2026 08:41:42 +0200
Message-ID: <20260912065608.873793574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 5e2fa29d223a9a1e6a948e40b109d09081d1decd upstream.

__destroy_client() releases a client's open owners, but a lock owner
whose only reference is a blocked lock (nbl) stays on
cl_ownerstr_hashtbl.  client_has_state() does not count a bare owner,
so DESTROY_CLIENTID can reach __destroy_client() with such owners
present.

__destroy_client() then walks the table, calling remove_blocked_locks()
on each owner without a reference.  Freeing a blocked lock drops the
owner reference held via flc_owner.  The per-net laundromat reaps
blocked locks from nn->blocked_locks_lru independently of client state.
The two paths share blocked_locks_lock only for the list splice, not
the owner's lifetime.  The laundromat therefore frees the owner as
__destroy_client() dereferences it, a NULL dereference in
remove_blocked_locks().

nfsd4_release_lockowner() holds a reference across the same call;
__destroy_client() does not.  Hold cl_lock across the walk, taking a
reference and unhashing each owner, then drop it before
remove_blocked_locks() and nfs4_put_stateowner(), which take
blocked_locks_lock and cl_lock.

Reported-by: Wolfgang Walter <linux@stwm.de>
Closes: https://lore.kernel.org/linux-nfs/6eccafaaaa60651ef091257c3439c46b@stwm.de/
Fixes: 68ef3bc31664 ("nfsd: remove blocked locks on client teardown")
Cc: stable@vger.kernel.org
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-1-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2335,14 +2335,24 @@ __destroy_client(struct nfs4_client *clp
 		release_openowner(oo);
 	}
 	for (i = 0; i < OWNER_HASH_SIZE; i++) {
-		struct nfs4_stateowner *so, *tmp;
+		struct nfs4_stateowner *so;
 
-		list_for_each_entry_safe(so, tmp, &clp->cl_ownerstr_hashtbl[i],
-					 so_strhash) {
+		spin_lock(&clp->cl_lock);
+		while (!list_empty(&clp->cl_ownerstr_hashtbl[i])) {
+			so = list_first_entry(&clp->cl_ownerstr_hashtbl[i],
+					      struct nfs4_stateowner, so_strhash);
 			/* Should be no openowners at this point */
 			WARN_ON_ONCE(so->so_is_open_owner);
+			nfs4_get_stateowner(so);
+			unhash_lockowner_locked(lockowner(so));
+			spin_unlock(&clp->cl_lock);
+
 			remove_blocked_locks(lockowner(so));
+			nfs4_put_stateowner(so);
+
+			spin_lock(&clp->cl_lock);
 		}
+		spin_unlock(&clp->cl_lock);
 	}
 	nfsd4_return_all_client_layouts(clp);
 	nfsd4_shutdown_copy(clp);


