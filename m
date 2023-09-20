Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4128E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D3FC433C9;
	Wed, 20 Sep 2023 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210768;
	bh=Bn6JMRljh4XFsPlZRadWdzShW9TJ7yA3xflCynlWgr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fe9MZZVaq36eEeGLhCM1wJlno6cmPhu1JI0RF8v0ASCHxn4X/CFbCRlCpRiA4Jb0A
	 FKuqr1nmPEGakNvbUG1mST3Z2ab5RwVdyiPZA9iIlkWgENJgnvWeLi/3qkOLp5um3z
	 nKTvr3VWAdZX4eZDlJzr6RcSx4wLQGMQ9IDZZYNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 198/211] scsi: qla2xxx: Use raw_smp_processor_id() instead of smp_processor_id()
Date: Wed, 20 Sep 2023 13:30:42 +0200
Message-ID: <20230920112852.004196698@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit 59f10a05b5c7b675256a66e3161741239889ff80 upstream.

The following call trace was observed:

localhost kernel: nvme nvme0: NVME-FC{0}: controller connect complete
localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u129:4/75092
localhost kernel: nvme nvme0: NVME-FC{0}: new ctrl: NQN "nqn.1992-08.com.netapp:sn.b42d198afb4d11ecad6d00a098d6abfa:subsystem.PR_Channel2022_RH84_subsystem_291"
localhost kernel: caller is qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
localhost kernel: CPU: 6 PID: 75092 Comm: kworker/u129:4 Kdump: loaded Tainted: G    B   W  OE    --------- ---  5.14.0-70.22.1.el9_0.x86_64+debug #1
localhost kernel: Hardware name: HPE ProLiant XL420 Gen10/ProLiant XL420 Gen10, BIOS U39 01/13/2022
localhost kernel: Workqueue: nvme-wq nvme_async_event_work [nvme_core]
localhost kernel: Call Trace:
localhost kernel: dump_stack_lvl+0x57/0x7d
localhost kernel: check_preemption_disabled+0xc8/0xd0
localhost kernel: qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]

Use raw_smp_processor_id() instead of smp_processor_id().

Also use queue_work() across the driver instead of queue_work_on() thus
avoiding usage of smp_processor_id() when CONFIG_DEBUG_PREEMPT is enabled.

Cc: stable@vger.kernel.org
Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230831112146.32595-2-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_inline.h  |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |    6 +++---
 drivers/scsi/qla2xxx/qla_target.c  |    3 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 ++--
 4 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -577,7 +577,7 @@ fcport_is_bigger(fc_port_t *fcport)
 static inline struct qla_qpair *
 qla_mapq_nvme_select_qpair(struct qla_hw_data *ha, struct qla_qpair *qpair)
 {
-	int cpuid = smp_processor_id();
+	int cpuid = raw_smp_processor_id();
 
 	if (qpair->cpuid != cpuid &&
 	    ha->qp_cpu_map[cpuid]) {
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3817,7 +3817,7 @@ void qla24xx_process_response_queue(stru
 	if (!ha->flags.fw_started)
 		return;
 
-	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
+	if (rsp->qpair->cpuid != raw_smp_processor_id() || !rsp->qpair->rcv_intr) {
 		rsp->qpair->rcv_intr = 1;
 
 		if (!rsp->qpair->cpu_mapped)
@@ -4308,7 +4308,7 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id
 	}
 	ha = qpair->hw;
 
-	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
+	queue_work(ha->wq, &qpair->q_work);
 
 	return IRQ_HANDLED;
 }
@@ -4334,7 +4334,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev
 	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
+	queue_work(ha->wq, &qpair->q_work);
 
 	return IRQ_HANDLED;
 }
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4425,8 +4425,7 @@ static int qlt_handle_cmd_for_atio(struc
 		queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
 	} else if (ha->msix_count) {
 		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
-			queue_work_on(smp_processor_id(), qla_tgt_wq,
-			    &cmd->work);
+			queue_work(qla_tgt_wq, &cmd->work);
 		else
 			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
 			    &cmd->work);
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -310,7 +310,7 @@ static void tcm_qla2xxx_free_cmd(struct
 	cmd->trc_flags |= TRC_CMD_DONE;
 
 	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
-	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 /*
@@ -547,7 +547,7 @@ static void tcm_qla2xxx_handle_data(stru
 	cmd->trc_flags |= TRC_DATA_IN;
 	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
-	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
+	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
 }
 
 static int tcm_qla2xxx_chk_dif_tags(uint32_t tag)


