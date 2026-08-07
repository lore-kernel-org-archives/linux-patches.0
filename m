Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE7F29AB1A;
	Fri,  7 Aug 2026 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116770; cv=none; b=CoTaEOK7FSaL98jiuVeNkRXOkDimPPfs7uzQg9UHhZQWo7rZFheF8vEv51W83s21o3OhlHbboenvO/oYS4a2jCSF5MkZn+DFw2bIbNef4YhHWVmckMx3qNG4a8zeWT57byXvbJYgR4U80C5KPI7CIFrO6ywwPyO7Krgq+XYDmsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116770; c=relaxed/simple;
	bh=YkdNIRD5690Ub9dR87hBUjqdIZ9kBp9PlpJN+mJ78/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE1n13MpxlIXWwWua7RqtQ/ghYj1zlzZQjpCV06rOMHWzt5cAJisSBI3m7t2e9KACcqKO4lhjoyaziNjXnZqquooEeR1zI/CBPVQUh/4mt+FEInbol2hqobqZxVVXfkIVD+MNveUMO1cVDdQCGWsrjUPedhlDE/vuEuNQQSlIlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIlG2hea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIlG2hea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BC41F00A3D;
	Fri,  7 Aug 2026 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116769;
	bh=ZV0pM1jImc3gMgstgGF9KSoH7AoYPg2iE5M9VTkCXds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIlG2heamqHVvVpjtGDt5kz/GitlmBPZC3ZFdpYDKELHjYjs3rhDEm1IQr+aBGlMM
	 9DD/o9JGmE6/1q0bHkrQxX3kp7aMvhA+dX2KCC47tsN20tLEVMwdn8XF+BfuaITzmn
	 JyM15ApONbhOAVTjdnJyTLIDq46N9T2mRrzsPXGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <hongbohbli@tencent.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 085/438] erofs: ensure valid f_path for page cache sharing
Date: Fri,  7 Aug 2026 16:34:41 +0200
Message-ID: <20260807143429.794853858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit 96b2dbbe58a1ea5df8d29c2fe24b5f04715f4443 ]

Previously, backing files for page cache sharing were set up with
f_path left as NULL (only f_inode was valid).  It worked, but a recent
mincore fix relies on f_path.mnt and crashes (found by "erofs/028" on
7.2-rc4):

 BUG: kernel NULL pointer dereference, address: 0000000000000018
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP PTI
 CPU: 3 UID: 0 PID: 675528 Comm: fincore Not tainted 7.2.0-rc4-00002-g[]-dirty #1 PREEMPT(lazy)
 Hardware name: Red Hat KVM, BIOS 1.16.0-4.al8 04/01/2014
 RIP: 0010:__do_sys_mincore+0xc0/0x2c0
 ...

Specify valid paths using valid disconnected dentries together with
erofs_ishare_mnt instead of leaving f_path empty, so they are more
like real backing files in a pseudo filesystem and standard
backing_file_open() can be used directly.

Fixes: e187bc02f8fa ("mm: do file ownership checks with the proper mount idmap")
Acked-by: Hongbo Li <hongbohbli@tencent.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/Kconfig    |  1 +
 fs/erofs/internal.h |  4 ++--
 fs/erofs/ishare.c   | 58 ++++++++++++++++++++++-----------------------
 3 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 4789b1077d8ce..1feb28cfe557d 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -189,6 +189,7 @@ config EROFS_FS_PCPU_KTHREAD_HIPRI
 config EROFS_FS_PAGE_CACHE_SHARE
 	bool "EROFS page cache share support (experimental)"
 	depends on EROFS_FS && EROFS_FS_XATTR
+	select FS_STACK
 	help
 	  This enables page cache sharing among inodes with identical
 	  content fingerprints on the same machine.
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 580f8d9f14e7f..57bd21859c65d 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -288,8 +288,8 @@ struct erofs_inode {
 			struct erofs_inode_fingerprint fingerprint;
 			spinlock_t ishare_lock;
 		};
-		/* for each real inode */
-		struct inode *sharedinode;
+		/* for each real filesystem inode */
+		struct dentry *sharedentry;
 	};
 #endif
 	/* the corresponding vfs inode */
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 0868c12fc15b4..25558df98a389 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -2,14 +2,13 @@
 /*
  * Copyright (C) 2024, Alibaba Cloud
  */
