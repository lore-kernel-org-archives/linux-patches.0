Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EF11A2FBB;
	Tue, 18 Jun 2024 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716411; cv=none; b=n9xYT1pXYmve1Our4pIqz7Wqtc+zDyNIoPDHP/KJwR1gD4PG25Ug3TXmUBJ8tSddy/tDJ+dsrw0VIHDCgH1QAmHviNQNuBEnJuu8kgBxvJWKRXATsgakwZLm8TX4v574bcT6JFhnc/DQcorQlpQtopzClC+6NiutR6uX0FTknH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716411; c=relaxed/simple;
	bh=ah8MMZRTr3CM6JydsYWs1BLZX/TU7my7vWX8rKvzFYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mopIGV9I4xiKBTD25mhoYt+RqkLSGMqJ1Wnie4sbRooTjlVqSfVRugVT4o8iN8hyYV1JuXHXsirxnNX7xLhXFnzDj4B4a5kBD9HOx11uPg+NO60hXBoiWoBSn5Hbs4JtCgP5cCGY+NPw1B0ptG76wTS1EtsGYtPBdPiQnpzrjYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpmnHbCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpmnHbCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE934C3277B;
	Tue, 18 Jun 2024 13:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716411;
	bh=ah8MMZRTr3CM6JydsYWs1BLZX/TU7my7vWX8rKvzFYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpmnHbCM8yIADpn7MkLheYNO76le5AjFvEyWgSmI4U4yJ8hQ7oI4baE00EcngaWay
	 elDV3BsJTBCYjbyjrKHjHtlmtwQKgMyik988cn+Y+U0K4j2m24m+WmPtfRttnFOY7o
	 sOFnRlr8bRIDpBJpLy2f6jkDJPyP4OJ3kc3a4EGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 637/770] NFSD: drop fname and flen args from nfsd_create_locked()
Date: Tue, 18 Jun 2024 14:38:10 +0200
Message-ID: <20240618123431.878417422@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 9558f9304ca1903090fa5d995a3269a8e82804b4 ]

nfsd_create_locked() does not use the "fname" and "flen" arguments, so
drop them from declaration and all callers.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c | 5 ++---
 fs/nfsd/vfs.c     | 5 ++---
 fs/nfsd/vfs.h     | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 749c3354304c2..7ed03ac6bdab3 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -391,9 +391,8 @@ nfsd_proc_create(struct svc_rqst *rqstp)
 	resp->status = nfs_ok;
 	if (!inode) {
 		/* File doesn't exist. Create it and set attrs */
-		resp->status = nfsd_create_locked(rqstp, dirfhp, argp->name,
-						  argp->len, &attrs, type, rdev,
-						  newfhp);
+		resp->status = nfsd_create_locked(rqstp, dirfhp, &attrs, type,
+						  rdev, newfhp);
 	} else if (type == S_IFREG) {
 		dprintk("nfsd:   existing %s, valid=%x, size=%ld\n",
 			argp->name, attr->ia_valid, (long) attr->ia_size);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index bc377ee177171..5ec1119a87859 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1273,7 +1273,7 @@ nfsd_check_ignore_resizing(struct iattr *iap)
 /* The parent directory should already be locked: */
 __be32
 nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		   char *fname, int flen, struct nfsd_attrs *attrs,
+		   struct nfsd_attrs *attrs,
 		   int type, dev_t rdev, struct svc_fh *resfhp)
 {
 	struct dentry	*dentry, *dchild;
@@ -1399,8 +1399,7 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (err)
 		goto out_unlock;
 	fh_fill_pre_attrs(fhp);
-	err = nfsd_create_locked(rqstp, fhp, fname, flen, attrs, type,
-				 rdev, resfhp);
+	err = nfsd_create_locked(rqstp, fhp, attrs, type, rdev, resfhp);
 	fh_fill_post_attrs(fhp);
 out_unlock:
 	inode_unlock(dentry->d_inode);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index c95cd414b4bb0..120521bc7b247 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -79,8 +79,8 @@ __be32		nfsd4_clone_file_range(struct svc_rqst *rqstp,
 				       u64 count, bool sync);
 #endif /* CONFIG_NFSD_V4 */
 __be32		nfsd_create_locked(struct svc_rqst *, struct svc_fh *,
-				char *name, int len, struct nfsd_attrs *attrs,
-				int type, dev_t rdev, struct svc_fh *res);
+				struct nfsd_attrs *attrs, int type, dev_t rdev,
+				struct svc_fh *res);
 __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct nfsd_attrs *attrs,
 				int type, dev_t rdev, struct svc_fh *res);
-- 
2.43.0



