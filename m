Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE19115820C;
	Tue, 18 Jun 2024 13:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716067; cv=none; b=lqCB9nKbPNhq5r+sIjg2H9/9iRvJY8fIoStMSanRLAJKHZ2kUv9Ytsk2EZDJA9CVfrYzIJifjajI9WokxgKZUG+4Z83KQU8kxkMsd55r5m/M2/i3q65AMNxTYcpA9/6uHFMgkzHdO9c93/5My1crJOEczgZPFRzOoQYSG9HZwlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716067; c=relaxed/simple;
	bh=FeJ979+WqoKaivy6tkWV4Sqr95TiROtPaOPdxA7bZwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjM89qQpYAVQAwpvmvnG1UFjzWXYbKnwMv4m9k1C5dc0iHS02cz5qOPDD3PYK6p2ASoGzsYbDzfNVGkZQ0jsn7ik+dtIYuf5bJJprGeXvfA/Uaq6ukHu5i3e6HTpsQbQRjB0553CBI+1C3V+0QCp9hBihwcDE1NmUBQ/PkT5PiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1gNRnQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1gNRnQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CF3C3277B;
	Tue, 18 Jun 2024 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716067;
	bh=FeJ979+WqoKaivy6tkWV4Sqr95TiROtPaOPdxA7bZwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1gNRnQoNnu7INWtMqxY0BZQSMtGC+CgjkmCn+/lnbRxaVgiZLa0lpTa0YixbouoZ
	 T+Beil2m/X2GqQw4TRvWNOkrwkYq65iMPDvbaF35XvkRj8qrTBAIax34BMqiXJ5TXA
	 jjVlH/gViT/MIz5pAbFUHYgjMq4hyZw5Nbxny9s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 522/770] NFSD: Remove do_nfsd_create()
Date: Tue, 18 Jun 2024 14:36:15 +0200
Message-ID: <20240618123427.462003143@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1c388f27759c5d9271d4fca081f7ee138986eb7d ]

Now that its two callers have their own version-specific instance of
this function, do_nfsd_create() is no longer used.

[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 150 --------------------------------------------------
 fs/nfsd/vfs.h |  10 ----
 2 files changed, 160 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 50451789a9444..26ae28b6f9b02 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1412,156 +1412,6 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 					rdev, resfhp);
 }
 
