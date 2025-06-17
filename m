Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F1C285048;
	Tue, 17 Jun 2025 16:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178558; cv=none; b=aW9CI5USgm8sppgC3S+y+VlRxNwO0tbJSGqGyWYf2/dWycVP3qYvh293qwOpVb3N1vNqZdzJv5uS9PyV2RLhk3YjzgHohTqN+7eP/PUQeYp9DXXCgBZKkO8ahXF6cVmSEgJpcJBZUuj3UGnggkwgtUA96bVC51hL/GvXordBgIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178558; c=relaxed/simple;
	bh=Ii4pDaX26HXs2siS6sMxh9Gbwvy9qJ7jJYV83mdMVt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqtZz8fS84CvVFMdUqIgCf1fbqzvCowq2+HvenaN4qorH98HOgSBQfQ/Nux53cpg2IJ2QnV+5gmpVaJaB0IMfOQVvyzXePqLlv3kJ5HmyByfAJ9i/23j3e3/cbOJDThQnT3F+QHgwmquvE3i8XZ+1bzoNvl16wVKFxVQREuHGBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4snEUR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4snEUR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EA0C4CEE3;
	Tue, 17 Jun 2025 16:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178558;
	bh=Ii4pDaX26HXs2siS6sMxh9Gbwvy9qJ7jJYV83mdMVt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4snEUR/CzhBynfXE/LW9Dnsc65IKEg8R+kfoau5BUy38biry8AbfXaPE1h3jsDjJ
	 CjVMBe7g3S7B8JEn7zn/jJIqaRGLQya/84Y+/mzgb90RyPLYX56w3sBL/9qdAOiuKC
	 4LsQ4RqaBPcVBOGPISpNhva2PgXXwQg4F5AKkuZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <anna@kernel.org>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 476/780] nfs: fix incorrect handling of large-number NFS errors in nfs4_do_mkdir()
Date: Tue, 17 Jun 2025 17:23:04 +0200
Message-ID: <20250617152510.875149016@linuxfoundation.org>
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

[ Upstream commit dd862da61e91123ca745e06c03ba39ce71a929d9 ]

A recent commit introduced nfs4_do_mkdir() which reports an error from
nfs4_call_sync() by returning it with ERR_PTR().

This is a problem as nfs4_call_sync() can return negative NFS-specific
errors with values larger than MAX_ERRNO (4095).  One example is
NFS4ERR_DELAY which has value 10008.

This "pointer" gets to PTR_ERR_OR_ZERO() in nfs4_proc_mkdir() which
chooses ZERO because it isn't in the range of value errors.  Ultimately
the pointer is dereferenced.

This patch changes nfs4_do_mkdir() to report the dentry pointer and
status separately - pointer as a return value, status in an "int *"
parameter.

The same separation is used for _nfs4_proc_mkdir() and the two are
combined only in nfs4_proc_mkdir() after the status has passed through
nfs4_handle_exception(), which ensures the error code does not exceed
MAX_ERRNO.

It also fixes a problem in the even when nfs4_handle_exception() updated
the error value, the original 'alias' was still returned.

Reported-by: Anna Schumaker <anna@kernel.org>
Fixes: 8376583b84a1 ("nfs: change mkdir inode_operation to return alternate dentry if needed.")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b1d2122bd5a74..4b123bca65e12 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5164,13 +5164,15 @@ static int nfs4_do_create(struct inode *dir, struct dentry *dentry, struct nfs4_
 }
 
 static struct dentry *nfs4_do_mkdir(struct inode *dir, struct dentry *dentry,
-				    struct nfs4_createdata *data)
+				    struct nfs4_createdata *data, int *statusp)
 {
-	int status = nfs4_call_sync(NFS_SERVER(dir)->client, NFS_SERVER(dir), &data->msg,
+	struct dentry *ret;
+
+	*statusp = nfs4_call_sync(NFS_SERVER(dir)->client, NFS_SERVER(dir), &data->msg,
 				    &data->arg.seq_args, &data->res.seq_res, 1);
 
-	if (status)
-		return ERR_PTR(status);
+	if (*statusp)
+		return NULL;
 
 	spin_lock(&dir->i_lock);
 	/* Creating a directory bumps nlink in the parent */
@@ -5179,7 +5181,11 @@ static struct dentry *nfs4_do_mkdir(struct inode *dir, struct dentry *dentry,
 				      data->res.fattr->time_start,
 				      NFS_INO_INVALID_DATA);
 	spin_unlock(&dir->i_lock);
-	return nfs_add_or_obtain(dentry, data->res.fh, data->res.fattr);
+	ret = nfs_add_or_obtain(dentry, data->res.fh, data->res.fattr);
+	if (!IS_ERR(ret))
+		return ret;
+	*statusp = PTR_ERR(ret);
+	return NULL;
 }
 
 static void nfs4_free_createdata(struct nfs4_createdata *data)
@@ -5240,17 +5246,18 @@ static int nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 
 static struct dentry *_nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 				       struct iattr *sattr,
-				       struct nfs4_label *label)
+				       struct nfs4_label *label, int *statusp)
 {
 	struct nfs4_createdata *data;
-	struct dentry *ret = ERR_PTR(-ENOMEM);
+	struct dentry *ret = NULL;
 
+	*statusp = -ENOMEM;
 	data = nfs4_alloc_createdata(dir, &dentry->d_name, sattr, NF4DIR);
 	if (data == NULL)
 		goto out;
 
 	data->arg.label = label;
-	ret = nfs4_do_mkdir(dir, dentry, data);
+	ret = nfs4_do_mkdir(dir, dentry, data, statusp);
 
 	nfs4_free_createdata(data);
 out:
@@ -5273,11 +5280,12 @@ static struct dentry *nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 	if (!(server->attr_bitmask[2] & FATTR4_WORD2_MODE_UMASK))
 		sattr->ia_mode &= ~current_umask();
 	do {
-		alias = _nfs4_proc_mkdir(dir, dentry, sattr, label);
-		err = PTR_ERR_OR_ZERO(alias);
+		alias = _nfs4_proc_mkdir(dir, dentry, sattr, label, &err);
 		trace_nfs4_mkdir(dir, &dentry->d_name, err);
-		err = nfs4_handle_exception(NFS_SERVER(dir), err,
-				&exception);
+		if (err)
+			alias = ERR_PTR(nfs4_handle_exception(NFS_SERVER(dir),
+							      err,
+							      &exception));
 	} while (exception.retry);
 	nfs4_label_release_security(label);
 
-- 
2.39.5



