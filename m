Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EC91A6813;
	Sat, 12 Sep 2026 07:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197610; cv=none; b=NRv4X0PeEejZ0F9vZmwowTE+oA5JwpU1IV6JJCUxIRdPDFwZluLp7QiOwPz4d/KCTbJH28w26NlYVY+FlybDlaBBvhMQqbfFya1eYMefnqhEa0JBy6CsjbvnjmwOopP03hJTYgQ2MhP9LKv9KRFfc6FD7dL3wj0gfCyKbnVCcPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197610; c=relaxed/simple;
	bh=E3KjD4m7zVIQwEJli1d0iOgfaVeMeMFg7oMV6t5Au4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tju+UD5pM5y8fdcXmpBh4fyi69MhbVfENYasiMm1mEPRSGbDY+58R/7oIB6mRq06HiDhhsGYAJC9kHlGbwyZBKdIBroKjZqRC5eMEezVrd3nNcneltNeaBcXYw5G7yZKw2pMP2LiWg3N91RS/24YUkq9HrHg2UVb0s6nJzgO1EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm4DkLOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm4DkLOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022411F000FF;
	Sat, 12 Sep 2026 07:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197608;
	bh=6q1th3idmily77EAGzd7FweD3ecZTE3IR4PRXsTE4zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm4DkLOuZY0d/vsWITq5YqmEk0Qqhxnmxqjbb3q7oih0/8XfYtUh8pQuk6A25ldTj
	 0tDqXqcInOWCz3KhqehcIH08LlI7Oe3yabd3fO3qB9WR1VwrZvbA/dU4vPSBcy4dV0
	 QOklc3Il7mJyah8Z0ZzR9Gixx8V2g/le86d30Hmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0183/1815] perf/x86/amd/uncore: Add group validation
Date: Sat, 12 Sep 2026 08:32:13 +0200
Message-ID: <20260912065653.301084091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index dbc00b6dd69ee..222dfab9225fe 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -265,6 +265,29 @@ static void amd_uncore_del(struct perf_event *event, int flags)
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
@@ -282,6 +305,14 @@ static int amd_uncore_event_init(struct perf_event *event)
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



