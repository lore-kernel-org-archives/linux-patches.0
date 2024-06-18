Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA03813D53F;
	Tue, 18 Jun 2024 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716655; cv=none; b=kvxDVpt+C9pOcjYX/cbYn9be8XhJldgZ5mw+v9jhq5CQi6JNOVEZ0WOjZ/I98Xr0EoJROFayYLLBoF4j06hMCTPVhaKqhGXuknXxyAEQ1usqDX4fR6Qy8N58IuduF/hZOAhjD1+T8nGpB02QhGwieLf4zHA/ZIm5wet7lQ/ZF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716655; c=relaxed/simple;
	bh=LNxIdD/s6z2Z7qAyq7YU3kddG8aCcWPXKH5bZoXiUkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRqJWi+szhm4xHVxJQBaiK9MbOAmGc0zvrXIfqnuTGaOc2xVuevNo9IkN9i4zQ3qRV81T+0wkbo8IAE0jsBuzi3kWqaYMtvOKYU1oSxiJX7+gBi/mJgG/QjrlCLWxA8fKfGI1V4n3cCZv9JyDzYAQbI66dXgVb519cDmPS5CYYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djYjk2JZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djYjk2JZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BA0C3277B;
	Tue, 18 Jun 2024 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716655;
	bh=LNxIdD/s6z2Z7qAyq7YU3kddG8aCcWPXKH5bZoXiUkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djYjk2JZXJBiBcQNa7TlWjogMLz628LkPVTzp27xR99yn2tGl5wfsU9nP7kcGqmrR
	 2zhkIthhbVhY/n3C4z/FzYByjMj3qDH9JNJgEgtKx5sxBv98Xc+YOHCaybx7+n89xg
	 aDzWBFnH5NFxfmFCRH4t8UnUdwX0xx1rs316RVQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 687/770] nfsd: move nfserrno() to vfs.c
Date: Tue, 18 Jun 2024 14:39:00 +0200
Message-ID: <20240618123433.796852005@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/blocklayout.c    |  1 +
 fs/nfsd/blocklayoutxdr.c |  1 +
 fs/nfsd/export.h         |  1 -
 fs/nfsd/flexfilelayout.c |  1 +
 fs/nfsd/nfs4idmap.c      |  1 +
 fs/nfsd/nfsproc.c        | 62 ---------------------------------------
 fs/nfsd/vfs.c            | 63 ++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/vfs.h            |  1 +
 8 files changed, 68 insertions(+), 63 deletions(-)

diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index a07c39c94bbd0..d91a686d2f313 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -16,6 +16,7 @@
 #include "blocklayoutxdr.h"
 #include "pnfs.h"
 #include "filecache.h"
+#include "vfs.h"
 
 #define NFSDDBG_FACILITY	NFSDDBG_PNFS
 
diff --git a/fs/nfsd/blocklayoutxdr.c b/fs/nfsd/blocklayoutxdr.c
index 2455dc8be18a8..1ed2f691ebb90 100644
--- a/fs/nfsd/blocklayoutxdr.c
+++ b/fs/nfsd/blocklayoutxdr.c
@@ -9,6 +9,7 @@
 
 #include "nfsd.h"
 #include "blocklayoutxdr.h"
+#include "vfs.h"
 
 #define NFSDDBG_FACILITY	NFSDDBG_PNFS
 
diff --git a/fs/nfsd/export.h b/fs/nfsd/export.h
index ee0e3aba4a6e5..d03f7f6a8642d 100644
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -115,7 +115,6 @@ struct svc_export *	rqst_find_fsidzero_export(struct svc_rqst *);
 int			exp_rootfh(struct net *, struct auth_domain *,
 					char *path, struct knfsd_fh *, int maxsize);
 __be32			exp_pseudoroot(struct svc_rqst *, struct svc_fh *);
-__be32			nfserrno(int errno);
 
 static inline void exp_put(struct svc_export *exp)
 {
diff --git a/fs/nfsd/flexfilelayout.c b/fs/nfsd/flexfilelayout.c
index 2e2f1d5e9f623..fabc21ed68cea 100644
--- a/fs/nfsd/flexfilelayout.c
+++ b/fs/nfsd/flexfilelayout.c
@@ -15,6 +15,7 @@
 
 #include "flexfilelayoutxdr.h"
 #include "pnfs.h"
+#include "vfs.h"
 
 #define NFSDDBG_FACILITY	NFSDDBG_PNFS
 
diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index e70a1a2999b7b..5e9809aff37eb 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -41,6 +41,7 @@
 #include "idmap.h"
 #include "nfsd.h"
 #include "netns.h"
+#include "vfs.h"
 
 /*
  * Turn off idmapping when using AUTH_SYS.
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 78fa5a9edf277..3777b5be4253a 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -848,65 +848,3 @@ const struct svc_version nfsd_version2 = {
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
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index aae81c5cecb94..9bda56fe303cf 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -48,6 +48,69 @@
 
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
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 120521bc7b247..8ddd687f83599 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -60,6 +60,7 @@ static inline void nfsd_attrs_free(struct nfsd_attrs *attrs)
 	posix_acl_release(attrs->na_dpacl);
 }
 
+__be32		nfserrno (int errno);
 int		nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 		                struct svc_export **expp);
 __be32		nfsd_lookup(struct svc_rqst *, struct svc_fh *,
-- 
2.43.0



