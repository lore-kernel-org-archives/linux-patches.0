Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A47216DC24;
	Tue, 18 Jun 2024 13:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715680; cv=none; b=Tbsy1qA0SE/vET5P+QLGBHY0OO1iKauXwrGiew50FjnJ0ZSL5I+V/4nAglLtXnllUPkEima6Jw0QbEJJpX1BteuHrLT2Ajqq+FDzygL1PqyfF+OpbdP3+8vt7Z0niBFINSwMQ5n1yezM8OFeVqogZTvHjnH3F1lAZsMFAM8geE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715680; c=relaxed/simple;
	bh=Un8KLqL1dRu5vsAoz14/LcwAeHf4/Qsf+Jv8xBnvQrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5Ucn7cstbVVTjxcAN+FK4SfujDataPdCVj2L60QyntfPE02lWjo6pc90jPsBISqUx7sjsi7CC921zRGmWKsY/IV6aEYI4I5sOAJ1/G7iLI0Wr5timyU0tVbNpyrluDb+gaAcDXy8Hob9eAqe0bsM+RNFFaGo6y+V6e3hYfabsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM+UD3XD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM+UD3XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEB9C3277B;
	Tue, 18 Jun 2024 13:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715680;
	bh=Un8KLqL1dRu5vsAoz14/LcwAeHf4/Qsf+Jv8xBnvQrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EM+UD3XDu2QP6bolNRTJfvHO/cMlcT29u8kRmL+//9lIpkPNfsRGp95TOfQ0k24mo
	 CAlT2xIwCk8W5r1/uQ0Q+GJY8rZU+EFRE/figS4nlgvMMiFFo3znMwgpW6S6XLLGga
	 lTdVwpzZ2frbBjX7umKHSfX7Q7gLsEXO/dKzsH9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/770] NFSD: drop support for ancient filehandles
Date: Tue, 18 Jun 2024 14:34:04 +0200
Message-ID: <20240618123422.372288002@linuxfoundation.org>
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

[ Upstream commit c645a883df34ee10b884ec921e850def54b7f461 ]

