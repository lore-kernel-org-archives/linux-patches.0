Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7B01F91E3;
	Sat, 12 Sep 2026 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231187; cv=none; b=O5sszIW9T3PtPHtznqCzN+d0X4795dzIDHSen76MgzTB0i3R1NxIEzh3U6w+R/fQfJ5SbJkcGRCH3ATueAo6QMZnBn5ACL2bGUPh6aLvIftc7TgZXzIfFEymTzMGoix9VSAexdzHhXTEDwOVYm33kXSaQHilIScWY6ssiQARXbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231187; c=relaxed/simple;
	bh=55LEJVRQa4IrANl+AiVyrZTClo2T9LxsLeil26gxgoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtd1ErPc/sN1+6zDDmS8AnS7xzHvIk2ddx+5Bheq1dTo8TYYfhZQaYJtl6zZ63RP/78WobVRtOlqfVDt4FJOa+jPndtWcUsJCsLoIBSvDvYqNE189Mq3Zydlp0BTCsGFqBY9DR/+MClSUloUFqhuuYd78myO/7hoH1mS5iDYsWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIsb0IhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIsb0IhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859551F000FF;
	Sat, 12 Sep 2026 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231185;
	bh=r8fTo/FASgcDEMPBkbUykAjEhHiIQqrP9D6EmvOArrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIsb0IhRwlUfZRKKOKNomak5XggqFh6h22VvLjiMrJ4Gh3FspcbuAHnvV8Jfsd5It
	 eOOGgoxNNx7FQCBS1cohA6i+x/kUtbuf9SBXNjeUyiGAXtvV6FmwNIixlqiVFvK7mh
	 7IIJ9EAlaLVRQj+A4Fo3Q+MhV/BuDdyE87qQcZcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Desnes Nunes <desnesn@redhat.com>,
	Tao Liu <ltao@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0947/1191] iommu/vt-d: Fix UCTP context table slot when copying root entries
Date: Sat, 12 Sep 2026 09:01:15 +0200
Message-ID: <20260912065609.493210978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Desnes Nunes <desnesn@redhat.com>

[ Upstream commit c6e63fc8e8fcefa5c32145dc0a3c82975b0ce152 ]

When translation is already enabled at boot (e.g. kdump), the vt-d driver
copies context tables from the previous kernel's root table. In scalable
mode, buses that only populate the upper root half (UCTP, devfn >= 0x80)
should be written to ctxt_tbls[tbl_idx + 1] through copy_context_table().
However, the current copy path always uses tbl[tbl_idx + 0] in this situa-
tion. Since idx wraps to 0 at devfn 0x80 due to a zeroed LCTP, new_ce for
LCTP will be NULL and keep pos equals to 0. Thus, UCTP entries will be co-
pied into tbl[tbl_idx + 0] instead of tbl[tbl_idx + 1], and written after-
wards to root_entry[bus].lo instead of .hi in copy_translation_tables().

In short, devices on bus 0x80 with devfn >= 0x80 fail DMA with fault 0x39,
which will break drivers running in kernels with translation pre-enabled.
This fixes NO_PASID DMAR faults for UCTP-only buses such as:

DMAR: [DMA Read NO_PASID] Request device [80:14.0] fault addr 0xe81759000
      [fault reason 0x39] SM: Present bit in Root Entry is clear

