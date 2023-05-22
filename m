Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08EF171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBCBC4339C;
	Mon, 22 May 2023 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684782822;
	bh=Ad2UXggBPUQFgGQJFs6Nq5lTd63NR0y5wkbb0JgwmGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joN/QKGrjRYDkZbIHHR6dyqQrKvtjKrmVZDb7kt+0aQ266mcHuz7rgV0o3nXsQMHa
	 veYEMK6XKsd754XLysEafosrXsPs90b7fuoaVgVqHJsKkL3v766J+mNMW7EbnNHEXG
	 DkOORTtvL8gxadgp5ca8tao9MzYHhpHxdOUuVuRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+6b7df7d5506b32467149@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/203] ext4: fix lockdep warning when enabling MMP
Date: Mon, 22 May 2023 20:07:31 +0100
Message-Id: <20230522190355.714531949@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
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

[ Upstream commit 949f95ff39bf188e594e7ecd8e29b82eb108f5bf ]

When we enable MMP in ext4_multi_mount_protect() during mount or
remount, we end up calling sb_start_write() from write_mmp_block(). This
triggers lockdep warning because freeze protection ranks above s_umount
semaphore we are holding during mount / remount. The problem is harmless
because we are guaranteed the filesystem is not frozen during mount /
remount but still let's fix the warning by not grabbing freeze
protection from ext4_multi_mount_protect().

Cc: stable@kernel.org
Reported-by: syzbot+6b7df7d5506b32467149@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=ab7e5b6f400b7778d46f01841422e5718fb81843
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/r/20230411121019.21940-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mmp.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 28129a8db713c..3e8bce19ad16d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -39,28 +39,36 @@ static void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
  * Write the MMP block using REQ_SYNC to try to get the block on-disk
  * faster.
  */
-static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
+static int write_mmp_block_thawed(struct super_block *sb,
+				  struct buffer_head *bh)
 {
 	struct mmp_struct *mmp = (struct mmp_struct *)(bh->b_data);
 
-	/*
-	 * We protect against freezing so that we don't create dirty buffers
-	 * on frozen filesystem.
-	 */
-	sb_start_write(sb);
 	ext4_mmp_csum_set(sb, mmp);
 	lock_buffer(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
 	submit_bh(REQ_OP_WRITE, REQ_SYNC | REQ_META | REQ_PRIO, bh);
 	wait_on_buffer(bh);
-	sb_end_write(sb);
 	if (unlikely(!buffer_uptodate(bh)))
 		return -EIO;
-
 	return 0;
 }
 
+static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
+{
+	int err;
+
+	/*
+	 * We protect against freezing so that we don't create dirty buffers
+	 * on frozen filesystem.
+	 */
+	sb_start_write(sb);
+	err = write_mmp_block_thawed(sb, bh);
+	sb_end_write(sb);
+	return err;
+}
+
 /*
  * Read the MMP block. It _must_ be read from disk and hence we clear the
  * uptodate flag on the buffer.
@@ -352,7 +360,11 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	seq = mmp_new_seq();
 	mmp->mmp_seq = cpu_to_le32(seq);
 
-	retval = write_mmp_block(sb, bh);
+	/*
+	 * On mount / remount we are protected against fs freezing (by s_umount
+	 * semaphore) and grabbing freeze protection upsets lockdep
+	 */
+	retval = write_mmp_block_thawed(sb, bh);
 	if (retval)
 		goto failed;
 
-- 
2.39.2



