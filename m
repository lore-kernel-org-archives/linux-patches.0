Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91B4286B6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXP4RZgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88629C433CA;
	Wed, 15 Nov 2023 19:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076383;
	bh=kl7xX2qxQTh+1EPOOJvPHriX2VxkujJgWNFXZzJtfYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXP4RZgzPCFeq72Hhhkv5wpedvHFkmuqUP8yqy5T9AztvjVTo3gAVfLxzrgVr3u0Y
	 L2ibu+6tHG6E15b9W3BQCBzxv6XredkbuTP4aYeo4UJ/cllOOonHa6CKqU9xb+t/mq
	 xwjnyRKmSfua79OZDlsSznVigFP8+wMCDrNKEKkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 258/550] drivers/perf: hisi_pcie: Check the type first in pmu::event_init()
Date: Wed, 15 Nov 2023 14:14:02 -0500
Message-ID: <20231115191618.587070101@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 6d7d51e88e21c0af1ca96a3617afef334bfeffcf ]

Check whether the event type matches the PMU type firstly in
pmu::event_init() before touching the event. Otherwise we'll
change the events of others and lead to incorrect results.
Since in perf_init_event() we may call every pmu's event_init()
in a certain case, we should not modify the event if it's not
ours.

Fixes: 8404b0fbc7fb ("drivers/perf: hisi: Add driver for HiSilicon PCIe PMU")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20231024092954.42297-2-yangyicong@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_pcie_pmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
index e10fc7cb9493a..dafff711185c8 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -353,6 +353,10 @@ static int hisi_pcie_pmu_event_init(struct perf_event *event)
 	struct hisi_pcie_pmu *pcie_pmu = to_pcie_pmu(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
 
+	/* Check the type first before going on, otherwise it's not our event */
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
 	event->cpu = pcie_pmu->on_cpu;
 
 	if (EXT_COUNTER_IS_USED(hisi_pcie_get_event(event)))
@@ -360,9 +364,6 @@ static int hisi_pcie_pmu_event_init(struct perf_event *event)
 	else
 		hwc->event_base = HISI_PCIE_CNT;
 
-	if (event->attr.type != event->pmu->type)
-		return -ENOENT;
-
 	/* Sampling is not supported. */
 	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
 		return -EOPNOTSUPP;
-- 
2.42.0



