Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32F3B14D4;
	Sat, 12 Sep 2026 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229296; cv=none; b=lNMKRFT5llhPApuZ23TvJXnTGneK8g03NVQnsLlV1czThLAAYuAIU1k1NjCgISbjhPV1Clx7bElYRVQHYdOJ5jeNwTTZfkGhb/K4ae8hLFSaV6xoGRSt0L4Y06AQi7W4WO/C6nNZF07oYsmMmbWjhA8G2nS18dENCyBBbOO8SKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229296; c=relaxed/simple;
	bh=wickqQuDA+IQzoC+vaUhRK2mKPHPKCN9NIgeL+LxbPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWpLiQyUB+U1QT8M+8ycZtgVesCjHLq9gsr0oeAB6zZjmau6F9c9L7LfQqz2zhK70DdFcdTpK2qnV9p3fSfqnCIBJ4N2H5VTs42Z9hHz5h61SnUhpfOiV7l0IyAzzWHeGHSwk2Yn6MvGaeffX9Tuv2/lVSfEzjtX+tIgDoVeE5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=st68KdZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="st68KdZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE811F00893;
	Sat, 12 Sep 2026 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229285;
	bh=3dkCASnwsoWv4BcljhcMnvF/R66TnvYdKkZyfD9I9wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=st68KdZqN9zOuXAXC7PCfJdgrPaKBZChSNtA0cQ751i+eaI+U1KkM9vAMlxrpO79+
	 B1ttgBi6QFnOB82T61tqDQX83KAxn/pUkjA1YKoOjL9+HzvYjmfg3Ui646EnwXyKtC
	 +mntFJzA4+nBzW/fpfeHRDjADi2MqbUy7LgDqePM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0516/1191] perf/x86/amd/uncore: Add group validation
Date: Sat, 12 Sep 2026 08:54:04 +0200
Message-ID: <20260912065559.837967050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ffcecda13d654..cc84ed9cc63af 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -167,6 +167,29 @@ static void amd_uncore_del(struct perf_event *event, int flags)
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
@@ -184,6 +207,14 @@ static int amd_uncore_event_init(struct perf_event *event)
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



