Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03CA3A7F43;
	Thu, 15 Jan 2026 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497220; cv=none; b=L9NH7SPGN7HxNU8qTNPWx3sEE/h0Gs7KO4FOI6ND4C3hSds9AHzNLO4d//UwCdP5hOpHj2HQXDDvZ04Yqm8kLBU1+u6C/vGj+2pVwuEAsKhZSTVeIBIIq9Amd/WVP4iPS4J0VXPN12LLkvl3vpYWYC1Zcby6nTJ7p1QpWOiLf9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497220; c=relaxed/simple;
	bh=1isUsmIlrHnpO+a7AOnqpFdNr7OJ2mVWEL/0iOxjgbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNm5KrQD3Jl2WKMZNlVOezsG33qD/5syVkVqR/YhpqRFGrgXGQbwm/XQDt/fECtpjsKMJNQ7sFBhVOJt4veST3Shuc5GT1YUL07dcoYHTwq2LbIrzQhlh7p0Xq1dRYzmIPlQllMAa1Oh7OHiyFKgUYbZqpdjcmqssBnvOp4MmzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnkH3F8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnkH3F8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEC3C116D0;
	Thu, 15 Jan 2026 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497220;
	bh=1isUsmIlrHnpO+a7AOnqpFdNr7OJ2mVWEL/0iOxjgbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnkH3F8CwLjwIYl5ZEPIabMUf+PYjUloAqJRebQHZVrC2ArUIeIJJWzYA4Cd5050H
	 xoqo8LVhu6VExtF20ujndSdpRRkVAECyLucDQIqrwTTC/ZmuqOCtzWVTQFuHXU4xBo
	 yX9PsvYBYOFFYTfOuyN2bYEwG8fz92jvVDKbbw+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/72] nfs_common: factor out nfs_errtbl and nfs_stat_to_errno
Date: Thu, 15 Jan 2026 17:49:09 +0100
Message-ID: <20260115164145.641359331@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 4806ded4c14c5e8fdc6ce885d83221a78c06a428 ]

Common nfs_stat_to_errno() is used by both fs/nfs/nfs2xdr.c and
fs/nfs/nfs3xdr.c

