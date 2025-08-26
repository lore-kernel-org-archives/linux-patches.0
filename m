Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625D0356908;
	Tue, 26 Aug 2025 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218263; cv=none; b=OB4MJ5wZGBTDy/cTBzKCEzHXNW8yQfhmWS4uAqTOr+YXGmzApTacxN3WH52hXE0CF4BuiAYEoeu6ZdJJ2vBFoHg008c6tDoaRmMhoD+o0daCfkcJqv/FAt7nNxI1LJ4O9FT85CCczqygZcUEPicMgmB6ARKI4IqCtb/s/cQfLEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218263; c=relaxed/simple;
	bh=YUrGJII0nxAEE+6EjIVI5zmXgTfxQSnjKHGuCD6Keqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5A2v/PFakMe2521G9pRHK1Dg+aI73pd2PuW7xn5nw99vcQZSXUftju7+BnoxMcN/p4wyW5K/hOWMusfWL3PvwICu1wrSEp/xI7Ns25Yq+sKKAyEO9b+xgOyNQ6rA5Va5RoHYfMCpFNaW6bsUEcVQ4QGqasO4hpSjywdnuBjFRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgxYFjXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgxYFjXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76E5C4CEF1;
	Tue, 26 Aug 2025 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218263;
	bh=YUrGJII0nxAEE+6EjIVI5zmXgTfxQSnjKHGuCD6Keqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgxYFjXfsSEuXaSfom5lmKZ29kk43u1BWCEbBZg5p/XXsL3uiR+9ZzW1ttndcZzzx
	 4QjT7N0Cg3PXynUz56sxVpOOTSn4B+Zw31y+wiaEPoL9plXRGltTuxhfNRqlACIgJi
	 F+LbbBamMcOpJrZElSml0zWZk3anfo6ZuoAZ88Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 455/523] NFS: Dont set NFS_INO_REVAL_PAGECACHE in the inode cache validity
Date: Tue, 26 Aug 2025 13:11:05 +0200
Message-ID: <20250826110935.672866348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 36a9346c225270262d9f34e66c91aa1723fa903f ]

It is no longer necessary to preserve the NFS_INO_REVAL_PAGECACHE flag.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: b01f21cacde9 ("NFS: Fix the setting of capabilities when automounting a new filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/inode.c    |    6 ++----
 fs/nfs/nfs4proc.c |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -217,11 +217,12 @@ static void nfs_set_cache_invalid(struct
 			flags &= ~NFS_INO_INVALID_OTHER;
 		flags &= ~(NFS_INO_INVALID_CHANGE
 				| NFS_INO_INVALID_SIZE
-				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_INVALID_XATTR);
 	} else if (flags & NFS_INO_REVAL_PAGECACHE)
 		flags |= NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_SIZE;
 
+	flags &= ~NFS_INO_REVAL_PAGECACHE;
+
 	if (!nfs_has_xattr_cache(nfsi))
 		flags &= ~NFS_INO_INVALID_XATTR;
 	if (inode->i_mapping->nrpages == 0)
@@ -1900,7 +1901,6 @@ static int nfs_update_inode(struct inode
 	nfsi->cache_validity &= ~(NFS_INO_INVALID_ATTR
 			| NFS_INO_INVALID_ATIME
 			| NFS_INO_REVAL_FORCED
-			| NFS_INO_REVAL_PAGECACHE
 			| NFS_INO_INVALID_BLOCKS);
 
 	/* Do atomic weak cache consistency updates */
@@ -1942,7 +1942,6 @@ static int nfs_update_inode(struct inode
 	} else {
 		nfsi->cache_validity |= save_cache_validity &
 				(NFS_INO_INVALID_CHANGE
-				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
 	}
@@ -1988,7 +1987,6 @@ static int nfs_update_inode(struct inode
 	} else {
 		nfsi->cache_validity |= save_cache_validity &
 				(NFS_INO_INVALID_SIZE
-				| NFS_INO_REVAL_PAGECACHE
 				| NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
 	}
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1213,7 +1213,6 @@ nfs4_update_changeattr_locked(struct ino
 		| cache_validity;
 
 	if (cinfo->atomic && cinfo->before == inode_peek_iversion_raw(inode)) {
-		nfsi->cache_validity &= ~NFS_INO_REVAL_PAGECACHE;
 		nfsi->attrtimeo_timestamp = jiffies;
 	} else {
 		if (S_ISDIR(inode->i_mode)) {


