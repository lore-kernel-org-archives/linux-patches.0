Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7F3EC2CD;
	Tue, 17 Mar 2026 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765522; cv=none; b=TPnGVTn6BtofxTf0jcRIteFDODbZdNHNFLfafSvzVMXHCu25gTRj+pgbUoh8/kxG71nTzLslJQHxiHnXcRQ9IevEi/QMWmCfBzCNc1T0I9KoIpyFMKITQyTYkCu6yDj2z7+PQhqnA1JiD7cMaxNoDn4qthEhUhi3iiO4Ix8JA9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765522; c=relaxed/simple;
	bh=d6MkwbXPPzeDMo0IPPdJRoHRiSOTptOYQgxN7tWmCz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fys23sojokNZZ7Dr/p39f+swRFT/v3gxPcGpD9dw90Go1snI4fhJzOgsx4OBqxAbdulS+8dcOgf50Rb0Zi4QGuZn1+c8m+fxpzRwrtcWjM20AKFHd6BIwa8tyTMirP4xFGvV1eUucAIyFPLeyMgrlr94XY3TKmkmKwh1hp3c99w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGyu1jzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGyu1jzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57433C4CEF7;
	Tue, 17 Mar 2026 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765521;
	bh=d6MkwbXPPzeDMo0IPPdJRoHRiSOTptOYQgxN7tWmCz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGyu1jzLzt7hsAY0/bWYpWdS7x2EqPMHU2fRsLeE+NT0goZgcTLR4w594YP/J5J+a
	 b1w6EQY5kUUbcAgw9i4NbAKptOlBc4LybAtsuzAW+HUOUup80Z7e1c9Hn5a5HGTYDY
	 ei4gE++lj+dsPiPK6WURwz0POxqez18zpkL3M30s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	Michael Kelley <mhklinux@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 009/378] scsi: storvsc: Fix scheduling while atomic on PREEMPT_RT
Date: Tue, 17 Mar 2026 17:29:26 +0100
Message-ID: <20260317163007.314566247@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

[ Upstream commit 57297736c08233987e5d29ce6584c6ca2a831b12 ]

This resolves the follow splat and lock-up when running with PREEMPT_RT
enabled on Hyper-V:

