Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400A322301;
	Thu, 16 Jul 2026 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210346; cv=none; b=SMLJZjVhmI2nDSyQAVFKd9Q0by3g4h907cdhdmRuX1LXHBAxVwZtryKiBUnE/cOX4TUv6+H8kA0WU35wA9Wic85RCWHQFbPbdpkARK70xzCDrlm1L5ohP+V0Z7W5QpMjbStIodNsM3tuaP3ubuEK3Fo1X7k3JboVpA66hKzySoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210346; c=relaxed/simple;
	bh=NJ7RGyZush+5fpgZcHf1SIjbg4IaaHJv6tArb3C/D8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQOlLe2c5VCMHT0XOgYKsk9/cR7maz4cnbjQ/UY8bziKUjdEdYU4Wo4JxEslySzmidyA+6j9FnWqY5rvsOmBcSU0bWJibUCMJnwVGG1lwUTy/9RX0mjBVylSOmvH8Qptig7lL9r+k/0K8u1VNIPUgSuJC1jAZk98ZTtjdHNO2nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDy3BIAU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDy3BIAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1051F00A3A;
	Thu, 16 Jul 2026 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210345;
	bh=Hutv7YHsOlT7jJQTjHulPBMduXRHAP65+wPRoDJTw54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDy3BIAUJu+Ym+fr7gPLdPjWtscSw2bHbSVL0Le+KqcAwtjvPD//z7gbLWoCB9Tgs
	 LlUPDuc1Nnz1OegwQZMvzFFesHvWwCylfxhZ1P53sArnpTSHh8nZQqOLosY29KNnjN
	 rjTnS64PZ2CNynrl99ZQi/J0SilrLLRPQQvt9/Oc=
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
Subject: [PATCH 6.18 013/480] f2fs: fix potential deadlock in gc_merge path of f2fs_balance_fs()
Date: Thu, 16 Jul 2026 15:26:00 +0200
Message-ID: <20260716133044.977135302@linuxfoundation.org>
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
@@ -443,6 +443,13 @@ void f2fs_balance_fs(struct f2fs_sb_info
 	if (has_enough_free_secs(sbi, 0, 0))
 		return;
 
+	/*
+	 * Submit all cached OPU/IPU DATA bios before triggering
+	 * foreground GC to avoid potential deadlocks.
+	 */
+	f2fs_submit_merged_write(sbi, DATA);
+	f2fs_submit_all_merged_ipu_writes(sbi);
+
 	if (test_opt(sbi, GC_MERGE) && sbi->gc_thread &&
 				sbi->gc_thread->f2fs_gc_task) {
 		DEFINE_WAIT(wait);
@@ -462,13 +469,6 @@ void f2fs_balance_fs(struct f2fs_sb_info
 			.err_gc_skipped = false,
 			.nr_free_secs = 1 };
 
-		/*
-		 * Submit all cached OPU/IPU DATA bios before triggering
-		 * foreground GC to avoid potential deadlocks.
-		 */
-		f2fs_submit_merged_write(sbi, DATA);
-		f2fs_submit_all_merged_ipu_writes(sbi);
-
 		f2fs_down_write(&sbi->gc_lock);
 		stat_inc_gc_call_count(sbi, FOREGROUND);
 		f2fs_gc(sbi, &gc_control);


