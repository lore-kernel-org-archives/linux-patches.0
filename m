Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1058F130E4F;
	Mon,  8 Apr 2024 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583051; cv=none; b=evPJBiHgtzjcjdeOfM5RzEtzMqUhCQaYitoMSU5yjkqyNHudcB7tEIMm6KdOPDCuKMZwHvAqp5WCSjxzg5E3tpKulHJ4V7v2369ift8yk2VpzyMdLBpBpzeMxZu/tGAd4/jEuJKIwf48Fpa15Lob3Mr3AuZ+XdEnG74d3dLfvsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583051; c=relaxed/simple;
	bh=rEDHcN7SAGKKVDH2994lVLiB7kRToJXlUHxwCBu38Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGLsNUcqQTM8BE24shpX4VklkNtAZUq7lsF8Fq45vDAkAiVEKtwRxaFUf3GzAETT0ftkc4wbMeFmGFEuQtgtt1VgvMUYTQ7bf9ky9EEILhnkpHnzA9jq7ndYUtsDUkKiIloVPU4EM/7vuBqICK+kr25ga1pJRFcI6jPNbjjZ5no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/ngkFGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/ngkFGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2259FC433F1;
	Mon,  8 Apr 2024 13:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583050;
	bh=rEDHcN7SAGKKVDH2994lVLiB7kRToJXlUHxwCBu38Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/ngkFGnlo/Nrtxh0aY1IygF5CXf9tovRGKcGjANHhp6zgZtQz7jZiCdosMKWvte5
	 +cLOxd16tpdWFYMrDJEZWqCfwmg/xrha7RFH/uSpV1bgNoL9hVgsYyprXr6Py+cLbA
	 /4XzAuBkdjpJae/4V6oMOGsr9DefNv9/JNM+W9BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	NeilBrown <neilb@suse.de>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 202/690] NFSD: simplify struct nfsfh
Date: Mon,  8 Apr 2024 14:51:08 +0200
Message-ID: <20240408125406.856793338@linuxfoundation.org>
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

[ Upstream commit d8b26071e65e80a348602b939e333242f989221b ]

Most of the fields in 'struct knfsd_fh' are 2 levels deep (a union and a
struct) and are accessed using macros like:

 #define fh_FOO fh_base.fh_new.fb_FOO

This patch makes the union and struct anonymous, so that "fh_FOO" can be
a name directly within 'struct knfsd_fh' and the #defines aren't needed.

The file handle as a whole is sometimes accessed as "fh_base" or
"fh_base.fh_pad", neither of which are particularly helpful names.
As the struct holding the filehandle is now anonymous, we
cannot use the name of that, so we union it with 'fh_raw' and use that
where the raw filehandle is needed.  fh_raw also ensure the structure is
large enough for the largest possible filehandle.

fh_raw is a 'char' array, removing any need to cast it for memcpy etc.

SVCFH_fmt() is simplified using the "%ph" printk format.  This
changes the appearance of filehandles in dprintk() debugging, making
them a little more precise.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/flexfilelayout.c |  2 +-
 fs/nfsd/lockd.c          |  2 +-
 fs/nfsd/nfs3xdr.c        |  4 ++--
 fs/nfsd/nfs4callback.c   |  2 +-
 fs/nfsd/nfs4proc.c       |  4 ++--
 fs/nfsd/nfs4state.c      |  4 ++--
 fs/nfsd/nfs4xdr.c        |  4 ++--
 fs/nfsd/nfsctl.c         |  6 ++---
 fs/nfsd/nfsfh.c          | 13 ++++-------
 fs/nfsd/nfsfh.h          | 50 ++++++++++++----------------------------
 fs/nfsd/nfsxdr.c         |  4 ++--
 11 files changed, 35 insertions(+), 60 deletions(-)

