Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93237145B3F;
	Mon, 13 Oct 2025 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368592; cv=none; b=Vol0APTvsb07T/M/Q07X5bQJKegMvFp50Y2QzEgKcjYjuS12PQ0W3nJderkPMBlyAcnrsCrKHCFR27+l3xRFt4GIOTCo+S4ffvqvaPvF7bV/wSdKr/wVghbfHcWh/8KousqYu9mhHgCmlvc96n/Pp6FFlLAzzBX2UXiRYk3SFJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368592; c=relaxed/simple;
	bh=8mY0m1COMRcM5rlttZcRogbjor360Cd7VEdngYFk0AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwc8hvXa3Y7zDRX0J4qL9aMZ9K+yRYyAnSBIiVzT4H5vBkFRDzpDLKO67tuzCObMn9bwYs1HfUb5f4P9Eh90eq34s2EPTmn+no+f4Cte2pzE/RIc+yInH5x+EGZFNUKR7wZUoDxYtSpzAM0RV5CUt9PmCTgksysHbvEKQsHaOs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUkLi5Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUkLi5Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F505C113D0;
	Mon, 13 Oct 2025 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368592;
	bh=8mY0m1COMRcM5rlttZcRogbjor360Cd7VEdngYFk0AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUkLi5Q9JobtkdYJChElbrTI+rFQRW159rDKyBtKtvRmBCENUn1xHAWFZLtvxe5dq
	 xsretano37H5zeFP6fdCURczE4KXXXUi2UwNbsTBHFicpVXqTK6tIigGyhmlTeX9du
	 6e1KpJzNM9yFxwPEmI7BAkhvjXGbugMdXf5BwZzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>,
	James Clark <james.clark@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/262] coresight-etm4x: Conditionally access register TRCEXTINSELR
Date: Mon, 13 Oct 2025 16:45:24 +0200
Message-ID: <20251013144332.683560067@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>

[ Upstream commit dcdc42f5dcf9b9197c51246c62966e2d54a033d8 ]

The TRCEXTINSELR is only implemented if TRCIDR5.NUMEXTINSEL > 0.
To avoid invalid accesses, introduce a check on numextinsel
(derived from TRCIDR5[11:9]) before reading or writing to this register.

Fixes: f5bd523690d2 ("coresight: etm4x: Convert all register accesses")
Signed-off-by: Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250812-trcextinselr_issue-v2-1-e6eb121dfcf4@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 11 ++++++++---
 drivers/hwtracing/coresight/coresight-etm4x.h      |  2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index be8b46f26ddc8..cdfd35e03c1dc 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -481,7 +481,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, config->seq_rst, TRCSEQRSTEVR);
 		etm4x_relaxed_write32(csa, config->seq_state, TRCSEQSTR);
 	}
-	etm4x_relaxed_write32(csa, config->ext_inp, TRCEXTINSELR);
+	if (drvdata->numextinsel)
+		etm4x_relaxed_write32(csa, config->ext_inp, TRCEXTINSELR);
 	for (i = 0; i < drvdata->nr_cntr; i++) {
 		etm4x_relaxed_write32(csa, config->cntrldvr[i], TRCCNTRLDVRn(i));
 		etm4x_relaxed_write32(csa, config->cntr_ctrl[i], TRCCNTCTLRn(i));
@@ -1362,6 +1363,7 @@ static void etm4_init_arch_data(void *info)
 	etmidr5 = etm4x_relaxed_read32(csa, TRCIDR5);
 	/* NUMEXTIN, bits[8:0] number of external inputs implemented */
 	drvdata->nr_ext_inp = FIELD_GET(TRCIDR5_NUMEXTIN_MASK, etmidr5);
+	drvdata->numextinsel = FIELD_GET(TRCIDR5_NUMEXTINSEL_MASK, etmidr5);
 	/* TRACEIDSIZE, bits[21:16] indicates the trace ID width */
 	drvdata->trcid_size = FIELD_GET(TRCIDR5_TRACEIDSIZE_MASK, etmidr5);
 	/* ATBTRIG, bit[22] implementation can support ATB triggers? */
@@ -1789,7 +1791,9 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trcseqrstevr = etm4x_read32(csa, TRCSEQRSTEVR);
 		state->trcseqstr = etm4x_read32(csa, TRCSEQSTR);
 	}
-	state->trcextinselr = etm4x_read32(csa, TRCEXTINSELR);
+
+	if (drvdata->numextinsel)
+		state->trcextinselr = etm4x_read32(csa, TRCEXTINSELR);
 
 	for (i = 0; i < drvdata->nr_cntr; i++) {
 		state->trccntrldvr[i] = etm4x_read32(csa, TRCCNTRLDVRn(i));
@@ -1921,7 +1925,8 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, state->trcseqrstevr, TRCSEQRSTEVR);
 		etm4x_relaxed_write32(csa, state->trcseqstr, TRCSEQSTR);
 	}
-	etm4x_relaxed_write32(csa, state->trcextinselr, TRCEXTINSELR);
+	if (drvdata->numextinsel)
+		etm4x_relaxed_write32(csa, state->trcextinselr, TRCEXTINSELR);
 
 	for (i = 0; i < drvdata->nr_cntr; i++) {
 		etm4x_relaxed_write32(csa, state->trccntrldvr[i], TRCCNTRLDVRn(i));
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 9e9165f62e81f..899790c8777a9 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -162,6 +162,7 @@
 #define TRCIDR4_NUMVMIDC_MASK			GENMASK(31, 28)
 
 #define TRCIDR5_NUMEXTIN_MASK			GENMASK(8, 0)
+#define TRCIDR5_NUMEXTINSEL_MASK               GENMASK(11, 9)
 #define TRCIDR5_TRACEIDSIZE_MASK		GENMASK(21, 16)
 #define TRCIDR5_ATBTRIG				BIT(22)
 #define TRCIDR5_LPOVERRIDE			BIT(23)
@@ -998,6 +999,7 @@ struct etmv4_drvdata {
 	u8				nr_cntr;
 	u8				nr_ext_inp;
 	u8				numcidc;
+	u8				numextinsel;
 	u8				numvmidc;
 	u8				nrseqstate;
 	u8				nr_event;
-- 
2.51.0



