Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AD42EA17F;
	Tue, 17 Jun 2025 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178594; cv=none; b=bTu9u5VX0byocgkBgwlJclZqVwylyxSaHh3t80UcalgbFcJ2w9vrNhwXc8oJyYmrL/U7cl2NAhuYvNcMtZBsyFLrgz4H6e2TJAhHZXUtb+lZcJfrZ8Pe9rTyEVhqROMFXHAQ0nohlUi7Mv9/6pfr4NfCOBCng10D3SV1CGU/pC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178594; c=relaxed/simple;
	bh=SIaYDl5A5MvyJL5aGnvUNlGPnmoZPDN9vRlUUMg7128=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elb1GGCcdJdNAL9NKiCiwEeHfJXMlK/f6pas+w+ZqavgMufuuxCjMnhfWbnzGbWOjFt8a/T3KzXd/V3anPMuoWtusrSLDtMGtB441tFHtwwjYtLwMr3AjwW1ZMzo5vhOD/zbLQZGcV8sznQhndIlC4ke3pYapOA//1E9e9s89pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NpJNGNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NpJNGNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F0FC4CEE3;
	Tue, 17 Jun 2025 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178594;
	bh=SIaYDl5A5MvyJL5aGnvUNlGPnmoZPDN9vRlUUMg7128=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NpJNGNfqn+GZWQr4gbmqOTNQRAhBV3LK3uw7b710OPrk8rVcg9vlOK8lZW4ci+PP
	 2UPmPOzgb3nm8OsPJJgFzf28Fm7ZNh0w96s3rMydn5PxrCCQayY967Lm1TCD16iH4/
	 T9XLP7CqcunJv7QHrzqwUVXZRxOORGxnRQZjq5P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 477/780] nfs_localio: use cmpxchg() to install new nfs_file_localio
Date: Tue, 17 Jun 2025 17:23:05 +0200
Message-ID: <20250617152510.914463800@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit ed9be317330c7390df7db9e1d046698c02001bd2 ]

Rather than using nfs_uuid.lock to protect installing
a new ro_file or rw_file, change to use cmpxchg().
Removing the file already uses xchg() so this improves symmetry
and also makes the code a little simpler.

Also remove the optimisation of not taking the lock, and not removing
the nfs_file_localio from the linked list, when both ->ro_file and
->rw_file are already NULL.  Given that ->nfs_uuid was not NULL, it is
extremely unlikely that neither ->ro_file or ->rw_file is NULL so
this optimisation can be of little value and it complicates
understanding of the code - why can the list_del_init() be skipped?

Finally, move the assignment of NULL to ->nfs_uuid until after
the last action on the nfs_file_localio (the list_del_init).  As soon as
this is NULL a racing nfs_close_local_fh() can bypass all the locking
and go on to free the nfs_file_localio, so we must be certain to be
finished with it first.

Fixes: 86e00412254a ("nfs: cache all open LOCALIO nfsd_file(s) in client")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c           | 11 +++--------
 fs/nfs_common/nfslocalio.c | 39 +++++++++++++++++---------------------
 2 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 4ec952f9f47dd..595903c215235 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -280,14 +280,9 @@ nfs_local_open_fh(struct nfs_client *clp, const struct cred *cred,
 			return NULL;
 		rcu_read_lock();
 		/* try to swap in the pointer */
-		spin_lock(&clp->cl_uuid.lock);
-		nf = rcu_dereference_protected(*pnf, 1);
-		if (!nf) {
-			nf = new;
-			new = NULL;
-			rcu_assign_pointer(*pnf, nf);
-		}
-		spin_unlock(&clp->cl_uuid.lock);
+		nf = unrcu_pointer(cmpxchg(pnf, NULL, RCU_INITIALIZER(new)));
+		if (!nf)
+			swap(nf, new);
 	}
 	nf = nfs_local_file_get(nf);
 	rcu_read_unlock();
diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index 6a0bdea6d6449..bdf251332b6b8 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -273,8 +273,8 @@ EXPORT_SYMBOL_GPL(nfs_open_local_fh);
 
 void nfs_close_local_fh(struct nfs_file_localio *nfl)
 {
-	struct nfsd_file *ro_nf = NULL;
-	struct nfsd_file *rw_nf = NULL;
+	struct nfsd_file *ro_nf;
+	struct nfsd_file *rw_nf;
 	nfs_uuid_t *nfs_uuid;
 
 	rcu_read_lock();
@@ -285,28 +285,23 @@ void nfs_close_local_fh(struct nfs_file_localio *nfl)
 		return;
 	}
 
-	ro_nf = rcu_access_pointer(nfl->ro_file);
-	rw_nf = rcu_access_pointer(nfl->rw_file);
-	if (ro_nf || rw_nf) {
-		spin_lock(&nfs_uuid->lock);
-		if (ro_nf)
-			ro_nf = rcu_dereference_protected(xchg(&nfl->ro_file, NULL), 1);
-		if (rw_nf)
-			rw_nf = rcu_dereference_protected(xchg(&nfl->rw_file, NULL), 1);
-
-		/* Remove nfl from nfs_uuid->files list */
-		RCU_INIT_POINTER(nfl->nfs_uuid, NULL);
-		list_del_init(&nfl->list);
-		spin_unlock(&nfs_uuid->lock);
-		rcu_read_unlock();
+	ro_nf = unrcu_pointer(xchg(&nfl->ro_file, NULL));
+	rw_nf = unrcu_pointer(xchg(&nfl->rw_file, NULL));
 
-		if (ro_nf)
-			nfs_to_nfsd_file_put_local(ro_nf);
-		if (rw_nf)
-			nfs_to_nfsd_file_put_local(rw_nf);
-		return;
-	}
+	spin_lock(&nfs_uuid->lock);
+	/* Remove nfl from nfs_uuid->files list */
+	list_del_init(&nfl->list);
+	spin_unlock(&nfs_uuid->lock);
 	rcu_read_unlock();
+	/* Now we can allow racing nfs_close_local_fh() to
+	 * skip the locking.
+	 */
+	RCU_INIT_POINTER(nfl->nfs_uuid, NULL);
+
+	if (ro_nf)
+		nfs_to_nfsd_file_put_local(ro_nf);
+	if (rw_nf)
+		nfs_to_nfsd_file_put_local(rw_nf);
 }
 EXPORT_SYMBOL_GPL(nfs_close_local_fh);
 
-- 
2.39.5



