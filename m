Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BBA27AC31;
	Sat, 12 Sep 2026 07:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199979; cv=none; b=sYmoU7xv7jH/g/Eu9RVFH8NJuuUU0N3UBZkc+JvuysjBBgE7hFWqV+DCMapKHqC4JM0FCAiCS0q/puYCy6geZ5BQQhnoGlqj65KfNY14JOjfCJHajxwmsG6w9q+3nLpYoKBbNuFv3Y5xHiNbhtwFQFl3mSZ2pFafvxCtNU5OEc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199979; c=relaxed/simple;
	bh=mG4ZJfz8QWIG9JXzLLG633Lh7xw29HWX8GT1uVI8TfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsJ7AkOK5cBScAB/Q6nnqjVOwXlMxrpK7zslhP5NA4fv7LJVmhU2X/lqBpHWh3j4CUP8IYgDmMB+wCbq/dnGibjFEPaN27v/iGyveIRneENlwu1aP43vu3OEXm18t5H7RnhBb1TqUWQlHpIBz9iGDA0Ex3vDVZHz+f3qFNcZ3aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iv7GsRVT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iv7GsRVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E281F000FF;
	Sat, 12 Sep 2026 07:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199977;
	bh=VfPJuU7C3mDewfuURJfxnJEEvez0Cja1Vpzi/c3e5Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iv7GsRVTnyXUKfvJ9bZ9Qvbs+QNFe3btl7x2aEPVxeGq+Aa6/LHPGWOulEsoId3jO
	 MXllC3tahIMuAMmG8JE+g4ku4F8e1QnZt9wb6GPJzFeIXiaWYD2frq7K3g1sG5k54h
	 1EDq/F1Dkf/lsIVnFreZ5qFIYUsSHUr5Zuz770CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gokul Krishna Krishnakumar <gokul.krishnakumar@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0697/1815] remoteproc: qcom: pas: Add late attach support for subsystems
Date: Sat, 12 Sep 2026 08:40:47 +0200
Message-ID: <20260912065705.254042573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 16472c99f4699cb28f2f5f946400ead02f58a15e ]

Subsystems can be brought out of reset by entities such as bootloaders.
As the irq enablement could be later than subsystem bring up, the state
of subsystem should be checked by reading SMP2P bits.

A new qcom_pas_attach() function is introduced. if crash state is detected
for the subsystem, rproc_report_crash() is called. If the ready state is
detected meanwhile stop state is not detected, it will be marked as
"attached", otherwise it could be the early boot feature is not supported
by other entities or it has already been stopped. In above cases, the
state will be marked as RPROC_OFFLINE so that the PAS driver can load the
firmware and start the remoteproc.

Co-developed-by: Gokul Krishna Krishnakumar <gokul.krishnakumar@oss.qualcomm.com>
Signed-off-by: Gokul Krishna Krishnakumar <gokul.krishnakumar@oss.qualcomm.com>
Tested-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-knp-soccp-v7-5-1ec7bb5c9fec@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 0ea50486978f ("remoteproc: qcom: q6v5: Request shutdown if crash is triggered host-side")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_common.h   |  6 +++
 drivers/remoteproc/qcom_q6v5.c     |  3 +-
 drivers/remoteproc/qcom_q6v5_pas.c | 68 ++++++++++++++++++++++++++++++
 drivers/remoteproc/qcom_sysmon.c   | 19 +++++++++
 4 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_common.h b/drivers/remoteproc/qcom_common.h
index b07fbaa091a06..b0e7e336d363e 100644
--- a/drivers/remoteproc/qcom_common.h
+++ b/drivers/remoteproc/qcom_common.h
@@ -68,6 +68,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 					   int ssctl_instance);
 void qcom_remove_sysmon_subdev(struct qcom_sysmon *sysmon);
 bool qcom_sysmon_shutdown_acked(struct qcom_sysmon *sysmon);
+bool qcom_sysmon_shutdown_irq_state(struct qcom_sysmon *sysmon);
 #else
 static inline struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 							 const char *name,
@@ -84,6 +85,11 @@ static inline bool qcom_sysmon_shutdown_acked(struct qcom_sysmon *sysmon)
 {
 	return false;
 }
+
+static inline bool qcom_sysmon_shutdown_irq_state(struct qcom_sysmon *sysmon)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index 58d5b85e58cda..a11d8ace554bc 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -202,7 +202,8 @@ int qcom_q6v5_request_stop(struct qcom_q6v5 *q6v5, struct qcom_sysmon *sysmon)
 	q6v5->running = false;
 
 	/* Don't perform SMP2P dance if remote isn't running */
