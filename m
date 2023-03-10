Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017038481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764C6C433EF;
	Fri, 10 Mar 2023 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457647;
	bh=XLQcy6H8umtd3377Tdeyl39KhEJ6wNNr/0wtxWOtyFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1y7wg3JIFtE2o7Dr85itiDEU2m39gyMZydq4l3fYHw0IVViQkf+m9URTqFp96OfO4
	 E+4oGMyh8WOYpDd6EK7n/QuXI+YOMZ55EuY03320TRHf8Cw+LoKqtAJjG32H3WhP31
	 qu2sq1r7SYTYGHK+Y9vfG7Rlm3l1/3aOerpXPabc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angus Chen <angus.chen@jaguarmicro.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/252] ARM: imx: Call ida_simple_remove() for ida_simple_get
Date: Fri, 10 Mar 2023 14:36:20 +0100
Message-Id: <20230310133719.144277860@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Angus Chen <angus.chen@jaguarmicro.com>

[ Upstream commit ebeb49f43c8952f12aa20f03f00d7009edc2d1c5 ]

The function call ida_simple_get maybe fail,we should deal with it.
And if ida_simple_get success ,it need to call ida_simple_remove also.
BTW,devm_kasprintf can handle id is zero for consistency.

Fixes: e76bdfd7403a ("ARM: imx: Added perf functionality to mmdc driver")
Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mmdc.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index 14be73ca107a5..965a41572283e 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -105,6 +105,7 @@ struct mmdc_pmu {
 	cpumask_t cpu;
 	struct hrtimer hrtimer;
 	unsigned int active_events;
+	int id;
 	struct device *dev;
 	struct perf_event *mmdc_events[MMDC_NUM_COUNTERS];
 	struct hlist_node node;
@@ -445,8 +446,6 @@ static enum hrtimer_restart mmdc_pmu_timer_handler(struct hrtimer *hrtimer)
 static int mmdc_pmu_init(struct mmdc_pmu *pmu_mmdc,
 		void __iomem *mmdc_base, struct device *dev)
 {
-	int mmdc_num;
-
 	*pmu_mmdc = (struct mmdc_pmu) {
 		.pmu = (struct pmu) {
 			.task_ctx_nr    = perf_invalid_context,
@@ -463,15 +462,16 @@ static int mmdc_pmu_init(struct mmdc_pmu *pmu_mmdc,
 		.active_events = 0,
 	};
 
-	mmdc_num = ida_simple_get(&mmdc_ida, 0, 0, GFP_KERNEL);
+	pmu_mmdc->id = ida_simple_get(&mmdc_ida, 0, 0, GFP_KERNEL);
 
-	return mmdc_num;
+	return pmu_mmdc->id;
 }
 
 static int imx_mmdc_remove(struct platform_device *pdev)
 {
 	struct mmdc_pmu *pmu_mmdc = platform_get_drvdata(pdev);
 
+	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	perf_pmu_unregister(&pmu_mmdc->pmu);
 	iounmap(pmu_mmdc->mmdc_base);
@@ -485,7 +485,6 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 {
 	struct mmdc_pmu *pmu_mmdc;
 	char *name;
-	int mmdc_num;
 	int ret;
 	const struct of_device_id *of_id =
 		of_match_device(imx_mmdc_dt_ids, &pdev->dev);
@@ -508,14 +507,14 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 		cpuhp_mmdc_state = ret;
 	}
 
-	mmdc_num = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
-	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
-	if (mmdc_num == 0)
-		name = "mmdc";
-	else
-		name = devm_kasprintf(&pdev->dev,
-				GFP_KERNEL, "mmdc%d", mmdc_num);
+	ret = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
+	if (ret < 0)
+		goto  pmu_free;
 
+	name = devm_kasprintf(&pdev->dev,
+				GFP_KERNEL, "mmdc%d", ret);
+
+	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
 	pmu_mmdc->devtype_data = (struct fsl_mmdc_devtype_data *)of_id->data;
 
 	hrtimer_init(&pmu_mmdc->hrtimer, CLOCK_MONOTONIC,
@@ -536,6 +535,7 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 
 pmu_register_err:
 	pr_warn("MMDC Perf PMU failed (%d), disabled\n", ret);
+	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	hrtimer_cancel(&pmu_mmdc->hrtimer);
 pmu_free:
-- 
2.39.2



