Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B43359F8C;
	Fri,  9 Jan 2026 12:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960556; cv=none; b=id3XlHVvPzMuTlnHxKmQVn6jmiGfu05LQ4AMnVGfCZGMiIMrgPbJ5v0CXIXy5lZFTTUeWli7jAysA392prHWFDqya6E+GEJmIdlrb+gCTRh/N1Y6ll9eXABpM3tfIzhfKcma/klZHA1t0RqZlKYRfIfPCINYNrvFVIjYyoN0N4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960556; c=relaxed/simple;
	bh=NjzWp7AgrcSWgQ50i9oXGpPoJX1TBitqp1Tao9QReAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kK4uFt4FTTv3J7ICfPjyyIM5PtQ8QcHKjRNhSWbUsJ5tQrRdzLbSSKrbGAcRri+K12E5uaJBgJ65jZB4oWZ0F+etbMpptBp3eq/p1FaCoVZr2V2LVyPpQzCdHlu5l3vNf6phvfCz3M273eDTH0RPA2duB6/aqlnTwys/oVms0mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXUOdTVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXUOdTVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6569C16AAE;
	Fri,  9 Jan 2026 12:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960556;
	bh=NjzWp7AgrcSWgQ50i9oXGpPoJX1TBitqp1Tao9QReAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXUOdTVriGNlexPx9dVFGVe0mFjzqPRKX4+rUk1/v1vypaxwCQ3+9Irx7K1DqC2PV
	 h5iDAlBuKetg03IXU9ZDbzATeKSBlv2Oa19aCYZYII78QpWvModG9pQyEv6TCIWgbL
	 4Uu/uHv6lIaPgJ6tryb/b8IPnp+AXUB/iOl6ug3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 445/737] scsi: Revert "scsi: qla2xxx: Perform lockless command completion in abort path"
Date: Fri,  9 Jan 2026 12:39:44 +0100
Message-ID: <20260109112150.736261366@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Tony Battersby <tonyb@cybernetics.com>

commit b57fbc88715b6d18f379463f48a15b560b087ffe upstream.

This reverts commit 0367076b0817d5c75dfb83001ce7ce5c64d803a9.

The commit being reverted added code to __qla2x00_abort_all_cmds() to
call sp->done() without holding a spinlock.  But unlike the older code
below it, this new code failed to check sp->cmd_type and just assumed
TYPE_SRB, which results in a jump to an invalid pointer in target-mode
with TYPE_TGT_CMD:

qla2xxx [0000:65:00.0]-d034:8: qla24xx_do_nack_work create sess success
  0000000009f7a79b
qla2xxx [0000:65:00.0]-5003:8: ISP System Error - mbx1=1ff5h mbx2=10h
  mbx3=0h mbx4=0h mbx5=191h mbx6=0h mbx7=0h.
qla2xxx [0000:65:00.0]-d01e:8: -> fwdump no buffer
qla2xxx [0000:65:00.0]-f03a:8: qla_target(0): System error async event
  0x8002 occurred
qla2xxx [0000:65:00.0]-00af:8: Performing ISP error recovery -
  ha=0000000058183fda.
BUG: kernel NULL pointer dereference, address: 0000000000000000
PF: supervisor instruction fetch in kernel mode
PF: error_code(0x0010) - not-present page
PGD 0 P4D 0
Oops: 0010 [#1] SMP
CPU: 2 PID: 9446 Comm: qla2xxx_8_dpc Tainted: G           O       6.1.133 #1
Hardware name: Supermicro Super Server/X11SPL-F, BIOS 4.2 12/15/2023
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc90001f93dc8 EFLAGS: 00010206
RAX: 0000000000000282 RBX: 0000000000000355 RCX: ffff88810d16a000
RDX: ffff88810dbadaa8 RSI: 0000000000080000 RDI: ffff888169dc38c0
RBP: ffff888169dc38c0 R08: 0000000000000001 R09: 0000000000000045
R10: ffffffffa034bdf0 R11: 0000000000000000 R12: ffff88810800bb40
R13: 0000000000001aa8 R14: ffff888100136610 R15: ffff8881070f7400
FS:  0000000000000000(0000) GS:ffff88bf80080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000010c8ff006 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ? __die+0x4d/0x8b
 ? page_fault_oops+0x91/0x180
 ? trace_buffer_unlock_commit_regs+0x38/0x1a0
 ? exc_page_fault+0x391/0x5e0
 ? asm_exc_page_fault+0x22/0x30
 __qla2x00_abort_all_cmds+0xcb/0x3e0 [qla2xxx_scst]
 qla2x00_abort_all_cmds+0x50/0x70 [qla2xxx_scst]
 qla2x00_abort_isp_cleanup+0x3b7/0x4b0 [qla2xxx_scst]
 qla2x00_abort_isp+0xfd/0x860 [qla2xxx_scst]
 qla2x00_do_dpc+0x581/0xa40 [qla2xxx_scst]
 kthread+0xa8/0xd0
 </TASK>

Then commit 4475afa2646d ("scsi: qla2xxx: Complete command early within
lock") added the spinlock back, because not having the lock caused a
race and a crash.  But qla2x00_abort_srb() in the switch below already
checks for qla2x00_chip_is_down() and handles it the same way, so the
code above the switch is now redundant and still buggy in target-mode.
Remove it.

Cc: stable@vger.kernel.org
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://patch.msgid.link/3a8022dc-bcfd-4b01-9f9b-7a9ec61fa2a3@cybernetics.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1874,12 +1874,6 @@ __qla2x00_abort_all_cmds(struct qla_qpai
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
-			if (qla2x00_chip_is_down(vha)) {
-				req->outstanding_cmds[cnt] = NULL;
-				sp->done(sp, res);
-				continue;
-			}
-
 			switch (sp->cmd_type) {
 			case TYPE_SRB:
 				qla2x00_abort_srb(qp, sp, res, &flags);


