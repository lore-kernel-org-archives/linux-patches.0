Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FD91519BF;
	Wed,  5 Feb 2025 15:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767974; cv=none; b=Qr0u79dEAzkM6gStc4/gCjJba2EA+8Ae51azt5e2BUXDrzWIDh92hSqGCJIwM7gpUZjInQtcrYKkruCXE8Z18lys93NfQIb76c+MoT/C8137w4DUdJONjGEnzorbKMa3/5rxq+pQ5kndzlp5grIRe5eUWCOsi/USdoYxbg6OVcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767974; c=relaxed/simple;
	bh=dA4h51W+08lCLL0pW6BRulkvtGvf4SnxPZmKljxhILI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AI9h3WZUTOYxMxOzNxMilNpTVRa38iJmMCgbeP2XEh2Q7hZezS37QXYurz6cJiDQosmuSfy1UeYNHH6WcIjnW95h2tVKo3xT9MwWD+fa1NoWcydFusqxlipYPp0mKbh340GXOCmJ2gZnG+LL0bRJPEOf3av/lq2AaF4V0tNjzZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XU1RMEKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XU1RMEKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFDBC4CED1;
	Wed,  5 Feb 2025 15:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767974;
	bh=dA4h51W+08lCLL0pW6BRulkvtGvf4SnxPZmKljxhILI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XU1RMEKqNRTugGGLhO5SHhJz9NrC3JwNom/QzqHlcnJbPUG00Xl1Qi9eI53P3gj54
	 QZDgaW+onVxw+D0Di4A3caDcsIROKJpkR5IUX0qLzlSayZdqEFsIm9hWxBVGbXHgPA
	 cQlG9aKYakMgTM70VoMSEJn/klPHhBZIWuvGVTe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com,
	syzbot+d98fd19acd08b36ff422@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 479/623] nilfs2: do not force clear folio if buffer is referenced
Date: Wed,  5 Feb 2025 14:43:41 +0100
Message-ID: <20250205134514.542528872@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit ca76bb226bf47ff04c782cacbd299f12ddee1ec1 ]

Patch series "nilfs2: protect busy buffer heads from being force-cleared".

This series fixes the buffer head state inconsistency issues reported by
syzbot that occurs when the filesystem is corrupted and falls back to
read-only, and the associated buffer head use-after-free issue.

This patch (of 2):

Syzbot has reported that after nilfs2 detects filesystem corruption and
falls back to read-only, inconsistencies in the buffer state may occur.

One of the inconsistencies is that when nilfs2 calls mark_buffer_dirty()
to set a data or metadata buffer as dirty, but it detects that the buffer
is not in the uptodate state:

 WARNING: CPU: 0 PID: 6049 at fs/buffer.c:1177 mark_buffer_dirty+0x2e5/0x520
  fs/buffer.c:1177
 ...
 Call Trace:
  <TASK>
  nilfs_palloc_commit_alloc_entry+0x4b/0x160 fs/nilfs2/alloc.c:598
  nilfs_ifile_create_inode+0x1dd/0x3a0 fs/nilfs2/ifile.c:73
  nilfs_new_inode+0x254/0x830 fs/nilfs2/inode.c:344
  nilfs_mkdir+0x10d/0x340 fs/nilfs2/namei.c:218
  vfs_mkdir+0x2f9/0x4f0 fs/namei.c:4257
  do_mkdirat+0x264/0x3a0 fs/namei.c:4280
  __do_sys_mkdirat fs/namei.c:4295 [inline]
  __se_sys_mkdirat fs/namei.c:4293 [inline]
  __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4293
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

The other is when nilfs_btree_propagate(), which propagates the dirty
state to the ancestor nodes of a b-tree that point to a dirty buffer,
detects that the origin buffer is not dirty, even though it should be:

 WARNING: CPU: 0 PID: 5245 at fs/nilfs2/btree.c:2089
  nilfs_btree_propagate+0xc79/0xdf0 fs/nilfs2/btree.c:2089
 ...
 Call Trace:
  <TASK>
  nilfs_bmap_propagate+0x75/0x120 fs/nilfs2/bmap.c:345
  nilfs_collect_file_data+0x4d/0xd0 fs/nilfs2/segment.c:587
  nilfs_segctor_apply_buffers+0x184/0x340 fs/nilfs2/segment.c:1006
  nilfs_segctor_scan_file+0x28c/0xa50 fs/nilfs2/segment.c:1045
  nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1216 [inline]
  nilfs_segctor_collect fs/nilfs2/segment.c:1540 [inline]
  nilfs_segctor_do_construct+0x1c28/0x6b90 fs/nilfs2/segment.c:2115
  nilfs_segctor_construct+0x181/0x6b0 fs/nilfs2/segment.c:2479
  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2587 [inline]
  nilfs_segctor_thread+0x69e/0xe80 fs/nilfs2/segment.c:2701
  kthread+0x2f0/0x390 kernel/kthread.c:389
  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
  </TASK>

Both of these issues are caused by the callbacks that handle the
page/folio write requests, forcibly clear various states, including the
working state of the buffers they hold, at unexpected times when they
detect read-only fallback.

Fix these issues by checking if the buffer is referenced before clearing
the page/folio state, and skipping the clear if it is.

Link: https://lkml.kernel.org/r/20250107200202.6432-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20250107200202.6432-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b2b14916b77acf8626d7
Reported-by: syzbot+d98fd19acd08b36ff422@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d98fd19acd08b36ff422
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Tested-by: syzbot+b2b14916b77acf8626d7@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/page.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 9de2a494a0694..899686d2e5f71 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -392,6 +392,11 @@ void nilfs_clear_dirty_pages(struct address_space *mapping)
 /**
  * nilfs_clear_folio_dirty - discard dirty folio
  * @folio: dirty folio that will be discarded
+ *
+ * nilfs_clear_folio_dirty() clears working states including dirty state for
+ * the folio and its buffers.  If the folio has buffers, clear only if it is
+ * confirmed that none of the buffer heads are busy (none have valid
+ * references and none are locked).
  */
 void nilfs_clear_folio_dirty(struct folio *folio)
 {
@@ -399,10 +404,6 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 
 	BUG_ON(!folio_test_locked(folio));
 
-	folio_clear_uptodate(folio);
-	folio_clear_mappedtodisk(folio);
-	folio_clear_checked(folio);
-
 	head = folio_buffers(folio);
 	if (head) {
 		const unsigned long clear_bits =
@@ -410,6 +411,25 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
 			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
 			 BIT(BH_Delay));
+		bool busy, invalidated = false;
+
+recheck_buffers:
+		busy = false;
+		bh = head;
+		do {
+			if (atomic_read(&bh->b_count) | buffer_locked(bh)) {
+				busy = true;
+				break;
+			}
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (busy) {
+			if (invalidated)
+				return;
+			invalidate_bh_lrus();
+			invalidated = true;
+			goto recheck_buffers;
+		}
 
 		bh = head;
 		do {
@@ -419,6 +439,9 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
+	folio_clear_checked(folio);
 	__nilfs_clear_folio_dirty(folio);
 }
 
-- 
2.39.5



