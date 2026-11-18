Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017901;
	b=23tRkV8DleQ0CYs9GKwVwr1ljgdhPSkJvMBkiReuDMCKngGJTvl+J3Nzw4byEBE6ijDb
	 ohpJcHZEDstjZVT8B2+6z+iCTPMKA2NrzC1U+2hV938w4TxlbZ1KNanpKG9l+I4hYrxfB
	 +7xngtaQlVp/Oeb6cQC7W9rQOab5IE5GfYP5U70SC03KScqd64XPhcnJcFvI3+yR6nFLv
	 QCT4WxgSCIHPhHJgvX5/PTWzZwSxKLfdtasUg2t3vd9xcKIg/GQJiiZTAcUpBdN4udpaW
	 WxMqyYqVcJMGVXOzW1TvwEkIxphdVOKWXVQ21ICVhwmeXkJmXjs1JCuXoVX2muRdq/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5u2OWF4P53gnYAOEmm2CL2PKujmQui7uJvK/6AEWx4=;
	b=NfSdVE1WTwyxgFvf/SQ7schKpjF2iBK9BSjC5pjT381268NgDaH+FiH7yoLSo2n3mzOv
	 NohT1n0F+dOI2TQsthfJLmL93Y+w96lUjELCo1YB37o9n09kMmsjcvCIZBkKeaYGG3FAQ
	 jlZCzofJOkKc8Jucu5W3gzJiOpa0jliiODPwzGNcA8npLAQs7M7hsDF9UTGbWOAq0FxL2
	 kjeLkMTz1ZtnO/g47/CtK3D3nw1q1nMgYUcaDF1kr2oaZAEm3DEs17kT+lAF/w/EjxUlF
	 GGVjke5IkNd2+26kiedg26UNnofpkqvTLKaNUqveY6UGNdbDweBlqXafRjH7AiBNRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FK5rRaUR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA883606A31C;
	Wed, 18 Nov 2026 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FK5rRaUR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D35C1F000CA;
	Wed, 18 Nov 2026 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017900;
	bh=e5u2OWF4P53gnYAOEmm2CL2PKujmQui7uJvK/6AEWx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FK5rRaURDCkZ6wfisE0dclktPCY/9DiNUJtH7yw2qiAt2aOf4qSZBrb1nLMKsoACe
	 HMio+7WXchMC1XJXtG3FyynrMG34E5EZhaOcG3D+O7p+fWpuZdRKOg427ZNTwfOKii
	 e+i9/Hklkfh5YTojoOChp2RHVsOKny7LK+tdu0k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1042/2651] perf pmu: Fix race with concurrent tracepoint creation and removal in perf list
Date: Wed, 18 Nov 2026 15:38:02 +0100
Message-ID: <20261118150325.476174253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit ab20a3090d338c4f161cb1a68e64a7f8914569ea ]

perf_pmus__print_pmu_events() first counts events via
perf_pmu__num_events() to allocate the aliases array, then populates it
via perf_pmu__for_each_event(). When dynamic tracepoints (such as
kprobes or uprobes during 'perf test' runs) are concurrently created or
removed between the two passes:
- If an event is removed, state.index is smaller than the allocated len,
  leaving trailing zeroed entries in aliases[] with name == NULL and
  pmu == NULL, which causes qsort(cmp_sevent) or the print loop to crash
  with SIGSEGV.
- If a dynamic tracepoint subsystem directory is removed while scanning
  /sys/kernel/tracing/events, tp_pmu__for_each_tp_event() returns
  -ENOENT and aborts enumeration of all remaining tracepoint subsystems.
- If an event is added, perf_pmus__print_pmu_events__callback() aborts
  enumeration when state->index reaches state->aliases_len.

Grow state->aliases dynamically via realloc() when needed, use
state.index as the actual populated length for sorting and printing, and
ignore -ENOENT when a tracepoint subsystem directory disappears during
enumeration.

