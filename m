Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176EB43CEC7;
	Tue, 16 Jun 2026 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634556; cv=none; b=bp7wGGNxE7jQvP911gG/Q/20Gky/JD05RdWSemnATKeL7EPoFmZpkpZdoShTo1qwXjhhIcVyTErKDYNZgv8Aujwozv3UXOuQzd1XZXNcchLMULkUeJcwI4komdesBm//dgRQByK4frRdgIVY+Qkh5kW/qEU/f8QA8id+bYGvWgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634556; c=relaxed/simple;
	bh=EfIBFFQlkUK/4SO36q6WN1ZTNDUBQTZ0a2epTOMIU0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqzx71CmL3VfkmhrGn93zdRQi8N1chFOPqsMTUePCgsFOz7CTIFVi47Ndfl5eOoK2URPySZ67rXGT4uWSGlbvrK8AVxr/H4x/SNOFYNOfqmOfBIbsCChXPk+asVQQuHpJhjBOA6IYXMoYsMzMTcn1CHdwefEHbP+fnfv8YSt1UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnkUajAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnkUajAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139A61F000E9;
	Tue, 16 Jun 2026 18:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634555;
	bh=xPNw6cWAm5GlYQ3I4AnGVJssGUZe+dHuW4o8BkVogUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnkUajARGnAmMVMmTuCOhBSfOeBWtdkHuexI5ijDTZZUHzxQG4FybXHH1ctq4ZrQy
	 J/56D6wWbkT3+7uICYT6t0isRH4iIKcl1ZziCoSxamqovAELvNcn3fvvHM+GRKrvCG
	 7q2yrWEsl4SsXY1dmAjDn9ukJSeEyLAj0WchfmiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/411] hfsplus: fix held lock freed on hfsplus_fill_super()
Date: Tue, 16 Jun 2026 20:28:44 +0530
Message-ID: <20260616145116.360837745@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 90c500e4fd83fa33c09bc7ee23b6d9cc487ac733 ]

hfsplus_fill_super() calls hfs_find_init() to initialize a search
structure, which acquires tree->tree_lock. If the subsequent call to
hfsplus_cat_build_key() fails, the function jumps to the out_put_root
error label without releasing the lock. The later cleanup path then
frees the tree data structure with the lock still held, triggering a
held lock freed warning.

Fix this by adding the missing hfs_find_exit(&fd) call before jumping
to the out_put_root error label. This ensures that tree->tree_lock is
properly released on the error path.

The bug was originally detected on v6.13-rc1 using an experimental
static analysis tool we are developing, and we have verified that the
issue persists in the latest mainline kernel. The tool is specifically
designed to detect memory management issues. It is currently under active
development and not yet publicly available.

