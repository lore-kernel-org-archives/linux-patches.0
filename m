Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01B51F152D;
	Tue, 30 Sep 2025 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244584; cv=none; b=S7xnxP5H7JHVdPOrjP3NdXGDy+S0ZSZ5lji7Ihqnht6ArG5c7YoLCZOATvVdn8i05cJsNMZlKuYQKflXGbIZV7hsT7JADhdJUPlygD4ZsPinf6L+g8erkWwhcoUotrr6vBflEyBpKuPsb+NzIv0swqz7upAN40dsWB8onBmYK1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244584; c=relaxed/simple;
	bh=ZjaCtzEmBv870xO83511dfONb0AJoKDtZNq3gd/8h30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvtFAzE9tpi62lGnLgLzOE1U0pgPlVsm62KGdy34kjgJ2LdFdFBK7/AN9ap9+kHL8aPWsLJOhw8PsIbAxUl8xALeIjWaejDXk1qBVRtfDP0CyDeoSKSHwDc3Q6y3FNG+z8rnSEdJCoOJaM6pWQ9TlZD8ihPQVAVI/YuIAiS4tpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEXppYOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEXppYOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79801C113D0;
	Tue, 30 Sep 2025 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244583;
	bh=ZjaCtzEmBv870xO83511dfONb0AJoKDtZNq3gd/8h30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEXppYOJ9KuE3vPnMy/owSextHau4D1ym7XT89WVnTMAfS7zv49u1pTyyfnQLby3y
	 QMoRdasCexK+hYR/wgdigtjnJJrXfb+f86b+sI1obsI1W8Lx3fN+g1SQeAIr5A3PTP
	 Ium9XCnuUgJsgFEQNfJ5JkTAvOLyVsuaMPgwUFSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 050/143] NFS: Protect against eof page pollution
Date: Tue, 30 Sep 2025 16:46:14 +0200
Message-ID: <20250930143833.225304456@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b1817b18ff20e69f5accdccefaf78bf5454bede2 ]

This commit fixes the failing xfstest 'generic/363'.

When the user mmaps() an area that extends beyond the end of file, and
proceeds to write data into the folio that straddles that eof, we're
required to discard that folio data if the user calls some function that
extends the file length.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c      | 33 +++++++++++++++++++++++++++++++++
 fs/nfs/inode.c     |  9 +++++++--
 fs/nfs/internal.h  |  2 ++
 fs/nfs/nfs42proc.c | 14 +++++++++++---
 fs/nfs/nfstrace.h  |  1 +
 5 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index a16a619fb8c33..8cc39a73faff8 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/gfp.h>
+#include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/compaction.h>
 
@@ -279,6 +280,37 @@ nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 }
 EXPORT_SYMBOL_GPL(nfs_file_fsync);
 
