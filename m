Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291151D0499;
	Wed,  2 Oct 2024 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877338; cv=none; b=DTPxAUfTykbLv4+/r+91CuehyzbnqBViANS8/5xwmdXxIGVomm1BJpA0ZnHdSm4jbRz6r4r9vu7gaNwcPjPkJ0yGm+VStZeRL0F/lWZMmaUIsuky5Nfv6ZqPJxbKj9IqMjcC+nTWh0vLFWPl8m86abl2TfN7wVUWFP85ArpbToU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877338; c=relaxed/simple;
	bh=x+gw3RI7F2qKKldKvk379hZln1NC9obaKcOpxCkTpPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWHHilNh4LHjoW5fDbu7qDPKdZPR22YSGy5HWaNA0iezmQ3OxhQl4FDiwmizfvFpzTqC34vbDpge8XYzda0e8TNz2Uwam3CSd9/CZb6RrDYPsWgLX/AkQe/XqHaL6MwpS8XNSHqnmqD7pZllDyIsZ764aGJZrOneVz4Ys5kj/64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJkysZbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJkysZbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D4FC4CECE;
	Wed,  2 Oct 2024 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877338;
	bh=x+gw3RI7F2qKKldKvk379hZln1NC9obaKcOpxCkTpPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJkysZbVVjX4USdArc9u/7aY9ijHnEvEMt1hcjF7n4Zmpq1s9gXyet9VOcXxrzN0q
	 IdjC6t3RGm4jCeMqlfAp640X+zbn36vmSpewq2NiPKdwhE3PPxzDmAGkJkaeyhzkqr
	 Mlzcy3EZEeRLLwOBh7+gLlJCJgmQ7bLa8LFSdnfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 048/634] drivers/perf: hisi_pcie: Record hardware counts correctly
Date: Wed,  2 Oct 2024 14:52:28 +0200
Message-ID: <20241002125813.000012873@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit daecd3373a16a039ad241086e30a1ec46fc9d61f ]

Currently we set the period and record it as the initial value of the
counter without checking it's set to the hardware successfully or not.
However the counter maybe unwritable if the target event is unsupported
by the device. In such case we will pass user a wrong count:

[start counts when setting the period]
hwc->prev_count = 0x8000000000000000
device.counter_value = 0 // the counter is not set as the period
[when user reads the counter]
event->count = device.counter_value - hwc->prev_count
             = 0x8000000000000000 // wrong. should be 0.

Fix this by record the hardware counter counts correctly when setting
the period.

Fixes: 8404b0fbc7fb ("drivers/perf: hisi: Add driver for HiSilicon PCIe PMU")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240829090332.28756-2-yangyicong@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_pcie_pmu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
index f06027574a241..fba569a8640cf 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -452,10 +452,24 @@ static void hisi_pcie_pmu_set_period(struct perf_event *event)
 	struct hisi_pcie_pmu *pcie_pmu = to_pcie_pmu(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
+	u64 orig_cnt, cnt;
+
+	orig_cnt = hisi_pcie_pmu_read_counter(event);
 
 	local64_set(&hwc->prev_count, HISI_PCIE_INIT_VAL);
 	hisi_pcie_pmu_writeq(pcie_pmu, HISI_PCIE_CNT, idx, HISI_PCIE_INIT_VAL);
 	hisi_pcie_pmu_writeq(pcie_pmu, HISI_PCIE_EXT_CNT, idx, HISI_PCIE_INIT_VAL);
+
+	/*
+	 * The counter maybe unwritable if the target event is unsupported.
+	 * Check this by comparing the counts after setting the period. If
+	 * the counts stay unchanged after setting the period then update
+	 * the hwc->prev_count correctly. Otherwise the final counts user
+	 * get maybe totally wrong.
+	 */
+	cnt = hisi_pcie_pmu_read_counter(event);
+	if (orig_cnt == cnt)
+		local64_set(&hwc->prev_count, cnt);
 }
 
 static void hisi_pcie_pmu_enable_counter(struct hisi_pcie_pmu *pcie_pmu, struct hw_perf_event *hwc)
-- 
2.43.0



