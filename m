Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4326054723;
	Fri, 13 Feb 2026 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990877; cv=none; b=cL2Xbnts9HMlKkq4Ch9q6m+sderLIsCKuBuZ1hq2hnrgEzrz14nyxS3Z/NRV0WIfqCEFvO3JypiRC/rqeFNU3qOHMM+xNY8JLW/aOrRd2WignCvXcngKDzxA+dK5F16pRA1yr6AQS5CMibhpxUiJyztKo9xtVjNaFFJRr4FiY50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990877; c=relaxed/simple;
	bh=NfHkl2S+C6gQSCFxTeLggKHDTcA64wOYz3KDeTAu4x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O0G3lkt5v7gcjtFjwrlWaRXc6O0TvtNO0is2t6CZTXqCQjWYVWl7Aj2J3LuXK1YUNOk/fN8rt9T8cjbzOVB19eD4i0ZPOSaH3COKK1VszXVSju5U+NCtcg19oQYph2pBpUYIivKdjukUIlgvKPQ92EXlPlJE5nFTm0bcBW+qEEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+z9Lpgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+z9Lpgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41B4C116C6;
	Fri, 13 Feb 2026 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990877;
	bh=NfHkl2S+C6gQSCFxTeLggKHDTcA64wOYz3KDeTAu4x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+z9LpgjF9SsNrv1xcQeyVnNU5CjYGdBXwlw53yEP4ZJ457FADyAtGdltwUMWmIm6
	 9aZc+I0j9dIMfN8pBVK1eMyr7EkwhOsFkfee/f5vtAeaUBmyvoLB/A9T4eyN02sT/6
	 BO8ZLUnmNpnENtGryejRBhFrFwal8/Jm2egcXFk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Gurumurthy <agurumurthy@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 38/49] scsi: qla2xxx: Validate sp before freeing associated memory
Date: Fri, 13 Feb 2026 14:48:22 +0100
Message-ID: <20260213134710.266478433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Gurumurthy <agurumurthy@marvell.com>

commit b6df15aec8c3441357d4da0eaf4339eb20f5999f upstream.

System crash with the following signature
[154563.214890] nvme nvme2: NVME-FC{1}: controller connect complete
[154564.169363] qla2xxx [0000:b0:00.1]-3002:2: nvme: Sched: Set ZIO exchange threshold to 3.
[154564.169405] qla2xxx [0000:b0:00.1]-ffffff:2: SET ZIO Activity exchange threshold to 5.
[154565.539974] qla2xxx [0000:b0:00.1]-5013:2: RSCN database changed – 0078 0080 0000.
[154565.545744] qla2xxx [0000:b0:00.1]-5013:2: RSCN database changed – 0078 00a0 0000.
[154565.545857] qla2xxx [0000:b0:00.1]-11a2:2: FEC=enabled (data rate).
[154565.552760] qla2xxx [0000:b0:00.1]-11a2:2: FEC=enabled (data rate).
[154565.553079] BUG: kernel NULL pointer dereference, address: 00000000000000f8
[154565.553080] #PF: supervisor read access in kernel mode
[154565.553082] #PF: error_code(0x0000) - not-present page
[154565.553084] PGD 80000010488ab067 P4D 80000010488ab067 PUD 104978a067 PMD 0
[154565.553089] Oops: 0000 1 PREEMPT SMP PTI
[154565.553092] CPU: 10 PID: 858 Comm: qla2xxx_2_dpc Kdump: loaded Tainted: G           OE     -------  ---  5.14.0-503.11.1.el9_5.x86_64 #1
[154565.553096] Hardware name: HPE Synergy 660 Gen10/Synergy 660 Gen10 Compute Module, BIOS I43 09/30/2024
[154565.553097] RIP: 0010:qla_fab_async_scan.part.0+0x40b/0x870 [qla2xxx]
[154565.553141] Code: 00 00 e8 58 a3 ec d4 49 89 e9 ba 12 20 00 00 4c 89 e6 49 c7 c0 00 ee a8 c0 48 c7 c1 66 c0 a9 c0 bf 00 80 00 10 e8 15 69 00 00 <4c> 8b 8d f8 00 00 00 4d 85 c9 74 35 49 8b 84 24 00 19 00 00 48 8b
[154565.553143] RSP: 0018:ffffb4dbc8aebdd0 EFLAGS: 00010286
[154565.553145] RAX: 0000000000000000 RBX: ffff8ec2cf0908d0 RCX: 0000000000000002
[154565.553147] RDX: 0000000000000000 RSI: ffffffffc0a9c896 RDI: ffffb4dbc8aebd47
[154565.553148] RBP: 0000000000000000 R08: ffffb4dbc8aebd45 R09: 0000000000ffff0a
[154565.553150] R10: 0000000000000000 R11: 000000000000000f R12: ffff8ec2cf0908d0
[154565.553151] R13: ffff8ec2cf090900 R14: 0000000000000102 R15: ffff8ec2cf084000
[154565.553152] FS:  0000000000000000(0000) GS:ffff8ed27f800000(0000) knlGS:0000000000000000
[154565.553154] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[154565.553155] CR2: 00000000000000f8 CR3: 000000113ae0a005 CR4: 00000000007706f0
[154565.553157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[154565.553158] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[154565.553159] PKRU: 55555554
[154565.553160] Call Trace:
[154565.553162]  <TASK>
[154565.553165]  ? show_trace_log_lvl+0x1c4/0x2df
[154565.553172]  ? show_trace_log_lvl+0x1c4/0x2df
[154565.553177]  ? qla_fab_async_scan.part.0+0x40b/0x870 [qla2xxx]
[154565.553215]  ? __die_body.cold+0x8/0xd
[154565.553218]  ? page_fault_oops+0x134/0x170
[154565.553223]  ? snprintf+0x49/0x70
[154565.553229]  ? exc_page_fault+0x62/0x150
[154565.553238]  ? asm_exc_page_fault+0x22/0x30

Check for sp being non NULL before freeing any associated memory

Fixes: a4239945b8ad ("scsi: qla2xxx: Add switch command to simplify fabric discovery")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251210101604.431868-10-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3701,23 +3701,25 @@ int qla_fab_async_scan(scsi_qla_host_t *
 	return rval;
 
 done_free_sp:
-	if (sp->u.iocb_cmd.u.ctarg.req) {
-		dma_free_coherent(&vha->hw->pdev->dev,
-		    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
-		    sp->u.iocb_cmd.u.ctarg.req,
-		    sp->u.iocb_cmd.u.ctarg.req_dma);
-		sp->u.iocb_cmd.u.ctarg.req = NULL;
-	}
-	if (sp->u.iocb_cmd.u.ctarg.rsp) {
-		dma_free_coherent(&vha->hw->pdev->dev,
-		    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
-		    sp->u.iocb_cmd.u.ctarg.rsp,
-		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
-		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
-	}
+	if (sp) {
+		if (sp->u.iocb_cmd.u.ctarg.req) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.req,
+			    sp->u.iocb_cmd.u.ctarg.req_dma);
+			sp->u.iocb_cmd.u.ctarg.req = NULL;
+		}
+		if (sp->u.iocb_cmd.u.ctarg.rsp) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.rsp,
+			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
+			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+		}
 
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	}
 
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;