Fixes: c3245d2093c16c60 ("perf pmu: Abstract alias/event struct")
Fixes: 45b6e281cb0648ac ("perf tp_pmu: Add event APIs")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmus.c   | 21 +++++++++++++++++----
 tools/perf/util/tp_pmu.c |  8 ++++++--
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/pmus.c b/tools/perf/util/pmus.c
index e0a4cb2428ca4..1355b317f3eda 100644
--- a/tools/perf/util/pmus.c
+++ b/tools/perf/util/pmus.c
@@ -8,6 +8,7 @@
 #include <sys/types.h>
 #include <ctype.h>
 #include <pthread.h>
+#include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include "cpumap.h"
@@ -571,7 +572,7 @@ static int cmp_sevent(const void *a, const void *b)
 	}
 
 	/* Order by event name. */
-	return strcmp(as->name, bs->name);
+	return strcmp(as->name ?: "", bs->name ?: "");
 }
 
 static bool pmu_alias_is_duplicate(struct sevent *a, struct sevent *b)
@@ -581,7 +582,7 @@ static bool pmu_alias_is_duplicate(struct sevent *a, struct sevent *b)
 		return false;
 
 	/* Don't remove duplicates for different PMUs */
-	return strcmp(a->pmu_name, b->pmu_name) == 0;
+	return strcmp(a->pmu_name ?: "", b->pmu_name ?: "") == 0;
 }
 
 struct events_callback_state {
@@ -597,8 +598,18 @@ static int perf_pmus__print_pmu_events__callback(void *vstate,
 	struct sevent *s;
 
 	if (state->index >= state->aliases_len) {
-		pr_err("Unexpected event %s/%s/\n", info->pmu->name, info->name);
-		return 1;
+		size_t new_len = max_t(size_t, 16, state->aliases_len * 2);
+		struct sevent *new_aliases;
+
+		new_aliases = realloc(state->aliases, new_len * sizeof(struct sevent));
+		if (!new_aliases) {
+			pr_err("Unexpected event %s/%s/\n", info->pmu->name, info->name);
+			return 1;
+		}
+		memset(&new_aliases[state->aliases_len], 0,
+		       (new_len - state->aliases_len) * sizeof(struct sevent));
+		state->aliases = new_aliases;
+		state->aliases_len = new_len;
 	}
 	assert(info->pmu != NULL || info->name != NULL);
 	s = &state->aliases[state->index];
@@ -654,6 +665,8 @@ void perf_pmus__print_pmu_events(const struct print_callbacks *print_cb, void *p
 		perf_pmu__for_each_event(pmu, skip_duplicate_pmus, &state,
 					 perf_pmus__print_pmu_events__callback);
 	}
+	aliases = state.aliases;
+	len = state.index;
 	qsort(aliases, len, sizeof(struct sevent), cmp_sevent);
 	for (int j = 0; j < len; j++) {
 		/* Skip duplicates */
diff --git a/tools/perf/util/tp_pmu.c b/tools/perf/util/tp_pmu.c
index c2be8c9f9084d..5ac732e068412 100644
--- a/tools/perf/util/tp_pmu.c
+++ b/tools/perf/util/tp_pmu.c
@@ -151,7 +151,9 @@ static int for_each_event_cb(void *state, const char *sys_name, const char *evt_
 
 static int for_each_event_sys_cb(void *state, const char *sys_name)
 {
-	return tp_pmu__for_each_tp_event(sys_name, state, for_each_event_cb);
+	int ret = tp_pmu__for_each_tp_event(sys_name, state, for_each_event_cb);
+
+	return ret == -ENOENT ? 0 : ret;
 }
 
 int tp_pmu__for_each_event(struct perf_pmu *pmu, void *state, pmu_event_callback cb)
@@ -176,7 +178,9 @@ static int num_events_cb(void *state, const char *sys_name __maybe_unused,
 
 static int num_events_sys_cb(void *state, const char *sys_name)
 {
-	return tp_pmu__for_each_tp_event(sys_name, state, num_events_cb);
+	int ret = tp_pmu__for_each_tp_event(sys_name, state, num_events_cb);
+
+	return ret == -ENOENT ? 0 : ret;
 }
 
 size_t tp_pmu__num_events(struct perf_pmu *pmu __maybe_unused)
-- 
2.53.0



