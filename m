Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB8335C682;
	Tue, 21 Jul 2026 22:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671573; cv=none; b=gkh61Oy3LQdSrkIuc8JMmrPC9TsdgdWaOqlvOVdnsIaaADa5D7BVL5OiabFoY5ZuIxG1zE374xh8IiZK6xmupOLILTyFTpGCjLDcV8jSGIB66qW7v0giP07q3b2ze+YZeuXhQ9dW0MZXHg717EoNZi4ZHtcdPRBb3OvPliMX/1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671573; c=relaxed/simple;
	bh=ipO8F2zdBh6HDc+tt4qpIB7ff5G12zFMgJRr1A++kf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNqn55CYg2IwkYfuKG52zDgSW8/hdjprZpl9NvIL0Oa5Apc8qi6+QXNgwnOutCDy8nLeVrPMBtuBzcbkmIPU5X8oiRvz7OeBl4ortjJrTKLTRD/l6UtIZ5CnHc+cUwqzg/fgoVOXS2B/f2Eu0AKAFgfjxRXLUgboxAD7fYnW4w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+GQZYRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+GQZYRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC04A1F000E9;
	Tue, 21 Jul 2026 22:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671572;
	bh=QBPsnTiNTFhppXYKeCDFrElf1J8ajHPaTzWt9PfOG98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+GQZYRyPNi16ZucyAjEWNqDQm5dCbEL+wmFGdS+c06llYF/p7m6oTZ9aIFrG4h57
	 6lr2tMui7fp/nSbIYjq6efgW0O3NjYsWV/0t6T8y+PrsU536KZ49t13VQxAesH8JXa
	 QKQRCVdBTheBI8UjzAEksPyco0cFIoGI11LFrL6U=
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
Subject: [PATCH 5.15 296/843] ocfs2: rebase copied fsdlm LVB pointers in locking_state
Date: Tue, 21 Jul 2026 17:18:51 +0200
Message-ID: <20260721152412.687105625@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit 93612d48fa42b3d1a637eb9279e15281c611c000 ]

The locking_state debugfs iterator snapshots struct ocfs2_lock_res by
value under ocfs2_dlm_tracking_lock and later formats that copy in
ocfs2_dlm_seq_show().  That is fine for the inline fields, but the
userspace fsdlm stack stores the LVB through lksb_fsdlm.sb_lvbptr.  Once
the iterator drops the tracking lock, a copied non-NULL sb_lvbptr still
points into the original lockres owner, so teardown can free that
container before the debugfs dump walks the raw LVB bytes.

Rebase the copied sb_lvbptr to the copied l_lksb before dumping the raw
LVB.  The seq snapshot already carries the inline LVB storage reserved in
struct ocfs2_dlm_lksb, so the debugfs reader can dump the copied bytes
without borrowing the original lockres lifetime.

The buggy scenario involves two paths, with each column showing the order
within that path:

locking_state reader:                  lockres teardown:
1. ocfs2_dlm_seq_start()/next()        1. file release or another owner
   copies struct ocfs2_lock_res           teardown reaches
2. ocfs2_dlm_seq_show() formats           ocfs2_lock_res_free()
   the copied row                      2. the lockres is removed from the
3. ocfs2_dlm_lvb() follows the            tracking list
   copied sb_lvbptr                   3. the owner frees the original
                                          lockres container

Validation reproduced this kernel report:
KASAN slab-use-after-free in ocfs2_dlm_seq_show+0x1bd/0x430
RIP: 0033:0x7f8ec4b1e29d
The buggy address belongs to the object at ffff88810a1e0800 which belongs
to the cache kmalloc-1k of size 1024
The buggy address is located 368 bytes inside of freed 1024-byte region
[ffff88810a1e0800, ffff88810a1e0c00)
Read of size 1
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  ocfs2_dlm_seq_show+0x1bd/0x430 (fs/ocfs2/dlmglue.c:3137)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x19f/0x330
  kasan_report+0xe0/0x110
  seq_read_iter+0x29d/0x790
  seq_read+0x20a/0x280
  find_held_lock+0x2b/0x80
  rcu_read_unlock+0x18/0x70
  full_proxy_read+0x9e/0xd0
  vfs_read+0x12c/0x590
  ksys_read+0xd2/0x170
  do_user_addr_fault+0x65a/0x890
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  __kasan_kmalloc+0xaa/0xb0
  ocfs2_file_open+0x13e/0x300
  do_dentry_open+0x233/0x7f0
  vfs_open+0x5a/0x1b0
  path_openat+0x66d/0x1540
  do_file_open+0x186/0x2b0
  do_sys_openat2+0xce/0x150
  __x64_sys_openat+0xd0/0x140
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Freed by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x5f/0x80
  kfree+0x313/0x590
  ocfs2_file_release+0x138/0x260
  __fput+0x1df/0x4b0
  fput_close_sync+0xd2/0x170
  __x64_sys_close+0x55/0x90
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lore.kernel.org/20260525041726.4112882-1-rollkingzzc@gmail.com
Fixes: cf4d8d75d8ab ("ocfs2: add fsdlm to stackglue")
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
 fs/ocfs2/dlmglue.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index d96cacf31f53d7..8fcf85e7eb924e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3133,6 +3133,22 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
  *	- Add last pr/ex unlock times and first lock wait time in usecs
  */
 #define OCFS2_DLM_DEBUG_STR_VERSION 4
+
+/*
+ * The debug iterator snapshots lockres by value, so a userspace-stack LVB
+ * pointer copied from the original lockres must be rebased to the copied
+ * lksb before the dump walks the raw bytes.
+ */
+static void ocfs2_dlm_seq_rebase_lvb(struct ocfs2_lock_res *lockres)
+{
+	if (!ocfs2_stack_supports_plocks())
+		return;
+
+	if (lockres->l_lksb.lksb_fsdlm.sb_lvbptr)
+		lockres->l_lksb.lksb_fsdlm.sb_lvbptr =
+			(char *)&lockres->l_lksb + sizeof(struct dlm_lksb);
+}
+
 static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -3193,6 +3209,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 		   lockres->l_blocking);
 
 	/* Dump the raw LVB */
+	ocfs2_dlm_seq_rebase_lvb(lockres);
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	for(i = 0; i < DLM_LVB_LEN; i++)
 		seq_printf(m, "0x%x\t", lvb[i]);
-- 
2.53.0



