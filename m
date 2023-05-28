Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041DC611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83191C433D2;
	Sun, 28 May 2023 19:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302825;
	bh=d4yItiBzRjfMRrdZQ69EO1/cdLcaMidzsYFY2Y1AsO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsTLZj2fjarZWHtC2hEtckQFccweRGNu5wXBmqpBIeOZz6FS5xZq/qaODqQBB/c6i
	 BwUrBYAZS7h1M53ZLPd5sCR3sB9/Cgg1G1cDE3UtZBLu1cYDPATWqNS8eAV50iyJby
	 mzOL9yXagU1dqutk/+NJVS0XQjgmSrDPT+X6y7XU=
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
Subject: [PATCH 5.10 024/211] ext4: fix lockdep warning when enabling MMP
Date: Sun, 28 May 2023 20:09:05 +0100
Message-Id: <20230528190844.121029883@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
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
index 92c863fd9a78d..7a9a8ed1de66c 100644
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



