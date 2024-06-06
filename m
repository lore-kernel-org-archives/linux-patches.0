Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28503199EBD;
	Thu,  6 Jun 2024 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683262; cv=none; b=dvJXL+47GsQLFuIg9jgk6IQ1aMDKBZf/TNbbMEwNplxBLN+LEgRfvJ/Rw0p0m8s2KcHM2ryDPDIlyVvjdragMfoSZgN6lRcuBxTQ4pF77Hj4NTglZ94PAss/q9+9+dcd0AmwDUgEDApVtb8k5t214DlVcI+tkSkGuM/EjKpFJ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683262; c=relaxed/simple;
	bh=pZ5phVodJbPATCOpDyB2XWEbxW2q9BL9hW5H0D4nP5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xjzb8IF04HtBU+tdNl89ABYefDdQwRR2efhEPhR1Vi3VBwNJUwgJK1btOpt1O3Wyu+lJ3OUpmNhYQLHtL5IwiOyxmHBfJ1FIlNI71/ph2YOk6wLPhsD3akAjJxzLKjD7wJD0E/ma96egIaH/jneVnHps4dscG3UV3P4FdOOZYT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7fRoIa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7fRoIa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F342DC32781;
	Thu,  6 Jun 2024 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683262;
	bh=pZ5phVodJbPATCOpDyB2XWEbxW2q9BL9hW5H0D4nP5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7fRoIa16ztovJUOPqiknxTCMRED8FzmuAE1ssUzTk5RDurMQoWZGnsCBsEfeCtSP
	 /kLAwreJMypqpPcWolzh0WFRoQbEO8ELu2jteJYU4SknkVpw0m7xW+I2DV90D18qcg
	 86XgXc9mxAEaIeuNO7XjAtTmZR1N2SsnJtjVuDYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 205/744] drivers/perf: hisi_pcie: Fix out-of-bound access when valid event group
Date: Thu,  6 Jun 2024 15:57:57 +0200
Message-ID: <20240606131738.983669759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 051efffc44c82..430ca15373fe2 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -337,15 +337,27 @@ static bool hisi_pcie_pmu_validate_event_group(struct perf_event *event)
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



