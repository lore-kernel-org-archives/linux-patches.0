Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB2C21B191;
	Sat, 30 May 2026 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165467; cv=none; b=AJ3+mdNe2pZKzegSH0ogWU/84firOaAEqT9y3bHtBazgXcGq4kCLV2ITfbjazG/a6AoYN6dWaiHlIN766y3GeKpV+l0lt0OtIh0JW7BwUobW5OXV0xrwWc1ede5pZpRUkpKp7D7OOLRTXM6koPOUN05PZ8kNXwQz+HwjpA2GBng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165467; c=relaxed/simple;
	bh=IDPav0oiOP/xdZ14nHr1T8A1Wm3UnW7lab7NAqbQ+fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGINH3etB+sDrBKaSPqHgltUo8QlpNiy6/sVRCyrr9ERanrwGvR4zBWcgErWXqBVx7XNzmSj7+e7EgKRiY97ncgOLfGlxqbILPOzlt+POxBOjwqlB6lvnFq+0Rik3L/YJpKYun0OSIudVnQvugC2UHa2mm8xvuJXOWgBU8Xo6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyDeDLSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyDeDLSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6148F1F00893;
	Sat, 30 May 2026 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165466;
	bh=5q/3SBpQ1RfnNrswUyc1wx/1CZPkCijyzMK/4uTadgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyDeDLSa5Y0+bK3xLgUtqa2DDhMX0q/9tKYmtTAq9p+bbrfDnTsu83ADx7n1MpSDg
	 H5oGXnuzuJEOO710nRAWdAwMPobSULzrue9zW1Ko0qyLLnPrM1p4k+D/DRjhvSRaEj
	 A01ZNSJMRoMGQNRIu0u8i3vvSwfHf24kwzS94trw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Patalano <mpatalan@redhat.com>,
	Arun Easi <aeasi@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/589] scsi: qla2xxx: Fix crash when I/O abort times out
Date: Sat, 30 May 2026 17:59:27 +0200
Message-ID: <20260530160226.929931638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Easi <aeasi@marvell.com>

commit 68ad83188d782b2ecef2e41ac245d27e0710fe8e upstream.

While performing CPU hotplug, a crash with the following stack was seen:

Call Trace:
     qla24xx_process_response_queue+0x42a/0x970 [qla2xxx]
     qla2x00_start_nvme_mq+0x3a2/0x4b0 [qla2xxx]
     qla_nvme_post_cmd+0x166/0x240 [qla2xxx]
     nvme_fc_start_fcp_op.part.0+0x119/0x2e0 [nvme_fc]
     blk_mq_dispatch_rq_list+0x17b/0x610
     __blk_mq_sched_dispatch_requests+0xb0/0x140
     blk_mq_sched_dispatch_requests+0x30/0x60
     __blk_mq_run_hw_queue+0x35/0x90
     __blk_mq_delay_run_hw_queue+0x161/0x180
     blk_execute_rq+0xbe/0x160
     __nvme_submit_sync_cmd+0x16f/0x220 [nvme_core]
     nvmf_connect_admin_queue+0x11a/0x170 [nvme_fabrics]
     nvme_fc_create_association.cold+0x50/0x3dc [nvme_fc]
     nvme_fc_connect_ctrl_work+0x19/0x30 [nvme_fc]
     process_one_work+0x1e8/0x3c0

On abort timeout, completion was called without checking if the I/O was
already completed.

Verify that I/O and abort request are indeed outstanding before attempting
completion.

Fixes: 71c80b75ce8f ("scsi: qla2xxx: Do command completion on abort timeout")
Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20221129092634.15347-1-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ kovalev: bp to fix CVE-2022-50493 ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 79b9571f63508..4a057748ba175 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -101,6 +101,7 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	struct qla_qpair *qpair = sp->qpair;
 	u32 handle;
 	unsigned long flags;
+	int sp_found = 0, cmdsp_found = 0;
 
 	if (sp->cmd_sp)
 		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
@@ -115,22 +116,27 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
 		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
-		    sp->cmd_sp))
+		    sp->cmd_sp)) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			cmdsp_found = 1;
+		}
 
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			sp_found = 1;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	if (sp->cmd_sp)
+	if (cmdsp_found && sp->cmd_sp)
 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
 
-	abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
-	sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	if (sp_found) {
+		abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
+		sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	}
 }
 
 static void qla24xx_abort_sp_done(srb_t *sp, int res)
-- 
2.53.0



