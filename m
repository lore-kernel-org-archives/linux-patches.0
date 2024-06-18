Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB01516B3AF;
	Tue, 18 Jun 2024 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715298; cv=none; b=WZc4qvxQf+l4bNY6YgLSkYcT+2EcjV38C/dHAHSE50lUXydcZorxTfJrBUDYlYU/30q1DWFE8Ja4xyMEYX+ELrHd3lg/2vOMClZ1n2VNiZLsPjs8Slpw6NE7BEE+D7RkRX8QOm64PrLvfOkHx5pukz/Hu3rfv5wF8burKhaNbKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715298; c=relaxed/simple;
	bh=Mc8FN2wNnnKNHzzboTG/RVLz+aSeTFRbZUY90scT/JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srnXrVPyifCG/PCzvr2nhJ0irO2cUBXRYM7a0mNJgCtw9DVka0F4mixNZWTgaWHZMrlq+/uOr6Wh6g7p1gjG7uK/KHC9XyVi5bZ54AaFIVH8DJ9EXlx0MwPSOVeTZk9z7OjaCVpAJBR6tjtE8na2OpE1Hwb+tCG5O3I+CP29XrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHJUv4/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHJUv4/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBBCC3277B;
	Tue, 18 Jun 2024 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715298;
	bh=Mc8FN2wNnnKNHzzboTG/RVLz+aSeTFRbZUY90scT/JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHJUv4/wyv/F8sfEYPXRKHOeRDYyc5pJUSeH4Q0AX0Aoc8bMcXpJiKyZGF/ecYcl1
	 b0JsN0o7vOm33agzT7xJCRAb2VlC8u//hR7ECvvFtRWqDg8CSs+d2LkzGyzz6dasIA
	 RBGgSh/Ocb47ujw9WCuYEbxoOE3R5rxKsxnLnomc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/770] nfsd: track filehandle aliasing in nfs4_files
Date: Tue, 18 Jun 2024 14:31:54 +0200
Message-ID: <20240618123417.347952381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit a0ce48375a367222989c2618fe68bf34db8c7bb7 ]

It's unusual but possible for multiple filehandles to point to the same
file.  In that case, we may end up with multiple nfs4_files referencing
the same inode.

For delegation purposes it will turn out to be useful to flag those
cases.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 37 ++++++++++++++++++++++++++++---------
 fs/nfsd/state.h     |  2 ++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 8d2d6e90bfc5e..89d5669ce1463 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4120,6 +4120,8 @@ static void nfsd4_init_file(struct svc_fh *fh, unsigned int hashval,
 	fp->fi_share_deny = 0;
 	memset(fp->fi_fds, 0, sizeof(fp->fi_fds));
 	memset(fp->fi_access, 0, sizeof(fp->fi_access));
+	fp->fi_aliased = false;
+	fp->fi_inode = d_inode(fh->fh_dentry);
 #ifdef CONFIG_NFSD_PNFS
 	INIT_LIST_HEAD(&fp->fi_lo_states);
 	atomic_set(&fp->fi_lo_recalls, 0);
@@ -4472,6 +4474,31 @@ find_file_locked(struct svc_fh *fh, unsigned int hashval)
 	return NULL;
 }
 
+static struct nfs4_file *insert_file(struct nfs4_file *new, struct svc_fh *fh,
+				     unsigned int hashval)
+{
+	struct nfs4_file *fp;
+	struct nfs4_file *ret = NULL;
+	bool alias_found = false;
+
+	spin_lock(&state_lock);
+	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash,
+				 lockdep_is_held(&state_lock)) {
+		if (fh_match(&fp->fi_fhandle, &fh->fh_handle)) {
+			if (refcount_inc_not_zero(&fp->fi_ref))
+				ret = fp;
+		} else if (d_inode(fh->fh_dentry) == fp->fi_inode)
+			fp->fi_aliased = alias_found = true;
+	}
+	if (likely(ret == NULL)) {
+		nfsd4_init_file(fh, hashval, new);
+		new->fi_aliased = alias_found;
+		ret = new;
+	}
+	spin_unlock(&state_lock);
+	return ret;
+}
+
 static struct nfs4_file * find_file(struct svc_fh *fh)
 {
 	struct nfs4_file *fp;
@@ -4495,15 +4522,7 @@ find_or_add_file(struct nfs4_file *new, struct svc_fh *fh)
 	if (fp)
 		return fp;
 
-	spin_lock(&state_lock);
-	fp = find_file_locked(fh, hashval);
-	if (likely(fp == NULL)) {
-		nfsd4_init_file(fh, hashval, new);
-		fp = new;
-	}
-	spin_unlock(&state_lock);
-
-	return fp;
+	return insert_file(new, fh, hashval);
 }
 
 /*
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 61a2d95d79233..e73bdbb1634ab 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -516,6 +516,8 @@ struct nfs4_clnt_odstate {
  */
 struct nfs4_file {
 	refcount_t		fi_ref;
+	struct inode *		fi_inode;
+	bool			fi_aliased;
 	spinlock_t		fi_lock;
 	struct hlist_node       fi_hash;	/* hash on fi_fhandle */
 	struct list_head        fi_stateids;
-- 
2.43.0