diff --git a/fs/nfsd/flexfilelayout.c b/fs/nfsd/flexfilelayout.c
index db7ef07ae50c9..2e2f1d5e9f623 100644
--- a/fs/nfsd/flexfilelayout.c
+++ b/fs/nfsd/flexfilelayout.c
@@ -61,7 +61,7 @@ nfsd4_ff_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
 		goto out_error;
 
 	fl->fh.size = fhp->fh_handle.fh_size;
-	memcpy(fl->fh.data, &fhp->fh_handle.fh_base, fl->fh.size);
+	memcpy(fl->fh.data, &fhp->fh_handle.fh_raw, fl->fh.size);
 
 	/* Give whole file layout segments */
 	seg->offset = 0;
diff --git a/fs/nfsd/lockd.c b/fs/nfsd/lockd.c
index 606fa155c28ad..46a7f9b813e52 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -35,7 +35,7 @@ nlm_fopen(struct svc_rqst *rqstp, struct nfs_fh *f, struct file **filp,
 	/* must initialize before using! but maxsize doesn't matter */
 	fh_init(&fh,0);
 	fh.fh_handle.fh_size = f->size;
-	memcpy((char*)&fh.fh_handle.fh_base, f->data, f->size);
+	memcpy(&fh.fh_handle.fh_raw, f->data, f->size);
 	fh.fh_export = NULL;
 
 	access = (mode == O_WRONLY) ? NFSD_MAY_WRITE : NFSD_MAY_READ;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 48d4f99b7f901..c69d0dc50a669 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -92,7 +92,7 @@ svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp)
 		return false;
 	fh_init(fhp, NFS3_FHSIZE);
 	fhp->fh_handle.fh_size = size;
-	memcpy(&fhp->fh_handle.fh_base, p, size);
+	memcpy(&fhp->fh_handle.fh_raw, p, size);
 
 	return true;
 }
@@ -131,7 +131,7 @@ svcxdr_encode_nfs_fh3(struct xdr_stream *xdr, const struct svc_fh *fhp)
 	*p++ = cpu_to_be32(size);
 	if (size)
 		p[XDR_QUADLEN(size) - 1] = 0;
-	memcpy(p, &fhp->fh_handle.fh_base, size);
+	memcpy(p, &fhp->fh_handle.fh_raw, size);
 
 	return true;
 }
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 97f517e9b4189..e1272a7f45220 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -121,7 +121,7 @@ static void encode_nfs_fh4(struct xdr_stream *xdr, const struct knfsd_fh *fh)
 
 	BUG_ON(length > NFS4_FHSIZE);
 	p = xdr_reserve_space(xdr, 4 + length);
