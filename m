Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620951;
	b=g1V0yOzWblJQS3AGofROA5oH0H09aF7B9nW68GQ2tnHZD4p1GWULbgsjCYcwuWu4Z2Mg
	 xbBULuZL0wt+t7Zru2LUIaiJQoACVEwAxsCFzffjGDwYLH7AcSOpJ4UxDtzIknq7cB1Qg
	 /cXg4Dg57uNYhF79W8uwH95WVpCR4zI2CUNXdlFJSfLGinj3F9xn9ZWm0oaB0mUYyQsiN
	 beUNQ/BPdbVvAVfAs+jz5xVTnC96Mdr0TRwIvJ+L7gDC13BXMl3xbWrsdYceNb0rM03R+
	 KtFTkA5F3shmrQL+5CMHaZvCVF9rPkv/ICm11y+hIAsIvNOFCbL517ZAGFqwAY9AVPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdwxsgj4m5tE+10x/DbcudIIBM10evzxRJkWQgAz3+g=;
	b=1fniu2+xXnF+ye9KcyX4g4RDbBezmdszMQplSrxfKbkr14IMxDDM6PgoF52WcDuznEr9
	 vZr5qHVOSoYObHAVTqctbWij1NZDjGG4WNuOiKTrKBCs4zvOjXtMHvgzXlGkwMQiKDvQ4
	 sr5oMzyUAzt/LRQFUTaQ/PtQYVKBvaTfvZmrlvwxFDuXbZ46cLvZ3W6rq+qUQ8IElRotN
	 M4JMbgaM/iIaVK8CacwOk4ZVxstBywevCyG7uwnGaGocl5BBMeBdhh5oFI5veJsv8/gVu
	 GoaFmyJEuXgXfd7WzbFtvxdrnn/OCVvsbLDXgqTj5S6BCe6dWxqdQ+4DMW5iKAUD/2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2dyiVva3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EEA60A380B;
	Wed, 25 Nov 2026 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2dyiVva3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7EE1F0089F;
	Wed, 25 Nov 2026 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620950;
	bh=bdwxsgj4m5tE+10x/DbcudIIBM10evzxRJkWQgAz3+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dyiVva37ai8hCKg+gWjomSZA0HRGgjr195H/9UgxrUSGfzEPx+9d+yLlIX8nPFbd
	 HZlYcznf0iIhMaf3Sdiv0yHMphfcgRHKUpPlr/oBnUXBUY4Nwbc8uVhM/mMuI9WZpL
	 3guHy1+kH2f6wxl2yctVZFOj5KqkcvRD65tZk2o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/990] 9p: Enable symlink caching in page cache
Date: Wed, 25 Nov 2026 15:24:02 +0100
Message-ID: <20261125143823.844730239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 712da38d134b6681946368dd5c9400b43eb772b0 ]

Currently, when cache=loose is enabled, file reads are cached in the
page cache, but symlink reads are not. This patch allows the results
of p9_client_readlink() to be stored in the page cache, eliminating
the need for repeated 9P transactions on subsequent symlink accesses.