Filehandles not in the "new" or "version 1" format have not been handed
out for new mounts since Linux 2.4 which was released 20 years ago.
I think it is safe to say that no such file handles are still in use,
and that we can drop support for them.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsfh.c | 160 +++++++++++++++---------------------------------
 fs/nfsd/nfsfh.h |  34 +---------
 2 files changed, 54 insertions(+), 140 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 04930056222b7..7e5a508173a04 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -153,11 +153,12 @@ static inline __be32 check_pseudo_root(struct svc_rqst *rqstp,
 static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 {
 	struct knfsd_fh	*fh = &fhp->fh_handle;
-	struct fid *fid = NULL, sfid;
+	struct fid *fid = NULL;
 	struct svc_export *exp;
 	struct dentry *dentry;
 	int fileid_type;
 	int data_left = fh->fh_size/4;
+	int len;
 	__be32 error;
 
 	error = nfserr_stale;
@@ -166,48 +167,35 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 	if (rqstp->rq_vers == 4 && fh->fh_size == 0)
 		return nfserr_nofilehandle;
 
-	if (fh->fh_version == 1) {
-		int len;
-
-		if (--data_left < 0)
-			return error;
-		if (fh->fh_auth_type != 0)
-			return error;
-		len = key_len(fh->fh_fsid_type) / 4;
-		if (len == 0)
-			return error;
-		if  (fh->fh_fsid_type == FSID_MAJOR_MINOR) {
-			/* deprecated, convert to type 3 */
-			len = key_len(FSID_ENCODE_DEV)/4;
-			fh->fh_fsid_type = FSID_ENCODE_DEV;
-			/*
-			 * struct knfsd_fh uses host-endian fields, which are
-			 * sometimes used to hold net-endian values. This
-			 * confuses sparse, so we must use __force here to
-			 * keep it from complaining.
-			 */
-			fh->fh_fsid[0] = new_encode_dev(MKDEV(ntohl((__force __be32)fh->fh_fsid[0]),
-							ntohl((__force __be32)fh->fh_fsid[1])));
-			fh->fh_fsid[1] = fh->fh_fsid[2];
-		}
-		data_left -= len;
-		if (data_left < 0)
-			return error;
-		exp = rqst_exp_find(rqstp, fh->fh_fsid_type, fh->fh_fsid);
-		fid = (struct fid *)(fh->fh_fsid + len);
-	} else {
-		__u32 tfh[2];
-		dev_t xdev;
-		ino_t xino;
-
-		if (fh->fh_size != NFS_FHSIZE)
-			return error;
-		/* assume old filehandle format */
-		xdev = old_decode_dev(fh->ofh_xdev);
-		xino = u32_to_ino_t(fh->ofh_xino);
-		mk_fsid(FSID_DEV, tfh, xdev, xino, 0, NULL);
-		exp = rqst_exp_find(rqstp, FSID_DEV, tfh);
+	if (fh->fh_version != 1)
+		return error;
+
+	if (--data_left < 0)
+		return error;
+	if (fh->fh_auth_type != 0)
+		return error;
+	len = key_len(fh->fh_fsid_type) / 4;
+	if (len == 0)
+		return error;
+	if (fh->fh_fsid_type == FSID_MAJOR_MINOR) {
+		/* deprecated, convert to type 3 */
+		len = key_len(FSID_ENCODE_DEV)/4;
+		fh->fh_fsid_type = FSID_ENCODE_DEV;
+		/*
+		 * struct knfsd_fh uses host-endian fields, which are
+		 * sometimes used to hold net-endian values. This
+		 * confuses sparse, so we must use __force here to
+		 * keep it from complaining.
+		 */
+		fh->fh_fsid[0] = new_encode_dev(MKDEV(ntohl((__force __be32)fh->fh_fsid[0]),
+						      ntohl((__force __be32)fh->fh_fsid[1])));
+		fh->fh_fsid[1] = fh->fh_fsid[2];
 	}
+	data_left -= len;
+	if (data_left < 0)
+		return error;
+	exp = rqst_exp_find(rqstp, fh->fh_fsid_type, fh->fh_fsid);
+	fid = (struct fid *)(fh->fh_fsid + len);
 
 	error = nfserr_stale;
 	if (IS_ERR(exp)) {
@@ -252,18 +240,7 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 	if (rqstp->rq_vers > 2)
 		error = nfserr_badhandle;
 
-	if (fh->fh_version != 1) {
-		sfid.i32.ino = fh->ofh_ino;
-		sfid.i32.gen = fh->ofh_generation;
-		sfid.i32.parent_ino = fh->ofh_dirino;
-		fid = &sfid;
-		data_left = 3;
-		if (fh->ofh_dirino == 0)
-			fileid_type = FILEID_INO32_GEN;
-		else
-			fileid_type = FILEID_INO32_GEN_PARENT;
-	} else
-		fileid_type = fh->fh_fileid_type;
+	fileid_type = fh->fh_fileid_type;
 
 	if (fileid_type == FILEID_ROOT)
 		dentry = dget(exp->ex_path.dentry);
@@ -451,20 +428,6 @@ static void _fh_update(struct svc_fh *fhp, struct svc_export *exp,
 	}
 }
 
-/*
- * for composing old style file handles
- */
-static inline void _fh_update_old(struct dentry *dentry,
-				  struct svc_export *exp,
-				  struct knfsd_fh *fh)
-{
-	fh->ofh_ino = ino_t_to_u32(d_inode(dentry)->i_ino);
-	fh->ofh_generation = d_inode(dentry)->i_generation;
-	if (d_is_dir(dentry) ||
-	    (exp->ex_flags & NFSEXP_NOSUBTREECHECK))
-		fh->ofh_dirino = 0;
-}
-
 static bool is_root_export(struct svc_export *exp)
 {
 	return exp->ex_path.dentry == exp->ex_path.dentry->d_sb->s_root;
@@ -561,9 +524,6 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
 	/* ref_fh is a reference file handle.
 	 * if it is non-null and for the same filesystem, then we should compose
 	 * a filehandle which is of the same version, where possible.
-	 * Currently, that means that if ref_fh->fh_handle.fh_version == 0xca
-	 * Then create a 32byte filehandle using nfs_fhbase_old
-	 *
 	 */
 
 	struct inode * inode = d_inode(dentry);
@@ -599,35 +559,21 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
 	fhp->fh_dentry = dget(dentry); /* our internal copy */
 	fhp->fh_export = exp_get(exp);
 
-	if (fhp->fh_handle.fh_version == 0xca) {
-		/* old style filehandle please */
-		memset(&fhp->fh_handle.fh_base, 0, NFS_FHSIZE);
-		fhp->fh_handle.fh_size = NFS_FHSIZE;
-		fhp->fh_handle.ofh_dcookie = 0xfeebbaca;
-		fhp->fh_handle.ofh_dev =  old_encode_dev(ex_dev);
-		fhp->fh_handle.ofh_xdev = fhp->fh_handle.ofh_dev;
-		fhp->fh_handle.ofh_xino =
-			ino_t_to_u32(d_inode(exp->ex_path.dentry)->i_ino);
-		fhp->fh_handle.ofh_dirino = ino_t_to_u32(parent_ino(dentry));
-		if (inode)
-			_fh_update_old(dentry, exp, &fhp->fh_handle);
-	} else {
-		fhp->fh_handle.fh_size =
-			key_len(fhp->fh_handle.fh_fsid_type) + 4;
-		fhp->fh_handle.fh_auth_type = 0;
-
-		mk_fsid(fhp->fh_handle.fh_fsid_type,
-			fhp->fh_handle.fh_fsid,
-			ex_dev,
-			d_inode(exp->ex_path.dentry)->i_ino,
-			exp->ex_fsid, exp->ex_uuid);
-
-		if (inode)
-			_fh_update(fhp, exp, dentry);
-		if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID) {
-			fh_put(fhp);
-			return nfserr_opnotsupp;
-		}
+	fhp->fh_handle.fh_size =
+		key_len(fhp->fh_handle.fh_fsid_type) + 4;
+	fhp->fh_handle.fh_auth_type = 0;
+
+	mk_fsid(fhp->fh_handle.fh_fsid_type,
+		fhp->fh_handle.fh_fsid,
+		ex_dev,
+		d_inode(exp->ex_path.dentry)->i_ino,
+		exp->ex_fsid, exp->ex_uuid);
+
+	if (inode)
+		_fh_update(fhp, exp, dentry);
+	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID) {
+		fh_put(fhp);
+		return nfserr_opnotsupp;
 	}
 
 	return 0;
@@ -648,16 +594,12 @@ fh_update(struct svc_fh *fhp)
 	dentry = fhp->fh_dentry;
 	if (d_really_is_negative(dentry))
 		goto out_negative;
-	if (fhp->fh_handle.fh_version != 1) {
-		_fh_update_old(dentry, fhp->fh_export, &fhp->fh_handle);
-	} else {
-		if (fhp->fh_handle.fh_fileid_type != FILEID_ROOT)
-			return 0;
+	if (fhp->fh_handle.fh_fileid_type != FILEID_ROOT)
+		return 0;
 
-		_fh_update(fhp, fhp->fh_export, dentry);
-		if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID)
-			return nfserr_opnotsupp;
-	}
+	_fh_update(fhp, fhp->fh_export, dentry);
+	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID)
+		return nfserr_opnotsupp;
 	return 0;
 out_bad:
 	printk(KERN_ERR "fh_update: fh not verified!\n");
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index ad47f16676a8c..8b5587f274a7d 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -14,26 +14,7 @@
 #include <linux/exportfs.h>
 #include <linux/nfs4.h>
 
-
-/*
- * This is the old "dentry style" Linux NFSv2 file handle.
- *
- * The xino and xdev fields are currently used to transport the
- * ino/dev of the exported inode.
- */
-struct nfs_fhbase_old {
-	u32		fb_dcookie;	/* dentry cookie - always 0xfeebbaca */
-	u32		fb_ino;		/* our inode number */
-	u32		fb_dirino;	/* dir inode number, 0 for directories */
-	u32		fb_dev;		/* our device */
-	u32		fb_xdev;
-	u32		fb_xino;
-	u32		fb_generation;
-};
-
 /*
- * This is the new flexible, extensible style NFSv2/v3/v4 file handle.
- *
  * The file handle starts with a sequence of four-byte words.
  * The first word contains a version number (1) and three descriptor bytes
  * that tell how the remaining 3 variable length fields should be handled.
@@ -57,7 +38,7 @@ struct nfs_fhbase_old {
  *     6  - 16 byte uuid
  *     7  - 8 byte inode number and 16 byte uuid
  *
- * The fileid_type identified how the file within the filesystem is encoded.
+ * The fileid_type identifies how the file within the filesystem is encoded.
  *   The values for this field are filesystem specific, exccept that
  *   filesystems must not use the values '0' or '0xff'. 'See enum fid_type'
  *   in include/linux/exportfs.h for currently registered values.
@@ -65,7 +46,7 @@ struct nfs_fhbase_old {
 struct nfs_fhbase_new {
 	union {
 		struct {
-			u8		fb_version_aux;	/* == 1, even => nfs_fhbase_old */
+			u8		fb_version_aux;	/* == 1 */
 			u8		fb_auth_type_aux;
 			u8		fb_fsid_type_aux;
 			u8		fb_fileid_type_aux;
@@ -74,7 +55,7 @@ struct nfs_fhbase_new {
 		/*	u32		fb_fileid[0]; floating */
 		};
 		struct {
-			u8		fb_version;	/* == 1, even => nfs_fhbase_old */
+			u8		fb_version;	/* == 1 */
 			u8		fb_auth_type;
 			u8		fb_fsid_type;
 			u8		fb_fileid_type;
@@ -89,20 +70,11 @@ struct knfsd_fh {
 					 * a new file handle
 					 */
 	union {
-		struct nfs_fhbase_old	fh_old;
 		u32			fh_pad[NFS4_FHSIZE/4];
 		struct nfs_fhbase_new	fh_new;
 	} fh_base;
 };
 
-#define ofh_dcookie		fh_base.fh_old.fb_dcookie
-#define ofh_ino			fh_base.fh_old.fb_ino
-#define ofh_dirino		fh_base.fh_old.fb_dirino
-#define ofh_dev			fh_base.fh_old.fb_dev
-#define ofh_xdev		fh_base.fh_old.fb_xdev
-#define ofh_xino		fh_base.fh_old.fb_xino
-#define ofh_generation		fh_base.fh_old.fb_generation
-
 #define	fh_version		fh_base.fh_new.fb_version
 #define	fh_fsid_type		fh_base.fh_new.fb_fsid_type
 #define	fh_auth_type		fh_base.fh_new.fb_auth_type
-- 
2.43.0



