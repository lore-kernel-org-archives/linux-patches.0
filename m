Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934842CA9;
	Tue, 12 Aug 2025 18:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024587; cv=none; b=pcARs+j5npzg4/sta1e6tR69XEQTj5/FGgIrgPhHmtN/lhqb2IPbAybWKUdqDYnrMCS1qJ41cWFFxTpCqMEJAcKfi+LLOMy6oq4BTtyTo2fzRNMNQB791Vn46qAMtHnDg5Bdmm7BWWw+OaYMH/T7LU8MnRrFASD7ErKdaUI/Zs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024587; c=relaxed/simple;
	bh=NgRZchFGVRlPoa0/xDXlzp/bOm3iZ3ue2aLKDBPXLPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTW5sfJwWgA9zdI+cNmULs+dd+imMBbzpxfL2vbaQNungF1D0xjNncU3QVQsudQtJ+2q3UpyqiMAteZTbEk6sZxzPYXBmbH7aiuDxnRBNRHTATp1Lh5pqy4MEKNsPOjcRDOzqQM7ru7PioY6u/WCFPaFyKP+Hv8HGPY/mCcdWOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0RjFpBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0RjFpBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A7C4CEF0;
	Tue, 12 Aug 2025 18:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024587;
	bh=NgRZchFGVRlPoa0/xDXlzp/bOm3iZ3ue2aLKDBPXLPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0RjFpBljBU1VkKk3dr/f+YYH2wu8ME9KVvn9aIkRFrYQ0GpUHQCRXDaBrj8Ggqhc
	 Xd9BB1GMhEjbIYSi2fgKIx7OvBKO6xvTP+CYumCIDcTGDb6ShgDHxhVXPS9q0PLuNd
	 Qh8gTsCm3H1iO7yGXl1bT9KSC+L3p8SRXUVJCA+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 384/627] perf python: Correct pyrf_evsel__read for tool PMUs
Date: Tue, 12 Aug 2025 19:31:19 +0200
Message-ID: <20250812173433.901493814@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 6183afcba9c1c810656ddb36170106aaf3cf778c ]

Tool PMUs assume that stat's process_counter_values is being used to
read the counters. Specifically they hold onto old values in
evsel->prev_raw_counts and give the cumulative count based off of this
value. Update pyrf_evsel__read to allocate counts and prev_raw_counts,
use evsel__read_counter rather than perf_evsel__read so tool PMUs are
read from not just perf_event_open events, make the returned
pyrf_counts_values contain the delta value rather than the cumulative
value.

Fixes: 739621f65702 ("perf python: Add evsel read method")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250710235126.1086011-12-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 47 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index eb560e3f9e35..b9fe7f2c14af 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -10,6 +10,7 @@
 #endif
 #include <perf/mmap.h>
 #include "callchain.h"
+#include "counts.h"
 #include "evlist.h"
 #include "evsel.h"
 #include "event.h"
@@ -888,12 +889,38 @@ static PyObject *pyrf_evsel__threads(struct pyrf_evsel *pevsel)
 	return (PyObject *)pthread_map;
 }
 
+/*
+ * Ensure evsel's counts and prev_raw_counts are allocated, the latter
+ * used by tool PMUs to compute the cumulative count as expected by
+ * stat's process_counter_values.
+ */
+static int evsel__ensure_counts(struct evsel *evsel)
+{
+	int nthreads, ncpus;
+
+	if (evsel->counts != NULL)
+		return 0;
+
+	nthreads = perf_thread_map__nr(evsel->core.threads);
+	ncpus = perf_cpu_map__nr(evsel->core.cpus);
+
+	evsel->counts = perf_counts__new(ncpus, nthreads);
+	if (evsel->counts == NULL)
+		return -ENOMEM;
+
+	evsel->prev_raw_counts = perf_counts__new(ncpus, nthreads);
+	if (evsel->prev_raw_counts == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static PyObject *pyrf_evsel__read(struct pyrf_evsel *pevsel,
 				  PyObject *args, PyObject *kwargs)
 {
 	struct evsel *evsel = &pevsel->evsel;
 	int cpu = 0, cpu_idx, thread = 0, thread_idx;
-	struct perf_counts_values counts;
+	struct perf_counts_values *old_count, *new_count;
 	struct pyrf_counts_values *count_values = PyObject_New(struct pyrf_counts_values,
 							       &pyrf_counts_values__type);
 
@@ -914,8 +941,22 @@ static PyObject *pyrf_evsel__read(struct pyrf_evsel *pevsel,
 			     thread);
 		return NULL;
 	}
-	perf_evsel__read(&(evsel->core), cpu_idx, thread_idx, &counts);
-	count_values->values = counts;
+
+	if (evsel__ensure_counts(evsel))
+		return PyErr_NoMemory();
+
+	/* Set up pointers to the old and newly read counter values. */
+	old_count = perf_counts(evsel->prev_raw_counts, cpu_idx, thread_idx);
+	new_count = perf_counts(evsel->counts, cpu_idx, thread_idx);
+	/* Update the value in evsel->counts. */
+	evsel__read_counter(evsel, cpu_idx, thread_idx);
+	/* Copy the value and turn it into the delta from old_count. */
+	count_values->values = *new_count;
+	count_values->values.val -= old_count->val;
+	count_values->values.ena -= old_count->ena;
+	count_values->values.run -= old_count->run;
+	/* Save the new count over the old_count for the next read. */
+	*old_count = *new_count;
 	return (PyObject *)count_values;
 }
 
-- 
2.39.5