-	xdr_encode_opaque(p, &fh->fh_base, length);
+	xdr_encode_opaque(p, &fh->fh_raw, length);
 }
 
 /*
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index f71af990e1e81..f5ac637b6e83d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -519,7 +519,7 @@ nfsd4_putfh(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	fh_put(&cstate->current_fh);
 	cstate->current_fh.fh_handle.fh_size = putfh->pf_fhlen;
-	memcpy(&cstate->current_fh.fh_handle.fh_base, putfh->pf_fhval,
+	memcpy(&cstate->current_fh.fh_handle.fh_raw, putfh->pf_fhval,
 	       putfh->pf_fhlen);
 	ret = fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_BYPASS_GSS);
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
@@ -1383,7 +1383,7 @@ nfsd4_setup_inter_ssc(struct svc_rqst *rqstp,
 	s_fh = &cstate->save_fh;
 
 	copy->c_fh.size = s_fh->fh_handle.fh_size;
-	memcpy(copy->c_fh.data, &s_fh->fh_handle.fh_base, copy->c_fh.size);
+	memcpy(copy->c_fh.data, &s_fh->fh_handle.fh_raw, copy->c_fh.size);
 	copy->stateid.seqid = cpu_to_be32(s_stid->si_generation);
 	memcpy(copy->stateid.other, (void *)&s_stid->si_opaque,
 	       sizeof(stateid_opaque_t));
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9b660491f3931..26c4212bcfcde 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1022,7 +1022,7 @@ static int delegation_blocked(struct knfsd_fh *fh)
 		}
 		spin_unlock(&blocked_delegations_lock);
 	}
-	hash = jhash(&fh->fh_base, fh->fh_size, 0);
+	hash = jhash(&fh->fh_raw, fh->fh_size, 0);
 	if (test_bit(hash&255, bd->set[0]) &&
 	    test_bit((hash>>8)&255, bd->set[0]) &&
 	    test_bit((hash>>16)&255, bd->set[0]))
@@ -1041,7 +1041,7 @@ static void block_delegations(struct knfsd_fh *fh)
 	u32 hash;
 	struct bloom_pair *bd = &blocked_delegations;
 
-	hash = jhash(&fh->fh_base, fh->fh_size, 0);
+	hash = jhash(&fh->fh_raw, fh->fh_size, 0);
 
 	spin_lock(&blocked_delegations_lock);
 	__set_bit(hash&255, bd->set[bd->new]);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d28b75909de89..1474af184368d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3104,7 +3104,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		p = xdr_reserve_space(xdr, fhp->fh_handle.fh_size + 4);
 		if (!p)
 			goto out_resource;
-		p = xdr_encode_opaque(p, &fhp->fh_handle.fh_base,
+		p = xdr_encode_opaque(p, &fhp->fh_handle.fh_raw,
 					fhp->fh_handle.fh_size);
 	}
 	if (bmval0 & FATTR4_WORD0_FILEID) {
@@ -3675,7 +3675,7 @@ nfsd4_encode_getfh(struct nfsd4_compoundres *resp, __be32 nfserr, struct svc_fh
 	p = xdr_reserve_space(xdr, len + 4);
 	if (!p)
 		return nfserr_resource;
-	p = xdr_encode_opaque(p, &fhp->fh_handle.fh_base, len);
+	p = xdr_encode_opaque(p, &fhp->fh_handle.fh_raw, len);
 	return 0;
 }
 
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index cb73c12925629..d0761ca8cb542 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -395,12 +395,12 @@ static ssize_t write_filehandle(struct file *file, char *buf, size_t size)
 	auth_domain_put(dom);
 	if (len)
 		return len;
-	
+
 	mesg = buf;
 	len = SIMPLE_TRANSACTION_LIMIT;
-	qword_addhex(&mesg, &len, (char*)&fh.fh_base, fh.fh_size);
+	qword_addhex(&mesg, &len, fh.fh_raw, fh.fh_size);
 	mesg[-1] = '\n';
-	return mesg - buf;	
+	return mesg - buf;
 }
 
 /*
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 149f9bbc48a4e..f3779fa72c896 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -640,16 +640,11 @@ fh_put(struct svc_fh *fhp)
 char * SVCFH_fmt(struct svc_fh *fhp)
 {
 	struct knfsd_fh *fh = &fhp->fh_handle;
+	static char buf[2+1+1+64*3+1];
 
-	static char buf[80];
-	sprintf(buf, "%d: %08x %08x %08x %08x %08x %08x",
-		fh->fh_size,
-		fh->fh_base.fh_pad[0],
-		fh->fh_base.fh_pad[1],
-		fh->fh_base.fh_pad[2],
-		fh->fh_base.fh_pad[3],
-		fh->fh_base.fh_pad[4],
-		fh->fh_base.fh_pad[5]);
+	if (fh->fh_size < 0 || fh->fh_size> 64)
+		return "bad-fh";
+	sprintf(buf, "%d: %*ph", fh->fh_size, fh->fh_size, fh->fh_raw);
 	return buf;
 }
 
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 8b5587f274a7d..d11e4b6870d68 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -43,44 +43,24 @@
  *   filesystems must not use the values '0' or '0xff'. 'See enum fid_type'
  *   in include/linux/exportfs.h for currently registered values.
  */
