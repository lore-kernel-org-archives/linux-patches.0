Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090F81E2834;
	Wed, 25 Feb 2026 01:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984026; cv=none; b=NEWo+8hXG3NYvB3HD25b61rVjOh7GG7Sfib2rHgXKjmOZgDEg5XxyPYuZPkdUCw86kPZEk3NDy7SPyM96M0HPgzJgfqbTXnsWk5qum2Wx4hvJ7EjTocOjlI/9JL38KfMCXyWHUpLxsnZpz2iMbmEZHqaCJwju0EnCzOBThGxXh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984026; c=relaxed/simple;
	bh=ActG3WlXVkACp1pEQfgdNxfz6eificW4sR2SGppsfQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9a11vVbzKVhs2mTjKjBCq3EusZVffa0GAiC5T+C54k8w5joPicK0HQ3g/7uTQHZWVZtNoo3sygDH3Qa86rirP9rMD4WWBgLSh8cA6BA4DyBBr/UCTcYsRxdNMQK/zkJTUpJ0fvs86VJNnZW9vQevB9znQrSY7JP2IqjDZwULLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0IPUPbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0IPUPbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6982C116D0;
	Wed, 25 Feb 2026 01:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984025;
	bh=ActG3WlXVkACp1pEQfgdNxfz6eificW4sR2SGppsfQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0IPUPbQVyXCBojTYpoR4q13B7on7w6HYG9VWrU7lFmHaHJNlnPQAPu65PhTKymk0
	 k3wW1TJxh5BSaIkrJG7D8vjQGK2i120z92DP5praUKqVjp4MlrOt0/C615G5g+XTti
	 UiktKboEEwH79f0fw57gvT7wxhVLPeo5HGoTTJBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/641] NFS: NFSERR_INVAL is not defined by NFSv2
Date: Tue, 24 Feb 2026 17:19:57 -0800
Message-ID: <20260225012355.362260656@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 8f71f5748c75b..906a672578900 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -33,7 +33,7 @@ static __be32 nfsd_map_status(__be32 status)
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



