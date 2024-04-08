Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF4942046;
	Mon,  8 Apr 2024 13:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584483; cv=none; b=hOGWN8b5Co7vCwxo3soksoqL83DslV7Ovu//4M7tTVO7SUR8gDHSrzAz8O8Mnv1uU2PL2GsE4XIUe5tFXuEnSAPz7cr3tm+NWfUbwX1OKXYjmVqarxYkTYhwwGkeOrIOlLde9ys8ddgDloqqeq7LuENah3mwB+c+anUkNysVmaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584483; c=relaxed/simple;
	bh=HsLK+CH7D5qw030Pdc9pYr0hvv8WDPY92zQonQkjC+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiWip2O8XHYuusp5RM08y2P5PE4HE2SKOUrT5ZQm+9w8p3VwOXDistIBfZka0xmD+n3k43iOpNAn8iBX5P67GPKFr/3//I/KVUsjp8rNWoGJPbvfRoJG42+Uej9PLuILiWGPzLrA9t31NrxX7RoD85BQhyI4h3+mQsrJPfhttlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2ggnJV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2ggnJV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE906C433C7;
	Mon,  8 Apr 2024 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584483;
	bh=HsLK+CH7D5qw030Pdc9pYr0hvv8WDPY92zQonQkjC+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2ggnJV4SKKJ7npHhOQQtjchpfh2XehZPGW0Ymc8QSjcsvpKm9w++VKtFpKIfDIdt
	 ks5o+8f/VygiN4APC9lKl5W/dUMDMLhgyFgD9AU2CMPu/XynyscezBYp28lCi+Ij+Y
	 6ydKm5NNcfRRYGOvN7XqLYAwZC1WL49OEgmTM5pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 423/690] NFSD: drop fname and flen args from nfsd_create_locked()
Date: Mon,  8 Apr 2024 14:54:49 +0200
Message-ID: <20240408125414.929058542@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 9558f9304ca1903090fa5d995a3269a8e82804b4 ]

nfsd_create_locked() does not use the "fname" and "flen" arguments, so
drop them from declaration and all callers.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsproc.c | 5 ++---
 fs/nfsd/vfs.c     | 5 ++---
 fs/nfsd/vfs.h     | 4 ++--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 4b19cc727ea50..ee02ede74bf53 100644
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
index 343af6341e5e1..77f8ab3826d75 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1257,7 +1257,7 @@ nfsd_check_ignore_resizing(struct iattr *iap)
 /* The parent directory should already be locked: */
 __be32
 nfsd_create_locked(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		   char *fname, int flen, struct nfsd_attrs *attrs,
+		   struct nfsd_attrs *attrs,
 		   int type, dev_t rdev, struct svc_fh *resfhp)
 {
 	struct dentry	*dentry, *dchild;
@@ -1384,8 +1384,7 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
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



