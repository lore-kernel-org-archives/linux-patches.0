Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9A1993B9;
	Thu, 15 Aug 2024 14:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732389; cv=none; b=BsjbFfPAhNOcUQ46QaOgw0/WiJ7gd6VuUi7axW7rtrjliPwZlwBoSu6PHi7llQlu05LTdngeBxW3B2+aFuQFM338JZn7txT2MZ8GSRp/SECfBnufy7SZKvPsCXTuem2LbjvXBwkI7h5bkYQCc88ZEgj72qOdDRDMb63/2jvAPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732389; c=relaxed/simple;
	bh=OSnN35/JABQww5XW0He4B7+92j2C3cbLEhYEsHTPJHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATMGgbliTlt4MFgJHwfdWYSQR6gxM1piZd/JjpeRWwQF1As7QZoaI0P+41+0NjSvXCgj+75no+kODGn7ORbmz4SYJDY+dIcNrHfhrHnGjaJ4FaufAMAE7wNF191DGNYZPGkPxs2D/BWC4sD6yIAlPmQNFNVI8/Oq3sCu2vqVn0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y/lT3QU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y/lT3QU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3345C32786;
	Thu, 15 Aug 2024 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732389;
	bh=OSnN35/JABQww5XW0He4B7+92j2C3cbLEhYEsHTPJHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0y/lT3QUdSJ5HVQA2bJF3/h/R3gdgpJxOLLcP2a1SoIzpoCBtN/cCAdSz6txujXow
	 2b3YQOB961/cKAkZYyJYgBMUu990vq0oXDARWbha29Csbz9qYZcIRo75PezTpi3YKP
	 qAjqZ9UNWJ3U2aWgTT5mo77kb140Dc4Sv0tAaMAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 165/352] scsi: qla2xxx: During vport delete send async logout explicitly
Date: Thu, 15 Aug 2024 15:23:51 +0200
Message-ID: <20240815131925.650045535@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Rangankar <mrangankar@marvell.com>

commit 76f480d7c717368f29a3870f7d64471ce0ff8fb2 upstream.

During vport delete, it is observed that during unload we hit a crash
because of stale entries in outstanding command array.  For all these stale
I/O entries, eh_abort was issued and aborted (fast_fail_io = 2009h) but
I/Os could not complete while vport delete is in process of deleting.

  BUG: kernel NULL pointer dereference, address: 000000000000001c
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  Workqueue: qla2xxx_wq qla_do_work [qla2xxx]
  RIP: 0010:dma_direct_unmap_sg+0x51/0x1e0
  RSP: 0018:ffffa1e1e150fc68 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 0000000000000021 RCX: 0000000000000001
  RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffff8ce208a7a0d0
  RBP: ffff8ce208a7a0d0 R08: 0000000000000000 R09: ffff8ce378aac9c8
  R10: ffff8ce378aac8a0 R11: ffffa1e1e150f9d8 R12: 0000000000000000
  R13: 0000000000000000 R14: ffff8ce378aac9c8 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff8d217f000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000000000001c CR3: 0000002089acc000 CR4: 0000000000350ee0
  Call Trace:
  <TASK>
  qla2xxx_qpair_sp_free_dma+0x417/0x4e0
  ? qla2xxx_qpair_sp_compl+0x10d/0x1a0
  ? qla2x00_status_entry+0x768/0x2830
  ? newidle_balance+0x2f0/0x430
  ? dequeue_entity+0x100/0x3c0
  ? qla24xx_process_response_queue+0x6a1/0x19e0
  ? __schedule+0x2d5/0x1140
  ? qla_do_work+0x47/0x60
  ? process_one_work+0x267/0x440
  ? process_one_work+0x440/0x440
  ? worker_thread+0x2d/0x3d0
  ? process_one_work+0x440/0x440
  ? kthread+0x156/0x180
  ? set_kthread_struct+0x50/0x50
  ? ret_from_fork+0x22/0x30
  </TASK>

Send out async logout explicitly for all the ports during vport delete.

Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-8-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -164,7 +164,7 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	list_for_each_entry(fcport, &vha->vp_fcports, list)
-		fcport->logout_on_delete = 0;
+		fcport->logout_on_delete = 1;
 
 	qla2x00_mark_all_devices_lost(vha);
 


