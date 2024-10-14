Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17A019E802;
	Mon, 14 Oct 2024 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917504; cv=none; b=FpFHgOSrZAjNY7iIjg55ASwAAZS7dsFvNQsAGHfwx0ddKIIp6ZTuRP/Kdr5GOB1U76h2OxZ4nP1c1Arl+73ah+XY4ut58HopBphtY2bT1gtwQ257IHKPCNyBn+G1f3mSiyq2/emh4EpJlSzk+jfAS0TdoiiSyFnkEmXd/OblIA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917504; c=relaxed/simple;
	bh=XPBRoCHl5m4EdMiq/t+MY0TiL8nGySPa22rDzBon/ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFDlsjSbo57R4aW2w9Nd6GfSQsya+fMyisyEKFavn/LVhsS0ZZk3D6QkQm2oOtRA/A4MyqD4ta90GUOMlJMeJI1nf/vWlXXa/IskRiWrsN/TsU2hJcVV4li1Tf3WGpZeT8GZQF9qyoZ7QJQbA5tIaJ07+zHOcSJ0ydUMHdh6c+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUI2t4Qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUI2t4Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20D3C4CECF;
	Mon, 14 Oct 2024 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917504;
	bh=XPBRoCHl5m4EdMiq/t+MY0TiL8nGySPa22rDzBon/ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUI2t4QxY5ZzqrpXJXUaPplyDk/dgf8heKC7GQlWXRAe73Iv6zurz3NM8PAWINJK4
	 7s+4rPzkPGPvQhv/J8Lu6+7C1RITGcTu9RH2ma1KwOOndYpN4DxkqJ213tKCkakd9K
	 SmhVwOd66SJU87jwPWuldTG3UemjBXY4vl+Gr2Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/798] drivers/perf: hisi_pcie: Record hardware counts correctly
Date: Mon, 14 Oct 2024 16:09:37 +0200
Message-ID: <20241014141218.860251432@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 49f2d69c119df..8a2106f1626e1 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -447,10 +447,24 @@ static void hisi_pcie_pmu_set_period(struct perf_event *event)
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



