Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D2D384CE2;
	Sat, 12 Sep 2026 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206378; cv=none; b=UtAHCcADhgGDeVX6FkdP6KSVRdSywYe4rpYOyY4lyY2X2CEZNmLFfg00R0CSET+qNU9G8jf7GDJ/6YAmtNg16xWrT+ycduseQIkWBmM4yp8lyN0N4aw5VtftD0JIIan2aV7KvZWW/dIJEYekRpObwslPYKKuCQq5YLRvmf33/AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206378; c=relaxed/simple;
	bh=cP8xQq3VJpH/k5ee6DI/THirrskC90FftenpYzFeB9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr24phyPCQCKTmCmH/zDxqT0mryplWLdVQc2fneM7EjXqTQ9bZWvKwTZ+cDcl0cCqHatlLfDqVGNsNZMqvyPBsGldzJJY8bNAVnXnPwXZxIPF+2A643Eg+PtcWq6+BzK4KC76iqGypqcbpl9cZBOOBhIclg2w4CGahE1BhxZVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9cAPeOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9cAPeOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D078B1F000FF;
	Sat, 12 Sep 2026 09:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206376;
	bh=lA5az9ju4IPe4ME1d46X82O1YqVhmTLle6/FjdcMtPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9cAPeOwz7xPL5+HdBAtdwljuq1WM0bJZfGSgv9HOJxOr8U8qYCR1QEARXtUgd8qr
	 yrxmElKX4cDuNg95Dx4LIY1gmBZ5mgO6LRQaIsjVkqYDsy5xv2BX8k6Q9Ec2Qdo7sk
	 yPmazP0CmZ9WRQclFFC4zpwIhPINk8Wfr/ohlSG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0196/1518] perf/x86/amd/uncore: Add group validation
Date: Sat, 12 Sep 2026 08:39:25 +0200
Message-ID: <20260912065627.924592314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit edda9051e267b7390c7ce24b1b71434414ad156e ]

The amd_uncore driver currently does not validate event groups and
allows creation of groups with more events than the number of available
hardware counters. Because of this, pmu->event_init() succeeds but
counter assignment fails later in pmu->add() which returns -EBUSY once
all counters are exhausted.

Address this by introducing group validation in the pmu->event_init()
path. Since the uncore PMUs have no per-event constraints and all
counters of a PMU are interchangeable, validation is reduced to just
counting the group members that target a PMU and ensuring that they fit
within the available set of counters.

Fixes: c43ca5091a37 ("perf/x86/amd: Add support for AMD NB and L2I "uncore" counters")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/750877d66e208603c3047f13eed6399625d43969.1782884387.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 9a13a9f21d2f8..c960481222727 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -264,6 +264,29 @@ static void amd_uncore_del(struct perf_event *event, int flags)
 	hwc->idx = -1;
 }
 
+static bool amd_uncore_group_valid(struct perf_event *event)
+{
+	struct amd_uncore_pmu *pmu = event_to_amd_uncore_pmu(event);
+	struct perf_event *leader = event->group_leader;
+	struct perf_event *sibling;
+	int counters = 0;
+
+	if (leader->pmu == event->pmu)
+		counters++;
+
+	for_each_sibling_event(sibling, leader) {
+		if (sibling->pmu == event->pmu &&
+		    sibling->state > PERF_EVENT_STATE_OFF)
+			counters++;
+	}
+
+	/*
+	 * When pmu->event_init() is called, the event is yet to be linked to
+	 * its leader's sibling list, so it is counted separately
+	 */
+	return (counters + 1) <= pmu->num_counters;
+}
+
 static int amd_uncore_event_init(struct perf_event *event)
 {
 	struct amd_uncore_pmu *pmu;
@@ -281,6 +304,14 @@ static int amd_uncore_event_init(struct perf_event *event)
 	if (!ctx)
 		return -ENODEV;
 
+	/*
+	 * Ensure that all events in a group can be scheduled together so that
+	 * a failure can be reported at perf_event_open() time rather than
+	 * silently at pmu->add() time when no free counter is found
+	 */
+	if (event->group_leader != event && !amd_uncore_group_valid(event))
+		return -EINVAL;
+
 	/*
 	 * NB and Last level cache counters (MSRs) are shared across all cores
 	 * that share the same NB / Last level cache.  On family 16h and below,
-- 
2.53.0



