Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A4E1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29649C433C7;
	Wed,  4 Oct 2023 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442930;
	bh=i05UaYaLvtXq9eZP5u/saFpV7TDtAEF3d2GIZ0qHm+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Afg/UnofKGbNuNogd/24LGB11rQduM53wDehLnvc9BXXpzoyVXzuKDwJP9NapQk9
	 SGxYJ6Vk8Y8MhXME2gm9IqFzcIOjFDOS0qTVlF2cEKXhAFOy4pUEmtldmO8nLzi4kv
	 FDiEZOru3sNMQWkoNQ8JIdEQ2+4LvNXXdQdD1p0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Chesnokov <gleb.chesnokov@scst.dev>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/183] scsi: qla2xxx: Fix NULL pointer dereference in target mode
Date: Wed,  4 Oct 2023 19:56:23 +0200
Message-ID: <20231004175210.387671486@linuxfoundation.org>
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

From: Gleb Chesnokov <gleb.chesnokov@scst.dev>

[ Upstream commit d54820b22e404b06b2b65877ff802cc7b31688bc ]

When target mode is enabled, the pci_irq_get_affinity() function may return
a NULL value in qla_mapq_init_qp_cpu_map() due to the qla24xx_enable_msix()
code that handles IRQ settings for target mode. This leads to a crash due
to a NULL pointer dereference.

This patch fixes the issue by adding a check for the NULL value returned by
pci_irq_get_affinity() and introducing a 'cpu_mapped' boolean flag to the
qla_qpair structure, ensuring that the qpair's CPU affinity is updated when
it has not been mapped to a CPU.

Fixes: 1d201c81d4cc ("scsi: qla2xxx: Select qpair depending on which CPU post_cmd() gets called")
Signed-off-by: Gleb Chesnokov <gleb.chesnokov@scst.dev>
Link: https://lore.kernel.org/r/56b416f2-4e0f-b6cf-d6d5-b7c372e3c6a2@scst.dev
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h    | 1 +
 drivers/scsi/qla2xxx/qla_init.c   | 3 +++
 drivers/scsi/qla2xxx/qla_inline.h | 3 +++
 drivers/scsi/qla2xxx/qla_isr.c    | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 723f9953ad701..3c876967e8b16 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3791,6 +3791,7 @@ struct qla_qpair {
 	uint64_t retry_term_jiff;
 	struct qla_tgt_counters tgt_counters;
 	uint16_t cpuid;
+	bool cpu_mapped;
 	struct qla_fw_resources fwres ____cacheline_aligned;
 	u32	cmd_cnt;
 	u32	cmd_completion_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d259f6727cf74..b59d5b560a278 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9780,6 +9780,9 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		qpair->rsp->req = qpair->req;
 		qpair->rsp->qpair = qpair;
 
+		if (!qpair->cpu_mapped)
+			qla_cpu_update(qpair, raw_smp_processor_id());
+
 		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 			if (ha->fw_attributes & BIT_4)
 				qpair->difdix_supported = 1;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index e66441355f7ae..a4a56ab0ba747 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -597,11 +597,14 @@ qla_mapq_init_qp_cpu_map(struct qla_hw_data *ha,
 	if (!ha->qp_cpu_map)
 		return;
 	mask = pci_irq_get_affinity(ha->pdev, msix->vector_base0);
+	if (!mask)
+		return;
 	qpair->cpuid = cpumask_first(mask);
 	for_each_cpu(cpu, mask) {
 		ha->qp_cpu_map[cpu] = qpair;
 	}
 	msix->cpuid = qpair->cpuid;
+	qpair->cpu_mapped = true;
 }
 
 static inline void
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4f6aab2599350..51e906fa8694e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3782,6 +3782,9 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 
 	if (rsp->qpair->cpuid != raw_smp_processor_id() || !rsp->qpair->rcv_intr) {
 		rsp->qpair->rcv_intr = 1;
+
+		if (!rsp->qpair->cpu_mapped)
+			qla_cpu_update(rsp->qpair, raw_smp_processor_id());
 	}
 
 #define __update_rsp_in(_update, _is_shadow_hba, _rsp, _rsp_in)		\
-- 
2.40.1



