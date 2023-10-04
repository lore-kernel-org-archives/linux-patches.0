Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811081D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08EAC433C7;
	Wed,  4 Oct 2023 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442730;
	bh=MC3kWqxB03SUKn40KqRIrBB3qTAKZzS8z1sipV5h9Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0xFcNXLf+d0jeN+c2IlPOdjGOOHjnpTdj+PMaMrx6P78irXaQCpakNhYMga9bcg0
	 pNvxbzMgpd4vkkNTvXpgNgIib51+O8ukNBq3H+04p8e2BF1Wwc61ePwXF+W+5bGWXa
	 B+Ix7TtHfyOe5lyjWestJKuXV6xIN0rixxC3gx6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/183] scsi: qla2xxx: Select qpair depending on which CPU post_cmd() gets called
Date: Wed,  4 Oct 2023 19:55:19 +0200
Message-ID: <20231004175207.555798341@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Shreyas Deodhar <sdeodhar@marvell.com>

[ Upstream commit 1d201c81d4cc6840735bbcc99e6031503e5cf3b8 ]

In current I/O path, Tx and Rx may not be processed on same CPU. This may
lead to thrashing and optimum performance may not be achieved.

Pick qpair such that Tx and Rx are processed on same CPU.

Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 59f10a05b5c7 ("scsi: qla2xxx: Use raw_smp_processor_id() instead of smp_processor_id()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    |  2 ++
 drivers/scsi/qla2xxx/qla_init.c   |  2 --
 drivers/scsi/qla2xxx/qla_inline.h | 55 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  3 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  4 +++
 drivers/scsi/qla2xxx/qla_os.c     |  6 ++++
 6 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d70c2f4ba718e..723f9953ad701 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3461,6 +3461,7 @@ struct qla_msix_entry {
 	int have_irq;
 	int in_use;
 	uint32_t vector;
+	uint32_t vector_base0;
 	uint16_t entry;
 	char name[30];
 	void *handle;
@@ -4119,6 +4120,7 @@ struct qla_hw_data {
 	struct req_que **req_q_map;
 	struct rsp_que **rsp_q_map;
 	struct qla_qpair **queue_pair_map;
+	struct qla_qpair **qp_cpu_map;
 	unsigned long req_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
 	unsigned long rsp_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
 	unsigned long qpair_qid_map[(QLA_MAX_QUEUES / 8)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1a2ceef92bf07..d259f6727cf74 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9779,8 +9779,6 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		qpair->req = ha->req_q_map[req_id];
 		qpair->rsp->req = qpair->req;
 		qpair->rsp->qpair = qpair;
-		/* init qpair to this cpu. Will adjust at run time. */
-		qla_cpu_update(qpair, raw_smp_processor_id());
 
 		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 			if (ha->fw_attributes & BIT_4)
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index a7b5d11146827..d5cf9db2a8ea3 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -573,3 +573,58 @@ fcport_is_bigger(fc_port_t *fcport)
 {
 	return !fcport_is_smaller(fcport);
 }
+
+static inline struct qla_qpair *
+qla_mapq_nvme_select_qpair(struct qla_hw_data *ha, struct qla_qpair *qpair)
+{
+	int cpuid = smp_processor_id();
+
+	if (qpair->cpuid != cpuid &&
+	    ha->qp_cpu_map[cpuid]) {
+		qpair = ha->qp_cpu_map[cpuid];
+	}
+	return qpair;
+}
+
+static inline void
+qla_mapq_init_qp_cpu_map(struct qla_hw_data *ha,
+			 struct qla_msix_entry *msix,
+			 struct qla_qpair *qpair)
+{
+	const struct cpumask *mask;
+	unsigned int cpu;
+
+	if (!ha->qp_cpu_map)
+		return;
+	mask = pci_irq_get_affinity(ha->pdev, msix->vector_base0);
+	qpair->cpuid = cpumask_first(mask);
+	for_each_cpu(cpu, mask) {
+		ha->qp_cpu_map[cpu] = qpair;
+	}
+	msix->cpuid = qpair->cpuid;
+}
+
+static inline void
+qla_mapq_free_qp_cpu_map(struct qla_hw_data *ha)
+{
+	if (ha->qp_cpu_map) {
+		kfree(ha->qp_cpu_map);
+		ha->qp_cpu_map = NULL;
+	}
+}
+
+static inline int qla_mapq_alloc_qp_cpu_map(struct qla_hw_data *ha)
+{
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+
+	if (!ha->qp_cpu_map) {
+		ha->qp_cpu_map = kcalloc(NR_CPUS, sizeof(struct qla_qpair *),
+					 GFP_KERNEL);
+		if (!ha->qp_cpu_map) {
+			ql_log(ql_log_fatal, vha, 0x0180,
+			       "Unable to allocate memory for qp_cpu_map ptrs.\n");
+			return -1;
+		}
+	}
+	return 0;
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 80c2dcf567b0c..a13732921b5c0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3782,7 +3782,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 
 	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
 		rsp->qpair->rcv_intr = 1;
-		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
 #define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
@@ -4396,6 +4395,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	for (i = 0; i < ha->msix_count; i++) {
 		qentry = &ha->msix_entries[i];
 		qentry->vector = pci_irq_vector(ha->pdev, i);
+		qentry->vector_base0 = i;
 		qentry->entry = i;
 		qentry->have_irq = 0;
 		qentry->in_use = 0;
@@ -4623,5 +4623,6 @@ int qla25xx_request_irq(struct qla_hw_data *ha, struct qla_qpair *qpair,
 	}
 	msix->have_irq = 1;
 	msix->handle = qpair;
+	qla_mapq_init_qp_cpu_map(ha, msix, qpair);
 	return ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index f535f478e37c8..088e84042efc7 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -598,6 +598,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	fc_port_t *fcport;
 	struct srb_iocb *nvme;
 	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha;
 	int rval;
 	srb_t *sp;
 	struct qla_qpair *qpair = hw_queue_handle;
@@ -618,6 +619,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 		return -ENODEV;
 
 	vha = fcport->vha;
+	ha = vha->hw;
 
 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
 		return -EBUSY;
@@ -632,6 +634,8 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	if (fcport->nvme_flag & NVME_FLAG_RESETTING)
 		return -EBUSY;
 
+	qpair = qla_mapq_nvme_select_qpair(ha, qpair);
+
 	/* Alloc SRB structure */
 	sp = qla2xxx_get_qpair_sp(vha, qpair, fcport, GFP_ATOMIC);
 	if (!sp)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a40af9b832ab4..1b175e5c0cfcc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -467,6 +467,11 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 			    "Unable to allocate memory for queue pair ptrs.\n");
 			goto fail_qpair_map;
 		}
+		if (qla_mapq_alloc_qp_cpu_map(ha) != 0) {
+			kfree(ha->queue_pair_map);
+			ha->queue_pair_map = NULL;
+			goto fail_qpair_map;
+		}
 	}
 
 	/*
@@ -541,6 +546,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 		ha->base_qpair = NULL;
 	}
 
+	qla_mapq_free_qp_cpu_map(ha);
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 0; cnt < ha->max_req_queues; cnt++) {
 		if (!test_bit(cnt, ha->req_qid_map))
-- 
2.40.1