-struct nfs_fhbase_new {
-	union {
-		struct {
-			u8		fb_version_aux;	/* == 1 */
-			u8		fb_auth_type_aux;
-			u8		fb_fsid_type_aux;
-			u8		fb_fileid_type_aux;
-			u32		fb_auth[1];
-		/*	u32		fb_fsid[0]; floating */
-		/*	u32		fb_fileid[0]; floating */
-		};
-		struct {
-			u8		fb_version;	/* == 1 */
-			u8		fb_auth_type;
-			u8		fb_fsid_type;
-			u8		fb_fileid_type;
-			u32		fb_auth_flex[]; /* flexible-array member */
-		};
-	};
-};
 
 struct knfsd_fh {
-	unsigned int	fh_size;	/* significant for NFSv3.
-					 * Points to the current size while building
-					 * a new file handle
+	unsigned int	fh_size;	/*
+					 * Points to the current size while
+					 * building a new file handle.
 					 */
 	union {
-		u32			fh_pad[NFS4_FHSIZE/4];
-		struct nfs_fhbase_new	fh_new;
-	} fh_base;
+		char			fh_raw[NFS4_FHSIZE];
+		struct {
+			u8		fh_version;	/* == 1 */
+			u8		fh_auth_type;	/* deprecated */
+			u8		fh_fsid_type;
+			u8		fh_fileid_type;
+			u32		fh_fsid[]; /* flexible-array member */
+		};
+	};
 };
 
-#define	fh_version		fh_base.fh_new.fb_version
-#define	fh_fsid_type		fh_base.fh_new.fb_fsid_type
-#define	fh_auth_type		fh_base.fh_new.fb_auth_type
-#define	fh_fileid_type		fh_base.fh_new.fb_fileid_type
-#define	fh_fsid			fh_base.fh_new.fb_auth_flex
-
 static inline __u32 ino_t_to_u32(ino_t ino)
 {
 	return (__u32) ino;
@@ -255,7 +235,7 @@ static inline void
 fh_copy_shallow(struct knfsd_fh *dst, struct knfsd_fh *src)
 {
 	dst->fh_size = src->fh_size;
-	memcpy(&dst->fh_base, &src->fh_base, src->fh_size);
+	memcpy(&dst->fh_raw, &src->fh_raw, src->fh_size);
 }
 
 static __inline__ struct svc_fh *
@@ -270,7 +250,7 @@ static inline bool fh_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
 {
 	if (fh1->fh_size != fh2->fh_size)
 		return false;
-	if (memcmp(fh1->fh_base.fh_pad, fh2->fh_base.fh_pad, fh1->fh_size) != 0)
+	if (memcmp(fh1->fh_raw, fh2->fh_raw, fh1->fh_size) != 0)
 		return false;
 	return true;
 }
@@ -294,7 +274,7 @@ static inline bool fh_fsid_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
  */
 static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
 {
-	return ~crc32_le(0xFFFFFFFF, (unsigned char *)&fh->fh_base, fh->fh_size);
+	return ~crc32_le(0xFFFFFFFF, fh->fh_raw, fh->fh_size);
 }
 #else
 static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 26a42f87c2409..ddcc18adfeb1a 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -64,7 +64,7 @@ svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp)
 	if (!p)
 		return false;
 	fh_init(fhp, NFS_FHSIZE);
-	memcpy(&fhp->fh_handle.fh_base, p, NFS_FHSIZE);
+	memcpy(&fhp->fh_handle.fh_raw, p, NFS_FHSIZE);
 	fhp->fh_handle.fh_size = NFS_FHSIZE;
 
 	return true;
@@ -78,7 +78,7 @@ svcxdr_encode_fhandle(struct xdr_stream *xdr, const struct svc_fh *fhp)
 	p = xdr_reserve_space(xdr, NFS_FHSIZE);
 	if (!p)
 		return false;
-	memcpy(p, &fhp->fh_handle.fh_base, NFS_FHSIZE);
+	memcpy(p, &fhp->fh_handle.fh_raw, NFS_FHSIZE);
 
 	return true;
 }
-- 
2.43.0



