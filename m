Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469884431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EDBC433D2;
	Wed, 15 Mar 2023 12:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884110;
	bh=V3E38VUATFYY6TRZV+ClJrtJ2pL47y7zoxcTI/+V4gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zl1CRLOYh8trakWKxp/xzOJeYGaxtB1+jmidDH2eUtw1obs9tfs85+d4NaBBDGn3Z
	 FFi7ryDlBPT6ENVWGP69gCszEhAdrpd5ed1uZfyvoycyOYlqXf2R/amk3qIBPMWaHj
	 Ow6FNQOWKsb1xEp0N3Q7/62BVE0nKd+KzbX1mqi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9d16c39efb5fade84574@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 111/141] ext4: Fix deadlock during directory rename
Date: Wed, 15 Mar 2023 13:13:34 +0100
Message-Id: <20230315115743.379590614@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 3c92792da8506a295afb6d032b4476e46f979725 ]

As lockdep properly warns, we should not be locking i_rwsem while having
transactions started as the proper lock ordering used by all directory
handling operations is i_rwsem -> transaction start. Fix the lock
ordering by moving the locking of the directory earlier in
ext4_rename().

Reported-by: syzbot+9d16c39efb5fade84574@syzkaller.appspotmail.com
Fixes: 0813299c586b ("ext4: Fix possible corruption when moving a directory")
Link: https://syzkaller.appspot.com/bug?extid=9d16c39efb5fade84574
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230301141004.15087-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e8f429330f3c3..7cc3918e2f189 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3813,10 +3813,20 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 			return retval;
 	}
 
+	/*
+	 * We need to protect against old.inode directory getting converted
+	 * from inline directory format into a normal one.
+	 */
+	if (S_ISDIR(old.inode->i_mode))
+		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
+
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
 				 &old.inlined);
-	if (IS_ERR(old.bh))
-		return PTR_ERR(old.bh);
+	if (IS_ERR(old.bh)) {
+		retval = PTR_ERR(old.bh);
+		goto unlock_moved_dir;
+	}
+
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -3873,11 +3883,6 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
 		}
-		/*
-		 * We need to protect against old.inode directory getting
-		 * converted from inline directory format into a normal one.
-		 */
-		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
 		retval = ext4_rename_dir_prepare(handle, &old);
 		if (retval) {
 			inode_unlock(old.inode);
@@ -4014,12 +4019,15 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	} else {
 		ext4_journal_stop(handle);
 	}
-	if (old.dir_bh)
-		inode_unlock(old.inode);
 release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
+
+unlock_moved_dir:
+	if (S_ISDIR(old.inode->i_mode))
+		inode_unlock(old.inode);
+
 	return retval;
 }
 
-- 
2.39.2



