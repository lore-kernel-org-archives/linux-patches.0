Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0C979955;
	Mon,  8 Apr 2024 13:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584562; cv=none; b=pmG/i4Ibd0Css2pOY71SXT4OLI6EcjLpPC1gzOxg94MY0ZO0YM5zrMKbVcq/80KMuT7UHrNUSQduiP0uUPTv6sBrcgwmeMEcKWGpp8YUlQPeLDmhVdjZcHCVasL1exdmy9w1widpRDLi/zissHQu0eOVjuJJYaU6WK/mI/4U0dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584562; c=relaxed/simple;
	bh=NcyvPZCe/MzxZJx0aUP+tY492oe/7AuaSBI+9I1g53E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJgfkNPS9uJgIGjk26TGl/5BuFTzEEb5XnOz7de9+Taf9YJq1lDZTsuIWwe5ZF76T95PS2I4I1/iLSI1LxhCbJAGia3e/4XITURMSWLAJOBNI9y/mT/A+//oI77LcKQbaJVyc1knZKCfsdcGGYAOf+uf8tFaxlKvlhXl9GMG4ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMLob7Vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMLob7Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67A2C433F1;
	Mon,  8 Apr 2024 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584562;
	bh=NcyvPZCe/MzxZJx0aUP+tY492oe/7AuaSBI+9I1g53E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMLob7VfsYWQ8pNQI1wm4rQS6u07+Eg0RlmncXNgys4Y97/YnXgu1SttzzEVZKQVg
	 9j3x5jJpOr7xU0GkEVnQFCFTX+Cs9oNzCLHURl7b4eFE7Ul/OBcUHHYS6EAlj1vPKt
	 1preBgIk7EVsP9dN/Ygvw4kM5UGLp6XVE3fA6zLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 5.15 479/690] NFSD: Add an NFSD_FILE_GC flag to enable nfsd_file garbage collection
Date: Mon,  8 Apr 2024 14:55:45 +0200
Message-ID: <20240408125416.971545624@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4d1ea8455716ca070e3cd85767e6f6a562a58b1b ]

NFSv4 operations manage the lifetime of nfsd_file items they use by
means of NFSv4 OPEN and CLOSE. Hence there's no need for them to be
garbage collected.

Introduce a mechanism to enable garbage collection for nfsd_file
items used only by NFSv2/3 callers.

Note that the change in nfsd_file_put() ensures that both CLOSE and
DELEGRETURN will actually close out and free an nfsd_file on last
reference of a non-garbage-collected file.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=394
Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 63 +++++++++++++++++++++++++++++++++++++++------
 fs/nfsd/filecache.h |  3 +++
 fs/nfsd/nfs3proc.c  |  4 +--
 fs/nfsd/trace.h     |  3 ++-
 fs/nfsd/vfs.c       |  4 +--
 5 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index e429fce894316..13a25503b80e1 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -62,6 +62,7 @@ struct nfsd_file_lookup_key {
 	struct net			*net;
 	const struct cred		*cred;
 	unsigned char			need;
+	bool				gc;
 	enum nfsd_file_lookup_type	type;
 };
 
@@ -161,6 +162,8 @@ static int nfsd_file_obj_cmpfn(struct rhashtable_compare_arg *arg,
 			return 1;
 		if (!nfsd_match_cred(nf->nf_cred, key->cred))
 			return 1;
+		if (!!test_bit(NFSD_FILE_GC, &nf->nf_flags) != key->gc)
+			return 1;
 		if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0)
 			return 1;
 		break;
@@ -296,6 +299,8 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 		nf->nf_flags = 0;
 		__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
 		__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
+		if (key->gc)
+			__set_bit(NFSD_FILE_GC, &nf->nf_flags);
 		nf->nf_inode = key->inode;
 		/* nf_ref is pre-incremented for hash table */
 		refcount_set(&nf->nf_ref, 2);
@@ -427,16 +432,27 @@ nfsd_file_put_noref(struct nfsd_file *nf)
 	}
 }
 
+static void
+nfsd_file_unhash_and_put(struct nfsd_file *nf)
+{
+	if (nfsd_file_unhash(nf))
+		nfsd_file_put_noref(nf);
+}
+
 void
 nfsd_file_put(struct nfsd_file *nf)
 {
 	might_sleep();
 
-	nfsd_file_lru_add(nf);
-	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
+	if (test_bit(NFSD_FILE_GC, &nf->nf_flags))
+		nfsd_file_lru_add(nf);
+	else if (refcount_read(&nf->nf_ref) == 2)
+		nfsd_file_unhash_and_put(nf);
+
+	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
-	} else if (nf->nf_file) {
+	} else if (nf->nf_file && test_bit(NFSD_FILE_GC, &nf->nf_flags)) {
 		nfsd_file_put_noref(nf);
 		nfsd_file_schedule_laundrette();
 	} else
@@ -1015,12 +1031,14 @@ nfsd_file_is_cached(struct inode *inode)
 
 static __be32
 nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		     unsigned int may_flags, struct nfsd_file **pnf, bool open)
