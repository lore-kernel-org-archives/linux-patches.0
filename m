Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CBF46AF2F;
	Wed, 30 Sep 2026 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797007; cv=none; b=ZRDdoITVdhb2sDSAiHUb6aHODj65B2gXhjz/uTTHe2GBB2n17/ERCKbyjubbGmoOGIE/ZQ639VQycR/W+0zYTOjFpvXBfOluh/7aGlt5ePT1nQYP49BGeFmvJ9/OnZoEcGY7B7uFqXvATnTTQ0Dw2FdaieSdpZsPC2MUMNEfmjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797007; c=relaxed/simple;
	bh=VzJUWmMf4eGYGxD+558b+FIxdgd7iJr0qXubLYWIdD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvzOypV1HpybS9GxmycEAmOg+hxCrnQ98yrKEEjqZJnCmht79PbokiRHfsftMNRJXFDyFvpXFwBEa6F4hktBrPH7rghgI8b79Agkl9yYdi+OcgUKSVLB4I1iM+Lod3RfNceokMmJdx2Bg0HGTFv4y5gIgudrg3Re8wbS9bsEvB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUT1iCNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUT1iCNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE1C1F000FF;
	Wed, 30 Sep 2026 19:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797006;
	bh=ONaWFe2ueds2+iaNQs0E1huJSGugkuW9RAghLFPhf/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUT1iCNLEsoHUZDTnXfCpscXXFCUpHfI/0tmiW6v9CNJwEqxI3xkr1lWNl9HjaOcT
	 hs2tt1BTb5Pk8DOgTWwgUKvMmlqZDcq8x4hbccAY7tBgUHOc4lHRJ6qEDsWxEEa3Jw
	 wNcQgjLHfiH9uRpkHN+pLBwn7zWGP6zkTm3ein0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.6 1114/1193] drm/nouveau: fix double-free in nvif_vmm_dtor
Date: Wed, 30 Sep 2026 17:29:58 +0200
Message-ID: <20260930152458.979074644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit 97077ac87afe9e91ec074ef0be64454e7ccbf344 upstream.

On failure, nouveau_cli_init() calls nouveau_cli_fini() to tear
the client down. Then, nouveau_drm_open() also enters into its
cleanup path and calls nouveau_cli_fini() AGAIN. nouveau_cli_fini()
calls nouveau_vmm_fini():

	void
	nouveau_vmm_fini(struct nouveau_vmm *vmm)
	{
		nouveau_svmm_fini(&vmm->svmm);
		nvif_vmm_dtor(&vmm->vmm);
		vmm->cli = NULL;
	}

Inside nvif_vmm_dtor(), vmm->page is freed unconditionally:

	void
	nvif_vmm_dtor(struct nvif_vmm *vmm)
	{
		kfree(vmm->page);
		nvif_object_dtor(&vmm->object);
	}

vmm->page is never cleared after being freed, so the second call of
nvif_vmm_dtor() will cause a double-free.

