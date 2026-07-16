Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB6F27732;
	Thu, 16 Jul 2026 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211652; cv=none; b=g3Jnidsb+vI0L90PVhA582+bK3RxItXSla6CRsW0+frrYKs/paiw0C8KmSsKBtc/ideFpbSDEWdDC5X8AdNsgFLbe5rTZYMl5CMIDJ8movU4vA6TzdoTU5QsfbYzOpSaPkJEK6zaqR6TfcLZ8PmI3E+xDyVaX3IeLPDNe6DhfQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211652; c=relaxed/simple;
	bh=yLaQRxOLih5K3RF+G622vRyQI/TBbfMmfbqdvSen/1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lj47Y6FP2X8O0tKSdlsLOWeJYha0Y3xkwNEEz2+0kWdorgKxNps1YaFMVG4Xz89rovDNYktqhJpfrYrKNayvP/Gk/5Z60NoNvjZ4qOyDTTVBEdqVD8pmkGyOvqw6GDNNTsIf5o6S366lW8+aX6x+04O4iNfdS6DhEUv14kPrAWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg290IVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg290IVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8403C1F000E9;
	Thu, 16 Jul 2026 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211651;
	bh=OnJ3kZePuIu/2OnsTKuaSvD1KSr8k+1WLwz5nGwv4oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kg290IVlXo/hMJo4JEkxxjVc0t4U2RUksOF3UF5o7s7j7nI3WVGe/a3oGJcAUwLEG
	 XoKvaueRlXyFKmPCfMLY/niAmFEkMMtag299ZMaLqkg8QVrX3NsMBtOvE5JGo28A16
	 MsMPUrBRcUjqD+9ElNTfxxO2l3TBTn7SIuKdxM+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/349] nfsd: change nfs4_client_to_reclaim() to allocate data
Date: Thu, 16 Jul 2026 15:29:22 +0200
Message-ID: <20260716133033.940559660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
index 4c63f46985c2ea..a8182962a28618 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -168,24 +168,13 @@ legacy_recdir_name_error(struct nfs4_client *clp, int error)
 
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
 
@@ -241,8 +230,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	inode_unlock(d_inode(dir));
 	if (status == 0) {
 		if (nn->in_grace)
-			__nfsd4_create_reclaim_record_grace(clp, dname,
-					HEXDIR_LEN, nn);
+			__nfsd4_create_reclaim_record_grace(clp, dname, nn);
 		vfs_fsync(nn->rec_file, 0);
 	} else {
 		printk(KERN_ERR "NFSD: failed to write recovery record"
@@ -479,7 +467,7 @@ nfsd4_recdir_purge_old(struct nfsd_net *nn)
 static int
 load_recdir(struct dentry *parent, char *cname, struct nfsd_net *nn)
 {
-	struct xdr_netobj name;
+	struct xdr_netobj name = { .len = HEXDIR_LEN, .data = cname };
 	struct xdr_netobj princhash = { .len = 0, .data = NULL };
 
 	if (strlen(cname) != HEXDIR_LEN - 1) {
@@ -488,16 +476,7 @@ load_recdir(struct dentry *parent, char *cname, struct nfsd_net *nn)
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
 
@@ -796,6 +775,8 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 {
 	uint8_t cmd, princhashlen;
 	struct xdr_netobj name, princhash = { .len = 0, .data = NULL };
+	char *namecopy __free(kfree) = NULL;
+	char *princhashcopy __free(kfree) = NULL;
 	uint16_t namelen;
 
 	if (get_user(cmd, &cmsg->cm_cmd)) {
@@ -813,20 +794,20 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				dprintk("%s: invalid namelen (%u)", __func__, namelen);
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
@@ -840,9 +821,10 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				dprintk("%s: invalid namelen (%u)", __func__, namelen);
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
 #ifdef CONFIG_NFSD_LEGACY_CLIENT_TRACKING
@@ -850,15 +832,12 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 			struct cld_net *cn = nn->cld_net;
 
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
index e18d70adcdb903..8c13fa68c08a84 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8557,9 +8557,6 @@ nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn)
 
 /*
  * failure => all reset bets are off, nfserr_no_grace...
- *
- * The caller is responsible for freeing name.data if NULL is returned (it
- * will be freed in nfs4_remove_reclaim_record in the normal case).
  */
 struct nfs4_client_reclaim *
 nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
@@ -8568,6 +8565,22 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
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
@@ -8579,6 +8592,9 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
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