+		     unsigned int may_flags, struct nfsd_file **pnf,
+		     bool open, bool want_gc)
 {
 	struct nfsd_file_lookup_key key = {
 		.type	= NFSD_FILE_KEY_FULL,
 		.need	= may_flags & NFSD_FILE_MAY_MASK,
 		.net	= SVC_NET(rqstp),
+		.gc	= want_gc,
 	};
 	bool open_retry = true;
 	struct nfsd_file *nf;
@@ -1116,14 +1134,35 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 * then unhash.
 	 */
 	if (status != nfs_ok || key.inode->i_nlink == 0)
-		if (nfsd_file_unhash(nf))
-			nfsd_file_put_noref(nf);
+		nfsd_file_unhash_and_put(nf);
 	clear_bit_unlock(NFSD_FILE_PENDING, &nf->nf_flags);
 	smp_mb__after_atomic();
 	wake_up_bit(&nf->nf_flags, NFSD_FILE_PENDING);
 	goto out;
 }
 
+/**
+ * nfsd_file_acquire_gc - Get a struct nfsd_file with an open file
+ * @rqstp: the RPC transaction being executed
+ * @fhp: the NFS filehandle of the file to be opened
+ * @may_flags: NFSD_MAY_ settings for the file
+ * @pnf: OUT: new or found "struct nfsd_file" object
+ *
+ * The nfsd_file object returned by this API is reference-counted
+ * and garbage-collected. The object is retained for a few
+ * seconds after the final nfsd_file_put() in case the caller
+ * wants to re-use it.
+ *
+ * Returns nfs_ok and sets @pnf on success; otherwise an nfsstat in
+ * network byte order is returned.
+ */
+__be32
+nfsd_file_acquire_gc(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		     unsigned int may_flags, struct nfsd_file **pnf)
+{
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true, true);
+}
+
 /**
  * nfsd_file_acquire - Get a struct nfsd_file with an open file
  * @rqstp: the RPC transaction being executed
@@ -1131,6 +1170,10 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * @may_flags: NFSD_MAY_ settings for the file
  * @pnf: OUT: new or found "struct nfsd_file" object
  *
+ * The nfsd_file_object returned by this API is reference-counted
+ * but not garbage-collected. The object is unhashed after the
+ * final nfsd_file_put().
+ *
  * Returns nfs_ok and sets @pnf on success; otherwise an nfsstat in
  * network byte order is returned.
  */
@@ -1138,7 +1181,7 @@ __be32
 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true, false);
 }
 
 /**
@@ -1148,6 +1191,10 @@ nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
  * @may_flags: NFSD_MAY_ settings for the file
  * @pnf: OUT: new or found "struct nfsd_file" object
  *
+ * The nfsd_file_object returned by this API is reference-counted
+ * but not garbage-collected. The object is released immediately
+ * one RCU grace period after the final nfsd_file_put().
+ *
  * Returns nfs_ok and sets @pnf on success; otherwise an nfsstat in
  * network byte order is returned.
  */
@@ -1155,7 +1202,7 @@ __be32
 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		 unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, false);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, false, false);
 }
 
 /*
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 6b012ea4bd9da..b7efb2c3ddb18 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -38,6 +38,7 @@ struct nfsd_file {
 #define NFSD_FILE_HASHED	(0)
 #define NFSD_FILE_PENDING	(1)
 #define NFSD_FILE_REFERENCED	(2)
+#define NFSD_FILE_GC		(3)
 	unsigned long		nf_flags;
 	struct inode		*nf_inode;	/* don't deref */
 	refcount_t		nf_ref;
@@ -55,6 +56,8 @@ void nfsd_file_put(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
 bool nfsd_file_is_cached(struct inode *inode);
+__be32 nfsd_file_acquire_gc(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		  unsigned int may_flags, struct nfsd_file **nfp);
 __be32 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **nfp);
 __be32 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index ff29205463332..d01b29aba6623 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -772,8 +772,8 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 				(unsigned long long) argp->offset);
 
 	fh_copy(&resp->fh, &argp->fh);
-	resp->status = nfsd_file_acquire(rqstp, &resp->fh, NFSD_MAY_WRITE |
-					 NFSD_MAY_NOT_BREAK_LEASE, &nf);
+	resp->status = nfsd_file_acquire_gc(rqstp, &resp->fh, NFSD_MAY_WRITE |
+					    NFSD_MAY_NOT_BREAK_LEASE, &nf);
 	if (resp->status)
 		goto out;
 	resp->status = nfsd_commit(rqstp, &resp->fh, nf, argp->offset,
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 72aa7435d55bd..d449c364cc76b 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -816,7 +816,8 @@ DEFINE_CLID_EVENT(confirmed_r);
 	__print_flags(val, "|",						\
 		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\
 		{ 1 << NFSD_FILE_PENDING,	"PENDING" },		\
-		{ 1 << NFSD_FILE_REFERENCED,	"REFERENCED"})
+		{ 1 << NFSD_FILE_REFERENCED,	"REFERENCED"},		\
+		{ 1 << NFSD_FILE_GC,		"GC"})
 
 DECLARE_EVENT_CLASS(nfsd_file_class,
 	TP_PROTO(struct nfsd_file *nf),
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 3c43a51e17865..db7f0119433cf 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1149,7 +1149,7 @@ __be32 nfsd_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	__be32 err;
 
 	trace_nfsd_read_start(rqstp, fhp, offset, *count);
-	err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_READ, &nf);
+	err = nfsd_file_acquire_gc(rqstp, fhp, NFSD_MAY_READ, &nf);
 	if (err)
 		return err;
 
@@ -1181,7 +1181,7 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
 
 	trace_nfsd_write_start(rqstp, fhp, offset, *cnt);
 
-	err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_WRITE, &nf);
+	err = nfsd_file_acquire_gc(rqstp, fhp, NFSD_MAY_WRITE, &nf);
 	if (err)
 		goto out;
 
-- 
2.43.0



