Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FB424B28;
	Wed,  8 Apr 2026 18:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672286; cv=none; b=VKWZYoJMlXcyQid+4N1vdR+O4AtKakmBJqBAsqhB4VuOYyGm1gGY9oi5eaD39WB6O+CowZVX9e7JaggiB6LGSEnZ9OU3K4vrk/7LxD8HfBs/yu+A6dsyBKQWS4TFOo/JZzUkVUZceF35VryhCJlg/FrG1Z4IGFdbvjxU02a2i3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672286; c=relaxed/simple;
	bh=oOEGwQ2FkEp3ZE7E5dfIokaNl7+FZKFXeFU8SQXgJ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9DIjpWvnqvij3F5NRUpYJa22pIyYMXN9KYR1e+P7ZRQfVM4cOmobEAod2MgbVNTzhK/aKP3peJSMq3gib/M9jIsAY/KOlmuEKjbNC2qS9lXl4Nv1s6UqykdE73XL7e3s0Jl3c18UyZ9Z96lcMj5sxJaJixNz51mIynHZjeSxjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DBxeT7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DBxeT7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1C6C19421;
	Wed,  8 Apr 2026 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672286;
	bh=oOEGwQ2FkEp3ZE7E5dfIokaNl7+FZKFXeFU8SQXgJ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DBxeT7qNxaN8bz0BW4445w3EnqWqZAPpKshJ9zF1ss2RFPjYGFFZ0t8Dkytpv/8l
	 i3c7cvDx8hdizEhjLx8XuD0n+xP70FMvFjdVdY7dZdemY4qVmrHRfQwJ0aRH2L4CO/
	 gblrWmKvakoJdGq/gz/hRiOoD4S0aENHAFRLIO/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 260/312] Revert "nvme: fix admin request_queue lifetime"
Date: Wed,  8 Apr 2026 20:02:57 +0200
Message-ID: <20260408175943.455965456@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heyne, Maximilian <mheyne@amazon.de>

This reverts commit ff037b5f47eeccc1636c03f84cd47db094eb73c9.

The backport of upstream commit 03b3bcd319b3 ("nvme: fix admin
request_queue lifetime") to 6.1 is broken in 2 ways. First of all it
doesn't actually fix the issue because blk_put_queue will still be
called as part of blk_mq_destroy_queue in nvme_remove_admin_tag_set
leading to the UAF.
Second, the backport leads to a refcount underflow when unbinding a pci
nvme device:

 refcount_t: underflow; use-after-free.
 WARNING: CPU: 2 PID: 1486 at lib/refcount.c:28 refcount_warn_saturate+0xba/0x110
 Modules linked in: bochs drm_vram_helper simpledrm skx_edac_common drm_shmem_helper drm_kms_helper kvm_intel cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea drm_ttm_helper fb ttm kvm fbdev drm mousedev nls_ascii psmouse irqbypass nls_cp437 atkbd crc32_pclmul crc32c_intel libps2 vfat fat sunrpc virtio_net ata_piix vivaldi_fmap drm_panel_orientation_quirks libata backlight i2c_piix4 net_failover i8042 ghash_clmulni_intel failover serio i2c_core button sch_fq_codel
 CPU: 2 PID: 1486 Comm: bash Not tainted 6.1.167 #2
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS edk2-20240813-306.amzn2 08/13/2024
 RIP: 0010:refcount_warn_saturate+0xba/0x110
 Code: 01 01 e8 89 79 ad ff 0f 0b e9 82 f4 7e 00 80 3d 73 03 cc 01 00 75 85 48 c7 c7 e0 5d 3b 8e c6 05 63 03 cc 01 01 e8 66 79 ad ff <0f> 0b c3 cc cc cc cc 80 3d 4e 03 cc 01 00 0f 85 5e ff ff ff 48 c7
 RSP: 0018:ffffd0cc011bfd18 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: ffff8ada07b33210 RCX: 0000000000000027
 RDX: ffff8adb37d1f728 RSI: 0000000000000001 RDI: ffff8adb37d1f720
 RBP: ffff8ada07b33000 R08: 0000000000000000 R09: 00000000fffeffff
 R10: ffffd0cc011bfba8 R11: ffffffff8f1781a8 R12: ffffd0cc011bfd38
 R13: ffff8ada03080800 R14: ffff8ada07b33210 R15: ffff8ada07b33b10
 FS:  00007f50f6964740(0000) GS:ffff8adb37d00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055cdb54e6ae0 CR3: 000000010224e001 CR4: 0000000000770ee0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
  nvme_pci_free_ctrl+0x45/0x80
  nvme_free_ctrl+0x1aa/0x2b0
  device_release+0x34/0x90
  kobject_cleanup+0x3a/0x130
  pci_device_remove+0x3e/0xb0
  device_release_driver_internal+0x1aa/0x230
  unbind_store+0x11f/0x130
  kernfs_fop_write_iter+0x13a/0x1d0
  vfs_write+0x2a6/0x3b0
  ksys_write+0x5f/0xe0
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
 RIP: 0033:0x7f50f66ff897
 Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
 RSP: 002b:00007fffaef903d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
 RAX: ffffffffffffffda RBX: 00007f50f67fd780 RCX: 00007f50f66ff897
 RDX: 000000000000000d RSI: 0000557f72ef6b90 RDI: 0000000000000001
 RBP: 000000000000000d R08: 0000000000000000 R09: 00007f50f67b2d20
 R10: 00007f50f67b2c20 R11: 0000000000000246 R12: 000000000000000d
 R13: 0000557f72ef6b90 R14: 000000000000000d R15: 00007f50f67f89c0
  </TASK>

The reason for this is that nvme_free_ctrl calls ->free_ctrl which
resolves to nvme_pci_free_ctrl in aforementioned case which also has a
blk_put_queue, so the admin queue is put twice. This is because on 6.1
we're missing the commit 96ef1be53663 ("nvme-pci: put the admin queue in
nvme_dev_remove_admin").

Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Tested-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9df33b293ee3e..938af571dc13e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5180,8 +5180,6 @@ static void nvme_free_ctrl(struct device *dev)
 		container_of(dev, struct nvme_ctrl, ctrl_device);
 	struct nvme_subsystem *subsys = ctrl->subsys;
 
-	if (ctrl->admin_q)
-		blk_put_queue(ctrl->admin_q);
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
 
-- 
2.53.0



