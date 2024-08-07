Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C1A82499;
	Wed,  7 Aug 2024 15:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043075; cv=none; b=BUfFSNnoEEMFoPK0XowBN3mWlBXjgzrg8Xrf1ady1hV6xrq9aFE2PhxN1nwwypGSnuOOyxbKGvcBO8VxrxQMfE6FDecVvkynJfCj8onEMlkig/Gij7U52M7ldNhJZA3oJljXlh/XdPaCJLVrq/PBHg7FNclUo3CJbJId/zeHq2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043075; c=relaxed/simple;
	bh=ehkAcju/HPDE2pU6BC9BSQaqU5zWpy4Q3nOxm1PvzPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzqm2uXqqzR7c7EottYcfdEed1GWeUgpZn+DedC+ewsyR/Yn0U7wPwVC2NXEF9O36Zioq5jPfN2ronlQwy5pVA987x4TU8eVVFZSLfnr8JX6S7mqnYW5nYM0iXm5BQF8DwR2Dww5ThslwCXVGzwjxvDBPy5Qp92rdMa6FF1vM14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlGUh3ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlGUh3ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D24C32781;
	Wed,  7 Aug 2024 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043075;
	bh=ehkAcju/HPDE2pU6BC9BSQaqU5zWpy4Q3nOxm1PvzPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlGUh3calc5nhJgsUeQirtvMLCB7lLdSl/E6T3fQtfsnSko+zmLQvlGNDMM1GjJmL
	 fr0xAb/kVhcAVPonuOhFGkvSFnbzPWIRaBEZ+2C2kyBYhbm7AXsCzgyHk5PO+AjEZ6
	 ir3FWQRAxl3m4DYBP+MOI3y50Nn58928sJWiQxQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a14d8ac9af3a2a4fd0c8@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 082/123] btrfs: make cow_file_range_inline() honor locked_page on error
Date: Wed,  7 Aug 2024 17:00:01 +0200
Message-ID: <20240807150023.463985434@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 478574370bef7951fbd9ef5155537d6cbed49472 upstream.

The btrfs buffered write path runs through __extent_writepage() which
has some tricky return value handling for writepage_delalloc().
Specifically, when that returns 1, we exit, but for other return values
we continue and end up calling btrfs_folio_end_all_writers(). If the
folio has been unlocked (note that we check the PageLocked bit at the
start of __extent_writepage()), this results in an assert panic like
this one from syzbot:

  BTRFS: error (device loop0 state EAL) in free_log_tree:3267: errno=-5 IO failure
  BTRFS warning (device loop0 state EAL): Skipping commit of aborted transaction.
  BTRFS: error (device loop0 state EAL) in cleanup_transaction:2018: errno=-5 IO failure
  assertion failed: folio_test_locked(folio), in fs/btrfs/subpage.c:871
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/subpage.c:871!
  Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
  CPU: 1 PID: 5090 Comm: syz-executor225 Not tainted
  6.10.0-syzkaller-05505-gb1bc554e009e #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
  Google 06/27/2024
  RIP: 0010:btrfs_folio_end_all_writers+0x55b/0x610 fs/btrfs/subpage.c:871
  Code: e9 d3 fb ff ff e8 25 22 c2 fd 48 c7 c7 c0 3c 0e 8c 48 c7 c6 80 3d
  0e 8c 48 c7 c2 60 3c 0e 8c b9 67 03 00 00 e8 66 47 ad 07 90 <0f> 0b e8
  6e 45 b0 07 4c 89 ff be 08 00 00 00 e8 21 12 25 fe 4c 89
  RSP: 0018:ffffc900033d72e0 EFLAGS: 00010246
  RAX: 0000000000000045 RBX: 00fff0000000402c RCX: 663b7a08c50a0a00
  RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
  RBP: ffffc900033d73b0 R08: ffffffff8176b98c R09: 1ffff9200067adfc
  R10: dffffc0000000000 R11: fffff5200067adfd R12: 0000000000000001
  R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0001cbee80
  FS:  0000000000000000(0000) GS:ffff8880b9500000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f5f076012f8 CR3: 000000000e134000 CR4: 00000000003506f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
  <TASK>
  __extent_writepage fs/btrfs/extent_io.c:1597 [inline]
  extent_write_cache_pages fs/btrfs/extent_io.c:2251 [inline]
  btrfs_writepages+0x14d7/0x2760 fs/btrfs/extent_io.c:2373
  do_writepages+0x359/0x870 mm/page-writeback.c:2656
  filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:397
  __filemap_fdatawrite_range mm/filemap.c:430 [inline]
  __filemap_fdatawrite mm/filemap.c:436 [inline]
  filemap_flush+0xdf/0x130 mm/filemap.c:463
  btrfs_release_file+0x117/0x130 fs/btrfs/file.c:1547
  __fput+0x24a/0x8a0 fs/file_table.c:422
  task_work_run+0x24f/0x310 kernel/task_work.c:222
  exit_task_work include/linux/task_work.h:40 [inline]
  do_exit+0xa2f/0x27f0 kernel/exit.c:877
  do_group_exit+0x207/0x2c0 kernel/exit.c:1026
  __do_sys_exit_group kernel/exit.c:1037 [inline]
  __se_sys_exit_group kernel/exit.c:1035 [inline]
  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1035
  x64_sys_call+0x2634/0x2640
  arch/x86/include/generated/asm/syscalls_64.h:232
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f5f075b70c9
  Code: Unable to access opcode bytes at
  0x7f5f075b709f.

