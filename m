Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B98915530C;
	Thu, 15 Jan 2026 17:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497535; cv=none; b=AcF6138E+B0yx3ww31wiKQF+zxklF00SuGmSmwewaTCGKlbMP3BjnFf5cqFTotK93Bx2k2QVc1l126JsTbtbJv6pPHc7FMpWrq4UuOWEFgx/rHDm4PST65E0grmXZpopcagzi6QJjFKVf/IJuQn2XCTVmtwYTWm7nseBBls+mbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497535; c=relaxed/simple;
	bh=h9jDns/Y8wzei6xDbb8gHJhXpLvoFFI6mAYzkmYfglw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB+WDPxFHpeMvDCo9uEQ2oKesJIYxmpePN/vFMgwy2e1zlrIOBaBc6g19vaz7qcjFgBhSY/9/QZSII7qSxCW/sh0JoHV0mjWUS6M+mWiu/qpZSgBqA6b1LAIXNFU35i4FsY4poHsQ8+rpfeu4Sz8dfAkI0S/4V6Q5AVb2xmTgvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amC7W93X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amC7W93X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED882C116D0;
	Thu, 15 Jan 2026 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497535;
	bh=h9jDns/Y8wzei6xDbb8gHJhXpLvoFFI6mAYzkmYfglw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amC7W93X/63eJNRKzzW2UHn2AdsuSK2TosN8ALTsf1r1/cjafPl7puMSxxFZM7AJI
	 NE3XpEQdcXewtJoHAoFkWsFhSoZHq3F6220yfnGDttIO/U75Cg85l6ktd8hSSnU/LJ
	 DDVIxgma15YbZ7jhKqPtcYIHr+Y6/jh6Dfi+nALI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/554] fs/ntfs3: Add new argument is_mft to ntfs_mark_rec_free
Date: Thu, 15 Jan 2026 17:43:01 +0100
Message-ID: <20260115164250.415527367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 071100ea0e6c353258f322cb2f8dde9be62d6808 ]

This argument helps in avoiding double locking

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 4d78d1173a65 ("fs/ntfs3: out1 also needs to put mi")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 12 ++++++------
 fs/ntfs3/fsntfs.c  |  9 ++++++---
 fs/ntfs3/inode.c   |  2 +-
 fs/ntfs3/ntfs_fs.h |  2 +-
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index a74bbfec8e3ac..b5f3e7bc5d6da 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1037,7 +1037,7 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 	err = -EINVAL;
 
 out1:
-	ntfs_mark_rec_free(sbi, rno);
+	ntfs_mark_rec_free(sbi, rno, is_mft);
 
 out:
 	return err;
@@ -1232,7 +1232,7 @@ static int ni_expand_mft_list(struct ntfs_inode *ni)
 		mft_min = mft_new;
 		mi_min = mi_new;
 	} else {
-		ntfs_mark_rec_free(sbi, mft_new);
+		ntfs_mark_rec_free(sbi, mft_new, true);
 		mft_new = 0;
 		ni_remove_mi(ni, mi_new);
 	}
@@ -1315,7 +1315,7 @@ static int ni_expand_mft_list(struct ntfs_inode *ni)
 
 out:
 	if (mft_new) {
-		ntfs_mark_rec_free(sbi, mft_new);
+		ntfs_mark_rec_free(sbi, mft_new, true);
 		ni_remove_mi(ni, mi_new);
 	}
 
@@ -1577,7 +1577,7 @@ int ni_delete_all(struct ntfs_inode *ni)
 		mi->dirty = true;
 		mi_write(mi, 0);
 
-		ntfs_mark_rec_free(sbi, mi->rno);
+		ntfs_mark_rec_free(sbi, mi->rno, false);
 		ni_remove_mi(ni, mi);
 		mi_put(mi);
 		node = next;
@@ -1588,7 +1588,7 @@ int ni_delete_all(struct ntfs_inode *ni)
 	ni->mi.dirty = true;
 	err = mi_write(&ni->mi, 0);
 
-	ntfs_mark_rec_free(sbi, ni->mi.rno);
+	ntfs_mark_rec_free(sbi, ni->mi.rno, false);
 
 	return err;
 }
@@ -3292,7 +3292,7 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint)
 			err = err2;
 
 		if (is_empty) {
-			ntfs_mark_rec_free(sbi, mi->rno);
+			ntfs_mark_rec_free(sbi, mi->rno, false);
 			rb_erase(node, &ni->mi_tree);
 			mi_put(mi);
 		}
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index c82398194cd10..7dc2ae7dec591 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -703,12 +703,14 @@ int ntfs_look_free_mft(struct ntfs_sb_info *sbi, CLST *rno, bool mft,
 
 /*
  * ntfs_mark_rec_free - Mark record as free.
+ * is_mft - true if we are changing MFT
  */
-void ntfs_mark_rec_free(struct ntfs_sb_info *sbi, CLST rno)
+void ntfs_mark_rec_free(struct ntfs_sb_info *sbi, CLST rno, bool is_mft)
 {
 	struct wnd_bitmap *wnd = &sbi->mft.bitmap;
 
-	down_write_nested(&wnd->rw_lock, BITMAP_MUTEX_MFT);
+	if (!is_mft)
+		down_write_nested(&wnd->rw_lock, BITMAP_MUTEX_MFT);
 	if (rno >= wnd->nbits)
 		goto out;
 
@@ -727,7 +729,8 @@ void ntfs_mark_rec_free(struct ntfs_sb_info *sbi, CLST rno)
 		sbi->mft.next_free = rno;
 
 out:
-	up_write(&wnd->rw_lock);
+	if (!is_mft)
+		up_write(&wnd->rw_lock);
 }
 
 /*
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0f4e166112de1..7ac76e6c35dcf 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1668,7 +1668,7 @@ struct inode *ntfs_create_inode(struct user_namespace *mnt_userns,
 	ni->mi.dirty = false;
 	discard_new_inode(inode);
 out3:
-	ntfs_mark_rec_free(sbi, ino);
+	ntfs_mark_rec_free(sbi, ino, false);
 
 out2:
 	__putname(new_de);
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index f7ef60bed6d84..69d1442eea623 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -596,7 +596,7 @@ int ntfs_look_for_free_space(struct ntfs_sb_info *sbi, CLST lcn, CLST len,
 			     enum ALLOCATE_OPT opt);
 int ntfs_look_free_mft(struct ntfs_sb_info *sbi, CLST *rno, bool mft,
 		       struct ntfs_inode *ni, struct mft_inode **mi);
-void ntfs_mark_rec_free(struct ntfs_sb_info *sbi, CLST rno);
+void ntfs_mark_rec_free(struct ntfs_sb_info *sbi, CLST rno, bool is_mft);
 int ntfs_clear_mft_tail(struct ntfs_sb_info *sbi, size_t from, size_t to);
 int ntfs_refresh_zone(struct ntfs_sb_info *sbi);
 int ntfs_update_mftmirr(struct ntfs_sb_info *sbi, int wait);
-- 
2.51.0



