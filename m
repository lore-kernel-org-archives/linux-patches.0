Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D964431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0827C433EF;
	Wed, 15 Mar 2023 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883588;
	bh=j07vEKC202TbWxmUU3linCKGfpAvj62RAV4w8SATi0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYWFY2CsuzTiFTT7HKxJur6wp/hb/vzljA/Ou9tGpu6nULwhJRbBdMl0Aff1FkNKq
	 vGZ5DzNSnjZKKDO0BoLcNFS5fjI8NVjzFPxxzYMEJf94chxRosqPCnIoFh97+ZXzjZ
	 US+qvhctg1w2rnJbOdsQaz+Kl/aN1YwgHxTF9PpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/143] ext4: Fix possible corruption when moving a directory
Date: Wed, 15 Mar 2023 13:12:22 +0100
Message-Id: <20230315115742.225534914@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

[ Upstream commit 0813299c586b175d7edb25f56412c54b812d0379 ]

When we are renaming a directory to a different directory, we need to
update '..' entry in the moved directory. However nothing prevents moved
directory from being modified and even converted from the inline format
to the normal format. When such race happens the rename code gets
confused and we crash. Fix the problem by locking the moved directory.

CC: stable@vger.kernel.org
Fixes: 32f7f22c0b52 ("ext4: let ext4_rename handle inline dir")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230126112221.11866-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9799ed2fdbc09..dc8f8a435a7ea 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3873,9 +3873,16 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 			if (new.dir != old.dir && EXT4_DIR_LINK_MAX(new.dir))
 				goto end_rename;
 		}
+		/*
+		 * We need to protect against old.inode directory getting
+		 * converted from inline directory format into a normal one.
+		 */
+		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval)
+		if (retval) {
+			inode_unlock(old.inode);
 			goto end_rename;
+		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or
@@ -4007,6 +4014,8 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	} else {
 		ext4_journal_stop(handle);
 	}
+	if (old.dir_bh)
+		inode_unlock(old.inode);
 release_bh:
 	brelse(old.dir_bh);
 	brelse(old.bh);
-- 
2.39.2



