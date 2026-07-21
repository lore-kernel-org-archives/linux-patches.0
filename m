Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BF63B2D00;
	Tue, 21 Jul 2026 21:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668064; cv=none; b=iBfp1qY1XOPdbUuA1TYJFB3PK4CeJdgnqd8B0h+jlRtQ4IJFixcGGLEes62SbeNf4er2DcAmVSwL5wBFK7ZC/RwlFhDftgIv7fet+isY6dcVO5E5pXFGIDO01vK9nx46AI+FXveAdWYTCCWtRtf87I0VQMHCorrBrgcsxPDduH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668064; c=relaxed/simple;
	bh=KkPV7+ZvNh4DZSi+Q89hDTbmYuLwvTPU9oGRC8/vlFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/sw9nRj3FC+LskRYr3CBebRZDM7msNxppKeJ+rgDV4c1tsz6fAE7viMG8PtfEZT7gH9+dtEa6zij+w8xRyBOzbDGoeVCnGcCoT6ZO4XBVPQB9PjDnICoLnKSeV1CN92bxMBniSyT83D/Tif56jqM+wsmdU0YCJZhr4sFg1ljzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heE2oFjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heE2oFjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC741F000E9;
	Tue, 21 Jul 2026 21:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668063;
	bh=98PtGRb9Ipo/Usnt8HSGCzTwhxTgydPXMu2dcHax1G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heE2oFjKfcOmK7s/fccoeVvazgwhTVnRbXrdelYiEdFDiadgX/sWhkAHiivbOsg3W
	 3/tVCF8659wpT3xqozC0avsEq9xB5XXb/whJ/5QIGVLk1fs3AI2/CLYfD7Pc6aaVEe
	 +98jHATIgYcJhy2vqnEeeaRhGB52yU4dkvphk+wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0034/1067] nfsd: change nfs4_client_to_reclaim() to allocate data
Date: Tue, 21 Jul 2026 17:10:35 +0200
Message-ID: <20260721152425.312596459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit 4552f4e3f2c96597914f07b060d5c5db84420ddd ]

The calling convention for nfs4_client_to_reclaim() is clumsy in that
the caller needs to free memory if the function fails.  It is much
cleaner if the function frees its own memory.

This patch changes nfs4_client_to_reclaim() to re-allocate the .data
fields to be stored in the newly allocated struct nfs4_client_reclaim,
and to free everything on failure.

__cld_pipe_inprogress_downcall() needs to allocate the data anyway to
copy it from user-space, so now that data is allocated twice.  I think
that is a small price to pay for a cleaner interface.

Signed-off-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 67 +++++++++++++++----------------------------
 fs/nfsd/nfs4state.c   | 22 ++++++++++++--
 2 files changed, 42 insertions(+), 47 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 3ad9da783eb686..4f1f4d2c6bed1f 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -167,24 +167,13 @@ legacy_recdir_name_error(struct nfs4_client *clp, int error)
 
 static void
 __nfsd4_create_reclaim_record_grace(struct nfs4_client *clp,
-		const char *dname, int len, struct nfsd_net *nn)
+				    char *dname, struct nfsd_net *nn)
 {
-	struct xdr_netobj name;
+	struct xdr_netobj name = { .len = strlen(dname), .data = dname };
 	struct xdr_netobj princhash = { .len = 0, .data = NULL };
 	struct nfs4_client_reclaim *crp;
 
-	name.data = kmemdup(dname, len, GFP_KERNEL);
-	if (!name.data) {
-		dprintk("%s: failed to allocate memory for name.data!\n",
-			__func__);
-		return;
-	}
-	name.len = len;
 	crp = nfs4_client_to_reclaim(name, princhash, nn);
-	if (!crp) {
-		kfree(name.data);
-		return;
-	}
 	crp->cr_clp = clp;
 }
 
