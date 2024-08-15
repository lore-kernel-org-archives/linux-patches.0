Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893617BEA5;
	Thu, 15 Aug 2024 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729839; cv=none; b=YoO1dvYba4HkLZH3m+t97s1y54rkwpMMDQI4gUF4WT/lTxdXxeUo143Povt+JjfGdqOJJ0h2bPU9+U6v5fvPNADDDMxwKVM02VDy3hgcJwjJFbv/KKivMQ8ZFs/gLdZGSPWlGcKQLqH1yWcqMiLhDS7nk2yt7PPJXT8c9epAHPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729839; c=relaxed/simple;
	bh=7qh+YWWI+DEt7Io5I07n2ovwQGEDMzSFzuIYG1AFm1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/HEuCZn9fUPvfbwfE7VeMno5uBcALz7qqgcuJdvcu7u04Q+9ldr4+8sEzxH8ayN6VihlySA9LVNQ0BGJ987soWjtaGQO68TxsNUfE09ar9MK95aJQzsPHGLlaAYSv7nWP0hBQ3ciZY9/7JzcPBpGNVA4KOhV8X/NrtQntMyOPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMyZuk5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMyZuk5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFFDC32786;
	Thu, 15 Aug 2024 13:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729839;
	bh=7qh+YWWI+DEt7Io5I07n2ovwQGEDMzSFzuIYG1AFm1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMyZuk5qwuTQtqCPcszMfDTAqeagqVQTRLVJWMhrUvbd3Hf0iFXJhokkzH2NPJk1C
	 QUoL4e9frEaVPa2QhPv6lWhMh+g+7pjJkIWXVUIjGIp9QTW1c74z+N3GY/P47SSWZD
	 YjEI4N9NVRDVa0obg70tK8vsdxTzpfp/MWiFtM6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Rangankar <mrangankar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 223/484] scsi: qla2xxx: During vport delete send async logout explicitly
Date: Thu, 15 Aug 2024 15:21:21 +0200
Message-ID: <20240815131950.025585089@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
@@ -180,7 +180,7 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	list_for_each_entry(fcport, &vha->vp_fcports, list)
-		fcport->logout_on_delete = 0;
+		fcport->logout_on_delete = 1;
 
 	if (!vha->hw->flags.edif_enabled)
 		qla2x00_wait_for_sess_deletion(vha);


