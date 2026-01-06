Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37E72EFD95;
	Tue,  6 Jan 2026 17:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721360; cv=none; b=LvoDON/kzflZ8lZFOMsqI9RAHD8EfRiWN6tRwRFl5QD93e42klXB9pSOODhIk4IRIGB5K2GtgTtGpMa+C6y3cM4nYFKRkFg1XK75zKU7LeYCEHfnh1zIhowemvIANzX0myQIjNjVXVTBGKc8+7I6h5gmijPM33C37K6d2CJSdF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721360; c=relaxed/simple;
	bh=o7/WF1J1+a8NDcPt0CONJ2IVHU9cYCgY7XdPnMqP6sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHViSC7Psu/gCTw4ha6Bku5KeK+JjbFFr4kzNp7eZAyEmB6M/Vx9A7RFCGL1f673suwz6ce9kTcuRs5fSaeDleEXHVt9OeEO81aUE/d8FTlUb0xUrfEE25sur9ntGo22Jse4TW0ClsyczCM7W/N/f0BCWlTP03eJXrpOYxr3tQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEJpgmH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEJpgmH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BF4C116C6;
	Tue,  6 Jan 2026 17:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721360;
	bh=o7/WF1J1+a8NDcPt0CONJ2IVHU9cYCgY7XdPnMqP6sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEJpgmH+uTuMT8oytKBnw0TALkJ/jF871Pr+1yf6kHCZsjsVw9HzMD+sDK9crkt9U
	 1cdeTzMsPbF3Sl7aW7l7dH1blxWohSPCVTluIGhKO3ywY6yWhqgqvI73wpBOFHWNZq
	 lGNABqsBgUHLBbJd6Wh2OSVzgz5oZD89fHgQTxnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 513/567] f2fs: add timeout in f2fs_enable_checkpoint()
Date: Tue,  6 Jan 2026 18:04:55 +0100
Message-ID: <20260106170510.353936461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 4bc347779698b5e67e1514bab105c2c083e55502 ]

During f2fs_enable_checkpoint() in remount(), if we flush a large
amount of dirty pages into slow device, it may take long time which
will block write IO, let's add a timeout machanism during dirty
pages flush to avoid long time block in f2fs_enable_checkpoint().

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: be112e7449a6 ("f2fs: fix to propagate error from f2fs_enable_checkpoint()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |    2 ++
 fs/f2fs/super.c |   21 +++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -249,6 +249,7 @@ enum {
 #define DEF_CP_INTERVAL			60	/* 60 secs */
 #define DEF_IDLE_INTERVAL		5	/* 5 secs */
 #define DEF_DISABLE_INTERVAL		5	/* 5 secs */
+#define DEF_ENABLE_INTERVAL		16	/* 16 secs */
 #define DEF_DISABLE_QUICK_INTERVAL	1	/* 1 secs */
 #define DEF_UMOUNT_DISCARD_TIMEOUT	5	/* 5 secs */
 
@@ -1351,6 +1352,7 @@ enum {
 	DISCARD_TIME,
 	GC_TIME,
 	DISABLE_TIME,
+	ENABLE_TIME,
 	UMOUNT_DISCARD_TIMEOUT,
 	MAX_TIME,
 };
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2283,16 +2283,24 @@ restore_flag:
 
 static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
-	int retry = DEFAULT_RETRY_IO_COUNT;
+	unsigned int nr_pages = get_pages(sbi, F2FS_DIRTY_DATA) / 16;
+
+	f2fs_update_time(sbi, ENABLE_TIME);
 
 	/* we should flush all the data to keep data consistency */
-	do {
-		sync_inodes_sb(sbi->sb);
+	while (get_pages(sbi, F2FS_DIRTY_DATA)) {
+		writeback_inodes_sb_nr(sbi->sb, nr_pages, WB_REASON_SYNC);
 		f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
-	} while (get_pages(sbi, F2FS_DIRTY_DATA) && retry--);
 
-	if (unlikely(retry < 0))
-		f2fs_warn(sbi, "checkpoint=enable has some unwritten data.");
+		if (f2fs_time_over(sbi, ENABLE_TIME))
+			break;
+	}
+
+	sync_inodes_sb(sbi->sb);
+
+	if (unlikely(get_pages(sbi, F2FS_DIRTY_DATA)))
+		f2fs_warn(sbi, "checkpoint=enable has some unwritten data: %lld",
+					get_pages(sbi, F2FS_DIRTY_DATA));
 
 	f2fs_down_write(&sbi->gc_lock);
 	f2fs_dirty_to_prefree(sbi);
@@ -3868,6 +3876,7 @@ static void init_sb_info(struct f2fs_sb_
 	sbi->interval_time[DISCARD_TIME] = DEF_IDLE_INTERVAL;
 	sbi->interval_time[GC_TIME] = DEF_IDLE_INTERVAL;
 	sbi->interval_time[DISABLE_TIME] = DEF_DISABLE_INTERVAL;
+	sbi->interval_time[ENABLE_TIME] = DEF_ENABLE_INTERVAL;
 	sbi->interval_time[UMOUNT_DISCARD_TIMEOUT] =
 				DEF_UMOUNT_DISCARD_TIMEOUT;
 	clear_sbi_flag(sbi, SBI_NEED_FSCK);