@@ -240,8 +229,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	inode_unlock(d_inode(dir));
 	if (status == 0) {
 		if (nn->in_grace)
-			__nfsd4_create_reclaim_record_grace(clp, dname,
-					HEXDIR_LEN, nn);
+			__nfsd4_create_reclaim_record_grace(clp, dname, nn);
 		vfs_fsync(nn->rec_file, 0);
 	} else {
 		printk(KERN_ERR "NFSD: failed to write recovery record"
@@ -478,7 +466,7 @@ nfsd4_recdir_purge_old(struct nfsd_net *nn)
 static int
 load_recdir(struct dentry *parent, char *cname, struct nfsd_net *nn)
 {
-	struct xdr_netobj name;
+	struct xdr_netobj name = { .len = HEXDIR_LEN, .data = cname };
 	struct xdr_netobj princhash = { .len = 0, .data = NULL };
 
 	if (strlen(cname) != HEXDIR_LEN - 1) {
@@ -487,16 +475,7 @@ load_recdir(struct dentry *parent, char *cname, struct nfsd_net *nn)
 		/* Keep trying; maybe the others are OK: */
 		return 0;
 	}
-	name.data = kstrdup(cname, GFP_KERNEL);
-	if (!name.data) {
-		dprintk("%s: failed to allocate memory for name.data!\n",
-			__func__);
-		goto out;
-	}
-	name.len = HEXDIR_LEN;
-	if (!nfs4_client_to_reclaim(name, princhash, nn))
-		kfree(name.data);
-out:
+	nfs4_client_to_reclaim(name, princhash, nn);
 	return 0;
 }
 
@@ -792,6 +771,8 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 {
 	uint8_t cmd, princhashlen;
 	struct xdr_netobj name, princhash = { .len = 0, .data = NULL };
+	char *namecopy __free(kfree) = NULL;
+	char *princhashcopy __free(kfree) = NULL;
 	uint16_t namelen;
 	struct cld_net *cn = nn->cld_net;
 
@@ -810,20 +791,20 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				dprintk("%s: namelen should not be zero", __func__);
 				return -EINVAL;
 			}
-			name.data = memdup_user(&ci->cc_name.cn_id, namelen);
-			if (IS_ERR(name.data))
-				return PTR_ERR(name.data);
+			namecopy = memdup_user(&ci->cc_name.cn_id, namelen);
+			if (IS_ERR(namecopy))
+				return PTR_ERR(namecopy);
+			name.data = namecopy;
 			name.len = namelen;
 			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
 				return -EFAULT;
 			if (princhashlen > 0) {
-				princhash.data = memdup_user(
-						&ci->cc_princhash.cp_data,
-						princhashlen);
-				if (IS_ERR(princhash.data)) {
-					kfree(name.data);
-					return PTR_ERR(princhash.data);
-				}
+				princhashcopy = memdup_user(
+					&ci->cc_princhash.cp_data,
+					princhashlen);
+				if (IS_ERR(princhashcopy))
+					return PTR_ERR(princhashcopy);
+				princhash.data = princhashcopy;
 				princhash.len = princhashlen;
 			} else
 				princhash.len = 0;
@@ -837,23 +818,21 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				dprintk("%s: namelen should not be zero", __func__);
 				return -EINVAL;
 			}
-			name.data = memdup_user(&cnm->cn_id, namelen);
-			if (IS_ERR(name.data))
-				return PTR_ERR(name.data);
+			namecopy = memdup_user(&cnm->cn_id, namelen);
+			if (IS_ERR(namecopy))
+				return PTR_ERR(namecopy);
+			name.data = namecopy;
 			name.len = namelen;
 		}
 #ifdef CONFIG_NFSD_V4
 		if (name.len > 5 && memcmp(name.data, "hash:", 5) == 0) {
 			name.len = name.len - 5;
-			memmove(name.data, name.data + 5, name.len);
+			name.data = name.data + 5;
 			cn->cn_has_legacy = true;
 		}
 #endif
-		if (!nfs4_client_to_reclaim(name, princhash, nn)) {
-			kfree(name.data);
-			kfree(princhash.data);
+		if (!nfs4_client_to_reclaim(name, princhash, nn))
 			return -EFAULT;
-		}
 		return nn->client_tracking_ops->msglen;
 	}
 	return -EFAULT;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index ed5cc5b2330aef..f390716ce3ffe7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8027,9 +8027,6 @@ nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn)
 
 /*
  * failure => all reset bets are off, nfserr_no_grace...
- *
- * The caller is responsible for freeing name.data if NULL is returned (it
- * will be freed in nfs4_remove_reclaim_record in the normal case).
  */
 struct nfs4_client_reclaim *
 nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
@@ -8038,6 +8035,22 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
 	unsigned int strhashval;
 	struct nfs4_client_reclaim *crp;
 
+	name.data = kmemdup(name.data, name.len, GFP_KERNEL);
+	if (!name.data) {
+		dprintk("%s: failed to allocate memory for name.data!\n",
+			__func__);
+		return NULL;
+	}
+	if (princhash.len) {
+		princhash.data = kmemdup(princhash.data, princhash.len, GFP_KERNEL);
+		if (!princhash.data) {
+			dprintk("%s: failed to allocate memory for princhash.data!\n",
+				__func__);
+			kfree(name.data);
+			return NULL;
+		}
+	} else
+		princhash.data = NULL;
 	crp = alloc_reclaim();
 	if (crp) {
 		strhashval = clientstr_hashval(name);
@@ -8049,6 +8062,9 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
 		crp->cr_princhash.len = princhash.len;
 		crp->cr_clp = NULL;
 		nn->reclaim_str_hashtbl_size++;
+	} else {
+		kfree(name.data);
+		kfree(princhash.data);
 	}
 	return crp;
 }
-- 
2.53.0



