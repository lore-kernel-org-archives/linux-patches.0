Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BB237F75B;
	Sat, 12 Sep 2026 19:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241015; cv=none; b=l6GedFIFfWvwud+UjfSlRJ8ncBWMR8rtPzHA9IiqB97Wz2AsXq27iUi4BjTF+f42WHwpThW39tCvJb++wOD8zGpn1DBlCGuwL6XzIVqp+GnvykOgNWUzoqDXGxsgGEoaJxA2jMro6R0kqXkyK1k9W1n7EMlUyzOpBIB7khvLiWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241015; c=relaxed/simple;
	bh=i1T7HIkWL1xwg9w+ewSVdDYBBZdeVtAijPYPs5DLl90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhXarCV2OnD+qZREDsZVKc2G64wj8/SEpt09MrlRtKxj4ZILNyneXSzrSCWFuOq/49RP84UUCrdlit0Te8/LH5Wa3IEQzSjaDT3AGvnNgNLzYvuj1siN8zhyROZvquMPjlrFqAn2Eoam2hPIm95nq4Vh1xB+VIIbKLwZ4LRyKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+56OrQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+56OrQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA931F000FF;
	Sat, 12 Sep 2026 19:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241014;
	bh=tKhLv6pzex6vKEKNekGusM3T0BiADfLkqCEWQdW/cFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+56OrQk038cZAPZ4M9Fj2qHMYkKi/KuGE9s8Dtu0qWofv0JIEFL6qi5CnmSFbCNN
	 EuXSgbHCPHCawrzRpM2DSzvpdeXNtg47YnCfiPBI3yqtrfenfJF5Y1ntIc14jLmypG
	 vJ+iVKHf60NNM3jrPAeGABInpjLnL/YjjfnZfmtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfgang Walter <linux@stwm.de>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 048/798] NFSD: Prevent lock owner use-after-free during client teardown
Date: Sat, 12 Sep 2026 08:54:36 +0200
Message-ID: <20260912065518.065868768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2336,14 +2336,24 @@ __destroy_client(struct nfs4_client *clp
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


