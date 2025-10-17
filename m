Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A86C330B04;
	Fri, 17 Oct 2025 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715976; cv=none; b=dwR+/LRIBi9hZ6kDNB2rKkTlJjl/0m6F26afSoaEhbCYwrzrLYfeov+Px//eozlKikph7GYP9dWm22gUvLYO1gepVeF8bz2BBNG7MgnhuP8sB0jl0AuKd8drQAqY2K2EYLMbOPe2sQD1a289qNeftcsNXv94nVAt0VAhmya1tME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715976; c=relaxed/simple;
	bh=OOsaA/vgM0jz7AGXq0owAAYKy8dPKoTZEDSO5zG97Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuFKdl2+vVtuSEpmSqcdrFHHqqeJs/2aw2vmBxHrABf/cQAoZoLqh45ZqarSHgX5VmWoxH/MKWuRhvtPbBwhDvMIyXJsjBBVCWghtacohhyj+pw8tq9JRaTeTWg/ElLC0sPBIeUpr8EWzP5I3DqUVtkmRFSS5aL8fP3bdcPDVZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNQlkKNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNQlkKNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FEBC4CEE7;
	Fri, 17 Oct 2025 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715976;
	bh=OOsaA/vgM0jz7AGXq0owAAYKy8dPKoTZEDSO5zG97Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNQlkKNFDp8j+4QtcMCR8Qk3Rxke/fjeyFufOEENsHqOzANg+AUlzmkitCo9TaaZB
	 +o3s2GpzPUzuKBP3svGb1pVD4rD1vQWY+HTt/wBqVALi1ParTF8450/MqtPB59Ds0t
	 EymNeRTjhngqIlg4Jc3IKrZf9OqY6x2nobYDcu+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 003/276] media: b2c2: Fix use-after-free causing by irq_check_work in flexcop_pci_remove
Date: Fri, 17 Oct 2025 16:51:36 +0200
Message-ID: <20251017145142.513842954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit 01e03fb7db419d39e18d6090d4873c1bff103914 upstream.

The original code uses cancel_delayed_work() in flexcop_pci_remove(), which
does not guarantee that the delayed work item irq_check_work has fully
completed if it was already running. This leads to use-after-free scenarios
where flexcop_pci_remove() may free the flexcop_device while irq_check_work
is still active and attempts to dereference the device.

A typical race condition is illustrated below:

CPU 0 (remove)                         | CPU 1 (delayed work callback)
flexcop_pci_remove()                   | flexcop_pci_irq_check_work()
  cancel_delayed_work()                |
  flexcop_device_kfree(fc_pci->fc_dev) |
                                       |   fc = fc_pci->fc_dev; // UAF

This is confirmed by a KASAN report:

==================================================================
BUG: KASAN: slab-use-after-free in __run_timer_base.part.0+0x7d7/0x8c0
Write of size 8 at addr ffff8880093aa8c8 by task bash/135
...
Call Trace:
 <IRQ>
 dump_stack_lvl+0x55/0x70
 print_report+0xcf/0x610
 ? __run_timer_base.part.0+0x7d7/0x8c0
 kasan_report+0xb8/0xf0
 ? __run_timer_base.part.0+0x7d7/0x8c0
 __run_timer_base.part.0+0x7d7/0x8c0
 ? __pfx___run_timer_base.part.0+0x10/0x10
 ? __pfx_read_tsc+0x10/0x10
 ? ktime_get+0x60/0x140
 ? lapic_next_event+0x11/0x20
 ? clockevents_program_event+0x1d4/0x2a0
 run_timer_softirq+0xd1/0x190
 handle_softirqs+0x16a/0x550
 irq_exit_rcu+0xaf/0xe0
 sysvec_apic_timer_interrupt+0x70/0x80
 </IRQ>
...

Allocated by task 1:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x7f/0x90
 __kmalloc_noprof+0x1be/0x460
 flexcop_device_kmalloc+0x54/0xe0
 flexcop_pci_probe+0x1f/0x9d0
 local_pci_probe+0xdc/0x190
 pci_device_probe+0x2fe/0x470
 really_probe+0x1ca/0x5c0
 __driver_probe_device+0x248/0x310
 driver_probe_device+0x44/0x120
 __driver_attach+0xd2/0x310
 bus_for_each_dev+0xed/0x170
 bus_add_driver+0x208/0x500
 driver_register+0x132/0x460
 do_one_initcall+0x89/0x300
 kernel_init_freeable+0x40d/0x720
 kernel_init+0x1a/0x150
 ret_from_fork+0x10c/0x1a0
 ret_from_fork_asm+0x1a/0x30

Freed by task 135:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3a/0x60
 __kasan_slab_free+0x3f/0x50
 kfree+0x137/0x370
 flexcop_device_kfree+0x32/0x50
 pci_device_remove+0xa6/0x1d0
 device_release_driver_internal+0xf8/0x210
 pci_stop_bus_device+0x105/0x150
 pci_stop_and_remove_bus_device_locked+0x15/0x30
 remove_store+0xcc/0xe0
 kernfs_fop_write_iter+0x2c3/0x440
 vfs_write+0x871/0xd70
 ksys_write+0xee/0x1c0
 do_syscall_64+0xac/0x280
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...

Replace cancel_delayed_work() with cancel_delayed_work_sync() to ensure
that the delayed work item is properly canceled and any executing delayed
work has finished before the device memory is deallocated.

This bug was initially identified through static analysis. To reproduce
and test it, I simulated the B2C2 FlexCop PCI device in QEMU and introduced
artificial delays within the flexcop_pci_irq_check_work() function to
increase the likelihood of triggering the bug.

Fixes: 382c5546d618 ("V4L/DVB (10694): [PATCH] software IRQ watchdog for Flexcop B2C2 DVB PCI cards")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/b2c2/flexcop-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -411,7 +411,7 @@ static void flexcop_pci_remove(struct pc
 	struct flexcop_pci *fc_pci = pci_get_drvdata(pdev);
 
 	if (irq_chk_intv > 0)
-		cancel_delayed_work(&fc_pci->irq_check_work);
+		cancel_delayed_work_sync(&fc_pci->irq_check_work);
 
 	flexcop_pci_dma_exit(fc_pci);
 	flexcop_device_exit(fc_pci->fc_dev);


