Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2408061B;
	Mon,  8 Apr 2024 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582381; cv=none; b=PPeegMkPcn6Bak9+zhW++ddWV0Lvw/7g1G7WVwr7fSr7pAFRTPPl/8GzmXG5IcU75yeq5tCVlkxCmtHWO4euyz/4kj5EjuBaGNoe+kX25KxLlNvx/QoJLwfwHakQ9W1zdxykfUIQkjQAqsOwAHu1WO0yBEA3grtuoNDDWN3dkJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582381; c=relaxed/simple;
	bh=AGQcqvbGA/K0k7UPH7OWTJVx4k6pSq8Reqrvvvvcimk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4oBZqQANKk61B6qX8wOsrOTXAP9pVN3wdK/oYaCKvnEd6yZu9m1i9FNPFQ2GEMixVWe36yJpNnto7LNuPr+nlv9on/HfrA6ZDECnfZryqN66nVuj37t2LqFW7nxDQg+abnv6/R/b+aAHSlqhxULnsOJwsc5Ci639ihKF8fF7BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOy4yYsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOy4yYsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1D5C433C7;
	Mon,  8 Apr 2024 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582381;
	bh=AGQcqvbGA/K0k7UPH7OWTJVx4k6pSq8Reqrvvvvcimk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOy4yYsM/FKpaYaMYmneeggug6ZVsGoCeChEWjalSJj81r4bzc/5FSnM/NQcb+XEK
	 o3dZ9lvwUgPygSoYz5AOjz5WrJoM4kWj17hjMiNX+MPF5vJZpFI7ypZHywZzSyMapr
	 nfd06NSDGoHRrntAdw+rCmYj4Bcs30su06qtFwmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Juergen Gross <jgross@suse.com>,
	Andrew Paniakin <apanyaki@amazon.com>
Subject: [PATCH 5.15 137/690] xen/events: close evtchn after mapping cleanup
Date: Mon,  8 Apr 2024 14:50:03 +0200
Message-ID: <20240408125404.482298105@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maximilian Heyne <mheyne@amazon.de>

commit fa765c4b4aed2d64266b694520ecb025c862c5a9 upstream.

shutdown_pirq and startup_pirq are not taking the
irq_mapping_update_lock because they can't due to lock inversion. Both
are called with the irq_desc->lock being taking. The lock order,
however, is first irq_mapping_update_lock and then irq_desc->lock.

This opens multiple races:
- shutdown_pirq can be interrupted by a function that allocates an event
  channel:

  CPU0                        CPU1
  shutdown_pirq {
    xen_evtchn_close(e)
                              __startup_pirq {
                                EVTCHNOP_bind_pirq
                                  -> returns just freed evtchn e
                                set_evtchn_to_irq(e, irq)
                              }
    xen_irq_info_cleanup() {
      set_evtchn_to_irq(e, -1)
    }
  }

  Assume here event channel e refers here to the same event channel
  number.
  After this race the evtchn_to_irq mapping for e is invalid (-1).

- __startup_pirq races with __unbind_from_irq in a similar way. Because
  __startup_pirq doesn't take irq_mapping_update_lock it can grab the
  evtchn that __unbind_from_irq is currently freeing and cleaning up. In
  this case even though the event channel is allocated, its mapping can
  be unset in evtchn_to_irq.

The fix is to first cleanup the mappings and then close the event
channel. In this way, when an event channel gets allocated it's
potential previous evtchn_to_irq mappings are guaranteed to be unset already.
This is also the reverse order of the allocation where first the event
channel is allocated and then the mappings are setup.

