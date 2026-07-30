Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7494409121;
	Thu, 30 Jul 2026 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424813; cv=none; b=bRnU/JcCcxqC/NT/3qRSsSdH7dpKPoXev7iUi86NXzrvfeAVFzXu7at43cgQhb9UYYmLHp+qdkUgjCH5FrIt18C/jTaqD0dTh/lHY4rlqlRqLnNxdEAPeNkVq0kwy9sXZ3dbiC3RwIq2qbApCRq2mPH12+8FuFWD2jemwkRhXI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424813; c=relaxed/simple;
	bh=oyidarWbNUeQBW58/Wx+q5HxKwcDOb8WAqJTSD+Is70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYzBCDE8awLQN6d4EcI8OvcxlXltq85pU0700PdFu25vggECBgU4mFH3e4wofru/8LVl4zEQcZoP2YfK8dB4sfAHnCRdDTVGuemap0K0hBayIoN7kQwqu39ESejRtcFDLR/Ua0slAX2I5/bcBnUmM66OgIDlmJhNMjx5ukUKYIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhsZX4SP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhsZX4SP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DFD1F000E9;
	Thu, 30 Jul 2026 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424811;
	bh=i3DmoKFVZzQzeBLNgCrVhIBP01nBz2XRGsNJ3zAJ0kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhsZX4SPlwlXzthvBPsCeu5L73FnFW8h1JP3SlU1hMM8RBpuGYoeSPO+aOS+HknQ6
	 q4d25bg88jEFd0bQwGpqjiRYFj+EvNpbNdDLeFIiXgqypF4K5TIC2mAUQiskylxw4G
	 x8GPbzeGod+YjRH5y8CpbRfbKKE7pBIkU7qkPoSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 525/675] fs/super: fix emergency thaw double-unlock of s_umount
Date: Thu, 30 Jul 2026 16:14:15 +0200
Message-ID: <20260730141456.300898830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit 503d67fbaec6fdeaba391cb497675071db9d16ea upstream.

do_thaw_all() iterates over all superblocks via __iterate_supers()
with SUPER_ITER_EXCL, which acquires s_umount exclusively before
calling the callback and releases it afterwards. However, the
callback do_thaw_all_callback() calls thaw_super_locked() which
unconditionally releases s_umount on every code path. This results
in a second unlock attempt in __iterate_supers() that corrupts the
rwsem state, triggering a DEBUG_RWSEMS warning:

[  182.601148] sysrq: Emergency Thaw of all frozen filesystems
[  182.601865] ------------[ cut here ]------------
[  182.602375] DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff99b1011e5870, owner = 0x0, curr 0xffff99b101b06c80, list not empty
[  182.603817] WARNING: kernel/locking/rwsem.c:1412 at up_write+0xa3/0x170, CPU#2: kworker/2:1/53
[  182.604578] Modules linked in:
[  182.604864] CPU: 2 UID: 0 PID: 53 Comm: kworker/2:1 Not tainted 7.2.0-rc4-00001-gbd3bd93ea98a-dirty #4 PREEMPT(lazy)
[  182.605711] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1kylin1 04/01/2014
[  182.606417] Workqueue: events do_thaw_all
[  182.606750] RIP: 0010:up_write+0xaf/0x170
[  182.607076] Code: 19 3a 92 48 0f 44 c2 48 8b 55 08 48 8b 55 00 4c 8b 45 08 48 8b 55 00 48 8d 3d ad 91 e0 01 48 8b 4d 20 50 48 c7 c6 f0 8c 26 92 <67> 48 0f b9 3a e8 d7 93 4e 00 58 eb 81 48 83 7f 18 00 48 c7 c2 8d
[  182.608563] RSP: 0018:ffffb670001d7e08 EFLAGS: 00010246
[  182.609007] RAX: ffffffff92349e8d RBX: 0000000000000000 RCX: ffff99b1011e5870
[  182.609595] RDX: 0000000000000000 RSI: ffffffff92268cf0 RDI: ffffffff92914d10
[  182.610283] RBP: ffff99b1011e5870 R08: 0000000000000000 R09: ffff99b101b06c80
[  182.610847] R10: ffff99b10139a808 R11: fefefefefefefeff R12: 0000000000000000
[  182.611414] R13: ffffffff90cf74d0 R14: 0000000000000000 R15: ffff99b1011e5800
[  182.612009] FS:  0000000000000000(0000) GS:ffff99b1eaaee000(0000) knlGS:0000000000000000
[  182.612670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  182.613146] CR2: 00000000005c631c CR3: 00000000013ee000 CR4: 00000000000006f0
[  182.613722] Call Trace:
[  182.613946]  <TASK>
[  182.614130]  __iterate_supers+0x128/0x150
[  182.614463]  do_thaw_all+0x1b/0x30
[  182.614759]  process_scheduled_works+0xbb/0x3f0
[  182.615150]  ? __pfx_worker_thread+0x10/0x10
[  182.615499]  worker_thread+0x129/0x270
[  182.615816]  ? __pfx_worker_thread+0x10/0x10
[  182.616201]  kthread+0xe2/0x120
[  182.616469]  ? __pfx_kthread+0x10/0x10
[  182.616792]  ret_from_fork+0x15b/0x240
[  182.617115]  ? __pfx_kthread+0x10/0x10
[  182.617426]  ret_from_fork_asm+0x1a/0x30
[  182.617761]  </TASK>
[  182.617968] ---[ end trace 0000000000000000 ]---
[  182.618412] Emergency Thaw complete

Fix this by switching to SUPER_ITER_UNLOCKED and acquiring s_umount
in the callback via super_lock_excl() before calling
thaw_super_locked(). This matches the locking pattern expected by
thaw_super_locked() and eliminates the double unlock.

While at it, remove the dead 'return;' at the end of
do_thaw_all_callback().

Fixes: 2992476528ae ("super: use a common iterator (Part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Link: https://patch.msgid.link/20260721064140.152305-1-chenchangcheng@kylinos.cn
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -1141,16 +1141,19 @@ void emergency_remount(void)
 
 static void do_thaw_all_callback(struct super_block *sb, void *unused)
 {
+	if (!super_lock_excl(sb))
+		return;
+
 	if (IS_ENABLED(CONFIG_BLOCK))
 		while (sb->s_bdev && !bdev_thaw(sb->s_bdev))
 			pr_warn("Emergency Thaw on %pg\n", sb->s_bdev);
+
 	thaw_super_locked(sb, FREEZE_HOLDER_USERSPACE, NULL);
-	return;
 }
 
 static void do_thaw_all(struct work_struct *work)
 {
-	__iterate_supers(do_thaw_all_callback, NULL, SUPER_ITER_EXCL);
+	__iterate_supers(do_thaw_all_callback, NULL, SUPER_ITER_UNLOCKED);
 	kfree(work);
 	printk(KERN_WARNING "Emergency Thaw complete\n");
 }


