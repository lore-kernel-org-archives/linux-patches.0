Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C05131191;
	Mon,  8 Apr 2024 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583494; cv=none; b=Joh/S4Q2H80JDbqKg7OAe5/qm8gr+vqGTNvHamcw4FF3J98svzY3cvBiubkj4peO6e42IXEaclHssOyW2dlLUO75tEv4WQUE/hKYUNrsTuruZ0A9x1ZPitu/SwcKv1UrYehbcYjuycfwQj6sk1XZeuHSgEdA+AJSmKHDClY695Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583494; c=relaxed/simple;
	bh=UMtTLQyVOumoSPY0Cxg7UwQfAB26eAI1im7ZHqTwVrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=py31VgsuozAiAy8hkFXLFqrLcjZ2FcaM232zz045Fyg/uqSggZcJtEQPuaIoVRnnhlVkxJd2DPyvdw1gWrLj7ht41RVT+LuNBW/D9d7/aaXruJxO+t/s3D5E+jm0oLA9/H2Zc55ycLEOGKxzbfbv1g8x015aXpsDEI1OoovVR3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwM5NjfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwM5NjfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C78C433C7;
	Mon,  8 Apr 2024 13:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583493;
	bh=UMtTLQyVOumoSPY0Cxg7UwQfAB26eAI1im7ZHqTwVrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwM5NjfNd70Ppls40s+zDSDlUhh/o8r8dRyBx76QD6wdrcmsX71yfj1gIwcICeS1I
	 vwDdbpUYSFKdZgMHMKs/vyF4acEa6kLe/6mZoZbMUHMd/sggM8ExfhD1vmLAm/x/oD
	 1OQXP9c5V0cNahYzwItiXUiN8hs0qBToq3hoErUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 253/690] nfsd4: add refcount for nfsd4_blocked_lock
Date: Mon,  8 Apr 2024 14:51:59 +0200
Message-ID: <20240408125408.782782309@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 47446d74f1707049067fee038507cdffda805631 ]

nbl allocated in nfsd4_lock can be released by a several ways:
directly in nfsd4_lock(), via nfs4_laundromat(), via another nfs
command RELEASE_LOCKOWNER or via nfsd4_callback.
This structure should be refcounted to be used and released correctly
in all these cases.

Refcount is initialized to 1 during allocation and is incremented
when nbl is added into nbl_list/nbl_lru lists.

Usually nbl is linked into both lists together, so only one refcount
is used for both lists.

However nfsd4_lock() should keep in mind that nbl can be present
in one of lists only. This can happen if nbl was handled already
by nfs4_laundromat/nfsd4_callback/etc.

Refcount is decremented if vfs_lock_file() returns FILE_LOCK_DEFERRED,
because nbl can be handled already by nfs4_laundromat/nfsd4_callback/etc.

Refcount is not changed in find_blocked_lock() because of it reuses counter
released after removing nbl from lists.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 25 ++++++++++++++++++++++---
 fs/nfsd/state.h     |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5ee11f0e24d3b..fc0d7fbe5d4a6 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -246,6 +246,7 @@ find_blocked_lock(struct nfs4_lockowner *lo, struct knfsd_fh *fh,
 	list_for_each_entry(cur, &lo->lo_blocked, nbl_list) {
 		if (fh_match(fh, &cur->nbl_fh)) {
 			list_del_init(&cur->nbl_list);
+			WARN_ON(list_empty(&cur->nbl_lru));
 			list_del_init(&cur->nbl_lru);
 			found = cur;
 			break;
@@ -271,6 +272,7 @@ find_or_allocate_block(struct nfs4_lockowner *lo, struct knfsd_fh *fh,
 			INIT_LIST_HEAD(&nbl->nbl_lru);
 			fh_copy_shallow(&nbl->nbl_fh, fh);
 			locks_init_lock(&nbl->nbl_lock);
+			kref_init(&nbl->nbl_kref);
 			nfsd4_init_cb(&nbl->nbl_cb, lo->lo_owner.so_client,
 					&nfsd4_cb_notify_lock_ops,
 					NFSPROC4_CLNT_CB_NOTIFY_LOCK);
@@ -279,12 +281,21 @@ find_or_allocate_block(struct nfs4_lockowner *lo, struct knfsd_fh *fh,
 	return nbl;
 }
 
+static void
+free_nbl(struct kref *kref)
+{
+	struct nfsd4_blocked_lock *nbl;
+
+	nbl = container_of(kref, struct nfsd4_blocked_lock, nbl_kref);
+	kfree(nbl);
+}
+
 static void
 free_blocked_lock(struct nfsd4_blocked_lock *nbl)
 {
 	locks_delete_block(&nbl->nbl_lock);
 	locks_release_private(&nbl->nbl_lock);
-	kfree(nbl);
+	kref_put(&nbl->nbl_kref, free_nbl);
 }
 
 static void
@@ -302,6 +313,7 @@ remove_blocked_locks(struct nfs4_lockowner *lo)
 					struct nfsd4_blocked_lock,
 					nbl_list);
 		list_del_init(&nbl->nbl_list);
+		WARN_ON(list_empty(&nbl->nbl_lru));
 		list_move(&nbl->nbl_lru, &reaplist);
 	}
 	spin_unlock(&nn->blocked_locks_lock);
@@ -7019,6 +7031,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		spin_lock(&nn->blocked_locks_lock);
 		list_add_tail(&nbl->nbl_list, &lock_sop->lo_blocked);
 		list_add_tail(&nbl->nbl_lru, &nn->blocked_locks_lru);
+		kref_get(&nbl->nbl_kref);
 		spin_unlock(&nn->blocked_locks_lock);
 	}
 
@@ -7031,6 +7044,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			nn->somebody_reclaimed = true;
 		break;
 	case FILE_LOCK_DEFERRED:
+		kref_put(&nbl->nbl_kref, free_nbl);
 		nbl = NULL;
 		fallthrough;
 	case -EAGAIN:		/* conflock holds conflicting lock */
@@ -7051,8 +7065,13 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		/* dequeue it if we queued it before */
 		if (fl_flags & FL_SLEEP) {
 			spin_lock(&nn->blocked_locks_lock);
-			list_del_init(&nbl->nbl_list);
-			list_del_init(&nbl->nbl_lru);
+			if (!list_empty(&nbl->nbl_list) &&
+			    !list_empty(&nbl->nbl_lru)) {
+				list_del_init(&nbl->nbl_list);
+				list_del_init(&nbl->nbl_lru);
+				kref_put(&nbl->nbl_kref, free_nbl);
+			}
+			/* nbl can use one of lists to be linked to reaplist */
 			spin_unlock(&nn->blocked_locks_lock);
 		}
 		free_blocked_lock(nbl);
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 6eb3c7157214b..95457cfd37fc0 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -633,6 +633,7 @@ struct nfsd4_blocked_lock {
 	struct file_lock	nbl_lock;
 	struct knfsd_fh		nbl_fh;
 	struct nfsd4_callback	nbl_cb;
+	struct kref		nbl_kref;
 };
 
 struct nfsd4_compound_state;
-- 
2.43.0



