Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3AD1D0E2A;
	Wed,  2 Oct 2024 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879264; cv=none; b=qUGzKl9MUL4JKunFk/l0mt0uXvnpCgMH3j/WWiq74N7ykI5tvlrP/T+/377GRUFtKXUo0BV+1P7Hil85yxwnq92ScvNsWzww6l85uLOtbEiCrFltt9jNgeZWGs/wYrfDhm7ob/yI+3OOoo5ve7PUs+1ich4UVDqe94WUm/u/umg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879264; c=relaxed/simple;
	bh=B5ulwsaN6vGJZXVuEfeCIbyGLjIiKTLQfJLcrmdaY3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkVQdlCjoktle7xkygKcEGzXRSscabMmOPh7YajhZcnA6nZ0BSAVunAMYx3vyeoMWCU+n5iFwy41aCRNqK/ayMW30opUVw9nYhcqrTTQMCSPwIdSgWoER2Ex26l51cE4SqAfKit7cjuwesgNpddTzejcZiKyQu5Ziy2gXpt2NnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTD/gQFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTD/gQFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1D8C4CEC2;
	Wed,  2 Oct 2024 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879264;
	bh=B5ulwsaN6vGJZXVuEfeCIbyGLjIiKTLQfJLcrmdaY3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTD/gQFFs2E1fYr+1giGPVA5XlXaruTXgezQYkLzjR2e/Lc2gIaM/B6iRvIs87SFn
	 ayoSpCFYJeGcBh05xnE8WhJOkuvyEqd57z/5/TryDhGvF8CKfsTTcCQ8f7FjxKS25E
	 KClQ2yAG0FczLqHfNZF/vt9Y+4dGGLZ4WP3IhazM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/538] drivers/perf: hisi_pcie: Record hardware counts correctly
Date: Wed,  2 Oct 2024 14:54:27 +0200
Message-ID: <20241002125753.130319786@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 430ca15373fe2..570ae69c38ec0 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -458,10 +458,24 @@ static void hisi_pcie_pmu_set_period(struct perf_event *event)
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