Found by fuzzing the nouveau driver with a modified Syzkaller:

	BUG: KASAN: double-free in nvif_vmm_dtor+0x31/0x50 drivers/gpu/drm/nouveau/nvif/vmm.c:194
	Free of addr ffff888010fcdc30 by task syz.0.173/2567

	CPU: 1 UID: 0 PID: 2567 Comm: syz.0.173 Not tainted 7.2.0 #24 PREEMPT(lazy)
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
	Call Trace:
	<TASK>
	__dump_stack lib/dump_stack.c:94 [inline]
	dump_stack_lvl+0x95/0xe0 lib/dump_stack.c:120
	print_address_description mm/kasan/report.c:378 [inline]
	print_report+0xcb/0x5a0 mm/kasan/report.c:482
	kasan_report_invalid_free+0xaa/0xd0 mm/kasan/report.c:557
	check_slab_allocation+0xe4/0x110 mm/kasan/common.c:235
	kasan_slab_pre_free include/linux/kasan.h:199 [inline]
	slab_free_hook mm/slub.c:2622 [inline]
	slab_free mm/slub.c:6377 [inline]
	kfree+0x192/0x590 mm/slub.c:6692
	nvif_vmm_dtor+0x31/0x50 drivers/gpu/drm/nouveau/nvif/vmm.c:194
	nouveau_vmm_fini+0x16/0x50 drivers/gpu/drm/nouveau/nouveau_vmm.c:127
	nouveau_cli_fini+0x10e/0x210 drivers/gpu/drm/nouveau/nouveau_drm.c:225
	nouveau_drm_open+0x24e/0x740 drivers/gpu/drm/nouveau/nouveau_drm.c:1255
	drm_file_alloc+0x5f2/0xad0 drivers/gpu/drm/drm_file.c:176
	drm_open_helper+0x1d7/0x4a0 drivers/gpu/drm/drm_file.c:335
	drm_open+0x190/0x3d0 drivers/gpu/drm/drm_file.c:388
	drm_stub_open+0x1f2/0x460 drivers/gpu/drm/drm_drv.c:1211
	chrdev_open+0x21c/0x660 fs/char_dev.c:411
	do_dentry_open+0x59d/0x12b0 fs/open.c:947
	vfs_open+0x82/0x390 fs/open.c:1052
	do_open fs/namei.c:4700 [inline]
	path_openat+0x2345/0x3420 fs/namei.c:4863
	do_file_open+0x207/0x460 fs/namei.c:4892
	do_sys_openat2+0xd1/0x1d0 fs/open.c:1368
	do_sys_open fs/open.c:1374 [inline]
	__do_sys_openat fs/open.c:1390 [inline]
	__se_sys_openat fs/open.c:1385 [inline]
	__x64_sys_openat+0x144/0x200 fs/open.c:1385
	do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
	do_syscall_64+0x115/0x690 arch/x86/entry/syscall_64.c:94
	entry_SYSCALL_64_after_hwframe+0x77/0x7f
	RIP: 0033:0x7fc6d687594d
	Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
	RSP: 002b:00007fc6d5295008 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
	RAX: ffffffffffffffda RBX: 00007fc6d6b06180 RCX: 00007fc6d687594d
	RDX: 0000000000022501 RSI: 0000200000000000 RDI: ffffffffffffff9c
	RBP: 00007fc6d691c303 R08: 0000000000000000 R09: 0000000000000000
	R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
	R13: 00007fc6d6b06218 R14: 00007fc6d6b06180 R15: 00007ffd9451d760
	</TASK>

	Allocated by task 2567 on cpu 1 at 163.593900s:
	kasan_save_stack+0x24/0x50 mm/kasan/common.c:57
	kasan_save_track+0x17/0x60 mm/kasan/common.c:78
	poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
	__kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
	kasan_kmalloc include/linux/kasan.h:263 [inline]
	__do_kmalloc_node mm/slub.c:5334 [inline]
	__kmalloc_noprof+0x304/0x7c0 mm/slub.c:5359
	_kmalloc_noprof include/linux/slab.h:992 [inline]
	nvif_vmm_ctor+0x3c0/0x7e0 drivers/gpu/drm/nouveau/nvif/vmm.c:237
	nouveau_vmm_init+0x40/0x90 drivers/gpu/drm/nouveau/nouveau_vmm.c:134
	nouveau_cli_init+0x7b9/0xe10 drivers/gpu/drm/nouveau/nouveau_drm.c:293
	nouveau_drm_open+0x236/0x740 drivers/gpu/drm/nouveau/nouveau_drm.c:1243
	drm_file_alloc+0x5f2/0xad0 drivers/gpu/drm/drm_file.c:176
	drm_open_helper+0x1d7/0x4a0 drivers/gpu/drm/drm_file.c:335
	drm_open+0x190/0x3d0 drivers/gpu/drm/drm_file.c:388
	drm_stub_open+0x1f2/0x460 drivers/gpu/drm/drm_drv.c:1211
	chrdev_open+0x21c/0x660 fs/char_dev.c:411
	do_dentry_open+0x59d/0x12b0 fs/open.c:947
	vfs_open+0x82/0x390 fs/open.c:1052
	do_open fs/namei.c:4700 [inline]
	path_openat+0x2345/0x3420 fs/namei.c:4863
	do_file_open+0x207/0x460 fs/namei.c:4892
	do_sys_openat2+0xd1/0x1d0 fs/open.c:1368
	do_sys_open fs/open.c:1374 [inline]
	__do_sys_openat fs/open.c:1390 [inline]
	__se_sys_openat fs/open.c:1385 [inline]
	__x64_sys_openat+0x144/0x200 fs/open.c:1385
	do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
	do_syscall_64+0x115/0x690 arch/x86/entry/syscall_64.c:94
	entry_SYSCALL_64_after_hwframe+0x77/0x7f

	Freed by task 2567 on cpu 1 at 163.601355s:
	kasan_save_stack+0x24/0x50 mm/kasan/common.c:57
	kasan_save_track+0x17/0x60 mm/kasan/common.c:78
	kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584
	poison_slab_object mm/kasan/common.c:253 [inline]
	__kasan_slab_free+0x61/0x80 mm/kasan/common.c:285
	kasan_slab_free include/linux/kasan.h:235 [inline]
	slab_free_hook mm/slub.c:2677 [inline]
	slab_free mm/slub.c:6377 [inline]
	kfree+0x383/0x590 mm/slub.c:6692
	nvif_vmm_dtor+0x31/0x50 drivers/gpu/drm/nouveau/nvif/vmm.c:194
	nouveau_vmm_fini+0x16/0x50 drivers/gpu/drm/nouveau/nouveau_vmm.c:127
	nouveau_cli_fini+0x10e/0x210 drivers/gpu/drm/nouveau/nouveau_drm.c:225
	nouveau_cli_init+0x593/0xe10 drivers/gpu/drm/nouveau/nouveau_drm.c:324
	nouveau_drm_open+0x236/0x740 drivers/gpu/drm/nouveau/nouveau_drm.c:1243
	drm_file_alloc+0x5f2/0xad0 drivers/gpu/drm/drm_file.c:176
	drm_open_helper+0x1d7/0x4a0 drivers/gpu/drm/drm_file.c:335
	drm_open+0x190/0x3d0 drivers/gpu/drm/drm_file.c:388
	drm_stub_open+0x1f2/0x460 drivers/gpu/drm/drm_drv.c:1211
	chrdev_open+0x21c/0x660 fs/char_dev.c:411
	do_dentry_open+0x59d/0x12b0 fs/open.c:947
	vfs_open+0x82/0x390 fs/open.c:1052
	do_open fs/namei.c:4700 [inline]
	path_openat+0x2345/0x3420 fs/namei.c:4863
	do_file_open+0x207/0x460 fs/namei.c:4892
	do_sys_openat2+0xd1/0x1d0 fs/open.c:1368
	do_sys_open fs/open.c:1374 [inline]
	__do_sys_openat fs/open.c:1390 [inline]
	__se_sys_openat fs/open.c:1385 [inline]
	__x64_sys_openat+0x144/0x200 fs/open.c:1385
	do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
	do_syscall_64+0x115/0x690 arch/x86/entry/syscall_64.c:94
	entry_SYSCALL_64_after_hwframe+0x77/0x7f

	The buggy address belongs to the object at ffff888010fcdc30
	which belongs to the cache kmalloc-16 of size 16
	The buggy address is located 0 bytes inside of
	16-byte region [ffff888010fcdc30, ffff888010fcdc40)

	The buggy address belongs to the physical page:
	page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10fcd
	flags: 0x100000000000000(node=0|zone=1)
	page_type: f5(slab)
	raw: 0100000000000000 ffff88800d441640 dead000000000100 dead000000000122
	raw: 0000000000000000 0000000000550055 00000000f5000000 0000000000000000
	page dumped because: kasan: bad access detected

	Memory state around the buggy address:
	ffff888010fcdb00: fc fc 00 04 fc fc fc fc fa fb fc fc fc fc fa fb
	ffff888010fcdb80: fc fc fc fc fa fb fc fc fc fc 00 07 fc fc fc fc
	>ffff888010fcdc00: fa fb fc fc fc fc fa fb fc fc fc fc fa fb fc fc
										^
	ffff888010fcdc80: fc fc fa fb fc fc fc fc 00 04 fc fc fc fc fa fb
	ffff888010fcdd00: fc fc fc fc 00 00 fc fc fc fc fa fb fc fc fc fc

Fix by removing the redundant teardown in nouveau_drm_open(),
since nouveau_cli_init() already does the cleanup work.
Also clear vmm->page after its freeing.

Cc: stable@vger.kernel.org
Fixes: 20d8a88e557a ("drm/nouveau: tidy up the client init/fini interfaces")
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Assisted-by: LLM
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/03BA723D9E5FF725+20260916103138.2651605-1-peiyang_he@smail.nju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    4 +---
 drivers/gpu/drm/nouveau/nvif/vmm.c    |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1156,10 +1156,8 @@ nouveau_drm_open(struct drm_device *dev,
 	mutex_unlock(&drm->clients_lock);
 
 done:
-	if (ret && cli) {
-		nouveau_cli_fini(cli);
+	if (ret && cli)
 		kfree(cli);
-	}
 
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
--- a/drivers/gpu/drm/nouveau/nvif/vmm.c
+++ b/drivers/gpu/drm/nouveau/nvif/vmm.c
@@ -192,6 +192,7 @@ void
 nvif_vmm_dtor(struct nvif_vmm *vmm)
 {
 	kfree(vmm->page);
+	vmm->page = NULL;
 	nvif_object_dtor(&vmm->object);
 }
 


