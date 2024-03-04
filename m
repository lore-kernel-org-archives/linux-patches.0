Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194F79DCA;
	Mon,  4 Mar 2024 21:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589047; cv=none; b=QMXYpIjgqZ3l7BPwcp4Av+WsO/lckir2iVaOJ70ufG8XIVz6xLIMwVCqumGyLTcUWkeds1soqZKRVPlnoypsFenyxBjYr/a/zx/DoBYclK5fVq8IpL8fcfD2xw3BEmK0+j3ceBVEv6yf1sG9cs0s0LGWBnmxorgU3I36xmJhbjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589047; c=relaxed/simple;
	bh=HsTvfgKW2A9EgsM+uFua0IQ5JxZb7B/CNvVFKDZUbIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggw9A6PmjlRXyRj5CTOgkArQYTyOo3A1IMdd84uFWixYi4AIFQKNTCHjbKJUuu3X1tD/BSxB9DrYJHVAqEa7uXTyAHljbWRIWQ3t+r9DjREUOSD0n9JD5PvJDmzesJ0YYmpc3DBLbS1D5Ztsr/3/wF33kEYqwwVWAj8XEOwlDco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5FhnRdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5FhnRdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A81C433C7;
	Mon,  4 Mar 2024 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589046;
	bh=HsTvfgKW2A9EgsM+uFua0IQ5JxZb7B/CNvVFKDZUbIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5FhnRdRyCIZpp0QGHyqGVPC1g5uJMfe2J5zwsuW+TyGCe/yAleyWX96uP1gedLH6
	 SSXP6X+ipxKvUAZwG8J2SvT8+Th/0z+zvXLnEYmUfLV1IQqsZ93kqRERSX//s00ntt
	 O9yHex2/zu0HL4U/3qPRwbCfXTyKS4yUkvo4ed40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 146/215] nfsd: move nfserrno() to vfs.c
Date: Mon,  4 Mar 2024 21:23:29 +0000
Message-ID: <20240304211601.669629174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit cb12fae1c34b1fa7eaae92c5aadc72d86d7fae19 ]

nfserrno() is common to all nfs versions, but nfsproc.c is specifically
for NFSv2. Move it to vfs.c, and the prototype to vfs.h.

While we're in here, remove the #ifdef EDQUOT check in this function.
It's apparently a holdover from the initial merge of the nfsd code in
1997. No other place in the kernel checks that that symbol is defined
before using it, so I think we can dispense with it here.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayout.c    |    1 
 fs/nfsd/blocklayoutxdr.c |    1 
 fs/nfsd/export.h         |    1 
 fs/nfsd/flexfilelayout.c |    1 
 fs/nfsd/nfs4idmap.c      |    1 
 fs/nfsd/nfsproc.c        |   62 ----------------------------------------------
 fs/nfsd/vfs.c            |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/vfs.h            |    1 
 8 files changed, 68 insertions(+), 63 deletions(-)

--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -12,6 +12,7 @@
 #include "blocklayoutxdr.h"
 #include "pnfs.h"
 #include "filecache.h"
+#include "vfs.h"
 
 #define NFSDDBG_FACILITY	NFSDDBG_PNFS
 
--- a/fs/nfsd/blocklayoutxdr.c
+++ b/fs/nfsd/blocklayoutxdr.c
@@ -9,6 +9,7 @@
 
 #include "nfsd.h"
 #include "blocklayoutxdr.h"
+#include "vfs.h"
 
 #define NFSDDBG_FACILITY	NFSDDBG_PNFS
 
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -115,7 +115,6 @@ struct svc_export *	rqst_find_fsidzero_e
 int			exp_rootfh(struct net *, struct auth_domain *,
 					char *path, struct knfsd_fh *, int maxsize);
 __be32			exp_pseudoroot(struct svc_rqst *, struct svc_fh *);
