Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4737D146D49;
	Thu, 11 Apr 2024 10:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831296; cv=none; b=eds8KMJuNLwFB8yxRZjikD3Iy7kbGBsmUsXla0tR800ORfFxQfEUWRK68/AM0hzrJlfPRh/f2Iz1FO5+/gQvKAtbHcmn2aU/fWKNDpPAna5u2FUu3IJsi725vFdVbw4BHVadPXvsyRTPLwj02fGT3/mZSbebCz8+FpAnaggc8QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831296; c=relaxed/simple;
	bh=a1ls2DbMjblVprY2ZqLvVlgjyNrxEju/XEkGJnD1F4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1nrX9kwJt8ebzpYZ1agNY26cMQVs76G32Ce5LGrl+oUheqw19+LsecFSyQKrK7FUDPKIb5cvZ9FA+EOPcEsF51aTMKFBcGzrVLCxwd+4F/eLzVd0iE0eXsHFIHMVUiEs5671bMCXZK+qF97bSEE1IVpdzRanBqsuFEWM/tcx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sgeoiK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sgeoiK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B726C433F1;
	Thu, 11 Apr 2024 10:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831295;
	bh=a1ls2DbMjblVprY2ZqLvVlgjyNrxEju/XEkGJnD1F4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sgeoiK3vw3zEpUzIwG9m81q+skZ3T2V83RfVErwqUdSiWmlPdKQnrsTeMDSrUmoL
	 qdLr1sV3c5o+B/eQ2AJnsuTQQ2LUsRWS/2yelnsMcO5XzZICqas0Q3vq35160DjDBn
	 zuuAzja328hJhsEBGBTr7ASRYK096x2JbxdcOF9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/114] drivers/perf: hisi: Enable HiSilicon Erratum 162700402 quirk for HIP09
Date: Thu, 11 Apr 2024 11:56:42 +0200
Message-ID: <20240411095419.151544551@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit e10b6976f6b9afdf3564f88c851e42d139bb19c0 ]

HiSilicon UC PMU v2 suffers the erratum 162700402 that the PMU counter
cannot be set due to the lack of clock under power saving mode. This will
lead to error or inaccurate counts. The clock can be enabled by the PMU
global enabling control.

This patch tries to fix this by set the UC PMU enable before set event
period to turn on the clock, and then restore the UC PMU configuration.
The counter register can hold its value without a clock.

Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240227125231.53127-1-hejunhao3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_uncore_uc_pmu.c | 42 ++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c b/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c
index 636fb79647c8c..481dcc9e8fbf8 100644
--- a/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c
@@ -287,12 +287,52 @@ static u64 hisi_uc_pmu_read_counter(struct hisi_pmu *uc_pmu,
 	return readq(uc_pmu->base + HISI_UC_CNTR_REGn(hwc->idx));
 }
 
-static void hisi_uc_pmu_write_counter(struct hisi_pmu *uc_pmu,
+static bool hisi_uc_pmu_get_glb_en_state(struct hisi_pmu *uc_pmu)
+{
+	u32 val;
+
+	val = readl(uc_pmu->base + HISI_UC_EVENT_CTRL_REG);
+	return !!FIELD_GET(HISI_UC_EVENT_GLB_EN, val);
+}
+
+static void hisi_uc_pmu_write_counter_normal(struct hisi_pmu *uc_pmu,
 				      struct hw_perf_event *hwc, u64 val)
 {
 	writeq(val, uc_pmu->base + HISI_UC_CNTR_REGn(hwc->idx));
 }
 
+static void hisi_uc_pmu_write_counter_quirk_v2(struct hisi_pmu *uc_pmu,
+				      struct hw_perf_event *hwc, u64 val)
+{
+	hisi_uc_pmu_start_counters(uc_pmu);
+	hisi_uc_pmu_write_counter_normal(uc_pmu, hwc, val);
+	hisi_uc_pmu_stop_counters(uc_pmu);
+}
+
+static void hisi_uc_pmu_write_counter(struct hisi_pmu *uc_pmu,
+				      struct hw_perf_event *hwc, u64 val)
+{
+	bool enable = hisi_uc_pmu_get_glb_en_state(uc_pmu);
+	bool erratum = uc_pmu->identifier == HISI_PMU_V2;
+
+	/*
+	 * HiSilicon UC PMU v2 suffers the erratum 162700402 that the
+	 * PMU counter cannot be set due to the lack of clock under power
+	 * saving mode. This will lead to error or inaccurate counts.
+	 * The clock can be enabled by the PMU global enabling control.
+	 * The irq handler and pmu_start() will call the function to set
+	 * period. If the function under irq context, the PMU has been
+	 * enabled therefore we set counter directly. Other situations
+	 * the PMU is disabled, we need to enable it to turn on the
+	 * counter clock to set period, and then restore PMU enable
+	 * status, the counter can hold its value without a clock.
+	 */
+	if (enable || !erratum)
+		hisi_uc_pmu_write_counter_normal(uc_pmu, hwc, val);
+	else
+		hisi_uc_pmu_write_counter_quirk_v2(uc_pmu, hwc, val);
+}
+
 static void hisi_uc_pmu_enable_counter_int(struct hisi_pmu *uc_pmu,
 					   struct hw_perf_event *hwc)
 {
-- 
2.43.0



