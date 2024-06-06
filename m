Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB201AB8FD;
	Thu,  6 Jun 2024 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683277; cv=none; b=lSGsq6OorrRMnS/X94lKUFEXsww0kKB93Tw2sUJWxP7wF3fFwemwXQ4WZ+4w90D3sCAKW5k+77NQkXcbdEFbED+TgTcy2PmWaJwsao4MAoiD7ivJL9Qyt3H43CYBYZR2+ER2qKJuURzZIttOnTT37rvDqE9c3NRsnoFyRxp+0Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683277; c=relaxed/simple;
	bh=+Y4WQcELjVylExv9/QTCFkpuybgJp5HLcjvwLYLPQUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOIa1iENIU3PogZGaPolvi8IdMXGK8/yZWNdUbdhrgtTYPduFR3U+SxCvkebAz8GaNfYGLiMZxQYG1H3CIffscKgRMjF/QZQffw3juuLpgs3Iro2AiiRQxqo+Hjfu99YeCCKZdDiGBvFCksUZ5kTQ/kCsASePiT+uDlFYihP5zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXGt2YCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXGt2YCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C892FC32781;
	Thu,  6 Jun 2024 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683276;
	bh=+Y4WQcELjVylExv9/QTCFkpuybgJp5HLcjvwLYLPQUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXGt2YCjiG5wr1eOMdnU2tO8E8+txTuSO7eZNg329jHEOuNfJKFiYoKxJ2FzntHot
	 M85yTwLpbEwvhQkmkmDQF55sH+lPsbyt+G3j7rRHq8m96OFwyc46xOFeoeJDh+bsBI
	 lnlYl2b2ttwV445hrFXTHVAGs/sEU+AofHgsx5kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/473] drivers/perf: hisi_pcie: Fix out-of-bound access when valid event group
Date: Thu,  6 Jun 2024 16:01:10 +0200
Message-ID: <20240606131704.602733269@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 77fce82678ea5fd51442e62febec2004f79e041b ]

The perf tool allows users to create event groups through following
cmd [1], but the driver does not check whether the array index is out of
bounds when writing data to the event_group array. If the number of events
in an event_group is greater than HISI_PCIE_MAX_COUNTERS, the memory write
overflow of event_group array occurs.

Add array index check to fix the possible array out of bounds violation,
and return directly when write new events are written to array bounds.

There are 9 different events in an event_group.
[1] perf stat -e '{pmu/event1/, ... ,pmu/event9/}'

Fixes: 8404b0fbc7fb ("drivers/perf: hisi: Add driver for HiSilicon PCIe PMU")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240425124627.13764-2-hejunhao3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_pcie_pmu.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
index c4c1cd269c577..49f2d69c119df 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -326,15 +326,27 @@ static bool hisi_pcie_pmu_validate_event_group(struct perf_event *event)
 			return false;
 
 		for (num = 0; num < counters; num++) {
+			/*
+			 * If we find a related event, then it's a valid group
+			 * since we don't need to allocate a new counter for it.
+			 */
 			if (hisi_pcie_pmu_cmp_event(event_group[num], sibling))
 				break;
 		}
 
+		/*
+		 * Otherwise it's a new event but if there's no available counter,
+		 * fail the check since we cannot schedule all the events in
+		 * the group simultaneously.
+		 */
+		if (num == HISI_PCIE_MAX_COUNTERS)
+			return false;
+
 		if (num == counters)
 			event_group[counters++] = sibling;
 	}
 
-	return counters <= HISI_PCIE_MAX_COUNTERS;
+	return true;
 }
 
 static int hisi_pcie_pmu_event_init(struct perf_event *event)
-- 
2.43.0



