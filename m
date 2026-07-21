Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F5437473A;
	Tue, 21 Jul 2026 21:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671012; cv=none; b=W41qn3NEPG3AqPaGWbg5OHDEL1ITlKfVUQr8hO3Jcqdna8BYQ7YpbzzqvAGXxsH/hAOXRK4HlyNeNS8GG+WU4tS+PntwJq4VTPqckSqYavbTAED2ZJnErS/n9FVr+Ply5p+4isVCUX3teK+T26XH6HlolMESO4pyJHNUW/y/blg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671012; c=relaxed/simple;
	bh=uw4JIp4BDWC022HtHIq7gA/6hE8q2EAkq2gofFS7KCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doAkfdfiIiJuTS4vBM95aleUeAP5Z8BaCy8SQ5XEjilC7UvW9sNs2SAlAog4U1c90aw6Y4BDJh6i0EN7JiC6c2LuMeo8CjV0GiaztlT2NmFui6vhKxU2M50RitGvtu1gIM7pMeLOOIhC9eM2sAi/HlmOPGIiprwGEF9JAT4oJT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWHDAcpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWHDAcpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBF11F000E9;
	Tue, 21 Jul 2026 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671011;
	bh=pbY5beGlaBltA+tg09XuTT0//iEoFXe2AS51gf5zD6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWHDAcpgCccEo63Ok4RG7mY3XS5ueh9JVfXBRO/hr6cYV0En47uF+ewn+LRu+LZLE
	 YAGMV6uDjWw+xDAGc6LUaUePi7P1vuOeBHHBNKP78rIyHUECQzVdQ7i15RZX2kqFec
	 jLcYH1YwRyJGvwCJI8QDgXrxDka7jcXcNFHkZb2g=
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
Subject: [PATCH 5.15 032/843] f2fs: fix potential deadlock in gc_merge path of f2fs_balance_fs()
Date: Tue, 21 Jul 2026 17:14:27 +0200
Message-ID: <20260721152406.693019389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -515,6 +515,13 @@ void f2fs_balance_fs(struct f2fs_sb_info
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
@@ -525,13 +532,6 @@ void f2fs_balance_fs(struct f2fs_sb_info
 			io_schedule();
 			finish_wait(&sbi->gc_thread->fggc_wq, &wait);
 		} else {
-			/*
-			 * Submit all cached OPU/IPU DATA bios before triggering
-			 * foreground GC to avoid potential deadlocks.
-			 */
-			f2fs_submit_merged_write(sbi, DATA);
-			f2fs_submit_all_merged_ipu_writes(sbi);
-
 			down_write(&sbi->gc_lock);
 			f2fs_gc(sbi, false, false, false, NULL_SEGNO);
 		}


