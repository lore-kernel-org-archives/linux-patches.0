Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F4146C4D2;
	Tue, 21 Jul 2026 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649177; cv=none; b=UwlFwMF0rJCwC2dE/eU+Qn8BkuJhiMc4KBNT3BmyuUVguMgFKnTGeeOYZQ34R8lkVvpI9jV15ZomYB6fSIJxlgKGzf4zOSKsdzVq5+DoAichiKqVz005AU/U5pmDuLDeMLr0V0BPxBXpuSxUrP7cgOceItIwlzB6Iy8h69kbVk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649177; c=relaxed/simple;
	bh=JaJXXSj8k8mdMkccrzSI5j4pZO5zGn1LGQWoQ7I/EZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di1/nzJCM7ivsoOzOn0PAIuBqgklHrnVWaG/3gqNsnF7+i5lQfnIuqVna3yu7LQivtWD8kMrZbXCD/A6N0lErpBxe3juB3V1MSzBHd0JylGCHWUXOt5VjT+PmmUIvwkKdXa+qYSR5Ruyp/wnLWR8jNVxhPkYeKJEkHDWwlIXmc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcbWPFvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcbWPFvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A43A1F000E9;
	Tue, 21 Jul 2026 15:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649176;
	bh=1cMMqVSS26w0a4pwOqiCxVgcRBhygCosMRhLYQQlOX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcbWPFvLOF2puz+YTyzdQF57FqFjzaOr8qpk/uy0e52fNEaCt97O26slkDcrN5oYe
	 D6nM/rnB4wzx1UqF5O8BTUUdZlmcYHpv47l4WpnMvFruIiKVHrHUX2DS5CLh9nF60e
	 SXyzYyEMyienhKaPWxeVvqfumCKYkyuUzVtPjRno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0479/2077] ocfs2/dlm: require a ref for locking_state debugfs open
Date: Tue, 21 Jul 2026 17:02:32 +0200
Message-ID: <20260721152604.105539863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit 03ad858ce8064861ea580021976dc19b7aabb549 ]

debug_lockres_open() copies inode->i_private into struct debug_lockres and
debug_lockres_release() later drops that pointer with dlm_put().  That
only works if open successfully pins the struct dlm_ctxt.

Today open calls dlm_grab(dlm) but ignores its return value.  Once the
last domain unregister has removed the context from dlm_domains,
dlm_grab() returns NULL, yet open still stores the raw pointer and returns
success.  The later release path is outside the debugfs removal barrier,
so it can call dlm_put() after dlm_free_ctxt_mem() has freed the context.
KASAN reports this as a slab-use-after-free in dlm_put() called from
debug_lockres_release().

Fail the open when dlm_grab() cannot acquire the reference and unwind the
seq_file private state before returning.  That keeps locking_state from
handing out a file descriptor whose release path does not own the
dlm_ctxt.

The buggy scenario involves two paths, with each column showing the order
within that path:

locking_state debugfs open:          last domain unregister:
1. debug_lockres_open() reads        1. dlm_unregister_domain() calls
   inode->i_private.                    dlm_complete_dlm_shutdown().
2. debug_lockres_open() calls        2. shutdown removes the dlm_ctxt from
   dlm_grab(dlm) and gets NULL.         dlm_domains.
3. open still stores the raw dlm     3. final teardown reaches
   pointer in dl->dl_ctxt and           dlm_free_ctxt_mem() and frees it.
   returns success.
4. debug_lockres_release() later
   calls dlm_put(dl->dl_ctxt).

Validation reproduced this kernel report:
KASAN slab-use-after-free in dlm_put+0x82/0x200
RIP: 0033:0x7f4d349bc9e0
The buggy address belongs to the object at ffff888103a3c000 which belongs
to the cache kmalloc-2k of size 2048
The buggy address is located 816 bytes inside of freed 2048-byte region
[ffff888103a3c000, ffff888103a3c800)
Write of size 4
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xd0/0x630 (?:?)
  dlm_put+0x82/0x200 (?:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x188/0x2f0 (?:?)
  kasan_report+0xe4/0x120 (?:?)
  kasan_check_range+0x105/0x1b0 (?:?)
  debug_lockres_release+0x53/0x80 (fs/ocfs2/dlm/dlmdebug.c:587)
  dlm_put+0x9/0x200 (?:?)
  debug_lockres_release+0x5c/0x80 (fs/ocfs2/dlm/dlmdebug.c:587)
  full_proxy_release+0x67/0x90 (?:?)
  __fput+0x1df/0x4b0 (?:?)
  do_raw_spin_lock+0x10f/0x1b0 (?:?)
  fput_close_sync+0xd2/0x170 (?:?)
  __x64_sys_close+0x55/0x90 (?:?)
  do_syscall_64+0x10c/0x640 (arch/x86/entry/syscall_64.c:87)
  irqentry_exit+0xac/0x6e0 (?:?)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
Freed by task stack:
  kasan_save_stack+0x33/0x60 (?:?)
  kasan_save_track+0x14/0x30 (?:?)
  kasan_save_free_info+0x3b/0x60 (?:?)
  __kasan_slab_free+0x5f/0x80 (?:?)
  kfree+0x30f/0x580 (?:?)
  dlm_put+0x1ce/0x200 (?:?)
  dlm_unregister_domain+0xf6/0xb30 (?:?)
  o2cb_cluster_disconnect+0x6b/0x90 (?:?)
  ocfs2_cluster_disconnect+0x41/0x70 (?:?)
  ocfs2_dlm_shutdown+0x1c4/0x220 (?:?)
  ocfs2_dismount_volume+0x38a/0x550 (?:?)
  generic_shutdown_super+0xc3/0x220 (?:?)
  kill_block_super+0x29/0x60 (?:?)
  deactivate_locked_super+0x66/0xe0 (?:?)
  cleanup_mnt+0x13d/0x210 (?:?)
  task_work_run+0xfa/0x170 (?:?)
  exit_to_user_mode_loop+0xd6/0x430 (?:?)
  do_syscall_64+0x3cb/0x640 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Link: https://lore.kernel.org/20260531044714.1640172-1-rollkingzzc@gmail.com
Fixes: 4e3d24ed1a12 ("ocfs2/dlm: Dumps the lockres' into a debugfs file")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmdebug.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index fe4fdd09bae398..56456735862011 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -560,6 +560,7 @@ static int debug_lockres_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	struct debug_lockres *dl;
 	void *buf;
+	int status = -ENOMEM;
 
 	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -572,16 +573,23 @@ static int debug_lockres_open(struct inode *inode, struct file *file)
 	dl->dl_len = PAGE_SIZE;
 	dl->dl_buf = buf;
 
-	dlm_grab(dlm);
-	dl->dl_ctxt = dlm;
+	/* ->release uses dl_ctxt after open, so it needs a real pin. */
+	dl->dl_ctxt = dlm_grab(dlm);
+	if (!dl->dl_ctxt) {
+		status = -ENOENT;
+		goto bailseq;
+	}
 
 	return 0;
 
+bailseq:
+	seq_release_private(inode, file);
 bailfree:
 	kfree(buf);
 bail:
-	mlog_errno(-ENOMEM);
-	return -ENOMEM;
+	if (status != -ENOENT)
+		mlog_errno(status);
+	return status;
 }
 
 static int debug_lockres_release(struct inode *inode, struct file *file)
-- 
2.53.0



