Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42526F2FE;
	Thu, 12 Dec 2024 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017949; cv=none; b=nTfQVbUz9K6MAsGo5sMj1+QqiI7jEMVejpmlMBoF33hB81jwbcftsHL0s9nslWMDb4VkDUrQDaAUgbBCfbRnrltkTzbH5h6pB8jotpS8SPkGy2mnYn4/APwewcXFeLWy00PEKcVItoDBEtk+hBw7g34SXETkq+TFWWJPQaNp5+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017949; c=relaxed/simple;
	bh=cJ9EmaZnNM0qZGzT4rEo/XbIwC9fUy8+fmZp6WfJan8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILdGS9rCI21zWrkVYD9d8bDjynvErKXqbT5NWDNvU+QTzkJTJR4d+ZL+K/3ex5TvLtQ9G3Jcg2tuAUj0ojZH2PHPRKcHEaOj9yzVMfliIo4qrDLqlvfyZpskK/+wwBHdEOiYoH1EEzTE6p8veI7dHJ2AfWyj13ESmsFFv0ntRyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBX4S0wi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBX4S0wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FD7C4CECE;
	Thu, 12 Dec 2024 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017949;
	bh=cJ9EmaZnNM0qZGzT4rEo/XbIwC9fUy8+fmZp6WfJan8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBX4S0winuf4gqIOlrJ3QdzbiP5HxRAffUQdtJFh2rOZ0PxILGgHhy5+zk7Xg21rX
	 tjugSvgwy0y/rE3i84iv5hr0RbJDFiE/ZbnRt+InNbTf56C1KZtC55znNCb7ILXJVR
	 1p1jubOT/yYg8JenoA4TATyf74393g9jHMVkec90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 155/356] scsi: qla2xxx: Fix use after free on unload
Date: Thu, 12 Dec 2024 15:57:54 +0100
Message-ID: <20241212144250.764451631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6899,12 +6899,15 @@ qla2x00_do_dpc(void *data)
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
 
@@ -6917,15 +6920,16 @@ qla2x00_do_dpc(void *data)
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
@@ -7238,9 +7242,6 @@ end_loop:
 	 */
 	ha->dpc_active = 0;
 
-	/* Cleanup any residual CTX SRBs. */
-	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
-
 	return 0;
 }
 


