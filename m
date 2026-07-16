Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346FE3CC9E8;
	Thu, 16 Jul 2026 13:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210375; cv=none; b=NqTFS+geaL+7qiGipOSNh9FK8CeYumPBZLSBiY9mmMeqtVO51RLn4srUkGfGLQZB8HE2WXIyIK8kzT/0JQZeOcj9TwctjgfL3FsuXv9sul9X/Snqz56y02C8lumxMHjWduTDIWBstmHsQQqcWINDUnqG2BWIzVP0IWkc59/MAK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210375; c=relaxed/simple;
	bh=mcyePzo8NFeHLoq/o3wQoLk76gwSX5vratFD2TxX8Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJzQYRF/N6ITfUxhLtz+4pxo6o3lDoNOnwjhm7uaX3M8/yxMI6IwjwdsONGxLFz8ZTXE7PSKP296E4uc+SZIb1V3Hhq70rsy4bTcFmQE+xXFgcCWoW4QgXLHvep7puQrsxYXdFyiDIHJfxaKgRHXfRMWmG6+MqWSBIs2Y6yGuN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEF8WzOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEF8WzOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F531F000E9;
	Thu, 16 Jul 2026 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210374;
	bh=YC0ijwQpo95i99HXAhhGEc7XnmCOWzJ+xlKL01+TAyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEF8WzOBHq4SSOcCFpFKdV1CrSf1Pb35xoJoKjY96hUbTpsPO6f+MSrS3mX6LFD7J
	 tGgd4U4k21pdk2VFxZ9xnSO1wB0oWNEq1xy3kSXsy5Evv12plyuDkIHSu9jbkA7ReW
	 iS7NHUm7H2c2gQ/WlZOqkbUi4gu76p8a3rDoasJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/480] nfsd: change nfs4_client_to_reclaim() to allocate data
Date: Thu, 16 Jul 2026 15:26:10 +0200
Message-ID: <20260716133045.198334515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8ab0b26c1f91ab..8c5b5b8a5c880a 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -147,24 +147,13 @@ legacy_recdir_name_error(struct nfs4_client *clp, int error)
 
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
 
@@ -223,8 +212,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	inode_unlock(d_inode(dir));
 	if (status == 0) {
 		if (nn->in_grace)
-			__nfsd4_create_reclaim_record_grace(clp, dname,
-					HEXDIR_LEN, nn);
+			__nfsd4_create_reclaim_record_grace(clp, dname, nn);
 		vfs_fsync(nn->rec_file, 0);
 	} else {
 		printk(KERN_ERR "NFSD: failed to write recovery record"
@@ -461,7 +449,7 @@ nfsd4_recdir_purge_old(struct nfsd_net *nn)
 static int
 load_recdir(struct dentry *parent, char *cname, struct nfsd_net *nn)
 {
-	struct xdr_netobj name;
+	struct xdr_netobj name = { .len = HEXDIR_LEN, .data = cname };
 	struct xdr_netobj princhash = { .len = 0, .data = NULL };
 
 	if (strlen(cname) != HEXDIR_LEN - 1) {
@@ -470,16 +458,7 @@ load_recdir(struct dentry *parent, char *cname, struct nfsd_net *nn)
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
 
@@ -777,6 +756,8 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 {
 	uint8_t cmd, princhashlen;
 	struct xdr_netobj name, princhash = { .len = 0, .data = NULL };
+	char *namecopy __free(kfree) = NULL;
+	char *princhashcopy __free(kfree) = NULL;
 	uint16_t namelen;
 
 	if (get_user(cmd, &cmsg->cm_cmd)) {
@@ -794,20 +775,20 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
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
@@ -821,9 +802,10 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
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
@@ -831,15 +813,12 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
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
index a063a4a83ec22d..a3e6076a3e645e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8831,9 +8831,6 @@ nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn)
 
 /*
  * failure => all reset bets are off, nfserr_no_grace...
- *
- * The caller is responsible for freeing name.data if NULL is returned (it
- * will be freed in nfs4_remove_reclaim_record in the normal case).
  */
 struct nfs4_client_reclaim *
 nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
@@ -8842,6 +8839,22 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
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
@@ -8853,6 +8866,9 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
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



