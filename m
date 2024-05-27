Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A30E17E90E;
	Mon, 27 May 2024 19:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836845; cv=none; b=QIQld/5qA/MziFzd1N1IjoRqBjjpUEZcn8zJdNqVI3GKI+UoLerIfh3tZuBF5XKFV/0CWecovtJhqYrMR4O5CwoV/4h2g0rrvHsqhwfMR4xtWj8rTuQgAzHk3CjKEH1/RQP/Tqtf13GIAlgh1YtUmXr2038786sGShndiHxpAq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836845; c=relaxed/simple;
	bh=2ILGVIO+xylAKl33c/n2QWJ9xkOTpID0q9Qz6pDfgz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCCLfgVIRvkGAueNNTvZsgCakv6mA01g/8yHHdlITl6niNJ16s+2l3x5D6fyklUm6+WgNHpH8caXSV13HTs/7CDfqe+l1e3TqQ5BL+dvzv0Z9Rb8EQbf2t3HvaDROyo8P/GsGzUDtGe1CuTDkU9y4nyKJQwv2m+ijSPYhszMr/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvRFvxZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvRFvxZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51E3C2BBFC;
	Mon, 27 May 2024 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836845;
	bh=2ILGVIO+xylAKl33c/n2QWJ9xkOTpID0q9Qz6pDfgz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvRFvxZLXzjPPLWLTTP0T6xWOAiDSYIPUr5tZSpSlbFBOM2omQbSxwvrawSWt1XOP
	 maEdahN606jnP2KME0fvm0IwkfdUHG5IsWjjp0sVzLdwHHvRymi9KqlEfcKIRkyS9G
	 lVxApct8HhssHw37UprQQjxCDlOfm8eIlL/FUZ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 183/427] drivers/perf: hisi_pcie: Fix out-of-bound access when valid event group
Date: Mon, 27 May 2024 20:53:50 +0200
Message-ID: <20240527185619.315632792@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5d1f0e9fdb08d..dba3991256586 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -350,15 +350,27 @@ static bool hisi_pcie_pmu_validate_event_group(struct perf_event *event)
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