Will also be used by fs/nfsd/localio.c

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: c6c209ceb87f ("NFSD: Remove NFSERR_EAGAIN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/Kconfig             |    1 
 fs/nfs/nfs2xdr.c           |   70 -----------------------------
 fs/nfs/nfs3xdr.c           |  108 ++++++++-------------------------------------
 fs/nfs/nfs4xdr.c           |    4 -
 fs/nfs_common/Makefile     |    2 
 fs/nfs_common/common.c     |   67 +++++++++++++++++++++++++++
 fs/nfsd/Kconfig            |    1 
 include/linux/nfs_common.h |   16 ++++++
 8 files changed, 109 insertions(+), 160 deletions(-)
 create mode 100644 fs/nfs_common/common.c
 create mode 100644 include/linux/nfs_common.h

--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -5,6 +5,7 @@ config NFS_FS
 	select CRC32
 	select LOCKD
 	select SUNRPC
+	select NFS_COMMON
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
 	help
 	  Choose Y here if you want to access files residing on other
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -22,14 +22,12 @@
 #include <linux/nfs.h>
 #include <linux/nfs2.h>
 #include <linux/nfs_fs.h>
+#include <linux/nfs_common.h>
 #include "nfstrace.h"
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
 
-/* Mapping from NFS error code to "errno" error code. */
-#define errno_NFSERR_IO		EIO
-
 /*
  * Declare the space requirements for NFS arguments and replies as
  * number of 32bit-words
@@ -64,8 +62,6 @@
 #define NFS_readdirres_sz	(1+NFS_pagepad_sz)
 #define NFS_statfsres_sz	(1+NFS_info_sz)
 
-static int nfs_stat_to_errno(enum nfs_stat);
-
 /*
  * Encode/decode NFSv2 basic data types
  *
@@ -1054,70 +1050,6 @@ out_default:
 	return nfs_stat_to_errno(status);
 }
 
-
-/*
- * We need to translate between nfs status return values and
- * the local errno values which may not be the same.
- */
-static const struct {
-	int stat;
-	int errno;
-} nfs_errtbl[] = {
-	{ NFS_OK,		0		},
-	{ NFSERR_PERM,		-EPERM		},
-	{ NFSERR_NOENT,		-ENOENT		},
-	{ NFSERR_IO,		-errno_NFSERR_IO},
-	{ NFSERR_NXIO,		-ENXIO		},
-/*	{ NFSERR_EAGAIN,	-EAGAIN		}, */
-	{ NFSERR_ACCES,		-EACCES		},
-	{ NFSERR_EXIST,		-EEXIST		},
-	{ NFSERR_XDEV,		-EXDEV		},
-	{ NFSERR_NODEV,		-ENODEV		},
-	{ NFSERR_NOTDIR,	-ENOTDIR	},
-	{ NFSERR_ISDIR,		-EISDIR		},
-	{ NFSERR_INVAL,		-EINVAL		},
-	{ NFSERR_FBIG,		-EFBIG		},
-	{ NFSERR_NOSPC,		-ENOSPC		},
-	{ NFSERR_ROFS,		-EROFS		},
-	{ NFSERR_MLINK,		-EMLINK		},
-	{ NFSERR_NAMETOOLONG,	-ENAMETOOLONG	},
-	{ NFSERR_NOTEMPTY,	-ENOTEMPTY	},
-	{ NFSERR_DQUOT,		-EDQUOT		},
-	{ NFSERR_STALE,		-ESTALE		},
-	{ NFSERR_REMOTE,	-EREMOTE	},
-#ifdef EWFLUSH
-	{ NFSERR_WFLUSH,	-EWFLUSH	},
-#endif
-	{ NFSERR_BADHANDLE,	-EBADHANDLE	},
-	{ NFSERR_NOT_SYNC,	-ENOTSYNC	},
-	{ NFSERR_BAD_COOKIE,	-EBADCOOKIE	},
-	{ NFSERR_NOTSUPP,	-ENOTSUPP	},
-	{ NFSERR_TOOSMALL,	-ETOOSMALL	},
-	{ NFSERR_SERVERFAULT,	-EREMOTEIO	},
-	{ NFSERR_BADTYPE,	-EBADTYPE	},
-	{ NFSERR_JUKEBOX,	-EJUKEBOX	},
-	{ -1,			-EIO		}
-};
-
-/**
- * nfs_stat_to_errno - convert an NFS status code to a local errno
- * @status: NFS status code to convert
- *
- * Returns a local errno value, or -EIO if the NFS status code is
- * not recognized.  This function is used jointly by NFSv2 and NFSv3.
- */
-static int nfs_stat_to_errno(enum nfs_stat status)
-{
-	int i;
-
-	for (i = 0; nfs_errtbl[i].stat != -1; i++) {
-		if (nfs_errtbl[i].stat == (int)status)
-			return nfs_errtbl[i].errno;
-	}
-	dprintk("NFS: Unrecognized nfs status value: %u\n", status);
-	return nfs_errtbl[i].errno;
-}
-
 #define PROC(proc, argtype, restype, timer)				\
 [NFSPROC_##proc] = {							\
 	.p_proc	    =  NFSPROC_##proc,					\
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -21,14 +21,13 @@
 #include <linux/nfs3.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfsacl.h>
+#include <linux/nfs_common.h>
+
 #include "nfstrace.h"
 #include "internal.h"
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
 
-/* Mapping from NFS error code to "errno" error code. */
-#define errno_NFSERR_IO		EIO
-
 /*
  * Declare the space requirements for NFS arguments and replies as
  * number of 32bit-words
@@ -91,8 +90,6 @@
 				NFS3_pagepad_sz)
 #define ACL3_setaclres_sz	(1+NFS3_post_op_attr_sz)
 
-static int nfs3_stat_to_errno(enum nfs_stat);
-
 /*
  * Map file type to S_IFMT bits
  */
@@ -1406,7 +1403,7 @@ static int nfs3_xdr_dec_getattr3res(stru
 out:
 	return error;
 out_default:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1445,7 +1442,7 @@ static int nfs3_xdr_dec_setattr3res(stru
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1495,7 +1492,7 @@ out_default:
 	error = decode_post_op_attr(xdr, result->dir_attr, userns);
 	if (unlikely(error))
 		goto out;
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1537,7 +1534,7 @@ static int nfs3_xdr_dec_access3res(struc
 out:
 	return error;
 out_default:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1578,7 +1575,7 @@ static int nfs3_xdr_dec_readlink3res(str
 out:
 	return error;
 out_default:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1658,7 +1655,7 @@ static int nfs3_xdr_dec_read3res(struct
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1728,7 +1725,7 @@ static int nfs3_xdr_dec_write3res(struct
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1795,7 +1792,7 @@ out_default:
 	error = decode_wcc_data(xdr, result->dir_attr, userns);
 	if (unlikely(error))
 		goto out;
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1835,7 +1832,7 @@ static int nfs3_xdr_dec_remove3res(struc
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1881,7 +1878,7 @@ static int nfs3_xdr_dec_rename3res(struc
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -1926,7 +1923,7 @@ static int nfs3_xdr_dec_link3res(struct
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /**
@@ -2101,7 +2098,7 @@ out_default:
 	error = decode_post_op_attr(xdr, result->dir_attr, rpc_rqst_userns(req));
 	if (unlikely(error))
 		goto out;
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -2167,7 +2164,7 @@ static int nfs3_xdr_dec_fsstat3res(struc
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -2243,7 +2240,7 @@ static int nfs3_xdr_dec_fsinfo3res(struc
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -2304,7 +2301,7 @@ static int nfs3_xdr_dec_pathconf3res(str
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 /*
@@ -2350,7 +2347,7 @@ static int nfs3_xdr_dec_commit3res(struc
 out:
 	return error;
 out_status:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 #ifdef CONFIG_NFS_V3_ACL
@@ -2416,7 +2413,7 @@ static int nfs3_xdr_dec_getacl3res(struc
 out:
 	return error;
 out_default:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 static int nfs3_xdr_dec_setacl3res(struct rpc_rqst *req,
@@ -2435,76 +2432,11 @@ static int nfs3_xdr_dec_setacl3res(struc
 out:
 	return error;
 out_default:
-	return nfs3_stat_to_errno(status);
+	return nfs_stat_to_errno(status);
 }
 
 #endif  /* CONFIG_NFS_V3_ACL */
 
-
-/*
- * We need to translate between nfs status return values and
- * the local errno values which may not be the same.
- */
-static const struct {
-	int stat;
-	int errno;
-} nfs_errtbl[] = {
-	{ NFS_OK,		0		},
-	{ NFSERR_PERM,		-EPERM		},
-	{ NFSERR_NOENT,		-ENOENT		},
-	{ NFSERR_IO,		-errno_NFSERR_IO},
-	{ NFSERR_NXIO,		-ENXIO		},
-/*	{ NFSERR_EAGAIN,	-EAGAIN		}, */
-	{ NFSERR_ACCES,		-EACCES		},
-	{ NFSERR_EXIST,		-EEXIST		},
-	{ NFSERR_XDEV,		-EXDEV		},
-	{ NFSERR_NODEV,		-ENODEV		},
-	{ NFSERR_NOTDIR,	-ENOTDIR	},
-	{ NFSERR_ISDIR,		-EISDIR		},
-	{ NFSERR_INVAL,		-EINVAL		},
-	{ NFSERR_FBIG,		-EFBIG		},
-	{ NFSERR_NOSPC,		-ENOSPC		},
-	{ NFSERR_ROFS,		-EROFS		},
-	{ NFSERR_MLINK,		-EMLINK		},
-	{ NFSERR_NAMETOOLONG,	-ENAMETOOLONG	},
-	{ NFSERR_NOTEMPTY,	-ENOTEMPTY	},
-	{ NFSERR_DQUOT,		-EDQUOT		},
-	{ NFSERR_STALE,		-ESTALE		},
-	{ NFSERR_REMOTE,	-EREMOTE	},
-#ifdef EWFLUSH
-	{ NFSERR_WFLUSH,	-EWFLUSH	},
-#endif
-	{ NFSERR_BADHANDLE,	-EBADHANDLE	},
-	{ NFSERR_NOT_SYNC,	-ENOTSYNC	},
-	{ NFSERR_BAD_COOKIE,	-EBADCOOKIE	},
-	{ NFSERR_NOTSUPP,	-ENOTSUPP	},
-	{ NFSERR_TOOSMALL,	-ETOOSMALL	},
-	{ NFSERR_SERVERFAULT,	-EREMOTEIO	},
-	{ NFSERR_BADTYPE,	-EBADTYPE	},
-	{ NFSERR_JUKEBOX,	-EJUKEBOX	},
-	{ -1,			-EIO		}
-};
-
-/**
- * nfs3_stat_to_errno - convert an NFS status code to a local errno
- * @status: NFS status code to convert
- *
- * Returns a local errno value, or -EIO if the NFS status code is
- * not recognized.  This function is used jointly by NFSv2 and NFSv3.
- */
-static int nfs3_stat_to_errno(enum nfs_stat status)
-{
-	int i;
-
-	for (i = 0; nfs_errtbl[i].stat != -1; i++) {
-		if (nfs_errtbl[i].stat == (int)status)
-			return nfs_errtbl[i].errno;
-	}
-	dprintk("NFS: Unrecognized nfs status value: %u\n", status);
-	return nfs_errtbl[i].errno;
-}
-
-
 #define PROC(proc, argtype, restype, timer)				\
 [NFS3PROC_##proc] = {							\
 	.p_proc      = NFS3PROC_##proc,					\
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -52,6 +52,7 @@
 #include <linux/nfs.h>
 #include <linux/nfs4.h>
 #include <linux/nfs_fs.h>
+#include <linux/nfs_common.h>
 
 #include "nfs4_fs.h"
 #include "nfs4trace.h"
@@ -63,9 +64,6 @@
 
 #define NFSDBG_FACILITY		NFSDBG_XDR
 
-/* Mapping from NFS error code to "errno" error code. */
-#define errno_NFSERR_IO		EIO
-
 struct compound_hdr;
 static int nfs4_stat_to_errno(int);
 static void encode_layoutget(struct xdr_stream *xdr,
--- a/fs/nfs_common/Makefile
+++ b/fs/nfs_common/Makefile
@@ -8,3 +8,5 @@ nfs_acl-objs := nfsacl.o
 
 obj-$(CONFIG_GRACE_PERIOD) += grace.o
 obj-$(CONFIG_NFS_V4_2_SSC_HELPER) += nfs_ssc.o
+
+obj-$(CONFIG_NFS_COMMON) += common.o
--- /dev/null
+++ b/fs/nfs_common/common.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/module.h>
+#include <linux/nfs_common.h>
+
+/*
+ * We need to translate between nfs status return values and
+ * the local errno values which may not be the same.
+ */
+static const struct {
+	int stat;
+	int errno;
+} nfs_errtbl[] = {
+	{ NFS_OK,		0		},
+	{ NFSERR_PERM,		-EPERM		},
+	{ NFSERR_NOENT,		-ENOENT		},
+	{ NFSERR_IO,		-errno_NFSERR_IO},
+	{ NFSERR_NXIO,		-ENXIO		},
+/*	{ NFSERR_EAGAIN,	-EAGAIN		}, */
+	{ NFSERR_ACCES,		-EACCES		},
+	{ NFSERR_EXIST,		-EEXIST		},
+	{ NFSERR_XDEV,		-EXDEV		},
+	{ NFSERR_NODEV,		-ENODEV		},
+	{ NFSERR_NOTDIR,	-ENOTDIR	},
+	{ NFSERR_ISDIR,		-EISDIR		},
+	{ NFSERR_INVAL,		-EINVAL		},
+	{ NFSERR_FBIG,		-EFBIG		},
+	{ NFSERR_NOSPC,		-ENOSPC		},
+	{ NFSERR_ROFS,		-EROFS		},
+	{ NFSERR_MLINK,		-EMLINK		},
+	{ NFSERR_NAMETOOLONG,	-ENAMETOOLONG	},
+	{ NFSERR_NOTEMPTY,	-ENOTEMPTY	},
+	{ NFSERR_DQUOT,		-EDQUOT		},
+	{ NFSERR_STALE,		-ESTALE		},
+	{ NFSERR_REMOTE,	-EREMOTE	},
+#ifdef EWFLUSH
+	{ NFSERR_WFLUSH,	-EWFLUSH	},
+#endif
+	{ NFSERR_BADHANDLE,	-EBADHANDLE	},
+	{ NFSERR_NOT_SYNC,	-ENOTSYNC	},
+	{ NFSERR_BAD_COOKIE,	-EBADCOOKIE	},
+	{ NFSERR_NOTSUPP,	-ENOTSUPP	},
+	{ NFSERR_TOOSMALL,	-ETOOSMALL	},
+	{ NFSERR_SERVERFAULT,	-EREMOTEIO	},
+	{ NFSERR_BADTYPE,	-EBADTYPE	},
+	{ NFSERR_JUKEBOX,	-EJUKEBOX	},
+	{ -1,			-EIO		}
+};
+
+/**
+ * nfs_stat_to_errno - convert an NFS status code to a local errno
+ * @status: NFS status code to convert
+ *
+ * Returns a local errno value, or -EIO if the NFS status code is
+ * not recognized.  This function is used jointly by NFSv2 and NFSv3.
+ */
+int nfs_stat_to_errno(enum nfs_stat status)
+{
+	int i;
+
+	for (i = 0; nfs_errtbl[i].stat != -1; i++) {
+		if (nfs_errtbl[i].stat == (int)status)
+			return nfs_errtbl[i].errno;
+	}
+	return nfs_errtbl[i].errno;
+}
+EXPORT_SYMBOL_GPL(nfs_stat_to_errno);
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -8,6 +8,7 @@ config NFSD
 	select LOCKD
 	select SUNRPC
 	select EXPORTFS
+	select NFS_COMMON
 	select NFS_ACL_SUPPORT if NFSD_V2_ACL
 	select NFS_ACL_SUPPORT if NFSD_V3_ACL
 	depends on MULTIUSER
--- /dev/null
+++ b/include/linux/nfs_common.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * This file contains constants and methods used by both NFS client and server.
+ */
+#ifndef _LINUX_NFS_COMMON_H
+#define _LINUX_NFS_COMMON_H
+
+#include <linux/errno.h>
+#include <uapi/linux/nfs.h>
+
+/* Mapping from NFS error code to "errno" error code. */
+#define errno_NFSERR_IO EIO
+
+int nfs_stat_to_errno(enum nfs_stat status);
+
+#endif /* _LINUX_NFS_COMMON_H */