-	if (q6v5->rproc->state != RPROC_RUNNING || qcom_sysmon_shutdown_acked(sysmon))
+	if ((q6v5->rproc->state != RPROC_RUNNING && q6v5->rproc->state != RPROC_ATTACHED) ||
+	    qcom_sysmon_shutdown_acked(sysmon))
 		return 0;
 
 	qcom_smem_state_update_bits(q6v5->state,
diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 7ab8969528225..cb3e51d6f7cec 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -60,6 +60,7 @@ struct qcom_pas_data {
 	int region_assign_count;
 	bool region_assign_shared;
 	int region_assign_vmid;
+	bool early_boot;
 };
 
 struct qcom_pas {
@@ -504,6 +505,67 @@ static unsigned long qcom_pas_panic(struct rproc *rproc)
 	return qcom_q6v5_panic(&pas->q6v5);
 }
 
+static int qcom_pas_attach(struct rproc *rproc)
+{
+	struct qcom_pas *pas = rproc->priv;
+	bool ready_state;
+	bool crash_state;
+	bool stop_state;
+	int ret;
+
+	pas->q6v5.handover_issued = true;
+	enable_irq(pas->q6v5.handover_irq);
+
+	pas->q6v5.running = true;
+	ret = irq_get_irqchip_state(pas->q6v5.fatal_irq,
+				    IRQCHIP_STATE_LINE_LEVEL, &crash_state);
+	if (ret)
+		goto disable_running;
+
+	if (crash_state) {
+		dev_err(pas->dev, "Subsystem has crashed before driver probe\n");
+		rproc_report_crash(rproc, RPROC_FATAL_ERROR);
+		ret = -EINVAL;
+		goto disable_running;
+	}
+
+	ret = irq_get_irqchip_state(pas->q6v5.stop_irq,
+				    IRQCHIP_STATE_LINE_LEVEL, &stop_state);
+	if (ret)
+		goto disable_running;
+
+	if (stop_state || qcom_sysmon_shutdown_irq_state(pas->sysmon)) {
+		dev_info(pas->dev, "Subsystem found stop state set. Falling back to start.\n");
+		goto unroll_attach;
+	}
+
+	ret = irq_get_irqchip_state(pas->q6v5.ready_irq,
+				    IRQCHIP_STATE_LINE_LEVEL, &ready_state);
+	if (ret)
+		goto disable_running;
+
+	if (unlikely(!ready_state)) {
+		/*
+		 * The bootloader may not support early boot, mark the state as
+		 * RPROC_OFFLINE so that the PAS driver can load the firmware and
+		 * start the remoteproc.
+		 */
+		dev_err(pas->dev, "Failed to get subsystem ready interrupt\n");
+		goto unroll_attach;
+	}
+
+	return 0;
+
+unroll_attach:
+	pas->rproc->state = RPROC_OFFLINE;
+	ret = -EINVAL;
+disable_running:
+	disable_irq(pas->q6v5.handover_irq);
+	pas->q6v5.running = false;
+
+	return ret;
+}
+
 static const struct rproc_ops qcom_pas_ops = {
 	.unprepare = qcom_pas_unprepare,
 	.start = qcom_pas_start,
@@ -512,6 +574,7 @@ static const struct rproc_ops qcom_pas_ops = {
 	.parse_fw = qcom_pas_parse_firmware,
 	.load = qcom_pas_load,
 	.panic = qcom_pas_panic,
+	.attach = qcom_pas_attach,
 };
 
 static const struct rproc_ops qcom_pas_minidump_ops = {
@@ -523,6 +586,7 @@ static const struct rproc_ops qcom_pas_minidump_ops = {
 	.load = qcom_pas_load,
 	.panic = qcom_pas_panic,
 	.coredump = qcom_pas_minidump,
+	.attach = qcom_pas_attach,
 };
 
 static int qcom_pas_init_clock(struct qcom_pas *pas)
@@ -849,6 +913,10 @@ static int qcom_pas_probe(struct platform_device *pdev)
 
 	pas->pas_ctx->use_tzmem = rproc->has_iommu;
 	pas->dtb_pas_ctx->use_tzmem = rproc->has_iommu;
+
+	if (desc->early_boot)
+		pas->rproc->state = RPROC_DETACHED;
+
 	ret = rproc_add(rproc);
 	if (ret)
 		goto remove_ssr_sysmon;
diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index 913e3b750a869..a0830a48b1f40 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -736,6 +736,25 @@ bool qcom_sysmon_shutdown_acked(struct qcom_sysmon *sysmon)
 }
 EXPORT_SYMBOL_GPL(qcom_sysmon_shutdown_acked);
 
+bool qcom_sysmon_shutdown_irq_state(struct qcom_sysmon *sysmon)
+{
+	bool shutdown_state;
+	int ret;
+
+	if (!sysmon)
+		return false;
+
+	ret = irq_get_irqchip_state(sysmon->shutdown_irq,
+				    IRQCHIP_STATE_LINE_LEVEL, &shutdown_state);
+	if (ret) {
+		dev_warn(sysmon->dev, "failed to get shutdown_state: %d\n", ret);
+		return false;
+	}
+
+	return shutdown_state;
+}
+EXPORT_SYMBOL_GPL(qcom_sysmon_shutdown_irq_state);
+
 /**
  * sysmon_probe() - probe sys_mon channel
  * @rpdev:	rpmsg device handle
-- 
2.53.0



