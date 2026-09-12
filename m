Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF54BEE22;
	Sat, 12 Sep 2026 12:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216550; cv=none; b=PoBPeAC98R310AYfMmBtUhyb79wVM264Lb0u+GbEGnCYVHPi8vbiqQLZlxuErurii6GafeZZ/41xg+2KOu+32z+AOHTlkljHeLvGm202y8m2VgEtDvfy+3d8dvctmxNXh8CEPNpw6gEREhcMs1MmVEenE8Mo2JKZ7na+21+EcJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216550; c=relaxed/simple;
	bh=NasAUynjEO53dnVt/Wshn4gKvM08L3B1dKD/DP1WVdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+2dVzBlRWoV2a+XVmeVvW737j46M5ME554PXU1jUOS81dL/5nl4UK8cgrpL3cuEkZd7YtD8sb5hdjx/+huUAuDSmJLWH29XdO1wittzWRYqt5niE0N2py5NAgPy3ENQr68QGXjIk/C4KjcU6cQui5/lXsq0FbzTsFsxZu/49D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tn6FH4wN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tn6FH4wN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C1F1F000FF;
	Sat, 12 Sep 2026 12:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216549;
	bh=MOPO6EJSEbbY6UAuJlVBFu1TK4UAaB9Z8IuLwBXUtAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tn6FH4wNgn+hNEXgzMp/sxEFcVfvGPIJJPGr/xVtXcN0oYPk9ju8w29B6TLZu4CvY
	 uBLAsXWM23tTIQj0WAlOTZetJs47Tx2fYTzBJfzVdJ84fbgIiigr6D9dZNcPdekPP3
	 oZSLEfQZyqrcjjhkRZcO7uzpS7NRl1EBcYTSGGD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <brgl@kernel.org>,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0760/1376] firmware: qcom_scm: Support multiple waitq contexts
Date: Sat, 12 Sep 2026 08:53:06 +0200
Message-ID: <20260912065624.478173368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>

[ Upstream commit ccd207ec848e768da41465352a0f52081eec6bb1 ]

Currently, only a single waitqueue context exists in the driver.
Multi-waitqueue mechanism is added in firmware to support the case,
when multiple VMs make SMC calls or single VM making multiple calls on
same CPU. Enhance the driver to support multiple waitqueue when
support is present in the firmware.

When VMs make a SMC call, firmware allocates a waitqueue context,
assuming the SMC call to be a blocking call. The SMC calls that cannot
acquire resources, while execution in firmware, are returned to sleep
in the calling VM. When the resource becomes available in the
firmware, the VM gets notified to wake the sleeping thread and resume
SMC call. The current qcom_scm driver supports single waitqueue as the
old firmwares support only single waitqueue with waitqueue id zero.
Multi-waitqueue mechanism is added in firmware starting SM8650 to
support the case when multiple VMs make SMC calls or single VM making
multiple calls on same CPU. To enable this support in qcom_scm driver,
add support for handling multiple waitqueues. For instance, SM8650
firmware can allocate two such waitq contexts, so the driver needs to
implement two waitqueue contexts. For a generalized approach, the
number of supported waitqueues can be queried from the firmware using
a SMC call.

Introduce qcom_scm_query_waitq_count to get the number of waitqueue
contexts supported by the firmware and allocate “N” unique waitqueue
contexts with a dynamic sized array where each unique wq_ctx is
associated with a struct completion variable for easy lookup. Older
targets which support only a single waitqueue, may return an error for
qcom_scm_query_waitq_count, set the wq_cnt to one for such failures.

