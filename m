Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024875;
	b=HqvlK9W49qx1Y1AJFKSUbm4EJqj/hQUsRtsZoduw7sXOt77/XApNDYGW1Mto4Lvo0AGr
	 pZiJJQ2iue9NPQZavQcZ0vUVf9YWcBsmVvFoG8bI/UHiN7dNssmccxCNIKd7YW2hJ6SZ2
	 34edEaJq4MVDzfmZiWHBqifSib3JkEYIkXigJZVaI2nO7iVc4XHzC09cbFtrjev0fnmWH
	 7kPQuWAWe36wEwpvwO70lEN/aRMH1m4JO3Z14hnZr+AMc40+QEZ7sLvKqGC5onbItefLM
	 9V2T8cmvNoeOKlcIuI2huogHsQ5SDzDOcw1ewe5cpJuGuo1K8qsgxtVuqVVi7dG/Trg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EpGu4VDI3zJFHjs664YdSMQurda4ZBKNQYJK87Ljl4k=;
	b=GR3XVl6xZSuyi+qGAySJkqPxtYw7jn5TliMuZFiB9VgdVNXRD8/bOwNyzqHFHr45KyyD
	 SC45JD4D36kzcL2K9YSejcG9899hEwT9WTSML20Cd8Lg6YynpGV418QUKdU7G1efkeAiZ
	 e4J7uqErkVhs84mntq7aes7Q0h1JswwBQsxsaGdYmDlugdw8IIN4N18k8aTLTpHuxQ1ty
	 TCQAF8Qeha+y4vOqqGlY1OAKeWQW3KgraVk6ZXdOIBBX6/Ven4U9BPaIub+IsHP8gI+9D
	 3ykgHgZYn3Ibsc0+EhtftNs+r5W/4eMKRA9nQ9yOE9On5FNtPiRQ4X00sWKQAkNCyeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UC/BhurW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96C2606A31C;
	Wed, 18 Nov 2026 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UC/BhurW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF1B1F000C4;
	Wed, 18 Nov 2026 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024875;
	bh=EpGu4VDI3zJFHjs664YdSMQurda4ZBKNQYJK87Ljl4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UC/BhurWlrtM6QaYRCE7DoM/VYJSQ3h3MyCX0X0jjZfZ+FCUKsEDgnptAagCDN/dK
	 +BHt8+bD4FmqO/wN9pn2KMtQX9tH/ypkypnqIM2k/duLHy8nuUphx/vRr6T0CoEUt8
	 eKB8uMe6tzYICWWC0C9Hh8KuOSOgPptTkkUI6sVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0881/2151] perf pmu: Fix race with concurrent tracepoint creation and removal in perf list
Date: Wed, 18 Nov 2026 15:43:36 +0100
Message-ID: <20261118150154.398692240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 98be2eb8f1f03..a13bebbbe4916 100644
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
@@ -553,7 +554,7 @@ static int cmp_sevent(const void *a, const void *b)
 	}
 
 	/* Order by event name. */
-	return strcmp(as->name, bs->name);
+	return strcmp(as->name ?: "", bs->name ?: "");
 }
 
 static bool pmu_alias_is_duplicate(struct sevent *a, struct sevent *b)
@@ -563,7 +564,7 @@ static bool pmu_alias_is_duplicate(struct sevent *a, struct sevent *b)
 		return false;
 
 	/* Don't remove duplicates for different PMUs */
-	return strcmp(a->pmu_name, b->pmu_name) == 0;
+	return strcmp(a->pmu_name ?: "", b->pmu_name ?: "") == 0;
 }
 
 struct events_callback_state {
@@ -579,8 +580,18 @@ static int perf_pmus__print_pmu_events__callback(void *vstate,
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
@@ -636,6 +647,8 @@ void perf_pmus__print_pmu_events(const struct print_callbacks *print_cb, void *p
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