[  415.140818] BUG: scheduling while atomic: stress-ng-iomix/1048/0x00000002
[  415.140822] INFO: lockdep is turned off.
[  415.140823] Modules linked in: intel_rapl_msr intel_rapl_common intel_uncore_frequency_common intel_pmc_core pmt_telemetry pmt_discovery pmt_class intel_pmc_ssram_telemetry intel_vsec ghash_clmulni_intel aesni_intel rapl binfmt_misc nls_ascii nls_cp437 vfat fat snd_pcm hyperv_drm snd_timer drm_client_lib drm_shmem_helper snd sg soundcore drm_kms_helper pcspkr hv_balloon hv_utils evdev joydev drm configfs efi_pstore nfnetlink vsock_loopback vmw_vsock_virtio_transport_common hv_sock vmw_vsock_vmci_transport vsock vmw_vmci efivarfs autofs4 ext4 crc16 mbcache jbd2 sr_mod sd_mod cdrom hv_storvsc serio_raw hid_generic scsi_transport_fc hid_hyperv scsi_mod hid hv_netvsc hyperv_keyboard scsi_common
[  415.140846] Preemption disabled at:
[  415.140847] [<ffffffffc0656171>] storvsc_queuecommand+0x2e1/0xbe0 [hv_storvsc]
[  415.140854] CPU: 8 UID: 0 PID: 1048 Comm: stress-ng-iomix Not tainted 6.19.0-rc7 #30 PREEMPT_{RT,(full)}
[  415.140856] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 09/04/2024
[  415.140857] Call Trace:
[  415.140861]  <TASK>
[  415.140861]  ? storvsc_queuecommand+0x2e1/0xbe0 [hv_storvsc]
[  415.140863]  dump_stack_lvl+0x91/0xb0
[  415.140870]  __schedule_bug+0x9c/0xc0
[  415.140875]  __schedule+0xdf6/0x1300
[  415.140877]  ? rtlock_slowlock_locked+0x56c/0x1980
[  415.140879]  ? rcu_is_watching+0x12/0x60
[  415.140883]  schedule_rtlock+0x21/0x40
[  415.140885]  rtlock_slowlock_locked+0x502/0x1980
[  415.140891]  rt_spin_lock+0x89/0x1e0
[  415.140893]  hv_ringbuffer_write+0x87/0x2a0
[  415.140899]  vmbus_sendpacket_mpb_desc+0xb6/0xe0
[  415.140900]  ? rcu_is_watching+0x12/0x60
[  415.140902]  storvsc_queuecommand+0x669/0xbe0 [hv_storvsc]
[  415.140904]  ? HARDIRQ_verbose+0x10/0x10
[  415.140908]  ? __rq_qos_issue+0x28/0x40
[  415.140911]  scsi_queue_rq+0x760/0xd80 [scsi_mod]
[  415.140926]  __blk_mq_issue_directly+0x4a/0xc0
[  415.140928]  blk_mq_issue_direct+0x87/0x2b0
[  415.140931]  blk_mq_dispatch_queue_requests+0x120/0x440
[  415.140933]  blk_mq_flush_plug_list+0x7a/0x1a0
[  415.140935]  __blk_flush_plug+0xf4/0x150
[  415.140940]  __submit_bio+0x2b2/0x5c0
[  415.140944]  ? submit_bio_noacct_nocheck+0x272/0x360
[  415.140946]  submit_bio_noacct_nocheck+0x272/0x360
[  415.140951]  ext4_read_bh_lock+0x3e/0x60 [ext4]
[  415.140995]  ext4_block_write_begin+0x396/0x650 [ext4]
[  415.141018]  ? __pfx_ext4_da_get_block_prep+0x10/0x10 [ext4]
[  415.141038]  ext4_da_write_begin+0x1c4/0x350 [ext4]
[  415.141060]  generic_perform_write+0x14e/0x2c0
[  415.141065]  ext4_buffered_write_iter+0x6b/0x120 [ext4]
[  415.141083]  vfs_write+0x2ca/0x570
[  415.141087]  ksys_write+0x76/0xf0
[  415.141089]  do_syscall_64+0x99/0x1490
[  415.141093]  ? rcu_is_watching+0x12/0x60
[  415.141095]  ? finish_task_switch.isra.0+0xdf/0x3d0
[  415.141097]  ? rcu_is_watching+0x12/0x60
[  415.141098]  ? lock_release+0x1f0/0x2a0
[  415.141100]  ? rcu_is_watching+0x12/0x60
[  415.141101]  ? finish_task_switch.isra.0+0xe4/0x3d0
[  415.141103]  ? rcu_is_watching+0x12/0x60
[  415.141104]  ? __schedule+0xb34/0x1300
[  415.141106]  ? hrtimer_try_to_cancel+0x1d/0x170
[  415.141109]  ? do_nanosleep+0x8b/0x160
[  415.141111]  ? hrtimer_nanosleep+0x89/0x100
[  415.141114]  ? __pfx_hrtimer_wakeup+0x10/0x10
[  415.141116]  ? xfd_validate_state+0x26/0x90
[  415.141118]  ? rcu_is_watching+0x12/0x60
[  415.141120]  ? do_syscall_64+0x1e0/0x1490
[  415.141121]  ? do_syscall_64+0x1e0/0x1490
[  415.141123]  ? rcu_is_watching+0x12/0x60
[  415.141124]  ? do_syscall_64+0x1e0/0x1490
[  415.141125]  ? do_syscall_64+0x1e0/0x1490
[  415.141127]  ? irqentry_exit+0x140/0x7e0
[  415.141129]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

get_cpu() disables preemption while the spinlock hv_ringbuffer_write is
using is converted to an rt-mutex under PREEMPT_RT.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Link: https://patch.msgid.link/0c7fb5cd-fb21-4760-8593-e04bade84744@siemens.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index b43d876747b76..68c837146b9ea 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1855,8 +1855,9 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	cmd_request->payload_sz = payload_sz;
 
 	/* Invokes the vsc to start an IO */
-	ret = storvsc_do_io(dev, cmd_request, get_cpu());
-	put_cpu();
+	migrate_disable();
+	ret = storvsc_do_io(dev, cmd_request, smp_processor_id());
+	migrate_enable();
 
 	if (ret)
 		scsi_dma_unmap(scmnd);
-- 
2.51.0



