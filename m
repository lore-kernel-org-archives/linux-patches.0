Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151F1338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301794; cv=none; b=fQOE7wsH3LR4o5LmMjllXZwh0wXsB2oyQn5OPyAyD1B32cqmRibs/J3/yMIVS7C6zSFGMMVhdQ7TAyNzfE6R34kdH3I63VttOnXw5ILqJBifo55JE9Ed0NNNdSmXqwxQIJQuRz1R+hliGhGMeqSe1Rfe7CAX09BiorpnMwSSAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301794; c=relaxed/simple;
	bh=gTwM/Dqtu91rpwSE1ksK58yGIkdVwH3FHhmuBZUhPmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4BY/EGkjRGrsnkiyO346486XGcQohyADPyjhxGvlZkWiUaJM1jTEBKsIbE0q8aJ+mz24qvAYfqf4ldoXyxgx1L+Ob8GOupX8D4/rObJ6ZsHBZE/HQBaqhn1y9jLU5uHyPbWgUvidRzZ+USDcL/O3RjjmPsB2xOk5/lzZlJMTzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5HuZsIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5HuZsIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59745C19424;
	Sat, 28 Feb 2026 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301793;
	bh=gTwM/Dqtu91rpwSE1ksK58yGIkdVwH3FHhmuBZUhPmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5HuZsIn/w6FAZQN8kS9cdJMtkHMXGHtutqYnIUUlLQgyDbfbdL9zq6DIIkhzrR5k
	 mUkN3owqPjW49zVs48i3FDs3OK2k9xPq1TS14BbHSAGVeW1b2fA0xBlpLOkYJC+HQS
	 vLDktVj1hchyOT+UFFkmF1NNAKool914giM0DqDdV9nHx2gAcyblgODvs/109vsWFc
	 3DHCUDkiZlLz1WGpaNQyR5To8HaYfGvss/HFr4Gme17tVKnkeuSUPuq1patNyAUDdJ
	 PrMplYuBQcmsldPSD4aLpywdfO3VZ5ddBFeE+KaPZgmyD19SlCfjGkhcclo6+pPvY1
	 hRYiQmwmLQsuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/385] NFS: NFSERR_INVAL is not defined by NFSv2
Date: Sat, 28 Feb 2026 12:57:06 -0500
Message-ID: <20260228180011.1568201-204-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0ac903d1bfdce8ff40657c2b7d996947b72b6645 ]

A documenting comment in include/uapi/linux/nfs.h claims incorrectly
that NFSv2 defines NFSERR_INVAL. There is no such definition in either
RFC 1094 or https://pubs.opengroup.org/onlinepubs/9629799/chap7.htm

NFS3ERR_INVAL is introduced in RFC 1813.

NFSD returns NFSERR_INVAL for PROC_GETACL, which has no
specification (yet).

However, nfsd_map_status() maps nfserr_symlink and nfserr_wrong_type
to nfserr_inval, which does not align with RFC 1094. This logic was
introduced only recently by commit 438f81e0e92a ("nfsd: move error
choice for incorrect object types to version-specific code."). Given
that we have no INVAL or SERVERFAULT status in NFSv2, probably the
only choice is NFSERR_IO.

Fixes: 438f81e0e92a ("nfsd: move error choice for incorrect object types to version-specific code.")
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c        | 2 +-
 fs/nfsd/nfsproc.c        | 2 +-
 include/uapi/linux/nfs.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 5fb202acb0fd0..0ac538c761800 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -45,7 +45,7 @@ static __be32 nfsacld_proc_getacl(struct svc_rqst *rqstp)
 	inode = d_inode(fh->fh_dentry);
 
 	if (argp->mask & ~NFS_ACL_MASK) {
-		resp->status = nfserr_inval;
+		resp->status = nfserr_io;
 		goto out;
 	}
 	resp->mask = argp->mask;
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 6dda081eb24c0..664171bdefb65 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -32,7 +32,7 @@ static __be32 nfsd_map_status(__be32 status)
 		break;
 	case nfserr_symlink:
 	case nfserr_wrong_type:
-		status = nfserr_inval;
+		status = nfserr_io;
 		break;
 	}
 	return status;
diff --git a/include/uapi/linux/nfs.h b/include/uapi/linux/nfs.h
index 71c7196d32817..e629c49535345 100644
--- a/include/uapi/linux/nfs.h
+++ b/include/uapi/linux/nfs.h
@@ -55,7 +55,7 @@
 	NFSERR_NODEV = 19,		/* v2 v3 v4 */
 	NFSERR_NOTDIR = 20,		/* v2 v3 v4 */
 	NFSERR_ISDIR = 21,		/* v2 v3 v4 */
-	NFSERR_INVAL = 22,		/* v2 v3 v4 */
+	NFSERR_INVAL = 22,		/*    v3 v4 */
 	NFSERR_FBIG = 27,		/* v2 v3 v4 */
 	NFSERR_NOSPC = 28,		/* v2 v3 v4 */
 	NFSERR_ROFS = 30,		/* v2 v3 v4 */
-- 
2.51.0

