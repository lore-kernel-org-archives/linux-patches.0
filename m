Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CC32C026C;
	Sat, 17 Oct 2026 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260279; cv=none; b=Hf6BxZtXX4pDO8raoeto97bUp08zoVGNteb+M/NgPHFh6s0iPUCPYSwGePefFQu2hARJFO2Cj1kcR0s7E91yoKc8u9NCLA8WDGvogaoZiPn8xwKDPL/AuqnmmZMdPxBsCdZvW4PyORjGMBNiKeIrdQqmFraHYaJjJ6hhitPfqHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260279; c=relaxed/simple;
	bh=7CL626VadNpYRhoZwN7BSqK0mrFC5oqO7UAGQ80HgIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kC1MrDbIuf6q2YRHy+FlINRYj6wnu3/HP3EZ3Evoz3oUeYGMhfViI4J5EZzOvi4FHroJjRDYswocbphYUnnKcmwSgv+7avCbKuagLQEwOESokpnWMJcQLSBfxis0uYAxoNKSnTUUFLeOO089kClmbRsBAL3bKGIaFSRjz+jwkk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTshZVG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTshZVG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDB31F000C4;
	Sat, 17 Oct 2026 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260278;
	bh=uYYg6vT+SjC+6238igUrEsuLV7yhDso+awrPXV52Q+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTshZVG73TJyjHebdYlfqFQyOL+zN15c60NqC7OQy7w7tzjC6x92F1kDZk4Cemwmn
	 B7a7IaHHgVMY2B8LlnFuReG+yKgFaenoeJrx1H45JG2oPTY0U52BDbE1cveazDPi8H
	 CN9La3EFHOaEACUzPpoNyKFRV4LduzgAl0ujglx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1455/1674] firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published
Date: Sat, 17 Oct 2026 18:02:07 +0200
Message-ID: <20261017160508.522604204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 966d23c7e68ea32679275a7e3d2383181002c868 ]

In qcom_scm_probe(), devm_request_threaded_irq() is called before
smp_store_release(&__scm, scm). Two paths can dereference __scm before
it is published, both causing a NULL pointer dereference.

The IRQ handler receives scm via its data argument but passes only wq_ctx
to qcom_scm_waitq_wakeup() and qcom_scm_get_completion(), which then
dereference __scm directly. Thread scm through both functions so the IRQ
handler path never touches __scm.

Non-atomic SMC calls made during probe (e.g. from qcom_tzmem_init via
qcom_scm_shm_bridge_enable) can return WAITQ_SLEEP, causing
qcom_scm_wait_for_wq_completion() to run before __scm is published and
dereference it. Add platform_set_drvdata(pdev, scm) early in probe and
change qcom_scm_wait_for_wq_completion() to take the device pointer and
use dev_get_drvdata() to reach scm, removing any dependency on __scm.

Fixes: 6bf325992236 ("firmware: qcom: scm: Add wait-queue handling logic")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260724094939.613844-2-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm-smc.c | 2 +-
 drivers/firmware/qcom_scm.c     | 8 +++++---
 drivers/firmware/qcom_scm.h     | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/qcom_scm-smc.c b/drivers/firmware/qcom_scm-smc.c
index 0a2a2c794d0ed..ed57c22715b6c 100644
--- a/drivers/firmware/qcom_scm-smc.c
+++ b/drivers/firmware/qcom_scm-smc.c
@@ -103,7 +103,7 @@ static int __scm_smc_do_quirk_handle_waitq(struct device *dev, struct arm_smccc_
 			wq_ctx = res->a1;
 			smc_call_ctx = res->a2;
 
-			ret = qcom_scm_wait_for_wq_completion(wq_ctx);
+			ret = qcom_scm_wait_for_wq_completion(dev, wq_ctx);
 			if (ret)
 				return ret;
 
diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 4c5c2b73d42c2..b5ada925f8da0 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1358,15 +1358,16 @@ static int qcom_scm_assert_valid_wq_ctx(u32 wq_ctx)
 	return 0;
 }
 
-int qcom_scm_wait_for_wq_completion(u32 wq_ctx)
+int qcom_scm_wait_for_wq_completion(struct device *dev, u32 wq_ctx)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	int ret;
 
 	ret = qcom_scm_assert_valid_wq_ctx(wq_ctx);
 	if (ret)
 		return ret;
 
-	wait_for_completion(&__scm->waitq_comp);
+	wait_for_completion(&scm->waitq_comp);
 
 	return 0;
 }
@@ -1379,7 +1380,7 @@ static int qcom_scm_waitq_wakeup(struct qcom_scm *scm, unsigned int wq_ctx)
 	if (ret)
 		return ret;
 
-	complete(&__scm->waitq_comp);
+	complete(&scm->waitq_comp);
 
 	return 0;
 }
@@ -1422,6 +1423,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	scm->dev = &pdev->dev;
+	platform_set_drvdata(pdev, scm);
 	ret = qcom_scm_find_dload_address(&pdev->dev, &scm->dload_mode_addr);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index e6e512bd57d1b..2bbf65442239f 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -60,7 +60,7 @@ struct qcom_scm_res {
 	u64 result[MAX_QCOM_SCM_RETS];
 };
 
-int qcom_scm_wait_for_wq_completion(u32 wq_ctx);
+int qcom_scm_wait_for_wq_completion(struct device *dev, u32 wq_ctx);
 int scm_get_wq_ctx(u32 *wq_ctx, u32 *flags, u32 *more_pending);
 
 #define SCM_SMC_FNID(s, c)	((((s) & 0xFF) << 8) | ((c) & 0xFF))
-- 
2.53.0



