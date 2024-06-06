Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2770E196DA6;
	Thu,  6 Jun 2024 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683288; cv=none; b=rD23EZ6VO0AQG4liF8cB/uesfM1avS2ei3tDR8ARJW6B9IqpWJMNOOYuxaoE0nqFQR0YqMlPJry8PHg0kd99oxAtPNfv6PxS5VDo2aWOr9qekFjfmmkzBl8QCSDKC0LiWGWLUJH2rcDeA4rCVe9mYuyD73mfyn9SdAFx60jD9i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683288; c=relaxed/simple;
	bh=XuqGG3jZoC2q+VwpCmyASdcR8Poq5oGqUISe23/OGHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw7oDFMK2YsucR9Eqw+2KgYMumKEKaqkWbsnY46y5PnP4RAK28FIvRqG1NBpu1HP6i8LoOeR0iiCi52fUleE/Taq7x/QYtiHOUc1OYzlS0b+j2jF1FKS9jDMqclsMSyavDQPdNTTx9PnyedEUcquorYXiQ+Iu5xVel7zIGzmJgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxS9wax+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxS9wax+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF766C2BD10;
	Thu,  6 Jun 2024 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683288;
	bh=XuqGG3jZoC2q+VwpCmyASdcR8Poq5oGqUISe23/OGHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxS9wax+wQUgree4T2B7Gy8pJ1zDKlWeSE0fXbsM/IDtugAjqdPU8ZX4zSXAv6/fq
	 DUy/gro7n5Nzna3mtYfio2g0QWdy9e44mKWyWesTY3lLPc8gSk09YVHap36Hu5AORL
	 CcewVBbgWx4Hh3PCosTeNBvQ7LwncSvgi40J3YoQ=
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
Subject: [PATCH 6.1 142/473] drivers/perf: hisi: hns3: Fix out-of-bound access when valid event group
Date: Thu,  6 Jun 2024 16:01:11 +0200
Message-ID: <20240606131704.635559997@linuxfoundation.org>
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



