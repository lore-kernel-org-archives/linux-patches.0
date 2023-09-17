Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE576FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1A9C433C7;
	Sun, 17 Sep 2023 20:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981554;
	bh=y7YZEzoHXN/EV/gsISXQF1ZLBTwwmzADHeQS/JtHO2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4toLLXUNCgbextcf0jPtF2xlLuh9+V17P4Lr1z9/K5a5V85k4vW5QncKrUjJAea1
	 XmgkCpERfDl+rJyHYfNYxQtaxjrp7OKCPugybTJobfhgXj0Mb47TCS/OhOn6BtYdGZ
	 F59q8Nut5HHFHC6WKhwKfQU0HUTuxEaV1OepxH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/511] perf/imx_ddr: dont enable counter0 if none of 4 counters are used
Date: Sun, 17 Sep 2023 21:08:18 +0200
Message-ID: <20230917191115.594432942@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit f4e2bd91ddf5e8543cbe7ad80b3fba3d2dc63fa3 ]

In current driver, counter0 will be enabled after ddr_perf_pmu_enable()
is called even though none of the 4 counters are used. This will cause
counter0 continue to count until ddr_perf_pmu_disabled() is called. If
pmu is not disabled all the time, the pmu interrupt will be asserted
from time to time due to counter0 will overflow and irq handler will
clear it. It's not an expected behavior. This patch will not enable
counter0 if none of 4 counters are used.

Fixes: 9a66d36cc7ac ("drivers/perf: imx_ddr: Add DDR performance counter support to perf")
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20230811015438.1999307-2-xu.yang_2@nxp.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index b1b2a55de77fc..4daa782c48df0 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -102,6 +102,7 @@ struct ddr_pmu {
 	const struct fsl_ddr_devtype_data *devtype_data;
 	int irq;
 	int id;
+	int active_counter;
 };
 
 static ssize_t ddr_perf_identifier_show(struct device *dev,
@@ -496,6 +497,10 @@ static void ddr_perf_event_start(struct perf_event *event, int flags)
 
 	ddr_perf_counter_enable(pmu, event->attr.config, counter, true);
 
+	if (!pmu->active_counter++)
+		ddr_perf_counter_enable(pmu, EVENT_CYCLES_ID,
+			EVENT_CYCLES_COUNTER, true);
+
 	hwc->state = 0;
 }
 
@@ -550,6 +555,10 @@ static void ddr_perf_event_stop(struct perf_event *event, int flags)
 	ddr_perf_counter_enable(pmu, event->attr.config, counter, false);
 	ddr_perf_event_update(event);
 
+	if (!--pmu->active_counter)
+		ddr_perf_counter_enable(pmu, EVENT_CYCLES_ID,
+			EVENT_CYCLES_COUNTER, false);
+
 	hwc->state |= PERF_HES_STOPPED;
 }
 
@@ -568,25 +577,10 @@ static void ddr_perf_event_del(struct perf_event *event, int flags)
 
 static void ddr_perf_pmu_enable(struct pmu *pmu)
 {
-	struct ddr_pmu *ddr_pmu = to_ddr_pmu(pmu);
-
-	/* enable cycle counter if cycle is not active event list */
-	if (ddr_pmu->events[EVENT_CYCLES_COUNTER] == NULL)
-		ddr_perf_counter_enable(ddr_pmu,
-				      EVENT_CYCLES_ID,
-				      EVENT_CYCLES_COUNTER,
-				      true);
 }
 
 static void ddr_perf_pmu_disable(struct pmu *pmu)
 {
-	struct ddr_pmu *ddr_pmu = to_ddr_pmu(pmu);
-
-	if (ddr_pmu->events[EVENT_CYCLES_COUNTER] == NULL)
-		ddr_perf_counter_enable(ddr_pmu,
-				      EVENT_CYCLES_ID,
-				      EVENT_CYCLES_COUNTER,
-				      false);
 }
 
 static int ddr_perf_init(struct ddr_pmu *pmu, void __iomem *base,
-- 
2.40.1