+#include <linux/backing-file.h>
 #include <linux/xxhash.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include "internal.h"
 #include "xattr.h"
 
-#include "../internal.h"
-
 static struct vfsmount *erofs_ishare_mnt;
 
 static inline bool erofs_is_ishare_inode(struct inode *inode)
@@ -39,10 +38,12 @@ static int erofs_ishare_iget5_set(struct inode *inode, void *data)
 
 bool erofs_ishare_fill_inode(struct inode *inode)
 {
+	static const struct file_operations empty_fops = {};
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	const struct address_space_operations *aops;
 	struct erofs_inode *vi = EROFS_I(inode);
 	struct erofs_inode_fingerprint fp;
+	struct dentry *sd;
 	struct inode *si;
 
 	aops = erofs_get_aops(inode);
@@ -55,7 +56,9 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 			  xxh32(fp.opaque, fp.size, 0),
 			  erofs_ishare_iget5_eq, erofs_ishare_iget5_set, &fp);
 	if (si && (inode_state_read_once(si) & I_NEW)) {
+		si->i_fop = &empty_fops;
 		si->i_mapping->a_ops = aops;
+		si->i_mode = 0444 | S_IFREG;
 		si->i_size = inode->i_size;
 		unlock_new_inode(si);
 	} else {
@@ -71,7 +74,10 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 			return false;
 		}
 	}
-	vi->sharedinode = si;
+	sd = d_obtain_alias(si); /* disconnected denties for sharedinodes */
+	if (IS_ERR(sd))
+		return false;
+	vi->sharedentry = sd;
 	INIT_LIST_HEAD(&vi->ishare_list);
 	spin_lock(&EROFS_I(si)->ishare_lock);
 	list_add(&vi->ishare_list, &EROFS_I(si)->ishare_list);
@@ -81,48 +87,40 @@ bool erofs_ishare_fill_inode(struct inode *inode)
 
 void erofs_ishare_free_inode(struct inode *inode)
 {
-	struct erofs_inode *vi = EROFS_I(inode);
-	struct inode *sharedinode = vi->sharedinode;
+	struct erofs_inode *vi = EROFS_I(inode), *svi;
 
-	if (!sharedinode)
+	if (!vi->sharedentry)
 		return;
-	spin_lock(&EROFS_I(sharedinode)->ishare_lock);
+	svi = EROFS_I(d_inode(vi->sharedentry));
+	spin_lock(&svi->ishare_lock);
 	list_del(&vi->ishare_list);
-	spin_unlock(&EROFS_I(sharedinode)->ishare_lock);
-	iput(sharedinode);
-	vi->sharedinode = NULL;
+	spin_unlock(&svi->ishare_lock);
+	dput(vi->sharedentry);
+	vi->sharedentry = NULL;
 }
 
 static int erofs_ishare_file_open(struct inode *inode, struct file *file)
 {
-	struct inode *sharedinode = EROFS_I(inode)->sharedinode;
-	struct file *realfile;
+	struct path sharedpath = {
+		.mnt = erofs_ishare_mnt,
+		.dentry = EROFS_I(inode)->sharedentry,
+	};
+	struct file *rf;
 
 	if (file->f_flags & O_DIRECT)
 		return -EINVAL;
-	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred(),
-					    file);
-	if (IS_ERR(realfile))
-		return PTR_ERR(realfile);
-	ihold(sharedinode);
-	realfile->f_op = &erofs_file_fops;
-	realfile->f_inode = sharedinode;
-	realfile->f_mapping = sharedinode->i_mapping;
-	path_get(&file->f_path);
-	backing_file_set_user_path(realfile, &file->f_path);
-
-	file_ra_state_init(&realfile->f_ra, file->f_mapping);
-	realfile->private_data = EROFS_I(inode);
-	file->private_data = realfile;
+
+	rf = backing_file_open(file, file->f_flags | O_NOATIME,
+			       &sharedpath, current_cred());
+	if (IS_ERR(rf))
+		return PTR_ERR(rf);
+	file->private_data = rf;
 	return 0;
 }
 
 static int erofs_ishare_file_release(struct inode *inode, struct file *file)
 {
-	struct file *realfile = file->private_data;
-
-	iput(realfile->f_inode);
-	fput(realfile);
+	fput(file->private_data);
 	file->private_data = NULL;
 	return 0;
 }
-- 
2.53.0



