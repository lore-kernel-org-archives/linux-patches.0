Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66818004F;
	Mon,  8 Apr 2024 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584914; cv=none; b=ITPre+TdMXb5l6n5QWQ7xdisITBkoXtPsrrI/gGgAeKJWxdRRO/6bg248u07zD2Hge3iAHa1lME08FNIEiw6sI0JzkqOmdAg2Uk1nNNV32FLr1J1toBTgE2lcaX/dP48O23nPSh7nRMxQueYb/N+UVFwdDD3+4PqxE/LmFm8x94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584914; c=relaxed/simple;
	bh=V1PGbPa/m3u+c/DjIEGsmykkvQCd8a5uUfy9Ea74gWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej9uqrr9QaA+I//BOXPAPyJy5MxjRpH3OPpjEYPrn5aLMM0GPr9HsZZpOjX0EteNIoxtxjWfBmcCLSRXGLbci4IjwmEOaPqbEsMNEFjhavlD+py0oRAUmzaQIv3ncjk26b551N8tKRZXMuXC9Z2BOTlTIKIXWK8xZ/25fCl04Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgSTVVQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgSTVVQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1403C433F1;
	Mon,  8 Apr 2024 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584914;
	bh=V1PGbPa/m3u+c/DjIEGsmykkvQCd8a5uUfy9Ea74gWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgSTVVQxiiv1qGO/Nc3rtxbXUhFdtAnVnPH3huv/vnMc0aDEXDWdFB8c3UaxPj8ve
	 KebcD924JkPIKIVI/zKVniFJENQRski8jpZxMFSCsXGKgJJgvd7gWx6ALhS1dpx3c7
	 8INszc5gE+ZvgJx7pVFb/t9ACTFaGMbvRUV03mr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 599/690] scsi: qla2xxx: Fix double free of fcport
Date: Mon,  8 Apr 2024 14:57:45 +0200
Message-ID: <20240408125421.297032784@linuxfoundation.org>
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
@@ -2638,7 +2638,8 @@ static void qla2x00_els_dcmd_sp_free(srb
 {
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
-	kfree(sp->fcport);
+	if (sp->fcport)
+		qla2x00_free_fcport(sp->fcport);
 
 	if (elsio->u.els_logo.els_logo_pyld)
 		dma_free_coherent(&sp->vha->hw->pdev->dev, DMA_POOL_SIZE,
@@ -2751,6 +2752,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2785,7 +2787,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *v
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
-	qla2x00_free_fcport(fcport);
 
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);