Reviewed-by: Bartosz Golaszewski <brgl@kernel.org>
Signed-off-by: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
Signed-off-by: Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251217-multi_waitq_scm-v11-2-f21e50e792b8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 966d23c7e68e ("firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 72 ++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 5b2ef39a2e9e9..7f56ab78ac159 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -48,7 +48,7 @@ struct qcom_scm {
 	struct clk *iface_clk;
 	struct clk *bus_clk;
 	struct icc_path *path;
-	struct completion waitq_comp;
+	struct completion *waitq_comps;
 	struct reset_controller_dev reset;
 
 	/* control access to the interconnect path */
@@ -58,6 +58,7 @@ struct qcom_scm {
 	u64 dload_mode_addr;
 
 	struct qcom_tzmem_pool *mempool;
+	unsigned int wq_cnt;
 };
 
 struct qcom_scm_current_perm_info {
@@ -137,6 +138,8 @@ static const u8 qcom_scm_cpu_warm_bits[QCOM_SCM_BOOT_MAX_CPUS] = {
 #define QCOM_DLOAD_MINIDUMP	2
 #define QCOM_DLOAD_BOTHDUMP	3
 
+#define QCOM_SCM_DEFAULT_WAITQ_COUNT 1
+
 static const char * const qcom_scm_convention_names[] = {
 	[SMC_CONVENTION_UNKNOWN] = "unknown",
 	[SMC_CONVENTION_ARM_32] = "smc arm 32",
@@ -1873,6 +1876,23 @@ static int qcom_scm_fill_irq_fwspec_params(struct irq_fwspec *fwspec, u32 hwirq)
 	return 0;
 }
 
+static int qcom_scm_query_waitq_count(struct qcom_scm *scm)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_WAITQ,
+		.cmd = QCOM_SCM_WAITQ_GET_INFO,
+		.owner = ARM_SMCCC_OWNER_SIP
+	};
+	struct qcom_scm_res res;
+	int ret;
+
+	ret = qcom_scm_call_atomic(scm->dev, &desc, &res);
+	if (ret)
+		return ret;
+
+	return res.result[0] & GENMASK(7, 0);
+}
+
 static int qcom_scm_get_waitq_irq(struct qcom_scm *scm)
 {
 	struct qcom_scm_desc desc = {
@@ -1904,42 +1924,40 @@ static int qcom_scm_get_waitq_irq(struct qcom_scm *scm)
 	return irq_create_fwspec_mapping(&fwspec);
 }
 
-static int qcom_scm_assert_valid_wq_ctx(u32 wq_ctx)
+static struct completion *qcom_scm_get_completion(u32 wq_ctx)
 {
-	/* FW currently only supports a single wq_ctx (zero).
-	 * TODO: Update this logic to include dynamic allocation and lookup of
-	 * completion structs when FW supports more wq_ctx values.
-	 */
-	if (wq_ctx != 0) {
-		dev_err(__scm->dev, "Firmware unexpectedly passed non-zero wq_ctx\n");
-		return -EINVAL;
-	}
+	struct completion *wq;
 
-	return 0;
+	if (WARN_ON_ONCE(wq_ctx >= __scm->wq_cnt))
+		return ERR_PTR(-EINVAL);
+
+	wq = &__scm->waitq_comps[wq_ctx];
+
+	return wq;
 }
 
 int qcom_scm_wait_for_wq_completion(u32 wq_ctx)
 {
-	int ret;
+	struct completion *wq;
 
-	ret = qcom_scm_assert_valid_wq_ctx(wq_ctx);
-	if (ret)
-		return ret;
+	wq = qcom_scm_get_completion(wq_ctx);
+	if (IS_ERR(wq))
+		return PTR_ERR(wq);
 
-	wait_for_completion(&__scm->waitq_comp);
+	wait_for_completion(wq);
 
 	return 0;
 }
 
 static int qcom_scm_waitq_wakeup(unsigned int wq_ctx)
 {
-	int ret;
+	struct completion *wq;
 
-	ret = qcom_scm_assert_valid_wq_ctx(wq_ctx);
-	if (ret)
-		return ret;
+	wq = qcom_scm_get_completion(wq_ctx);
+	if (IS_ERR(wq))
+		return PTR_ERR(wq);
 
-	complete(&__scm->waitq_comp);
+	complete(wq);
 
 	return 0;
 }
@@ -2015,6 +2033,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	struct qcom_tzmem_pool_config pool_config;
 	struct qcom_scm *scm;
 	int irq, ret;
+	int i;
 
 	scm = devm_kzalloc(&pdev->dev, sizeof(*scm), GFP_KERNEL);
 	if (!scm)
@@ -2025,7 +2044,6 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	init_completion(&scm->waitq_comp);
 	mutex_init(&scm->scm_bw_lock);
 
 	scm->path = devm_of_icc_get(&pdev->dev, NULL);
@@ -2060,6 +2078,16 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	/* Paired with smp_load_acquire() in qcom_scm_is_available(). */
 	smp_store_release(&__scm, scm);
 
+	ret = qcom_scm_query_waitq_count(scm);
+	scm->wq_cnt = ret < 0 ? QCOM_SCM_DEFAULT_WAITQ_COUNT : ret;
+	scm->waitq_comps = devm_kcalloc(&pdev->dev, scm->wq_cnt, sizeof(*scm->waitq_comps),
+					GFP_KERNEL);
+	if (!scm->waitq_comps)
+		return -ENOMEM;
+
+	for (i = 0; i < scm->wq_cnt; i++)
+		init_completion(&scm->waitq_comps[i]);
+
 	irq = qcom_scm_get_waitq_irq(scm);
 	if (irq < 0)
 		irq = platform_get_irq_optional(pdev, 0);
-- 
2.53.0



