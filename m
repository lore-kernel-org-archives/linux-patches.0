Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A346402444;
	Tue, 21 Jul 2026 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654571; cv=none; b=JoaDeqf6gmw0JRQGpo+5Nn1nzZQ97mlCplN1MkOS+YPZntMBaVyhv3UkgqQR+u7hHnV9mX+WxzVaIIiTzysppHXvLFFqQHypIFddVroloJHPAaYaInIq3HkX/3OZUzTftUQTFOnG1OITAO0r//JMCdF5fiBFTo5c/c407mLc95c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654571; c=relaxed/simple;
	bh=nW4CPVHezaYiyiT/DdoQcTW7qcgq1EfATHgyegoHTYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPMXEuDnj8lx/mq6aPl/yCcY4LN6uEhwbk5+ljEtXWl3+/GuP7Xk27yYK1nSCTNjX0/bD+sHvGUL3kQDQAeycPF8vTZJzn/Wk39v6ay9dD/ujPHkMyRp56q3Vuah6wjqNimKT1ePNKxvChfhEYdvrYKujxgz1spp9xRcXSTnsjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vl1rfxvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vl1rfxvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E771F000E9;
	Tue, 21 Jul 2026 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654570;
	bh=jJ+XsT6t97Eqni2cFw44QO48s2oATHIYHwPlgsToDmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vl1rfxvYkZCMugMShhH0nTYaBOXDokTmpb5TzRKRqnszsBV7LnRm0Hg0T+EI+5zJV
	 OkYyHQ+GcmMhqtPyv82J+fxjKLL3pBBzk+bEcHkRSD6+hBPvJf6t1cuKpwQaat2nPN
	 /K7VqbX8bVuTcaJVYmyhCwuIM9KI39lpRsGSNeX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1712/2077] ntfs: fix mrec_lock ABBA deadlock in rename
Date: Tue, 21 Jul 2026 17:23:05 +0200
Message-ID: <20260721152633.138310599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit eb94f5a41a193a425e09a63cb75dffd151d8f42e upstream.

ntfs_file_fsync(), ntfs_dir_fsync() and __ntfs_write_inode() lock an
inode's mrec_lock before taking the mrec_lock of its parent directory.

ntfs_rename() takes old_ni->mrec_lock and old_dir_ni->mrec_lock
before taking new_ni->mrec_lock for an existing target, or
new_dir_ni->mrec_lock for a cross-directory rename.
This can deadlock when ntfs_file_fsync() or __ntfs_write_inode() holds
the target inode, or when ntfs_dir_fsync() holds a child target
directory, while rename() holds the parent directory and waits for the
target.

Fix this by locking the existing target inode before taking any parent
directory mrec_lock. For cross-directory renames where the target parent
is a descendant of the source parent, lock the target parent before the
source parent so the directory order matches the child-to-parent order used
by ntfs_file_fsync(), ntfs_dir_fsync(), and __ntfs_write_inode().

Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Closes: https://lore.kernel.org/all/C4D296F0E9F3D66C+9397ffbc-eb55-44bb-9b3f-5da4809e7955@smail.nju.edu.cn/
Fixes: af0db57d4293 ("ntfs: update inode operations")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/namei.c |   62 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -1264,6 +1264,7 @@ static int ntfs_rename(struct mnt_idmap
 	struct ntfs_volume *vol = NTFS_SB(sb);
 	struct ntfs_inode *old_ni, *new_ni = NULL;
 	struct ntfs_inode *old_dir_ni = NTFS_I(old_dir), *new_dir_ni = NTFS_I(new_dir);
+	bool new_dir_first = false;
 
 	if (NVolShutdown(old_dir_ni->vol))
 		return -EIO;
@@ -1299,36 +1300,39 @@ static int ntfs_rename(struct mnt_idmap
 	old_inode = old_dentry->d_inode;
 	new_inode = new_dentry->d_inode;
 	old_ni = NTFS_I(old_inode);
+	if (new_inode)
+		new_ni = NTFS_I(new_inode);
+	if (old_dir != new_dir)
+		new_dir_first = is_subdir(new_dentry->d_parent,
+					  old_dentry->d_parent);
 
 	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
 		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	mutex_lock_nested(&old_ni->mrec_lock, NTFS_INODE_MUTEX_NORMAL);
-	mutex_lock_nested(&old_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT);
+	if (new_ni)
+		mutex_lock_nested(&new_ni->mrec_lock, NTFS_INODE_MUTEX_NORMAL_2);
+
+	if (old_dir == new_dir) {
+		mutex_lock_nested(&old_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT);
+	} else if (new_dir_first) {
+		mutex_lock_nested(&new_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT);
+		mutex_lock_nested(&old_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT_2);
+	} else {
+		mutex_lock_nested(&old_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT);
+		mutex_lock_nested(&new_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT_2);
+	}
 
-	if (NInoBeingDeleted(old_ni) || NInoBeingDeleted(old_dir_ni)) {
+	if (NInoBeingDeleted(old_ni) || NInoBeingDeleted(old_dir_ni) ||
+	    (new_ni && NInoBeingDeleted(new_ni)) ||
+	    (old_dir != new_dir && NInoBeingDeleted(new_dir_ni))) {
 		err = -ENOENT;
-		goto unlock_old;
+		goto err_out;
 	}
 
 	is_dir = S_ISDIR(old_inode->i_mode);
 
 	if (new_inode) {
-		new_ni = NTFS_I(new_inode);
-		mutex_lock_nested(&new_ni->mrec_lock, NTFS_INODE_MUTEX_NORMAL_2);
-		if (old_dir != new_dir) {
-			mutex_lock_nested(&new_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT_2);
-			if (NInoBeingDeleted(new_dir_ni)) {
-				err = -ENOENT;
-				goto err_out;
-			}
-		}
-
-		if (NInoBeingDeleted(new_ni)) {
-			err = -ENOENT;
-			goto err_out;
-		}
-
 		if (is_dir) {
 			struct mft_record *ni_mrec;
 
@@ -1346,14 +1350,6 @@ static int ntfs_rename(struct mnt_idmap
 		err = ntfs_delete(new_ni, new_dir_ni, uname_new, new_name_len, false);
 		if (err)
 			goto err_out;
-	} else {
-		if (old_dir != new_dir) {
-			mutex_lock_nested(&new_dir_ni->mrec_lock, NTFS_INODE_MUTEX_PARENT_2);
-			if (NInoBeingDeleted(new_dir_ni)) {
-				err = -ENOENT;
-				goto err_out;
-			}
-		}
 	}
 
 	err = __ntfs_link(old_ni, new_dir_ni, uname_new, new_name_len);
@@ -1384,13 +1380,17 @@ static int ntfs_rename(struct mnt_idmap
 	inode_inc_iversion(new_dir);
 
 err_out:
-	if (old_dir != new_dir)
+	if (old_dir == new_dir) {
+		mutex_unlock(&old_dir_ni->mrec_lock);
+	} else if (new_dir_first) {
+		mutex_unlock(&old_dir_ni->mrec_lock);
 		mutex_unlock(&new_dir_ni->mrec_lock);
-	if (new_inode)
+	} else {
+		mutex_unlock(&new_dir_ni->mrec_lock);
+		mutex_unlock(&old_dir_ni->mrec_lock);
+	}
+	if (new_ni)
 		mutex_unlock(&new_ni->mrec_lock);
-
-unlock_old:
-	mutex_unlock(&old_dir_ni->mrec_lock);
 	mutex_unlock(&old_ni->mrec_lock);
 	if (uname_new)
 		kmem_cache_free(ntfs_name_cache, uname_new);