We confirmed the bug by runtime testing under QEMU with x86_64 defconfig,
lockdep enabled, and CONFIG_HFSPLUS_FS=y. To trigger the error path, we
used GDB to dynamically shrink the max_unistr_len parameter to 1 before
hfsplus_asc2uni() is called. This forces hfsplus_asc2uni() to naturally
return -ENAMETOOLONG, which propagates to hfsplus_cat_build_key() and
exercises the faulty error path. The following warning was observed
during mount:

	=========================
	WARNING: held lock freed!
	7.0.0-rc3-00016-gb4f0dd314b39 #4 Not tainted
	-------------------------
	mount/174 is freeing memory ffff888103f92000-ffff888103f92fff, with a lock still held there!
	ffff888103f920b0 (&tree->tree_lock){+.+.}-{4:4}, at: hfsplus_find_init+0x154/0x1e0
	2 locks held by mount/174:
	#0: ffff888103f960e0 (&type->s_umount_key#42/1){+.+.}-{4:4}, at: alloc_super.constprop.0+0x167/0xa40
	#1: ffff888103f920b0 (&tree->tree_lock){+.+.}-{4:4}, at: hfsplus_find_init+0x154/0x1e0

	stack backtrace:
	CPU: 2 UID: 0 PID: 174 Comm: mount Not tainted 7.0.0-rc3-00016-gb4f0dd314b39 #4 PREEMPT(lazy)
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
	Call Trace:
	<TASK>
	dump_stack_lvl+0x82/0xd0
	debug_check_no_locks_freed+0x13a/0x180
	kfree+0x16b/0x510
	? hfsplus_fill_super+0xcb4/0x18a0
	hfsplus_fill_super+0xcb4/0x18a0
	? __pfx_hfsplus_fill_super+0x10/0x10
	? srso_return_thunk+0x5/0x5f
	? bdev_open+0x65f/0xc30
	? srso_return_thunk+0x5/0x5f
	? pointer+0x4ce/0xbf0
	? trace_contention_end+0x11c/0x150
	? __pfx_pointer+0x10/0x10
	? srso_return_thunk+0x5/0x5f
	? bdev_open+0x79b/0xc30
	? srso_return_thunk+0x5/0x5f
	? srso_return_thunk+0x5/0x5f
	? vsnprintf+0x6da/0x1270
	? srso_return_thunk+0x5/0x5f
	? __mutex_unlock_slowpath+0x157/0x740
	? __pfx_vsnprintf+0x10/0x10
	? srso_return_thunk+0x5/0x5f
	? srso_return_thunk+0x5/0x5f
	? mark_held_locks+0x49/0x80
	? srso_return_thunk+0x5/0x5f
	? srso_return_thunk+0x5/0x5f
	? irqentry_exit+0x17b/0x5e0
	? trace_irq_disable.constprop.0+0x116/0x150
	? __pfx_hfsplus_fill_super+0x10/0x10
	? __pfx_hfsplus_fill_super+0x10/0x10
	get_tree_bdev_flags+0x302/0x580
	? __pfx_get_tree_bdev_flags+0x10/0x10
	? vfs_parse_fs_qstr+0x129/0x1a0
	? __pfx_vfs_parse_fs_qstr+0x3/0x10
	vfs_get_tree+0x89/0x320
	fc_mount+0x10/0x1d0
	path_mount+0x5c5/0x21c0
	? __pfx_path_mount+0x10/0x10
	? trace_irq_enable.constprop.0+0x116/0x150
	? trace_irq_enable.constprop.0+0x116/0x150
	? srso_return_thunk+0x5/0x5f
	? srso_return_thunk+0x5/0x5f
	? kmem_cache_free+0x307/0x540
	? user_path_at+0x51/0x60
	? __x64_sys_mount+0x212/0x280
	? srso_return_thunk+0x5/0x5f
	__x64_sys_mount+0x212/0x280
	? __pfx___x64_sys_mount+0x10/0x10
	? srso_return_thunk+0x5/0x5f
	? trace_irq_enable.constprop.0+0x116/0x150
	? srso_return_thunk+0x5/0x5f
	do_syscall_64+0x111/0x680
	entry_SYSCALL_64_after_hwframe+0x77/0x7f
	RIP: 0033:0x7ffacad55eae
	Code: 48 8b 0d 85 1f 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 8
	RSP: 002b:00007fff1ab55718 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
	RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ffacad55eae
	RDX: 000055740c64e5b0 RSI: 000055740c64e630 RDI: 000055740c651ab0
	RBP: 000055740c64e380 R08: 0000000000000000 R09: 0000000000000001
	R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
	R13: 000055740c64e5b0 R14: 000055740c651ab0 R15: 000055740c64e380
	</TASK>

After applying this patch, the warning no longer appears.

Fixes: 89ac9b4d3d1a ("hfsplus: fix longname handling")
CC: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hfsplus/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -539,8 +539,10 @@ static int hfsplus_fill_super(struct sup
 	if (err)
 		goto out_put_root;
 	err = hfsplus_cat_build_key(sb, fd.search_key, HFSPLUS_ROOT_CNID, &str);
-	if (unlikely(err < 0))
+	if (unlikely(err < 0)) {
+		hfs_find_exit(&fd);
 		goto out_put_root;
+	}
 	if (!hfsplus_brec_read_cat(&fd, &entry)) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER)) {