-/*
- * NFSv3 and NFSv4 version of nfsd_create
- */
-__be32
-do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		char *fname, int flen, struct iattr *iap,
-		struct svc_fh *resfhp, int createmode, u32 *verifier,
-	        bool *truncp, bool *created)
-{
-	struct dentry	*dentry, *dchild = NULL;
-	struct inode	*dirp;
-	__be32		err;
-	int		host_err;
-	__u32		v_mtime=0, v_atime=0;
-
-	err = nfserr_perm;
-	if (!flen)
-		goto out;
-	err = nfserr_exist;
-	if (isdotent(fname, flen))
-		goto out;
-	if (!(iap->ia_valid & ATTR_MODE))
-		iap->ia_mode = 0;
-	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_EXEC);
-	if (err)
-		goto out;
-
-	dentry = fhp->fh_dentry;
-	dirp = d_inode(dentry);
-
-	host_err = fh_want_write(fhp);
-	if (host_err)
-		goto out_nfserr;
-
-	fh_lock_nested(fhp, I_MUTEX_PARENT);
-
-	/*
-	 * Compose the response file handle.
-	 */
-	dchild = lookup_one_len(fname, dentry, flen);
-	host_err = PTR_ERR(dchild);
-	if (IS_ERR(dchild))
-		goto out_nfserr;
-
-	/* If file doesn't exist, check for permissions to create one */
-	if (d_really_is_negative(dchild)) {
-		err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
-		if (err)
-			goto out;
-	}
-
-	err = fh_compose(resfhp, fhp->fh_export, dchild, fhp);
-	if (err)
-		goto out;
-
-	if (nfsd_create_is_exclusive(createmode)) {
-		/* solaris7 gets confused (bugid 4218508) if these have
-		 * the high bit set, as do xfs filesystems without the
-		 * "bigtime" feature.  So just clear the high bits. If this is
-		 * ever changed to use different attrs for storing the
-		 * verifier, then do_open_lookup() will also need to be fixed
-		 * accordingly.
-		 */
-		v_mtime = verifier[0]&0x7fffffff;
-		v_atime = verifier[1]&0x7fffffff;
-	}
-	
-	if (d_really_is_positive(dchild)) {
-		err = 0;
-
-		switch (createmode) {
-		case NFS3_CREATE_UNCHECKED:
-			if (! d_is_reg(dchild))
-				goto out;
-			else if (truncp) {
-				/* in nfsv4, we need to treat this case a little
-				 * differently.  we don't want to truncate the
-				 * file now; this would be wrong if the OPEN
-				 * fails for some other reason.  furthermore,
-				 * if the size is nonzero, we should ignore it
-				 * according to spec!
-				 */
-				*truncp = (iap->ia_valid & ATTR_SIZE) && !iap->ia_size;
-			}
-			else {
-				iap->ia_valid &= ATTR_SIZE;
-				goto set_attr;
-			}
-			break;
-		case NFS3_CREATE_EXCLUSIVE:
-			if (   d_inode(dchild)->i_mtime.tv_sec == v_mtime
-			    && d_inode(dchild)->i_atime.tv_sec == v_atime
-			    && d_inode(dchild)->i_size  == 0 ) {
-				if (created)
-					*created = true;
-				break;
-			}
-			fallthrough;
-		case NFS4_CREATE_EXCLUSIVE4_1:
-			if (   d_inode(dchild)->i_mtime.tv_sec == v_mtime
-			    && d_inode(dchild)->i_atime.tv_sec == v_atime
-			    && d_inode(dchild)->i_size  == 0 ) {
-				if (created)
-					*created = true;
-				goto set_attr;
-			}
-			fallthrough;
-		case NFS3_CREATE_GUARDED:
-			err = nfserr_exist;
-		}
-		goto out;
-	}
-
-	if (!IS_POSIXACL(dirp))
-		iap->ia_mode &= ~current_umask();
-
-	host_err = vfs_create(dirp, dchild, iap->ia_mode, true);
-	if (host_err < 0)
-		goto out_nfserr;
-	if (created)
-		*created = true;
-
-	nfsd_check_ignore_resizing(iap);
-
-	if (nfsd_create_is_exclusive(createmode)) {
-		/* Cram the verifier into atime/mtime */
-		iap->ia_valid = ATTR_MTIME|ATTR_ATIME
-			| ATTR_MTIME_SET|ATTR_ATIME_SET;
-		/* XXX someone who knows this better please fix it for nsec */ 
-		iap->ia_mtime.tv_sec = v_mtime;
-		iap->ia_atime.tv_sec = v_atime;
-		iap->ia_mtime.tv_nsec = 0;
-		iap->ia_atime.tv_nsec = 0;
-	}
-
- set_attr:
-	err = nfsd_create_setattr(rqstp, fhp, resfhp, iap);
-
- out:
-	fh_unlock(fhp);
-	if (dchild && !IS_ERR(dchild))
-		dput(dchild);
-	fh_drop_write(fhp);
- 	return err;
- 
- out_nfserr:
-	err = nfserrno(host_err);
-	goto out;
-}
-
 /*
  * Read a symlink. On entry, *lenp must contain the maximum path length that
  * fits into the buffer. On return, it contains the true length.
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 1f32a83456b03..f99794b033a55 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -71,10 +71,6 @@ __be32		nfsd_create(struct svc_rqst *, struct svc_fh *,
 __be32		nfsd_access(struct svc_rqst *, struct svc_fh *, u32 *, u32 *);
 __be32		nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				struct svc_fh *resfhp, struct iattr *iap);
-__be32		do_nfsd_create(struct svc_rqst *, struct svc_fh *,
-				char *name, int len, struct iattr *attrs,
-				struct svc_fh *res, int createmode,
-				u32 *verifier, bool *truncp, bool *created);
 __be32		nfsd_commit(struct svc_rqst *rqst, struct svc_fh *fhp,
 				u64 offset, u32 count, __be32 *verf);
 #ifdef CONFIG_NFSD_V4
@@ -161,10 +157,4 @@ static inline __be32 fh_getattr(const struct svc_fh *fh, struct kstat *stat)
 				    AT_STATX_SYNC_AS_STAT));
 }
 
-static inline int nfsd_create_is_exclusive(int createmode)
-{
-	return createmode == NFS3_CREATE_EXCLUSIVE
-	       || createmode == NFS4_CREATE_EXCLUSIVE4_1;
-}
-
 #endif /* LINUX_NFSD_VFS_H */
-- 
2.43.0