This change improves performance for workloads that involve frequent
symlink resolution.

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Message-ID: <982462d17c0c0d2856763266a25eb04d080c1dbb.1779355927.git.repk@triplefau.lt>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: a3a6212c7d67 ("9p: treat read return values of 0 as EOF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_addr.c       | 38 ++++++++++++++++++++++++++---
 fs/9p/vfs_inode.c      |  6 +++--
 fs/9p/vfs_inode_dotl.c | 54 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 6bf5973445b66..0a77ce5d11767 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -97,11 +97,34 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
 	struct p9_fid *fid = rreq->netfs_priv;
+	char *target;
 	unsigned long long pos = subreq->start + subreq->transferred;
-	int total, err;
-
-	total = p9_client_read(fid, pos, &subreq->io_iter, &err);
+	int total = 0, err, len, n;
+
+	if (S_ISLNK(rreq->inode->i_mode)) {
+		/* p9_client_readlink() must not be called for legacy protocols
+		 * 9p2000 or 9p2000.u.
+		 */
+		BUG_ON(!p9_is_proto_dotl(fid->clnt));
+		if (WARN_ON_ONCE(pos)) {
+			/* reading a link at a non null offset should
+			 * not happen
+			 */
+			err = -EIO;
+			goto fill_subreq;
+		}
+		err = p9_client_readlink(fid, &target);
+		if (err != 0)
+			goto fill_subreq;
+		len = strlen(target);
+		n = copy_to_iter(target, len, &subreq->io_iter);
+		kfree(target);
+		total = n;
+	} else {
+		total = p9_client_read(fid, pos, &subreq->io_iter, &err);
+	}
 
+fill_subreq:
 	/* if we just extended the file size, any portion not in
 	 * cache won't be on server and is zeroes */
 	if (subreq->rreq->origin != NETFS_UNBUFFERED_READ &&
@@ -126,6 +149,7 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
 static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
 	struct p9_fid *fid;
+	struct dentry *dentry;
 	bool writing = (rreq->origin == NETFS_READ_FOR_WRITE ||
 			rreq->origin == NETFS_WRITETHROUGH ||
 			rreq->origin == NETFS_UNBUFFERED_WRITE ||
@@ -142,6 +166,14 @@ static int v9fs_init_request(struct netfs_io_request *rreq, struct file *file)
 		if (!fid)
 			goto no_fid;
 		p9_fid_get(fid);
+	} else if (S_ISLNK(rreq->inode->i_mode)) {
+		dentry = d_find_any_alias(rreq->inode);
+		if (!dentry)
+			goto no_fid;
+		fid = v9fs_fid_lookup(dentry);
+		dput(dentry);
+		if (IS_ERR(fid))
+			goto no_fid;
 	} else {
 		fid = v9fs_fid_find_inode(rreq->inode, writing, INVALID_UID, true);
 		if (!fid)
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 34fda75c77607..7af14775dffaf 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -302,10 +302,12 @@ int v9fs_init_inode(struct v9fs_session_info *v9ses,
 			goto error;
 		}
 
-		if (v9fs_proto_dotl(v9ses))
+		if (v9fs_proto_dotl(v9ses)) {
 			inode->i_op = &v9fs_symlink_inode_operations_dotl;
-		else
+			inode_nohighmem(inode);
+		} else {
 			inode->i_op = &v9fs_symlink_inode_operations;
+		}
 
 		break;
 	case S_IFDIR:
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index cbc72a17b01a8..72aca3106d76f 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -686,9 +686,11 @@ v9fs_vfs_symlink_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	int err;
 	kgid_t gid;
 	const unsigned char *name;
+	struct v9fs_session_info *v9ses;
 	struct p9_qid qid;
 	struct p9_fid *dfid;
 	struct p9_fid *fid = NULL;
+	struct inode *inode;
 
 	name = dentry->d_name.name;
 	p9_debug(P9_DEBUG_VFS, "%lu,%s,%s\n", dir->i_ino, name, symname);
@@ -712,6 +714,26 @@ v9fs_vfs_symlink_dotl(struct mnt_idmap *idmap, struct inode *dir,
 
 	v9fs_invalidate_inode_attr(dir);
 
+	/* instantiate inode and assign the unopened fid to the dentry */
+	fid = p9_client_walk(dfid, 1, &name, 1);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n",
+			 err);
+		goto error;
+	}
+
+	v9ses = v9fs_inode2v9ses(dir);
+	inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		p9_debug(P9_DEBUG_VFS, "inode creation failed %d\n",
+			 err);
+		goto error;
+	}
+	v9fs_fid_add(dentry, &fid);
+	d_instantiate(dentry, inode);
+	err = 0;
 error:
 	p9_fid_put(fid);
 	p9_fid_put(dfid);
@@ -853,16 +875,18 @@ v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
 }
 
 /**
- * v9fs_vfs_get_link_dotl - follow a symlink path
+ * v9fs_vfs_get_link_nocache_dotl - Resolve a symlink directly.
+ *
+ * To be used when symlink caching is not enabled.
+ *
  * @dentry: dentry for symlink
  * @inode: inode for symlink
  * @done: destructor for return value
  */
-
 static const char *
-v9fs_vfs_get_link_dotl(struct dentry *dentry,
-		       struct inode *inode,
-		       struct delayed_call *done)
+v9fs_vfs_get_link_nocache_dotl(struct dentry *dentry,
+			       struct inode *inode,
+			       struct delayed_call *done)
 {
 	struct p9_fid *fid;
 	char *target;
@@ -884,6 +908,26 @@ v9fs_vfs_get_link_dotl(struct dentry *dentry,
 	return target;
 }
 
+/**
+ * v9fs_vfs_get_link_dotl - follow a symlink path
+ * @dentry: dentry for symlink
+ * @inode: inode for symlink
+ * @done: destructor for return value
+ */
+static const char *
+v9fs_vfs_get_link_dotl(struct dentry *dentry,
+		       struct inode *inode,
+		       struct delayed_call *done)
+{
+	struct v9fs_session_info *v9ses;
+
+	v9ses = v9fs_inode2v9ses(inode);
+	if (v9ses->cache & (CACHE_META|CACHE_LOOSE))
+		return page_get_link(dentry, inode, done);
+
+	return v9fs_vfs_get_link_nocache_dotl(dentry, inode, done);
+}
+
 int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
 {
 	struct p9_stat_dotl *st;
-- 
2.53.0



