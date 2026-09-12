Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D719D19D8BC;
	Sat, 12 Sep 2026 10:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208709; cv=none; b=SxN4weOm+RxXyNStBFecoyWa7FLrcfHMKu/YcgLSAwUZkQ/SGl3LacjhFESxUwQlgYtm/v6slgIKF/EM49tnII36ReAaysbZoX94fivGff7Z2ECJgHpDnC99gd7rO95/02F11bhybLEnkbVNTv1LKNcaUa/wPFgfrYEeQygi6RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208709; c=relaxed/simple;
	bh=PTLdXh5r3GOfOpwiwfcTVBX5XpKe3qCXmR7V3/D2Mnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZhcZ9jWayfBYVfWdjEezTf1IOEtNsPgVpWhnxWF3BtcvWDS7uBvlVbY3i2/a/yk6EGXbnQWc4mL7tGzftgNlv/MAxoRYOgkMzrDaobbPfAs9YJLkCEW5/cbP7bOSOErT7qtmKPCrbXZ1bnTostPFwTscPIHczBKN6KozpDPXIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdsOoW2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdsOoW2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926DA1F000FF;
	Sat, 12 Sep 2026 10:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208707;
	bh=aA0J00TL09eTOw3q9mV6CmXyQn2jcJ+BAKcSXOKsZqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdsOoW2vt7rDQx5NUKOd9jh+RG50l6lIBEvWTxzHUzvJ+BqYGOn/kNwJ9btKAXHl5
	 lUcb6TtODRcwYPHcz2Oohho1fqp9uHt5KU4kw7RiB0BYxCAQJU9fxGCUqJMhYjIE0g
	 hyZL0hw5R/cp1fEZYOCGCBPcU1IEKFmlhoQEWVuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0672/1518] firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published
Date: Sat, 12 Sep 2026 08:47:21 +0200
Message-ID: <20260912065638.636520274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/firmware/qcom/qcom_scm-smc.c |  2 +-
 drivers/firmware/qcom/qcom_scm.c     | 22 ++++++++++------------
 drivers/firmware/qcom/qcom_scm.h     |  2 +-
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm-smc.c b/drivers/firmware/qcom/qcom_scm-smc.c
index 01999c22659cb..127365ab11fc2 100644
--- a/drivers/firmware/qcom/qcom_scm-smc.c
+++ b/drivers/firmware/qcom/qcom_scm-smc.c
@@ -111,7 +111,7 @@ static int __scm_smc_do_quirk_handle_waitq(struct device *dev, struct arm_smccc_
 			smc_call_ctx = res->a2;
 
 			trace_scm_waitq_sleep(wq_ctx, smc_call_ctx);
-			ret = qcom_scm_wait_for_wq_completion(wq_ctx);
+			ret = qcom_scm_wait_for_wq_completion(dev, wq_ctx);
 			if (ret)
 				return ret;
 
diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 99a06b3b1b629..73179a99935ba 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2334,23 +2334,20 @@ static int qcom_scm_get_waitq_irq(struct qcom_scm *scm)
 	return irq_create_fwspec_mapping(&fwspec);
 }
 
-static struct completion *qcom_scm_get_completion(u32 wq_ctx)
+static struct completion *qcom_scm_get_completion(struct qcom_scm *scm, u32 wq_ctx)
 {
-	struct completion *wq;
-
-	if (WARN_ON_ONCE(wq_ctx >= __scm->wq_cnt))
+	if (WARN_ON_ONCE(wq_ctx >= scm->wq_cnt))
 		return ERR_PTR(-EINVAL);
 
-	wq = &__scm->waitq_comps[wq_ctx];
-
-	return wq;
+	return &scm->waitq_comps[wq_ctx];
 }
 
-int qcom_scm_wait_for_wq_completion(u32 wq_ctx)
+int qcom_scm_wait_for_wq_completion(struct device *dev, u32 wq_ctx)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	struct completion *wq;
 
-	wq = qcom_scm_get_completion(wq_ctx);
+	wq = qcom_scm_get_completion(scm, wq_ctx);
 	if (IS_ERR(wq))
 		return PTR_ERR(wq);
 
@@ -2359,11 +2356,11 @@ int qcom_scm_wait_for_wq_completion(u32 wq_ctx)
 	return 0;
 }
 
-static int qcom_scm_waitq_wakeup(unsigned int wq_ctx)
+static int qcom_scm_waitq_wakeup(struct qcom_scm *scm, unsigned int wq_ctx)
 {
 	struct completion *wq;
 
-	wq = qcom_scm_get_completion(wq_ctx);
+	wq = qcom_scm_get_completion(scm, wq_ctx);
 	if (IS_ERR(wq))
 		return PTR_ERR(wq);
 
@@ -2390,7 +2387,7 @@ static irqreturn_t qcom_scm_irq_handler(int irq, void *data)
 			goto out;
 		}
 
-		ret = qcom_scm_waitq_wakeup(wq_ctx);
+		ret = qcom_scm_waitq_wakeup(scm, wq_ctx);
 		if (ret)
 			goto out;
 	} while (more_pending);
@@ -2450,6 +2447,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	scm->dev = &pdev->dev;
+	platform_set_drvdata(pdev, scm);
 	ret = qcom_scm_find_dload_address(&pdev->dev, &scm->dload_mode_addr);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
index 8b1e2ea18a59a..2111188f9fad0 100644
--- a/drivers/firmware/qcom/qcom_scm.h
+++ b/drivers/firmware/qcom/qcom_scm.h
@@ -66,7 +66,7 @@ struct qcom_scm_res {
 	u64 result[MAX_QCOM_SCM_RETS];
 };
 
-int qcom_scm_wait_for_wq_completion(u32 wq_ctx);
+int qcom_scm_wait_for_wq_completion(struct device *dev, u32 wq_ctx);
 int scm_get_wq_ctx(u32 *wq_ctx, u32 *flags, u32 *more_pending);
 
 #define SCM_SMC_FNID(s, c)	((((s) & 0xFF) << 8) | ((c) & 0xFF))
-- 
2.53.0