On a 5.10 kernel prior to commit 3fcdaf3d7634 ("xen/events: modify internal
[un]bind interfaces"), we hit a BUG like the following during probing of NVMe
devices. The issue is that during nvme_setup_io_queues, pci_free_irq
is called for every device which results in a call to shutdown_pirq.
With many nvme devices it's therefore likely to hit this race during
boot because there will be multiple calls to shutdown_pirq and
startup_pirq are running potentially in parallel.

  ------------[ cut here ]------------
  blkfront: xvda: barrier or flush: disabled; persistent grants: enabled; indirect descriptors: enabled; bounce buffer: enabled
  kernel BUG at drivers/xen/events/events_base.c:499!
  invalid opcode: 0000 [#1] SMP PTI
  CPU: 44 PID: 375 Comm: kworker/u257:23 Not tainted 5.10.201-191.748.amzn2.x86_64 #1
  Hardware name: Xen HVM domU, BIOS 4.11.amazon 08/24/2006
  Workqueue: nvme-reset-wq nvme_reset_work
  RIP: 0010:bind_evtchn_to_cpu+0xdf/0xf0
  Code: 5d 41 5e c3 cc cc cc cc 44 89 f7 e8 2b 55 ad ff 49 89 c5 48 85 c0 0f 84 64 ff ff ff 4c 8b 68 30 41 83 fe ff 0f 85 60 ff ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 0f 1f 44 00 00
  RSP: 0000:ffffc9000d533b08 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
  RDX: 0000000000000028 RSI: 00000000ffffffff RDI: 00000000ffffffff
  RBP: ffff888107419680 R08: 0000000000000000 R09: ffffffff82d72b00
  R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000001ed
  R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000002
  FS:  0000000000000000(0000) GS:ffff88bc8b500000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000002610001 CR4: 00000000001706e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   ? show_trace_log_lvl+0x1c1/0x2d9
   ? show_trace_log_lvl+0x1c1/0x2d9
   ? set_affinity_irq+0xdc/0x1c0
   ? __die_body.cold+0x8/0xd
   ? die+0x2b/0x50
   ? do_trap+0x90/0x110
   ? bind_evtchn_to_cpu+0xdf/0xf0
   ? do_error_trap+0x65/0x80
   ? bind_evtchn_to_cpu+0xdf/0xf0
   ? exc_invalid_op+0x4e/0x70
   ? bind_evtchn_to_cpu+0xdf/0xf0
   ? asm_exc_invalid_op+0x12/0x20
   ? bind_evtchn_to_cpu+0xdf/0xf0
   ? bind_evtchn_to_cpu+0xc5/0xf0
   set_affinity_irq+0xdc/0x1c0
   irq_do_set_affinity+0x1d7/0x1f0
   irq_setup_affinity+0xd6/0x1a0
   irq_startup+0x8a/0xf0
   __setup_irq+0x639/0x6d0
   ? nvme_suspend+0x150/0x150
   request_threaded_irq+0x10c/0x180
   ? nvme_suspend+0x150/0x150
   pci_request_irq+0xa8/0xf0
   ? __blk_mq_free_request+0x74/0xa0
   queue_request_irq+0x6f/0x80
   nvme_create_queue+0x1af/0x200
   nvme_create_io_queues+0xbd/0xf0
   nvme_setup_io_queues+0x246/0x320
   ? nvme_irq_check+0x30/0x30
   nvme_reset_work+0x1c8/0x400
   process_one_work+0x1b0/0x350
   worker_thread+0x49/0x310
   ? process_one_work+0x350/0x350
   kthread+0x11b/0x140
   ? __kthread_bind_mask+0x60/0x60
   ret_from_fork+0x22/0x30
  Modules linked in:
  ---[ end trace a11715de1eee1873 ]---

Fixes: d46a78b05c0e ("xen: implement pirq type event channels")
Cc: stable@vger.kernel.org
Co-debugged-by: Andrew Panyakin <apanyaki@amazon.com>
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240124163130.31324-1-mheyne@amazon.de
Signed-off-by: Juergen Gross <jgross@suse.com>
[apanyaki: backport to v5.15-stable]
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -936,8 +936,8 @@ static void shutdown_pirq(struct irq_dat
 		return;
 
 	do_mask(info, EVT_MASK_REASON_EXPLICIT);
-	xen_evtchn_close(evtchn);
 	xen_irq_info_cleanup(info);
+	xen_evtchn_close(evtchn);
 }
 
 static void enable_pirq(struct irq_data *data)
@@ -981,8 +981,6 @@ static void __unbind_from_irq(unsigned i
 		unsigned int cpu = cpu_from_irq(irq);
 		struct xenbus_device *dev;
 
-		xen_evtchn_close(evtchn);
-
 		switch (type_from_irq(irq)) {
 		case IRQT_VIRQ:
 			per_cpu(virq_to_irq, cpu)[virq_from_irq(irq)] = -1;
@@ -1000,6 +998,7 @@ static void __unbind_from_irq(unsigned i
 		}
 
 		xen_irq_info_cleanup(info);
+		xen_evtchn_close(evtchn);
 	}
 
 	xen_free_irq(irq);