For instance, this fault yielded to locking issues between systemd and
xHCI, blocking a system's reboot after a vmcore was captured with kdump:

 systemd-udevd[246]: usb3: Worker [255] processing SEQNUM=2193 is taking a long time
 dracut-initqueue[277]: Timed out while waiting for udev queue to empty.
 systemd-udevd[246]: usb3: Worker [255] processing SEQNUM=2193 killed
 systemd-udevd[246]: usb3: Worker [255] terminated by signal 9 (KILL).
 ...
 kdump[569]: saving vmcore complete
 ...
 systemd-shutdown[1]: Rebooting.
 INFO: task kworker/0:1:11 blocked for more than 122 seconds.
       Not tainted 7.0.0-clean #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:kworker/0:1 state:D stack:0 pid:11 tgid:11 ppid:2 task_flags:0x4208160 flags:0x00080000
 Workqueue: usb_hub_wq hub_event
 Call Trace:
  <TASK>
  __schedule+0x299/0x5c0
  schedule+0x27/0x80
  schedule_timeout+0xbd/0x100
  __wait_for_common+0x97/0x1b0
  ? __pfx_schedule_timeout+0x10/0x10
  xhci_alloc_dev+0x9e/0x2b0
  usb_alloc_dev+0x7a/0x3b0
  hub_port_connect+0x285/0x960
  hub_port_connect_change+0x94/0x290
  port_event+0x4bb/0x840
  hub_event+0x141/0x460
  process_one_work+0x196/0x390
  worker_thread+0x1af/0x320
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xe3/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x199/0x260
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 INFO: task systemd-shutdow:1 blocked for more than 122 seconds.
       Not tainted 7.0.0-clean #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:systemd-shutdow state:D stack:0 pid:1 tgid:1 ppid:0 task_flags:0x400100 flags:0x00080000
 Call Trace:
  <TASK>
  __schedule+0x299/0x5c0
  schedule+0x27/0x80
  schedule_preempt_disabled+0x15/0x30
  __mutex_lock.constprop.0+0x547/0xac0
  device_shutdown+0xac/0x1b0
  kernel_restart+0x3a/0x70
  __do_sys_reboot+0x147/0x240
  do_syscall_64+0x11b/0x6a0
  ? handle_mm_fault+0x110/0x350
  ? do_user_addr_fault+0x206/0x680
  ? irqentry_exit+0x7a/0x4d0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7fe2958da917
 RSP: 002b:00007ffc5c458618 EFLAGS: 00000206 ORIG_RAX: 00000000000000a9
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe2958da917
 RDX: 0000000001234567 RSI: 0000000028121969 RDI: 00000000fee1dead
 RBP: 00007ffc5c458790 R08: 0000000000000069 R09: 00000000ffffffff
 R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
 R13: 0000000000000000 R14: 00007ffc5c4588b8 R15: 0000000000000000
  </TASK>
 INFO: task systemd-shutdow:1 is blocked on a mutex likely owned by task kworker/0:1:11.

Fixes: 091d42e43d21 ("iommu/vt-d: Copy translation tables from old kernel")
Signed-off-by: Desnes Nunes <desnesn@redhat.com>
Tested-by: Tao Liu <ltao@redhat.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 2efb8c3a7b3cb..9ef81870b20cf 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2691,7 +2691,7 @@ static int copy_context_table(struct intel_iommu *iommu,
 			      struct context_entry **tbl,
 			      int bus, bool ext)
 {
-	int tbl_idx, pos = 0, idx, devfn, ret = 0, did;
+	int tbl_idx, tbl_slot = 0, idx, devfn, ret = 0, did;
 	struct context_entry *new_ce = NULL, ce;
 	struct context_entry *old_ce = NULL;
 	struct root_entry re;
@@ -2707,10 +2707,9 @@ static int copy_context_table(struct intel_iommu *iommu,
 		if (idx == 0) {
 			/* First save what we may have and clean up */
 			if (new_ce) {
-				tbl[tbl_idx] = new_ce;
+				tbl[tbl_idx + tbl_slot] = new_ce;
 				__iommu_flush_cache(iommu, new_ce,
 						    VTD_PAGE_SIZE);
-				pos = 1;
 			}
 
 			if (old_ce)
@@ -2732,6 +2731,9 @@ static int copy_context_table(struct intel_iommu *iommu,
 				}
 			}
 
+			/* Track if saving UCTP or LCTP entries in scalable mode */
+			tbl_slot = ext && devfn >= 0x80 ? 1 : 0;
+
 			ret = -ENOMEM;
 			old_ce = memremap(old_ce_phys, PAGE_SIZE,
 					MEMREMAP_WB);
@@ -2759,7 +2761,7 @@ static int copy_context_table(struct intel_iommu *iommu,
 		new_ce[idx] = ce;
 	}
 
-	tbl[tbl_idx + pos] = new_ce;
+	tbl[tbl_idx + tbl_slot] = new_ce;
 
 	__iommu_flush_cache(iommu, new_ce, VTD_PAGE_SIZE);
 
-- 
2.53.0