I was hitting the same issue by doing hundreds of accelerated runs of
generic/475, which also hits IO errors by design.

I instrumented that reproducer with bpftrace and found that the
undesirable folio_unlock was coming from the following callstack:

  folio_unlock+5
  __process_pages_contig+475
  cow_file_range_inline.constprop.0+230
  cow_file_range+803
  btrfs_run_delalloc_range+566
  writepage_delalloc+332
  __extent_writepage # inlined in my stacktrace, but I added it here
  extent_write_cache_pages+622

Looking at the bisected-to patch in the syzbot report, Josef realized
that the logic of the cow_file_range_inline error path subtly changing.
In the past, on error, it jumped to out_unlock in cow_file_range(),
which honors the locked_page, so when we ultimately call
folio_end_all_writers(), the folio of interest is still locked. After
the change, we always unlocked ignoring the locked_page, on both success
and error. On the success path, this all results in returning 1 to
__extent_writepage(), which skips the folio_end_all_writers() call,
which makes it OK to have unlocked.

Fix the bug by wiring the locked_page into cow_file_range_inline() and
only setting locked_page to NULL on success.

Reported-by: syzbot+a14d8ac9af3a2a4fd0c8@syzkaller.appspotmail.com
Fixes: 0586d0a89e77 ("btrfs: move extent bit and page cleanup into cow_file_range_inline")
CC: stable@vger.kernel.org # 6.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -737,8 +737,9 @@ out:
 	return ret;
 }
 
-static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 offset,
-					  u64 end,
+static noinline int cow_file_range_inline(struct btrfs_inode *inode,
+					  struct page *locked_page,
+					  u64 offset, u64 end,
 					  size_t compressed_size,
 					  int compress_type,
 					  struct folio *compressed_folio,
@@ -762,7 +763,10 @@ static noinline int cow_file_range_inlin
 		return ret;
 	}
 
-	extent_clear_unlock_delalloc(inode, offset, end, NULL, &cached,
+	if (ret == 0)
+		locked_page = NULL;
+
+	extent_clear_unlock_delalloc(inode, offset, end, locked_page, &cached,
 				     clear_flags,
 				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
 				     PAGE_END_WRITEBACK);
@@ -1037,10 +1041,10 @@ again:
 	 * extent for the subpage case.
 	 */
 	if (total_in < actual_end)
-		ret = cow_file_range_inline(inode, start, end, 0,
+		ret = cow_file_range_inline(inode, NULL, start, end, 0,
 					    BTRFS_COMPRESS_NONE, NULL, false);
 	else
-		ret = cow_file_range_inline(inode, start, end, total_compressed,
+		ret = cow_file_range_inline(inode, NULL, start, end, total_compressed,
 					    compress_type, folios[0], false);
 	if (ret <= 0) {
 		if (ret < 0)
@@ -1359,7 +1363,7 @@ static noinline int cow_file_range(struc
 
 	if (!no_inline) {
 		/* lets try to make an inline extent */
-		ret = cow_file_range_inline(inode, start, end, 0,
+		ret = cow_file_range_inline(inode, locked_page, start, end, 0,
 					    BTRFS_COMPRESS_NONE, NULL, false);
 		if (ret <= 0) {
 			/*


