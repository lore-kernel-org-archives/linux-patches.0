Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB1D34D4E7;
	Tue, 16 Dec 2025 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888445; cv=none; b=Or7SPI43pVep60KAqr2n/u1gGa51HHkSEytRuXuJMg8Zoe0O5WGejRAfAYO4LEZGTLgaqkaL02t2EFctMkZSb5018HP8K+TF2IuubLHsJ4n2xiG2lMVuHLBNevlg/RoMmTRQrJKxAGl5MldM/f4mIjXQ8zuggUJLQe/uy8OTRPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888445; c=relaxed/simple;
	bh=vAePhrvbSsl8tAcnSIo6jSoJMQ2xwoWsN5ippSz3FUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL5g5c4n1K0fNtHtaeCXw94fvrqo3nhL1ivTSHBQenY1Iw6XC8u5zZ0kIqXSE/Z31tnn7HKSma0LzXDQK2wg91K20KqPtxw+uJmYB402g5zIrheI27zwBYTnrr23GzYijhtBdxarjBFm5jbD1gxAZQEOB1j0Mqs1OUNt/+KN0t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DubnlQFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DubnlQFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0CDC4CEF1;
	Tue, 16 Dec 2025 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888445;
	bh=vAePhrvbSsl8tAcnSIo6jSoJMQ2xwoWsN5ippSz3FUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DubnlQFkOasuwhCGqjSlTlKUqXOn0kaloOK/o74abITNUiTbf/gZBXTUI+leinO1U
	 U5VPnZ7fdh9QD0moGmIfk80Grx/9W00s7LuDnh4dhZEFxh14iYX9ux2963HDW96MsO
	 CNj5rjXEyTPDJoGLPAdO79lByXAmawtm4QUMQDLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 537/614] f2fs: maintain one time GC mode is enabled during whole zoned GC cycle
Date: Tue, 16 Dec 2025 12:15:04 +0100
Message-ID: <20251216111420.835901186@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index a7708cf80c04e..8abf521530ff3 100644
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
 		if (foreground && !f2fs_sb_has_blkzoned(sbi))
-- 
2.51.0



