Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2854418F5;
	Tue, 21 Jul 2026 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668022; cv=none; b=Sp2obSdEx+9da/JqoJyAzfMKk50OXRPTeDggYFgO/0JArKftLwxd+Kt8fVBba4wYUYVl0jhy5F6YY4R6obQtqD4fxtdTAuCXGVfWO+Bag9IimNJqLt9BvFFtpbREthczMtYyXqzvMme3RgjLAI5hKISRZEYl8RX3EXGRtryqGWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668022; c=relaxed/simple;
	bh=hiKLXhU1Uc94DaT91XC5BmEuBHimF10C2+0zMXEDVGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLpXGEFE/LIia4DPU5SL5jSLZY6G4u7HC2kuWgYhFWoCyCfApScy2GjLw/gbdhIZ2VnrTZn4/+/BH+k0F2lsQSgUhTC3lM6mOvDawJ5p787kIH6kjDY8ZoHX+NRVDnSMWRC8/OZQOd/XEE4vWZo44dkKf0HMpoZEoeeBBw6LU5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nblZO3Xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nblZO3Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273301F000E9;
	Tue, 21 Jul 2026 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668020;
	bh=rZSg5djmxDgl70LvhwPDQs2bYcns/Lrzt3S6vSnzgew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nblZO3XuF4MN10599fF5CAyuJ+YUG3ghvrH1MymyYli51KjAKrfFW53LA0Wj4xQKm
	 F4h1NdbYQLq8ocqDWCzbgwJdFUepa5TgHROeasTAaJqE6KHZvAOpco3Hd3I07PeXQm
	 TcNcTHw7WJpl2/Ldj3wA9jlIhhljELGGeGLS5JM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ruipeng Qi <ruipengqi3@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Chao Yu <chaseyu@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0019/1067] f2fs: fix potential deadlock in gc_merge path of f2fs_balance_fs()
Date: Tue, 21 Jul 2026 17:10:20 +0200
Message-ID: <20260721152424.964082688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 8b4468ec023d0d1b4669dfb867588997cc03a06b ]

When we mount device w/ gc_merge mount option, we may suffer below
potential deadlock:

Kworker					GC trehad			Truncator
- f2fs_write_cache_pages
 - f2fs_write_single_data_page
  - f2fs_do_write_data_page
   - folio_start_writeback  --- set writeback flag on folio
   - f2fs_outplace_write_data
   : cached folio in internal bio cache
  - f2fs_balance_fs
   - wake_up(gc_thread)
   : wake up gc thread to run foreground GC
   - finish_wait(fggc_wq)
   : wait on the waitqueue --- wait on GC thread to finish the work
									- truncate_inode_pages_range
									 - __filemap_get_folio(, FGP_LOCK)  --- lock folio
									 - truncate_inode_partial_folio
									  - folio_wait_writeback            --- wait on writeback being cleared
					- do_garbage_collect
					 - move_data_page
					  - f2fs_get_lock_data_folio
					   - lock on folio  --- blocked on folio's lock

In order to avoid such deadlock, let's call below functions to commit
cached bios in GC_MERGE path of f2fs_balance_fs() as the same as we did
in NOGC_MERGE path.
- f2fs_submit_merged_write(sbi, DATA);
- f2fs_submit_all_merged_ipu_writes(sbi);

Cc: stable@kernel.org
Fixes: 351df4b20115 ("f2fs: add segment operations")
Cc: Ruipeng Qi <ruipengqi3@gmail.com>
Reported: Sandeep Dhavale <dhavale@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Chao Yu <chaseyu@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -408,6 +408,13 @@ void f2fs_balance_fs(struct f2fs_sb_info
 	 * dir/node pages without enough free segments.
 	 */
 	if (has_not_enough_free_secs(sbi, 0, 0)) {
+		/*
+		 * Submit all cached OPU/IPU DATA bios before triggering
+		 * foreground GC to avoid potential deadlocks.
+		 */
+		f2fs_submit_merged_write(sbi, DATA);
+		f2fs_submit_all_merged_ipu_writes(sbi);
+
 		if (test_opt(sbi, GC_MERGE) && sbi->gc_thread &&
 					sbi->gc_thread->f2fs_gc_task) {
 			DEFINE_WAIT(wait);
@@ -426,13 +433,6 @@ void f2fs_balance_fs(struct f2fs_sb_info
 				.err_gc_skipped = false,
 				.nr_free_secs = 1 };
 
-			/*
-			 * Submit all cached OPU/IPU DATA bios before triggering
-			 * foreground GC to avoid potential deadlocks.
-			 */
-			f2fs_submit_merged_write(sbi, DATA);
-			f2fs_submit_all_merged_ipu_writes(sbi);
-
 			f2fs_down_write(&sbi->gc_lock);
 			f2fs_gc(sbi, &gc_control);
 		}


