Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97241146A88;
	Tue, 18 Jun 2024 12:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714887; cv=none; b=SJJI+UDqrNAJ4oT/Y/5rrlUTEETOw+84GMXkozclsy+Z5GKgy26/HXzqHuLG8OnjfKxsQKCAee22D/XB0cTDq3lxIX4P3i+6/M3t1ZPT0ble+ytLMQDyNTwhTdrjevspFv4svfZQwixaSC8Zcp7poaszU6IS9T/70BviUY+wZ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714887; c=relaxed/simple;
	bh=As039JXgekAkYJSVeTCt2U5yYOGRhLsX6uDQ9BRL1IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V41FdaWSd1FKJlf8pwjEuwZGFrs3UiFWBiEWkhDpNka4UA+i0+aGwR/pPdi6Q2P63kAbrdbb313frzPZ+FMVvx6+MXTVR9lWTJnw8sTRGEWinlf4AYRhqWwSZtVQW9bsVJBpNClrvAMsFqOvaT7JalYB7mn2Qd7IjZABnCF36/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hFJKi63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hFJKi63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D574C3277B;
	Tue, 18 Jun 2024 12:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714887;
	bh=As039JXgekAkYJSVeTCt2U5yYOGRhLsX6uDQ9BRL1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hFJKi63xn5k0HI0zIY/k0+aCdwRtWeChCYq5fXGi95TllkoU4B6opUkI+zpUIWHk
	 +lnfZ5E2Fl0WFhx7fD7DgH2dGy4YAzjdNeqWuk/xZ6c1ELmhRMMV6IPgC+PT2M7p2N
	 2g4bpJQ3LcM8rqkfpX9C8bgCqKY/QxGbcM7w7arA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/770] nfsd: Record NFSv4 pre/post-op attributes as non-atomic
Date: Tue, 18 Jun 2024 14:29:18 +0200
Message-ID: <20240618123411.328146767@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 716a8bc7f706eeef80ab42c99d9f210eda845c81 ]

For the case of NFSv4, specify to the client that the pre/post-op
attributes were not recorded atomically with the main operation.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c          | 3 ++-
 fs/nfsd/nfsfh.c          | 4 ++++
 fs/nfsd/nfsfh.h          | 5 +++++
 fs/nfsd/xdr4.h           | 2 +-
 include/linux/exportfs.h | 3 +++
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 48b879cfe6e3b..7412bb164fa77 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -172,5 +172,6 @@ const struct export_operations nfs_export_ops = {
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
 	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
-		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS,
+		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
+		EXPORT_OP_NOATOMIC_ATTR,
 };
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index e80a7525561d0..66f2ef67792a7 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -301,6 +301,10 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 	fhp->fh_export = exp;
 
 	switch (rqstp->rq_vers) {
+	case 4:
+		if (dentry->d_sb->s_export_op->flags & EXPORT_OP_NOATOMIC_ATTR)
+			fhp->fh_no_atomic_attr = true;
+		break;
 	case 3:
 		if (dentry->d_sb->s_export_op->flags & EXPORT_OP_NOWCC)
 			fhp->fh_no_wcc = true;
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 347d10aa62655..cb20c2cd34695 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -36,6 +36,11 @@ typedef struct svc_fh {
 	bool			fh_locked;	/* inode locked by us */
 	bool			fh_want_write;	/* remount protection taken */
 	bool			fh_no_wcc;	/* no wcc data needed */
+	bool			fh_no_atomic_attr;
+						/*
+						 * wcc data is not atomic with
+						 * operation
+						 */
 	int			fh_flags;	/* FH flags */
 #ifdef CONFIG_NFSD_V3
 	bool			fh_post_saved;	/* post-op attrs saved */
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index b4556e86e97c3..a60ff5ce1a375 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -748,7 +748,7 @@ static inline void
 set_change_info(struct nfsd4_change_info *cinfo, struct svc_fh *fhp)
 {
 	BUG_ON(!fhp->fh_pre_saved);
-	cinfo->atomic = (u32)fhp->fh_post_saved;
+	cinfo->atomic = (u32)(fhp->fh_post_saved && !fhp->fh_no_atomic_attr);
 
 	cinfo->before_change = fhp->fh_pre_change;
 	cinfo->after_change = fhp->fh_post_change;
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index d93e8a6737bb0..9f4d4bcbf251d 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -217,6 +217,9 @@ struct export_operations {
 #define	EXPORT_OP_NOSUBTREECHK		(0x2) /* no subtree checking */
 #define	EXPORT_OP_CLOSE_BEFORE_UNLINK	(0x4) /* close files before unlink */
 #define EXPORT_OP_REMOTE_FS		(0x8) /* Filesystem is remote */
+#define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
+						  atomic attribute updates
+						*/
 	unsigned long	flags;
 };
 
-- 
2.43.0



