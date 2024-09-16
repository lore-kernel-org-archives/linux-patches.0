Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ED6158DD0;
	Mon, 16 Sep 2024 12:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488282; cv=none; b=pObBcFPb1Vzagc1iu++GjuntcwW8TXkkZXJ2p1lLziBF4lsFWrEykNXiaGNQktU5Zrp8BGal0PEjRxZ0ghMdtmQvALtzOTpB+PhGe+PUse1ML4WQArvHnYrLhTAQGQtO0SG523zN/2rAMdZ2IxPyqJLOIjv7R7gyfYmW9yPXy8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488282; c=relaxed/simple;
	bh=cdwKZOWNcBbQBJMgzLDQ/d7OCQL+gsH7bazUuqeOofc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNoyvHDCd/fgKgOorV1Gkt6UUKdkCBrvquX6UbwkSg5ZrmdzHMf76tR3bqqFAq5kXmLYtSrOPA8c83beaM/Kw/qz1bwx810TBbjMwgEwrsfZB61W1enF2khb6teOrHSSY7e0jYCtBR5tK0YcwJ1OniqKHLlMYxLyFGCRstWSeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcEVo8GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcEVo8GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D86C4CEC4;
	Mon, 16 Sep 2024 12:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488281;
	bh=cdwKZOWNcBbQBJMgzLDQ/d7OCQL+gsH7bazUuqeOofc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcEVo8GNZ8VpuioXKoMFvqDPSpW9pQMtDIXRUhxdUKDblsh/0P0JA/+HVs7wpoM59
	 eZtJYNpAPa0adl/SNM6c8kPFbs7yFf2jUj0IMlOaQRp49wolxCIoZYXpDGDJareO9z
	 Ib7NFhDWfvknG/uiAkxH1ratPd74p4o0VC6qwJfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.10 058/121] bcachefs: Dont delete open files in online fsck
Date: Mon, 16 Sep 2024 13:43:52 +0200
Message-ID: <20240916114231.079285590@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit 16005147cca41a0f67b5def2a4656286f8c0db4a ]

If a file is unlinked but still open, we don't want online fsck to
delete it - or fun inconsistencies will happen.

https://github.com/koverstreet/bcachefs/issues/727

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs.c   |    8 ++++++++
 fs/bcachefs/fs.h   |    7 +++++++
 fs/bcachefs/fsck.c |   18 ++++++++++++++++++
 3 files changed, 33 insertions(+)

--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -177,6 +177,14 @@ static unsigned bch2_inode_hash(subvol_i
 	return jhash_3words(inum.subvol, inum.inum >> 32, inum.inum, JHASH_INITVAL);
 }
 
+struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *c, subvol_inum inum)
+{
+	return to_bch_ei(ilookup5_nowait(c->vfs_sb,
+					 bch2_inode_hash(inum),
+					 bch2_iget5_test,
+					 &inum));
+}
+
 static struct bch_inode_info *bch2_inode_insert(struct bch_fs *c, struct bch_inode_info *inode)
 {
 	subvol_inum inum = inode_inum(inode);
--- a/fs/bcachefs/fs.h
+++ b/fs/bcachefs/fs.h
@@ -56,6 +56,8 @@ static inline subvol_inum inode_inum(str
 	};
 }
 
+struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *, subvol_inum);
+
 /*
  * Set if we've gotten a btree error for this inode, and thus the vfs inode and
  * btree inode may be inconsistent:
@@ -194,6 +196,11 @@ int bch2_vfs_init(void);
 
 #define bch2_inode_update_after_write(_trans, _inode, _inode_u, _fields)	({ do {} while (0); })
 
+static inline struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *c, subvol_inum inum)
+{
+	return NULL;
+}
+
 static inline void bch2_evict_subvolume_inodes(struct bch_fs *c,
 					       snapshot_id_list *s) {}
 static inline void bch2_vfs_exit(void) {}
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -8,6 +8,7 @@
 #include "darray.h"
 #include "dirent.h"
 #include "error.h"
+#include "fs.h"
 #include "fs-common.h"
 #include "fsck.h"
 #include "inode.h"
@@ -948,6 +949,22 @@ fsck_err:
 	return ret;
 }
 
+static bool bch2_inode_open(struct bch_fs *c, struct bpos p)
+{
+	subvol_inum inum = {
+		.subvol = snapshot_t(c, p.snapshot)->subvol,
+		.inum	= p.offset,
+	};
+
+	/* snapshot tree corruption, can't safely delete */
+	if (!inum.subvol) {
+		bch_err_ratelimited(c, "%s(): snapshot %u has no subvol", __func__, p.snapshot);
+		return true;
+	}
+
+	return __bch2_inode_hash_find(c, inum) != NULL;
+}
+
 static int check_inode(struct btree_trans *trans,
 		       struct btree_iter *iter,
 		       struct bkey_s_c k,
@@ -1025,6 +1042,7 @@ static int check_inode(struct btree_tran
 	}
 
 	if (u.bi_flags & BCH_INODE_unlinked &&
+	    !bch2_inode_open(c, k.k->p) &&
 	    (!c->sb.clean ||
 	     fsck_err(c, inode_unlinked_but_clean,
 		      "filesystem marked clean, but inode %llu unlinked",


