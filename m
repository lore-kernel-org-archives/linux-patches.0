Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C39E46B9F;
	Mon,  1 Apr 2024 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989292; cv=none; b=j6s/iumfAvdRysNSNBToVMJ+1M/Bu5DySuPf3oawpD17YtvdY+PZcxJjnyqKh7UbUCFdWKMCyv0DkLz9DsBrt0EnMrIrYCRLsfkjqfKiVoZVCeYc/IN/e5KLwZBV16vZXVDUuuR55ixTIWoJ1cOzoARTmpEPcq725IwWOMVsrMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989292; c=relaxed/simple;
	bh=k65io7sNzeiLKUv7tjOOzO09qPy3o1SgN0qmbLAtaq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbV34nWaopMA8w3pvM7JnSSGJ7yi/LK6aBMwhQoRGJGpgBxifiKZaWT1GA4tQfsE298qkP/3Qup8bBuHaHZ5NooXoA/Ap1s2QqaL0rLJDuoJLkitRNY6tWf+HwmADiUhjHQ2uoNMbp1xB/FADN0vTnPUHWpWFVbaJ1RK/W7TF/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dX4apnQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dX4apnQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF723C433F1;
	Mon,  1 Apr 2024 16:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989292;
	bh=k65io7sNzeiLKUv7tjOOzO09qPy3o1SgN0qmbLAtaq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dX4apnQNA+w1a+73zKI3P8o8+BBrpyk6H39Oi9x44arNwYV+FocVhCQ/Lao+ycLnA
	 +RxKcae6ppZhzZbKpd2VrfRXW/ebPV4kwsZUujmKXr3RlpZXlWTp/BAD+OJ8hQDDwl
	 hmbmDIXwIM/4pFPnanDBFsLjYw5GImxYYkUzPGsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 419/432] scsi: qla2xxx: Fix double free of fcport
Date: Mon,  1 Apr 2024 17:46:46 +0200
Message-ID: <20240401152605.911376214@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

commit 82f522ae0d97119a43da53e0f729275691b9c525 upstream.

The server was crashing after LOGO because fcport was getting freed twice.

 -----------[ cut here ]-----------
 kernel BUG at mm/slub.c:371!
 invalid opcode: 0000 1 SMP PTI
 CPU: 35 PID: 4610 Comm: bash Kdump: loaded Tainted: G OE --------- - - 4.18.0-425.3.1.el8.x86_64 #1
 Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 09/03/2021
 RIP: 0010:set_freepointer.part.57+0x0/0x10
 RSP: 0018:ffffb07107027d90 EFLAGS: 00010246
 RAX: ffff9cb7e3150000 RBX: ffff9cb7e332b9c0 RCX: ffff9cb7e3150400
 RDX: 0000000000001f37 RSI: 0000000000000000 RDI: ffff9cb7c0005500
 RBP: fffff693448c5400 R08: 0000000080000000 R09: 0000000000000009
 R10: 0000000000000000 R11: 0000000000132af0 R12: ffff9cb7c0005500
 R13: ffff9cb7e3150000 R14: ffffffffc06990e0 R15: ffff9cb7ea85ea58
 FS: 00007ff6b79c2740(0000) GS:ffff9cb8f7ec0000(0000) knlGS:0000000000000000
 CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055b426b7d700 CR3: 0000000169c18002 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
 kfree+0x238/0x250
 qla2x00_els_dcmd_sp_free+0x20/0x230 [qla2xxx]
 ? qla24xx_els_dcmd_iocb+0x607/0x690 [qla2xxx]
 qla2x00_issue_logo+0x28c/0x2a0 [qla2xxx]
 ? qla2x00_issue_logo+0x28c/0x2a0 [qla2xxx]
 ? kernfs_fop_write+0x11e/0x1a0

Remove one of the free calls and add check for valid fcport. Also use
function qla2x00_free_fcport() instead of kfree().

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-9-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2637,7 +2637,8 @@ static void qla2x00_els_dcmd_sp_free(srb
 {
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
-	kfree(sp->fcport);
+	if (sp->fcport)
+		qla2x00_free_fcport(sp->fcport);
 
 	if (elsio->u.els_logo.els_logo_pyld)
 		dma_free_coherent(&sp->vha->hw->pdev->dev, DMA_POOL_SIZE,
@@ -2750,6 +2751,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2784,7 +2786,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
-	qla2x00_free_fcport(fcport);
 
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);


