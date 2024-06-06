Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17C4198831;
	Thu,  6 Jun 2024 14:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683039; cv=none; b=BhHlLuzEIJeAsKwe/0yKTtOSWsORbSfTFZUZ7oA42SpLwNlCjEM8m1y57a2aO9zQqHyUEzsyOhQSh2+9VLXfRP+Qes5AgzlhwAWR4AU2MCgQRPQVo74EEneCbu2RdOSG/K0vVJjKrhnx7sh918vUz7YhKFg5PgtHK1OiWo17AwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683039; c=relaxed/simple;
	bh=NVi1TYPDHju4evz+ts1//jW0cIPnU3XcWSlm/9zBBGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ccf6+5sCA9MNrBAPm7h2BQwZKaF+Ms7Ri9pmsiNgBa7fKlOnBGuWRmFHwPDrsDYl3i4Jeee+nZtPwicyMXWBxfG1ISe3fA2XTuOtEa5KP6D2iX5j6I0LfrVZcmoSVE8EnRGwzReTFAc6hrVkijXMxWh8IVyih2gEi9ca6Ce62eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhC/YHYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhC/YHYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FC9C4DDE9;
	Thu,  6 Jun 2024 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683039;
	bh=NVi1TYPDHju4evz+ts1//jW0cIPnU3XcWSlm/9zBBGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhC/YHYXRH0zR1PqC16ihIvKCQ2bKaF4RpfZd8ntarmKi0F5euqYBsOQNkR5B25iL
	 UvmgQ2Gg9gatta1vDRJEmi29BFsDCmou7VKbu8qYS2RBvpK7HQWq+FLbfY/oKhj41v
	 U2lHpGb4jQkTk5iXh4mxvB8kZ5asRzhrZwYyLq1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Greg Thelen <gthelen@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tuan Phan <tuanphan@os.amperecomputing.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 230/374] perf/arm-dmc620: Fix lockdep assert in ->event_init()
Date: Thu,  6 Jun 2024 16:03:29 +0200
Message-ID: <20240606131659.515826607@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit a4c5a457c6107dfe9dc65a104af1634811396bac ]

for_each_sibling_event() checks leader's ctx but it doesn't have the ctx
yet if it's the leader.  Like in perf_event_validate_size(), we should
skip checking siblings in that case.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Fixes: f3c0eba28704 ("perf: Add a few assertions")
Reported-by: Greg Thelen <gthelen@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Tuan Phan <tuanphan@os.amperecomputing.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20240514180050.182454-1-namhyung@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_dmc620_pmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/arm_dmc620_pmu.c b/drivers/perf/arm_dmc620_pmu.c
index 8a81be2dd5ecf..88c17c1d6d499 100644
--- a/drivers/perf/arm_dmc620_pmu.c
+++ b/drivers/perf/arm_dmc620_pmu.c
@@ -542,12 +542,16 @@ static int dmc620_pmu_event_init(struct perf_event *event)
 	if (event->cpu < 0)
 		return -EINVAL;
 
+	hwc->idx = -1;
+
+	if (event->group_leader == event)
+		return 0;
+
 	/*
 	 * We can't atomically disable all HW counters so only one event allowed,
 	 * although software events are acceptable.
 	 */
-	if (event->group_leader != event &&
-			!is_software_event(event->group_leader))
+	if (!is_software_event(event->group_leader))
 		return -EINVAL;
 
 	for_each_sibling_event(sibling, event->group_leader) {
@@ -556,7 +560,6 @@ static int dmc620_pmu_event_init(struct perf_event *event)
 			return -EINVAL;
 	}
 
-	hwc->idx = -1;
 	return 0;
 }
 
-- 
2.43.0



