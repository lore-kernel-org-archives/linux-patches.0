Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EC33D7A0C;
	Thu, 16 Jul 2026 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210354; cv=none; b=QNh5nGc+/0ICMvWPVV9k00UnJ3eM8u1ttvr+uaSJb4FEe5mKfgLsZSyCz/KofB9Oz7qaEX4gO0A6k1S+rMLPo6ExCkAAAiwNb06BUKmNADDby8GBB87cvJU3URZw7JqINkFujFwWrQsFQ05tM3PjPaUwnUueg9UX76u7K7Zvvc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210354; c=relaxed/simple;
	bh=sDgVwgY0zaY9kHATLQJ9o8AJ39IJiNPOMni9W+QoaH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hrt/32kRrwoSk9vhGtN5eInaBIfVVlLtw72V649s3R4x4IJDxrYXX01baIdq05StlcHE0NIEOm3PJ4zmmXAeDkWOMcDHYUlggLKtd6kOj8QhqcjYw1AtC1fo0/I9l2Sg84DD++DFo6nhdN1/Tkisg4pr3lBP/vn5W2yuJ4L6hZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNURsVur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNURsVur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E09D1F000E9;
	Thu, 16 Jul 2026 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210353;
	bh=2F/UooH5inX/YPq9emrJu5Xo2cWfkJFjn6WozVt4ExA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNURsVurTkc5ot6kuM9swIRG1xygwfQzfyJX006U9u0caguJVil6EvxDYYjaD63TV
	 SJ5hW1O24kwjBQdPJWZoe47Y6AGvlBxRBsTfFah9/0DaoIogBLH8GF5uzwoLvOrV7X
	 dRT49WB7NbbSDzYE1sdY1wMZQsCuuDQSEG88/ofE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/480] f2fs: introduce f2fs_schedule_timeout()
Date: Thu, 16 Jul 2026 15:26:03 +0200
Message-ID: <20260716133045.043712656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 76e780d88c771921ea643fb8a6c8d0b08c17cb7b ]

In f2fs retry logic, we will call f2fs_io_schedule_timeout() to sleep as
uninterruptible state (waiting for IO) for a while, however, in several
paths below, we are not blocked by IO:
- f2fs_write_single_data_page() return -EAGAIN due to racing on cp_rwsem.
- f2fs_flush_device_cache() failed to submit preflush command.
- __issue_discard_cmd_range() sleeps periodically in between two in batch
discard submissions.

So, in order to reveal state of task more accurate, let's introduce
f2fs_schedule_timeout() and call it in above paths in where we are waiting
for non-IO reasons.

