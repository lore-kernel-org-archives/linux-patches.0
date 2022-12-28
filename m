Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C49B1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AD7C433EF;
	Wed, 28 Dec 2022 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245918;
	bh=ld4GI8IxkG5GhH1HYhSS/uEu2E7iHy1QQzt0YzYVSSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkGg8oD1fZLQOU0mvZrn3e8Yb0C0uc0h37+1dJaCybGLyMWeAgwIZJcmS8VdOo+Rm
	 e3x3glR650/wSy5UVxHfwurs4GvKY3PrWDJ2FHhfcG4ofmjb2+OiBb2I+cGCxMfKn5
	 4iazE81Zgvl/cU/IMf30xWLznMTbrsIL3LXlSENY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0980/1073] scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs
Date: Wed, 28 Dec 2022 15:42:48 +0100
Message-Id: <20221228144354.698033945@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit c44e50f4a0ec00c2298f31f91bc2c3e9bbd81c7e ]

During I/O and simultaneous cat of /sys/kernel/debug/lpfc/fnX/rx_monitor, a
hard lockup similar to the call trace below may occur.

The spin_lock_bh in lpfc_rx_monitor_report is not protecting from timer
interrupts as expected, so change the strength of the spin lock to _irq.

Kernel panic - not syncing: Hard LOCKUP
CPU: 3 PID: 110402 Comm: cat Kdump: loaded

exception RIP: native_queued_spin_lock_slowpath+91

[IRQ stack]
 native_queued_spin_lock_slowpath at ffffffffb814e30b
 _raw_spin_lock at ffffffffb89a667a
 lpfc_rx_monitor_record at ffffffffc0a73a36 [lpfc]
 lpfc_cmf_timer at ffffffffc0abbc67 [lpfc]
 __hrtimer_run_queues at ffffffffb8184250
 hrtimer_interrupt at ffffffffb8184ab0
 smp_apic_timer_interrupt at ffffffffb8a026ba
 apic_timer_interrupt at ffffffffb8a01c4f
[End of IRQ stack]

 apic_timer_interrupt at ffffffffb8a01c4f
 lpfc_rx_monitor_report at ffffffffc0a73c80 [lpfc]
 lpfc_rx_monitor_read at ffffffffc0addde1 [lpfc]
 full_proxy_read at ffffffffb83e7fc3
 vfs_read at ffffffffb833fe71
 ksys_read at ffffffffb83402af
 do_syscall_64 at ffffffffb800430b
 entry_SYSCALL_64_after_hwframe at ffffffffb8a000ad

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20221017164323.14536-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 03c21167fc85..c4960da4c1c4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8076,10 +8076,10 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 					"IO_cnt", "Info", "BWutil(ms)");
 	}
 
-	/* Needs to be _bh because record is called from timer interrupt
+	/* Needs to be _irq because record is called from timer interrupt
 	 * context
 	 */
-	spin_lock_bh(ring_lock);
+	spin_lock_irq(ring_lock);
 	while (*head_idx != *tail_idx) {
 		entry = &ring[*head_idx];
 
@@ -8123,7 +8123,7 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 		if (cnt >= max_read_entries)
 			break;
 	}
-	spin_unlock_bh(ring_lock);
+	spin_unlock_irq(ring_lock);
 
 	return cnt;
 }
-- 
2.35.1



