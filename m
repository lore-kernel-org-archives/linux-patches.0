Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39691BD00C;
	Thu,  6 Jun 2024 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683511; cv=none; b=S4fWv/i3Pd8Pvokx1RCWyvm2DQKzgF+qTFer8I1aKkDj1LTYOG/wbvhHwD9MIxSyUjwgm4QTMNwK1ztDvPRVBx5X/qVSujlNvYhIrd43DptRRprRxeQKPIpod1JVeyNvXr2cw78vQRi1qIj/gOshPeftmWEmNA7y8h8bV3NEkC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683511; c=relaxed/simple;
	bh=catPX/1wBH0LUZ1Hx3Y4rnndTDb+QD7uUDS8kJhPFFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgCS1PKiHbtKrXfD3S7IwYJypLsWOXocFbtNPbmTm9Ks16LIT5arfZVzxZfFULS/FDgK6ZtNCWOxhaSpHPT/JOg0SwI7m2oYGNDxsm4Ag2d7m8IUKucvG903cWCLEk8M+sQxSNMq830Vp25D2omQbvcDdyrToSxMbOpZFOKsciE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJPLlEGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJPLlEGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE1FC2BD10;
	Thu,  6 Jun 2024 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683511;
	bh=catPX/1wBH0LUZ1Hx3Y4rnndTDb+QD7uUDS8kJhPFFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJPLlEGtKC0Gh82RzcD/ctj3/ccdggNhJVrpHiAhSJ8NKDhhnQDo9MenyAskoC1E1
	 eYww1tH6czHn5uJxonr8c8i+yeqiA+5zodNmKhDcEAPJ4zc+aC0qUrE0FHA4wIVquJ
	 VNWIg56GeAqxt9gQ9ZGZ3tN0sep67uz9KXfggDuU=
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
Subject: [PATCH 6.1 400/473] perf/arm-dmc620: Fix lockdep assert in ->event_init()
Date: Thu,  6 Jun 2024 16:05:29 +0200
Message-ID: <20240606131713.050958392@linuxfoundation.org>
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
index 54aa4658fb36e..535734dad2eb8 100644
--- a/drivers/perf/arm_dmc620_pmu.c
+++ b/drivers/perf/arm_dmc620_pmu.c
@@ -513,12 +513,16 @@ static int dmc620_pmu_event_init(struct perf_event *event)
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
@@ -527,7 +531,6 @@ static int dmc620_pmu_event_init(struct perf_event *event)
 			return -EINVAL;
 	}
 
-	hwc->idx = -1;
 	return 0;
 }
 
-- 
2.43.0



