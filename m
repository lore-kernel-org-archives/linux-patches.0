Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39B82F44;
	Thu, 12 Dec 2024 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023290; cv=none; b=G/rGZ0nyDBM9JpITkHy6TXjPUjiC1qBNlj+C00aiPt5K3QnMJVE7fUxP7iDuzoLwE1j63IdsUzpxg/LoZIMHa3wR2ie33hvuRnYjccLT/zXj4gWRD+rIcMcRY5ph24qLDfGpMTx0xAb+42yB+5d3tG+ZkNEQgZq6zjIkc+H7UHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023290; c=relaxed/simple;
	bh=WLsx2VJtZnb2wZ/+0UKSNQu9yI9rUVTpoo3S3vQS81Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKGOkTU5YOYhFVzKgWfndFOkDgRG/uGWkj0Z1fpMSOrSO/2JniAhzA5aZZI7iFwUQZ7OMTl/RYYIKmYCDCsPVSQfHpldlEcfLfDKXI77E8Ho68pdtH3L9m5ULzR2YqLVH/dZL4IhIVUA6N4TSC9b0N7LAUQzMNRPlkkBRSp7PvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WM5mLnSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WM5mLnSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE2CC4CECE;
	Thu, 12 Dec 2024 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023289;
	bh=WLsx2VJtZnb2wZ/+0UKSNQu9yI9rUVTpoo3S3vQS81Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WM5mLnSl7XCM8jFnWAX9Q0Sss9Psl1H4u91/DiPrhJ7ZMi82vNvBfr+y2RvPnB+vL
	 VM23vO/RIybtVjsSMT+DP1v61XqZl+DAc2zrBiSnd6YlR++TRy3ia+Z9yPFodgTQaY
	 vz6HbkzyoPrl3xmgPLcli4OaQzEvsAT4SG1tPgKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 456/565] scsi: qla2xxx: Fix use after free on unload
Date: Thu, 12 Dec 2024 16:00:51 +0100
Message-ID: <20241212144329.750159904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 07c903db0a2ff84b68efa1a74a4de353ea591eb0 upstream.

System crash is observed with stack trace warning of use after
free. There are 2 signals to tell dpc_thread to terminate (UNLOADING
flag and kthread_stop).

On setting the UNLOADING flag when dpc_thread happens to run at the time
and sees the flag, this causes dpc_thread to exit and clean up
itself. When kthread_stop is called for final cleanup, this causes use
after free.

Remove UNLOADING signal to terminate dpc_thread.  Use the kthread_stop
as the main signal to exit dpc_thread.

[596663.812935] kernel BUG at mm/slub.c:294!
[596663.812950] invalid opcode: 0000 [#1] SMP PTI
[596663.812957] CPU: 13 PID: 1475935 Comm: rmmod Kdump: loaded Tainted: G          IOE    --------- -  - 4.18.0-240.el8.x86_64 #1
[596663.812960] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/20/2012
[596663.812974] RIP: 0010:__slab_free+0x17d/0x360

...
[596663.813008] Call Trace:
[596663.813022]  ? __dentry_kill+0x121/0x170
[596663.813030]  ? _cond_resched+0x15/0x30
[596663.813034]  ? _cond_resched+0x15/0x30
[596663.813039]  ? wait_for_completion+0x35/0x190
[596663.813048]  ? try_to_wake_up+0x63/0x540
[596663.813055]  free_task+0x5a/0x60
[596663.813061]  kthread_stop+0xf3/0x100
[596663.813103]  qla2x00_remove_one+0x284/0x440 [qla2xxx]

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20241115130313.46826-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6851,12 +6851,15 @@ qla2x00_do_dpc(void *data)
 	set_user_nice(current, MIN_NICE);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop()) {
+	while (1) {
 		ql_dbg(ql_dbg_dpc, base_vha, 0x4000,
 		    "DPC handler sleeping.\n");
 
 		schedule();
 
+		if (kthread_should_stop())
+			break;
+
 		if (test_and_clear_bit(DO_EEH_RECOVERY, &base_vha->dpc_flags))
 			qla_pci_set_eeh_busy(base_vha);
 
@@ -6869,15 +6872,16 @@ qla2x00_do_dpc(void *data)
 			goto end_loop;
 		}
 
+		if (test_bit(UNLOADING, &base_vha->dpc_flags))
+			/* don't do any work. Wait to be terminated by kthread_stop */
+			goto end_loop;
+
 		ha->dpc_active = 1;
 
 		ql_dbg(ql_dbg_dpc + ql_dbg_verbose, base_vha, 0x4001,
 		    "DPC handler waking up, dpc_flags=0x%lx.\n",
 		    base_vha->dpc_flags);
 
-		if (test_bit(UNLOADING, &base_vha->dpc_flags))
-			break;
-
 		if (IS_P3P_TYPE(ha)) {
 			if (IS_QLA8044(ha)) {
 				if (test_and_clear_bit(ISP_UNRECOVERABLE,
@@ -7195,9 +7199,6 @@ end_loop:
 	 */
 	ha->dpc_active = 0;
 
-	/* Cleanup any residual CTX SRBs. */
-	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
-
 	return 0;
 }
 