+void nfs_truncate_last_folio(struct address_space *mapping, loff_t from,
+			     loff_t to)
+{
+	struct folio *folio;
+
+	if (from >= to)
+		return;
+
+	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
+	if (IS_ERR(folio))
+		return;
+
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+
+	if (folio_test_uptodate(folio)) {
+		loff_t fpos = folio_pos(folio);
+		size_t offset = from - fpos;
+		size_t end = folio_size(folio);
+
+		if (to - fpos < end)
+			end = to - fpos;
+		folio_zero_segment(folio, offset, end);
+		trace_nfs_size_truncate_folio(mapping->host, to);
+	}
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(nfs_truncate_last_folio);
+
 /*
  * Decide whether a read/modify/write cycle may be more efficient
  * then a modify/write/read cycle when writing to a page in the
@@ -353,6 +385,7 @@ static int nfs_write_begin(struct file *file, struct address_space *mapping,
 
 	dfprintk(PAGECACHE, "NFS: write_begin(%pD2(%lu), %u@%lld)\n",
 		file, mapping->host->i_ino, len, (long long) pos);
+	nfs_truncate_last_folio(mapping, i_size_read(mapping->host), pos);
 
 	fgp |= fgf_set_order(len);
 start:
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index a32cc45425e28..f6b448666d419 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -710,6 +710,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 {
 	struct inode *inode = d_inode(dentry);
 	struct nfs_fattr *fattr;
+	loff_t oldsize = i_size_read(inode);
 	int error = 0;
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
@@ -725,7 +726,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		if (error)
 			return error;
 
-		if (attr->ia_size == i_size_read(inode))
+		if (attr->ia_size == oldsize)
 			attr->ia_valid &= ~ATTR_SIZE;
 	}
 
@@ -773,8 +774,12 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	}
 
 	error = NFS_PROTO(inode)->setattr(dentry, fattr, attr);
-	if (error == 0)
+	if (error == 0) {
+		if (attr->ia_valid & ATTR_SIZE)
+			nfs_truncate_last_folio(inode->i_mapping, oldsize,
+						attr->ia_size);
 		error = nfs_refresh_inode(inode, fattr);
+	}
 	nfs_free_fattr(fattr);
 out:
 	trace_nfs_setattr_exit(inode, error);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 0ef0fc6aba3b3..ae4d039c10d3a 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -438,6 +438,8 @@ int nfs_file_release(struct inode *, struct file *);
 int nfs_lock(struct file *, int, struct file_lock *);
 int nfs_flock(struct file *, int, struct file_lock *);
 int nfs_check_flags(int);
+void nfs_truncate_last_folio(struct address_space *mapping, loff_t from,
+			     loff_t to);
 
 /* inode.c */
 extern struct workqueue_struct *nfsiod_workqueue;
diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 48ee3d5d89c4a..4b0e35a0d89dd 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -138,6 +138,7 @@ int nfs42_proc_allocate(struct file *filep, loff_t offset, loff_t len)
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_ALLOCATE],
 	};
 	struct inode *inode = file_inode(filep);
+	loff_t oldsize = i_size_read(inode);
 	int err;
 
 	if (!nfs_server_capable(inode, NFS_CAP_ALLOCATE))
@@ -146,7 +147,11 @@ int nfs42_proc_allocate(struct file *filep, loff_t offset, loff_t len)
 	inode_lock(inode);
 
 	err = nfs42_proc_fallocate(&msg, filep, offset, len);
-	if (err == -EOPNOTSUPP)
+
+	if (err == 0)
+		nfs_truncate_last_folio(inode->i_mapping, oldsize,
+					offset + len);
+	else if (err == -EOPNOTSUPP)
 		NFS_SERVER(inode)->caps &= ~(NFS_CAP_ALLOCATE |
 					     NFS_CAP_ZERO_RANGE);
 
@@ -184,6 +189,7 @@ int nfs42_proc_zero_range(struct file *filep, loff_t offset, loff_t len)
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_ZERO_RANGE],
 	};
 	struct inode *inode = file_inode(filep);
+	loff_t oldsize = i_size_read(inode);
 	int err;
 
 	if (!nfs_server_capable(inode, NFS_CAP_ZERO_RANGE))
@@ -192,9 +198,11 @@ int nfs42_proc_zero_range(struct file *filep, loff_t offset, loff_t len)
 	inode_lock(inode);
 
 	err = nfs42_proc_fallocate(&msg, filep, offset, len);
-	if (err == 0)
+	if (err == 0) {
+		nfs_truncate_last_folio(inode->i_mapping, oldsize,
+					offset + len);
 		truncate_pagecache_range(inode, offset, (offset + len) -1);
-	if (err == -EOPNOTSUPP)
+	} else if (err == -EOPNOTSUPP)
 		NFS_SERVER(inode)->caps &= ~NFS_CAP_ZERO_RANGE;
 
 	inode_unlock(inode);
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index 7a058bd8c566e..1e4dc632f1800 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -267,6 +267,7 @@ DECLARE_EVENT_CLASS(nfs_update_size_class,
 			TP_ARGS(inode, new_size))
 
 DEFINE_NFS_UPDATE_SIZE_EVENT(truncate);
+DEFINE_NFS_UPDATE_SIZE_EVENT(truncate_folio);
 DEFINE_NFS_UPDATE_SIZE_EVENT(wcc);
 DEFINE_NFS_UPDATE_SIZE_EVENT(update);
 DEFINE_NFS_UPDATE_SIZE_EVENT(grow);
-- 
2.51.0



