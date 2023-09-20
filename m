Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E612A28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B349C433CA;
	Wed, 20 Sep 2023 11:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210833;
	bh=2Zaju/PoY5RLCQuLAAA8jhrkbUSCpGzRwqJgBqs/DG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oru50X0Ar8mbMALl+KgauNSa3gGkHZUjccUd9oxVxuuNCPn5hdrZfrFAi3b1fcJ5
	 6WP7WYV9UanuhaUl6oGxb5IojO8M6zYMjrijL86P7sKeCoZkS8DyHDwXXXgV1TCKD8
	 23Kit/o/A28JdBznjU0u3vWM4Dj5QCEou1Vf6kDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/139] perf/imx_ddr: speed up overflow frequency of cycle
Date: Wed, 20 Sep 2023 13:29:04 +0200
Message-ID: <20230920112835.969684348@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit e89ecd8368860bf05437eabd07d292c316221cfc ]

For i.MX8MP, we cannot ensure that cycle counter overflow occurs at least
4 times as often as other events. Due to byte counters will count for any
event configured, it will overflow more often. And if byte counters
overflow that related counters would stop since they share the
COUNTER_CNTL. We can speed up cycle counter overflow frequency by setting
counter parameter (CP) field of cycle counter. In this way, we can avoid
stop counting byte counters when interrupt didn't come and the byte
counters can be fetched or updated from each cycle counter overflow
interrupt.

Because we initialize CP filed to shorten counter0 overflow time, the cycle
counter will start couting from a fixed/base value each time. We need to
remove the base from the result too. Therefore, we could get precise result
from cycle counter.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20230811015438.1999307-1-xu.yang_2@nxp.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index cd4ce2b4906d1..a4cda73b81c9f 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -28,6 +28,8 @@
 #define CNTL_CLEAR_MASK		0xFFFFFFFD
 #define CNTL_OVER_MASK		0xFFFFFFFE
 
+#define CNTL_CP_SHIFT		16
+#define CNTL_CP_MASK		(0xFF << CNTL_CP_SHIFT)
 #define CNTL_CSV_SHIFT		24
 #define CNTL_CSV_MASK		(0xFFU << CNTL_CSV_SHIFT)
 
@@ -35,6 +37,8 @@
 #define EVENT_CYCLES_COUNTER	0
 #define NUM_COUNTERS		4
 
+/* For removing bias if cycle counter CNTL.CP is set to 0xf0 */
+#define CYCLES_COUNTER_MASK	0x0FFFFFFF
 #define AXI_MASKING_REVERT	0xffff0000	/* AXI_MASKING(MSB 16bits) + AXI_ID(LSB 16bits) */
 
 #define to_ddr_pmu(p)		container_of(p, struct ddr_pmu, pmu)
@@ -429,6 +433,17 @@ static void ddr_perf_counter_enable(struct ddr_pmu *pmu, int config,
 		writel(0, pmu->base + reg);
 		val = CNTL_EN | CNTL_CLEAR;
 		val |= FIELD_PREP(CNTL_CSV_MASK, config);
+
+		/*
+		 * On i.MX8MP we need to bias the cycle counter to overflow more often.
+		 * We do this by initializing bits [23:16] of the counter value via the
+		 * COUNTER_CTRL Counter Parameter (CP) field.
+		 */
+		if (pmu->devtype_data->quirks & DDR_CAP_AXI_ID_FILTER_ENHANCED) {
+			if (counter == EVENT_CYCLES_COUNTER)
+				val |= FIELD_PREP(CNTL_CP_MASK, 0xf0);
+		}
+
 		writel(val, pmu->base + reg);
 	} else {
 		/* Disable counter */
@@ -468,6 +483,12 @@ static void ddr_perf_event_update(struct perf_event *event)
 	int ret;
 
 	new_raw_count = ddr_perf_read_counter(pmu, counter);
+	/* Remove the bias applied in ddr_perf_counter_enable(). */
+	if (pmu->devtype_data->quirks & DDR_CAP_AXI_ID_FILTER_ENHANCED) {
+		if (counter == EVENT_CYCLES_COUNTER)
+			new_raw_count &= CYCLES_COUNTER_MASK;
+	}
+
 	local64_add(new_raw_count, &event->count);
 
 	/*
-- 
2.40.1



