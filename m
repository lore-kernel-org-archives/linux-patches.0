Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7221F31E0E0;
	Mon, 27 Oct 2025 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592883; cv=none; b=uVLqLd5zlmjFDB2hNopsoO5nqUUcXAtCmJbzSjy6P6QCCckKwwnbA9SgTeF4addOrubc373hSD9djyWYNOJJYCb5raIbdaskAUQvHDI4hkUwog66RI+U6UM+h7OAEFRq/wWqsmNiQVjZZH9rSXQmvV14+eZyyKSF4He89DG1MgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592883; c=relaxed/simple;
	bh=2eG6NAvApt82IPALesV5qmG6GM/ZYXgh53YR5GdMeRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSVXzdi0x5VMUWOC8DVVq9ihZM+fXqDkKkAtpjHtm3W3ql9Jy3ZJzqt1p/1CJf9ylQWo8t2FNn9dJdaQWDuCxBxRVxD6KORomE7U2vx7adZLSW+ihWsQ/ad0uruZd+MVT8opaqZLjEKoWc9rTYkXpnyDrxmh9e2URxILli+7sRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wENvV4Es; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wENvV4Es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F204AC4CEF1;
	Mon, 27 Oct 2025 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592883;
	bh=2eG6NAvApt82IPALesV5qmG6GM/ZYXgh53YR5GdMeRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wENvV4Esch1J0vnSTuJeNjAn0GDR5lHEwlNVRsjSu+rxRC70/l1RuemhEkhuOCINH
	 E3XfflfvQfdLJzQgWt8DyU0U7mGd6KmWMYozar1ZBVAogQ+Mlbrcjpz7hDltCeO1VG
	 NpbM5tomwLz3wp/7GFGHTiX6QpCdKNsezEKv+UP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Dewei Meng <mengdewei@cqsoftware.com.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 048/117] btrfs: directly free partially initialized fs_info in btrfs_check_leaked_roots()
Date: Mon, 27 Oct 2025 19:36:14 +0100
Message-ID: <20251027183455.294071383@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Dewei Meng <mengdewei@cqsoftware.com.cn>

commit 17679ac6df6c4830ba711835aa8cf961be36cfa1 upstream.

If fs_info->super_copy or fs_info->super_for_commit allocated failed in
btrfs_get_tree_subvol(), then no need to call btrfs_free_fs_info().
Otherwise btrfs_check_leaked_roots() would access NULL pointer because
fs_info->allocated_roots had not been initialised.

syzkaller reported the following information:
  ------------[ cut here ]------------
  BUG: unable to handle page fault for address: fffffffffffffbb0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 64c9067 P4D 64c9067 PUD 64cb067 PMD 0
  Oops: Oops: 0000 [#1] SMP KASAN PTI
  CPU: 0 UID: 0 PID: 1402 Comm: syz.1.35 Not tainted 6.15.8 #4 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), (...)
  RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:23 [inline]
  RIP: 0010:raw_atomic_read include/linux/atomic/atomic-arch-fallback.h:457 [inline]
  RIP: 0010:atomic_read include/linux/atomic/atomic-instrumented.h:33 [inline]
  RIP: 0010:refcount_read include/linux/refcount.h:170 [inline]
  RIP: 0010:btrfs_check_leaked_roots+0x18f/0x2c0 fs/btrfs/disk-io.c:1230
  [...]
  Call Trace:
   <TASK>
   btrfs_free_fs_info+0x310/0x410 fs/btrfs/disk-io.c:1280
   btrfs_get_tree_subvol+0x592/0x6b0 fs/btrfs/super.c:2029
   btrfs_get_tree+0x63/0x80 fs/btrfs/super.c:2097
   vfs_get_tree+0x98/0x320 fs/super.c:1759
   do_new_mount+0x357/0x660 fs/namespace.c:3899
   path_mount+0x716/0x19c0 fs/namespace.c:4226
   do_mount fs/namespace.c:4239 [inline]
   __do_sys_mount fs/namespace.c:4450 [inline]
   __se_sys_mount fs/namespace.c:4427 [inline]
   __x64_sys_mount+0x28c/0x310 fs/namespace.c:4427
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x92/0x180 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f032eaffa8d
  [...]

Fixes: 3bb17a25bcb0 ("btrfs: add get_tree callback for new mount API")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Dewei Meng <mengdewei@cqsoftware.com.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2029,7 +2029,13 @@ static int btrfs_get_tree_subvol(struct
 	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
 	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_KERNEL);
 	if (!fs_info->super_copy || !fs_info->super_for_commit) {
-		btrfs_free_fs_info(fs_info);
+		/*
+		 * Dont call btrfs_free_fs_info() to free it as it's still
+		 * initialized partially.
+		 */
+		kfree(fs_info->super_copy);
+		kfree(fs_info->super_for_commit);
+		kvfree(fs_info);
 		return -ENOMEM;
 	}
 	btrfs_init_fs_info(fs_info);