-__be32			nfserrno(int errno);
 
 static inline void exp_put(struct svc_export *exp)
 {
--- a/fs/nfsd/flexfilelayout.c
+++ b/fs/nfsd/flexfilelayout.c
@@ -15,6 +15,7 @@
 
 #include "flexfilelayoutxdr.h"
 #include "pnfs.h"
+#include "vfs.h"
 
 #define NFSDDBG_FACILITY	NFSDDBG_PNFS
 
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -41,6 +41,7 @@
 #include "idmap.h"
 #include "nfsd.h"
 #include "netns.h"
+#include "vfs.h"
 
 /*
  * Turn off idmapping when using AUTH_SYS.
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -848,65 +848,3 @@ const struct svc_version nfsd_version2 =
 	.vs_dispatch	= nfsd_dispatch,
 	.vs_xdrsize	= NFS2_SVC_XDRSIZE,
 };
-
-/*
- * Map errnos to NFS errnos.
- */
-__be32
-nfserrno (int errno)
-{
-	static struct {
-		__be32	nfserr;
-		int	syserr;
-	} nfs_errtbl[] = {
-		{ nfs_ok, 0 },
-		{ nfserr_perm, -EPERM },
-		{ nfserr_noent, -ENOENT },
-		{ nfserr_io, -EIO },
-		{ nfserr_nxio, -ENXIO },
-		{ nfserr_fbig, -E2BIG },
-		{ nfserr_stale, -EBADF },
-		{ nfserr_acces, -EACCES },
-		{ nfserr_exist, -EEXIST },
-		{ nfserr_xdev, -EXDEV },
-		{ nfserr_mlink, -EMLINK },
-		{ nfserr_nodev, -ENODEV },
-		{ nfserr_notdir, -ENOTDIR },
-		{ nfserr_isdir, -EISDIR },
-		{ nfserr_inval, -EINVAL },
-		{ nfserr_fbig, -EFBIG },
-		{ nfserr_nospc, -ENOSPC },
-		{ nfserr_rofs, -EROFS },
-		{ nfserr_mlink, -EMLINK },
-		{ nfserr_nametoolong, -ENAMETOOLONG },
-		{ nfserr_notempty, -ENOTEMPTY },
-#ifdef EDQUOT
-		{ nfserr_dquot, -EDQUOT },
-#endif
-		{ nfserr_stale, -ESTALE },
-		{ nfserr_jukebox, -ETIMEDOUT },
-		{ nfserr_jukebox, -ERESTARTSYS },
-		{ nfserr_jukebox, -EAGAIN },
-		{ nfserr_jukebox, -EWOULDBLOCK },
-		{ nfserr_jukebox, -ENOMEM },
-		{ nfserr_io, -ETXTBSY },
-		{ nfserr_notsupp, -EOPNOTSUPP },
-		{ nfserr_toosmall, -ETOOSMALL },
-		{ nfserr_serverfault, -ESERVERFAULT },
-		{ nfserr_serverfault, -ENFILE },
-		{ nfserr_io, -EREMOTEIO },
-		{ nfserr_stale, -EOPENSTALE },
-		{ nfserr_io, -EUCLEAN },
-		{ nfserr_perm, -ENOKEY },
-		{ nfserr_no_grace, -ENOGRACE},
-	};
-	int	i;
-
-	for (i = 0; i < ARRAY_SIZE(nfs_errtbl); i++) {
-		if (nfs_errtbl[i].syserr == errno)
-			return nfs_errtbl[i].nfserr;
-	}
-	WARN_ONCE(1, "nfsd: non-standard errno: %d\n", errno);
-	return nfserr_io;
-}
-
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -49,6 +49,69 @@
 
 #define NFSDDBG_FACILITY		NFSDDBG_FILEOP
 
+/**
+ * nfserrno - Map Linux errnos to NFS errnos
+ * @errno: POSIX(-ish) error code to be mapped
+ *
+ * Returns the appropriate (net-endian) nfserr_* (or nfs_ok if errno is 0). If
+ * it's an error we don't expect, log it once and return nfserr_io.
+ */
+__be32
+nfserrno (int errno)
+{
+	static struct {
+		__be32	nfserr;
+		int	syserr;
+	} nfs_errtbl[] = {
+		{ nfs_ok, 0 },
+		{ nfserr_perm, -EPERM },
+		{ nfserr_noent, -ENOENT },
+		{ nfserr_io, -EIO },
+		{ nfserr_nxio, -ENXIO },
+		{ nfserr_fbig, -E2BIG },
+		{ nfserr_stale, -EBADF },
+		{ nfserr_acces, -EACCES },
+		{ nfserr_exist, -EEXIST },
+		{ nfserr_xdev, -EXDEV },
+		{ nfserr_mlink, -EMLINK },
+		{ nfserr_nodev, -ENODEV },
+		{ nfserr_notdir, -ENOTDIR },
+		{ nfserr_isdir, -EISDIR },
+		{ nfserr_inval, -EINVAL },
+		{ nfserr_fbig, -EFBIG },
+		{ nfserr_nospc, -ENOSPC },
+		{ nfserr_rofs, -EROFS },
+		{ nfserr_mlink, -EMLINK },
+		{ nfserr_nametoolong, -ENAMETOOLONG },
+		{ nfserr_notempty, -ENOTEMPTY },
+		{ nfserr_dquot, -EDQUOT },
+		{ nfserr_stale, -ESTALE },
+		{ nfserr_jukebox, -ETIMEDOUT },
+		{ nfserr_jukebox, -ERESTARTSYS },
+		{ nfserr_jukebox, -EAGAIN },
+		{ nfserr_jukebox, -EWOULDBLOCK },
+		{ nfserr_jukebox, -ENOMEM },
+		{ nfserr_io, -ETXTBSY },
+		{ nfserr_notsupp, -EOPNOTSUPP },
+		{ nfserr_toosmall, -ETOOSMALL },
+		{ nfserr_serverfault, -ESERVERFAULT },
+		{ nfserr_serverfault, -ENFILE },
+		{ nfserr_io, -EREMOTEIO },
+		{ nfserr_stale, -EOPENSTALE },
+		{ nfserr_io, -EUCLEAN },
+		{ nfserr_perm, -ENOKEY },
+		{ nfserr_no_grace, -ENOGRACE},
+	};
+	int	i;
+
+	for (i = 0; i < ARRAY_SIZE(nfs_errtbl); i++) {
+		if (nfs_errtbl[i].syserr == errno)
+			return nfs_errtbl[i].nfserr;
+	}
+	WARN_ONCE(1, "nfsd: non-standard errno: %d\n", errno);
+	return nfserr_io;
+}
+
 /* 
  * Called from nfsd_lookup and encode_dirent. Check if we have crossed 
  * a mount point.
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -60,6 +60,7 @@ static inline void nfsd_attrs_free(struc
 	posix_acl_release(attrs->na_dpacl);
 }
 
+__be32		nfserrno (int errno);
 int		nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 		                struct svc_export **expp);
 __be32		nfsd_lookup(struct svc_rqst *, struct svc_fh *,


