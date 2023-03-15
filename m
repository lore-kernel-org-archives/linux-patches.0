Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991AD4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB75C433D2;
	Wed, 15 Mar 2023 12:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882798;
	bh=OOd06p52d3HEOy/TxocowIHnU7OBHr8J/RbFDC5PD6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCw/JWFLbVmVL3kJ8K84TFgdRd5BqKIHmKlRUBL0Y878U2mntZQZpipsbqyqZTMuH
	 Xavm/YUym3yJ+m2ZAswi+yaLDZjH0mZ+0eCKCamYiEO80thZj2JcqBS0AhGzZhavkv
	 y5wU7219DmJ3YRhj+d5q+Iqq9WJecsTOzZCRAwcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9d16c39efb5fade84574@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/68] ext4: Fix deadlock during directory rename
Date: Wed, 15 Mar 2023 13:12:43 +0100
Message-Id: <20230315115728.041904746@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
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
index f9d11f59df7d2..b708b437b3e36 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3795,10 +3795,20 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -3855,11 +3865,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -3960,12 +3965,15 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
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



