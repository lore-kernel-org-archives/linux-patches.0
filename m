Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF6E262BE;
	Mon, 27 May 2024 19:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838058; cv=none; b=ScsC65C3xmmcJzM6MHYk0GULKV0aulCK81Pl/DkjJv3iojISG3YS3rgPaNCIFvYUcqMxUp6Th4xArMtRv5viV/n8I8zrpxV+WJGaRRCHAL0o5tUmQ60ovidXDm4DSBEC8h8tVUX87NgMwc3kdxOHLpv10kv+mW7wNCzmaQZ6XZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838058; c=relaxed/simple;
	bh=wZMfHncxWMPKSKWwiTBOjovTMtvVOFg6sglVNU9pGJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsvY8rmYMFm/jMB0DytSJG/b8aP+qjZdUECMXQN/nnmghyyDen4Z00t8u4LGDMxTsOQ18PlttJ1PwyHTrriEreSV/u3v52icO1ivp/HUy/I/BPPs78KEjgWOYYqFha4hps6UkyKo0I/TlMM+8j5M2MBDtnGfZacvd0ErGfxf9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqK90Vs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqK90Vs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F444C32781;
	Mon, 27 May 2024 19:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838058;
	bh=wZMfHncxWMPKSKWwiTBOjovTMtvVOFg6sglVNU9pGJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqK90Vs7lZJ0kuDcBEcMSYOPbYQHJneZCqbyUkmNmfO+9KYreCfmJ/kapg8NxWGc2
	 0MiTRlYntdHzVNKmf/RIFpZXIV/6FnkmA3617Fm9OHjfnAIYiLnygvS9HomQzTE376
	 QFKCaVf18r/bvWzaZ4DRf4XKZ/WayamccLZayE+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Hao Chen <chenhao418@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 249/493] drivers/perf: hisi: hns3: Fix out-of-bound access when valid event group
Date: Mon, 27 May 2024 20:54:11 +0200
Message-ID: <20240527185638.447449499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 81bdd60a3d1d3b05e6cc6674845afb1694dd3a0e ]

The perf tool allows users to create event groups through following
cmd [1], but the driver does not check whether the array index is out
of bounds when writing data to the event_group array. If the number of
events in an event_group is greater than HNS3_PMU_MAX_HW_EVENTS, the
memory write overflow of event_group array occurs.

Add array index check to fix the possible array out of bounds violation,
and return directly when write new events are written to array bounds.

There are 9 different events in an event_group.
[1] perf stat -e '{pmu/event1/, ... ,pmu/event9/}

Fixes: 66637ab137b4 ("drivers/perf: hisi: add driver for HNS3 PMU")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Signed-off-by: Hao Chen <chenhao418@huawei.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Link: https://lore.kernel.org/r/20240425124627.13764-3-hejunhao3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hns3_pmu.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hns3_pmu.c b/drivers/perf/hisilicon/hns3_pmu.c
index 16869bf5bf4cc..cbdd53b0a0342 100644
--- a/drivers/perf/hisilicon/hns3_pmu.c
+++ b/drivers/perf/hisilicon/hns3_pmu.c
@@ -1085,15 +1085,27 @@ static bool hns3_pmu_validate_event_group(struct perf_event *event)
 			return false;
 
 		for (num = 0; num < counters; num++) {
+			/*
+			 * If we find a related event, then it's a valid group
+			 * since we don't need to allocate a new counter for it.
+			 */
 			if (hns3_pmu_cmp_event(event_group[num], sibling))
 				break;
 		}
 
+		/*
+		 * Otherwise it's a new event but if there's no available counter,
+		 * fail the check since we cannot schedule all the events in
+		 * the group simultaneously.
+		 */
+		if (num == HNS3_PMU_MAX_HW_EVENTS)
+			return false;
+
 		if (num == counters)
 			event_group[counters++] = sibling;
 	}
 
-	return counters <= HNS3_PMU_MAX_HW_EVENTS;
+	return true;
 }
 
 static u32 hns3_pmu_get_filter_condition(struct perf_event *event)
-- 
2.43.0



