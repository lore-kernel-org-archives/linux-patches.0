Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ADB341AD7;
	Tue, 16 Dec 2025 11:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884796; cv=none; b=j9ndqDCCE3dc9Oq7Ub8DtZ0jjGkVDqI6YEMMFwGK7+Oq2qzTNs+JEALer+wfRwo1ZX7QI3UVKqiCrXHxvfQgw6Fd1YJq6YXScKYyQrZPkJBOmGZh8xtLy6blkKcw4DaHSJsXx4KU1gJViunFeTSYF2W1YoUX3KPxwPlu57qKIdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884796; c=relaxed/simple;
	bh=LbH3yyFUdl2meuW0YEkkg+DprbsOJ8URSAAl+ZmHC7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtbuKHLXUi8Sx+sJT7B/gYG645OTv4wNbX1DbjGd8XPW+LStoTDFw+npTMANIicC/6uUpfkHjG++KJtiDLIC98WM94MUZKbRQed/PvxGk3Xc3Sd+gsxgBHBMmPOvM7jr3ZxH3sefU+ZZ9dVz8sMJ9p3DlytBM3n47d3T5hGYbAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrLutzD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrLutzD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED11BC4CEF1;
	Tue, 16 Dec 2025 11:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884796;
	bh=LbH3yyFUdl2meuW0YEkkg+DprbsOJ8URSAAl+ZmHC7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrLutzD+E2BhokVBd57pdJ/fo1bCBZgNR4b2m9VzSq9oeiBe/Pu03zofD4BibSeSF
	 qM4d0Ms1oyV4XZITIWtpZR0yWd+JIrLbY09GvmU/0/LkhHT1p/9nZd+j6WYvIBv1uk
	 s4CY+0gVJkou8uYTJPIWgerAMP1C18iksiZuDkbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/354] f2fs: maintain one time GC mode is enabled during whole zoned GC cycle
Date: Tue, 16 Dec 2025 12:14:28 +0100
Message-ID: <20251216111331.816743824@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit e462fc48ceb8224811c3224650afed05cb7f0872 ]

The current version missed setting one time GC for normal zoned GC
cycle. So, valid threshold control is not working. Need to fix it to
prevent excessive GC for zoned devices.

Fixes: e791d00bd06c ("f2fs: add valid block ratio not to do excessive GC for one time GC")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 12737dfba5efb..2dda8f23c0b99 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -38,13 +38,14 @@ static int gc_thread_func(void *data)
 	struct f2fs_gc_control gc_control = {
 		.victim_segno = NULL_SEGNO,
 		.should_migrate_blocks = false,
-		.err_gc_skipped = false };
+		.err_gc_skipped = false,
+		.one_time = false };
 
 	wait_ms = gc_th->min_sleep_time;
 
 	set_freezable();
 	do {
-		bool sync_mode, foreground = false;
+		bool sync_mode, foreground = false, gc_boost = false;
 
 		wait_event_freezable_timeout(*wq,
 				kthread_should_stop() ||
@@ -52,8 +53,12 @@ static int gc_thread_func(void *data)
 				gc_th->gc_wake,
 				msecs_to_jiffies(wait_ms));
 
-		if (test_opt(sbi, GC_MERGE) && waitqueue_active(fggc_wq))
+		if (test_opt(sbi, GC_MERGE) && waitqueue_active(fggc_wq)) {
 			foreground = true;
+			gc_control.one_time = false;
+		} else if (f2fs_sb_has_blkzoned(sbi)) {
+			gc_control.one_time = true;
+		}
 
 		/* give it a try one time */
 		if (gc_th->gc_wake)
@@ -81,8 +86,6 @@ static int gc_thread_func(void *data)
 			continue;
 		}
 
-		gc_control.one_time = false;
-
 		/*
 		 * [GC triggering condition]
 		 * 0. GC is not conducted currently.
@@ -132,7 +135,7 @@ static int gc_thread_func(void *data)
 		if (need_to_boost_gc(sbi)) {
 			decrease_sleep_time(gc_th, &wait_ms);
 			if (f2fs_sb_has_blkzoned(sbi))
-				gc_control.one_time = true;
+				gc_boost = true;
 		} else {
 			increase_sleep_time(gc_th, &wait_ms);
 		}
@@ -141,7 +144,7 @@ static int gc_thread_func(void *data)
 					FOREGROUND : BACKGROUND);
 
 		sync_mode = (F2FS_OPTION(sbi).bggc_mode == BGGC_MODE_SYNC) ||
-			(gc_control.one_time && gc_th->boost_gc_greedy);
+			(gc_boost && gc_th->boost_gc_greedy);
 
 		/* foreground GC was been triggered via f2fs_balance_fs() */
 		if (foreground)
-- 
2.51.0



