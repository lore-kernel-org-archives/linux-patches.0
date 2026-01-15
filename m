Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D583BC4EB;
	Thu, 15 Jan 2026 17:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499138; cv=none; b=sfpUpVYcy1qBfH0VAZxcOS2z5wCZrdMADM3TVFNdCUNkIkfuRVv0hccrEIOkF+cu2E/na2ZYIoFgBQtfa3jw59ZXeH/ji0SvaGOOMsSiwysIAnA44aI68R3uunN4tBlGBpKlOND1Xp24dtZfTQJjruhR3o4xC1BKitdatvHGe8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499138; c=relaxed/simple;
	bh=ipbRhe9lFSNrPZEiGGSnsk2aGmzZSXmpvwltKF+OL18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWXuipfLEKi+otNYcP1EZFM3fPmwAiv59n75YIJknyr5JYJuTLWoS2ZT8P3ASZ4cf9l0TXTHKMAQ38V8fLsGgc5ExVYxlWtDHi1db/cl53nC7tm8ordIUSHSa18rgke4KdnBzBa7gnUwhnJPIMIPnGqZdCPQ5LJL+Exez/vRdgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/UwSZKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/UwSZKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E535AC116D0;
	Thu, 15 Jan 2026 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499138;
	bh=ipbRhe9lFSNrPZEiGGSnsk2aGmzZSXmpvwltKF+OL18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/UwSZKmbkzqArW2lsXbFfgQwPf5Zxl8El7aP0f/7wtjSGpfVDxSYrECE3AyBglb4
	 TbDJtyFhttWf+0Zd7eo9nKZrAQArW/W9e5H13HjvcO+u1aAYJNX9e1Uzq18d8mwBpp
	 pd81VCAUMRG3OoH5AgivOQuZXtXjkduiDRIUPlPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/451] NFS: Clean up function nfs_mark_dir_for_revalidate()
Date: Thu, 15 Jan 2026 17:45:21 +0100
Message-ID: <20260115164235.264292665@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

[ Upstream commit fd6d3feed041e96b84680d0bfc1e7abc8f65de92 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: bd4928ec799b ("NFS: Avoid changing nlink when file removes and attribute updates race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c      | 4 +---
 fs/nfs/inode.c    | 2 +-
 fs/nfs/internal.h | 3 ++-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 935029632d5f6..e38ebe8bfb169 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1203,10 +1203,8 @@ int nfs_lookup_verify_inode(struct inode *inode, unsigned int flags)
 
 static void nfs_mark_dir_for_revalidate(struct inode *inode)
 {
-	struct nfs_inode *nfsi = NFS_I(inode);
-
 	spin_lock(&inode->i_lock);
-	nfsi->cache_validity |= NFS_INO_REVAL_PAGECACHE;
+	nfs_set_cache_invalid(inode, NFS_INO_REVAL_PAGECACHE);
 	spin_unlock(&inode->i_lock);
 }
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 3e3114a9d1937..e04739bf59261 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -207,7 +207,7 @@ static bool nfs_has_xattr_cache(const struct nfs_inode *nfsi)
 }
 #endif
 
-static void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
+void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	bool have_delegation = NFS_PROTO(inode)->have_delegation(inode, FMODE_READ);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 838f3a3744851..10759e1b89fb2 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -424,7 +424,8 @@ extern int nfs_write_inode(struct inode *, struct writeback_control *);
 extern int nfs_drop_inode(struct inode *);
 extern void nfs_clear_inode(struct inode *);
 extern void nfs_evict_inode(struct inode *);
-void nfs_zap_acl_cache(struct inode *inode);
+extern void nfs_zap_acl_cache(struct inode *inode);
+extern void nfs_set_cache_invalid(struct inode *inode, unsigned long flags);
 extern bool nfs_check_cache_invalid(struct inode *, unsigned long);
 extern int nfs_wait_bit_killable(struct wait_bit_key *key, int mode);
 extern int nfs_wait_atomic_killable(atomic_t *p, unsigned int mode);
-- 
2.51.0