Then we can get real reason of uninterruptible sleep for a thread in
tracepoint, perfetto, etc.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 8712353ed80f ("f2fs: fix to do sanity check on f2fs_get_node_folio_ra()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c |    4 ++--
 fs/f2fs/compress.c   |    4 ++--
 fs/f2fs/data.c       |    4 ++--
 fs/f2fs/f2fs.h       |   22 +++++++++++++++-------
 fs/f2fs/segment.c    |    4 ++--
 fs/f2fs/super.c      |    2 +-
 6 files changed, 24 insertions(+), 16 deletions(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1330,7 +1330,7 @@ void f2fs_wait_on_all_pages(struct f2fs_
 			f2fs_submit_merged_write(sbi, DATA);
 
 		prepare_to_wait(&sbi->cp_wait, &wait, TASK_UNINTERRUPTIBLE);
-		io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+		io_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 	}
 	finish_wait(&sbi->cp_wait, &wait);
 }
@@ -1986,7 +1986,7 @@ void f2fs_flush_ckpt_thread(struct f2fs_
 
 	/* Let's wait for the previous dispatched checkpoint. */
 	while (atomic_read(&cprc->queued_ckpt))
-		io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+		io_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 }
 
 void f2fs_init_ckpt_req_control(struct f2fs_sb_info *sbi)
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1057,7 +1057,7 @@ static void cancel_cluster_writeback(str
 		f2fs_submit_merged_write(F2FS_I_SB(cc->inode), DATA);
 		while (atomic_read(&cic->pending_pages) !=
 					(cc->valid_nr_cpages - submitted + 1))
-			f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+			f2fs_io_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 	}
 
 	/* Cancel writeback and stay locked. */
@@ -1582,7 +1582,7 @@ continue_unlock:
 				 */
 				if (IS_NOQUOTA(cc->inode))
 					goto out;
-				f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+				f2fs_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 				goto retry_write;
 			}
 			goto out;
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3214,8 +3214,8 @@ result:
 				} else if (ret == -EAGAIN) {
 					ret = 0;
 					if (wbc->sync_mode == WB_SYNC_ALL) {
-						f2fs_io_schedule_timeout(
-							DEFAULT_IO_TIMEOUT);
+						f2fs_schedule_timeout(
+							DEFAULT_SCHEDULE_TIMEOUT);
 						goto retry_write;
 					}
 					goto next;
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -665,8 +665,8 @@ enum {
 
 #define DEFAULT_RETRY_IO_COUNT	8	/* maximum retry read IO or flush count */
 
-/* congestion wait timeout value, default: 20ms */
-#define	DEFAULT_IO_TIMEOUT	(msecs_to_jiffies(20))
+/* IO/non-IO congestion wait timeout value, default: 20ms */
+#define	DEFAULT_SCHEDULE_TIMEOUT	(msecs_to_jiffies(20))
 
 /* timeout value injected, default: 1000ms */
 #define DEFAULT_FAULT_TIMEOUT	(msecs_to_jiffies(1000))
@@ -4940,22 +4940,30 @@ static inline bool f2fs_block_unit_disca
 	return F2FS_OPTION(sbi).discard_unit == DISCARD_UNIT_BLOCK;
 }
 
-static inline void f2fs_io_schedule_timeout(long timeout)
+static inline void __f2fs_schedule_timeout(long timeout, bool io)
 {
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	io_schedule_timeout(timeout);
+	if (io)
+		io_schedule_timeout(timeout);
+	else
+		schedule_timeout(timeout);
 }
 
+#define f2fs_io_schedule_timeout(timeout)		\
+			__f2fs_schedule_timeout(timeout, true)
+#define f2fs_schedule_timeout(timeout)			\
+			__f2fs_schedule_timeout(timeout, false)
+
 static inline void f2fs_io_schedule_timeout_killable(long timeout)
 {
 	while (timeout) {
 		if (fatal_signal_pending(current))
 			return;
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		io_schedule_timeout(DEFAULT_IO_TIMEOUT);
-		if (timeout <= DEFAULT_IO_TIMEOUT)
+		io_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
+		if (timeout <= DEFAULT_SCHEDULE_TIMEOUT)
 			return;
-		timeout -= DEFAULT_IO_TIMEOUT;
+		timeout -= DEFAULT_SCHEDULE_TIMEOUT;
 	}
 }
 
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -758,7 +758,7 @@ int f2fs_flush_device_cache(struct f2fs_
 		do {
 			ret = __submit_flush_wait(sbi, FDEV(i).bdev);
 			if (ret)
-				f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+				f2fs_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 		} while (ret && --count);
 
 		if (ret) {
@@ -3480,7 +3480,7 @@ next:
 			blk_finish_plug(&plug);
 			mutex_unlock(&dcc->cmd_lock);
 			trimmed += __wait_all_discard_cmd(sbi, NULL);
-			f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+			f2fs_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 			goto next;
 		}
 skip:
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2656,7 +2656,7 @@ static int f2fs_enable_checkpoint(struct
 	/* we should flush all the data to keep data consistency */
 	while (get_pages(sbi, F2FS_DIRTY_DATA)) {
 		writeback_inodes_sb_nr(sbi->sb, nr_pages, WB_REASON_SYNC);
-		f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+		f2fs_io_schedule_timeout(DEFAULT_SCHEDULE_TIMEOUT);
 
 		if (f2fs_time_over(sbi, ENABLE_TIME))
 			break;


