Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8D830276F;
	Wed,  3 Dec 2025 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776654; cv=none; b=n6sGS3WvCI9Xbqc4CXmlAUysCCUb+YkRf3ZcypS+BJknnvGmbbmFEXfglZ3aLl8QeQQHgo1cGAJIKQXYUl2nDwzOZBLGklnccNRPUgaIeHo193xtYUx60VYu4ZRwbgmLJAPD3Wx3c76t84P9F3URXkxWnN7V3ZFffC98ui0e82U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776654; c=relaxed/simple;
	bh=n52nT0oB8+gzPqbtHzKPYOv0fkxIvMC0YzLZwLfMUtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNrjxSyPoZ9pSFGWalXzYEil8FDmxy8oqQIQaEMB0FGibPIM99PYHvtZ6NWk623g56zkLG3LprMxdTUEsD1WbcwqhixGBWI3HMYUuCYhdNnAr1FtCpiPP6UTlOgWMYINIflGplf2yXAsZHLyzWeIciCQ//toNjNWYpNCMotLW+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4ipM/cn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4ipM/cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005BDC4CEF5;
	Wed,  3 Dec 2025 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776654;
	bh=n52nT0oB8+gzPqbtHzKPYOv0fkxIvMC0YzLZwLfMUtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4ipM/cnMDR2r2k+EeRugKUMQ3q0R+y1KPg/V0UuHSekoJeyxLp3oUqxYRfq+qCGI
	 Js3VFkDIEof7fGNqPc3jJeb7qCO1wEWAMxA+82/yCIrJiD1Z5BaAAL54aPXqZxHZm/
	 SiQ6nCjizVsM04vYP74zuRPqZ4Ueajb7O08fTXBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ahmed, Aaron" <aarnahmd@amazon.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 240/300] Revert "NFS: Dont set NFS_INO_REVAL_PAGECACHE in the inode cache validity"
Date: Wed,  3 Dec 2025 16:27:24 +0100
Message-ID: <20251203152409.516297001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

This reverts commit 36a9346c225270262d9f34e66c91aa1723fa903f.

The above commit was incorrectly labelled as a dependency for commit
b01f21cacde9 ("NFS: Fix the setting of capabilities when automounting a
new filesystem")
A revert is needed, since the incorrectly applied commit depends upon a
series of other patches that were merged into Linux 5.13, but have not
been applied to the 5.10 stable series.

Reported-by: "Ahmed, Aaron" <aarnahmd@amazon.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/inode.c    |    6 ++++--
 fs/nfs/nfs4proc.c |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -217,12 +217,11 @@ static void nfs_set_cache_invalid(struct
 			flags &= ~NFS_INO_INVALID_OTHER;
 		flags &= ~(NFS_INO_INVALID_CHANGE
 				| NFS_INO_INVALID_SIZE
+				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_INVALID_XATTR);
 	} else if (flags & NFS_INO_REVAL_PAGECACHE)
 		flags |= NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_SIZE;
 
-	flags &= ~NFS_INO_REVAL_PAGECACHE;
-
 	if (!nfs_has_xattr_cache(nfsi))
 		flags &= ~NFS_INO_INVALID_XATTR;
 	if (inode->i_mapping->nrpages == 0)
@@ -1901,6 +1900,7 @@ static int nfs_update_inode(struct inode
 	nfsi->cache_validity &= ~(NFS_INO_INVALID_ATTR
 			| NFS_INO_INVALID_ATIME
 			| NFS_INO_REVAL_FORCED
+			| NFS_INO_REVAL_PAGECACHE
 			| NFS_INO_INVALID_BLOCKS);
 
 	/* Do atomic weak cache consistency updates */
@@ -1942,6 +1942,7 @@ static int nfs_update_inode(struct inode
 	} else {
 		nfsi->cache_validity |= save_cache_validity &
 				(NFS_INO_INVALID_CHANGE
+				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
 	}
@@ -1987,6 +1988,7 @@ static int nfs_update_inode(struct inode
 	} else {
 		nfsi->cache_validity |= save_cache_validity &
 				(NFS_INO_INVALID_SIZE
+				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
 	}
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1212,6 +1212,7 @@ nfs4_update_changeattr_locked(struct ino
 		| cache_validity;
 
 	if (cinfo->atomic && cinfo->before == inode_peek_iversion_raw(inode)) {
+		nfsi->cache_validity &= ~NFS_INO_REVAL_PAGECACHE;
 		nfsi->attrtimeo_timestamp = jiffies;
 	} else {
 		if (S_ISDIR(inode->i_mode)) {


