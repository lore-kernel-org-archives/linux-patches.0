Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986FC1D0E1F;
	Wed,  2 Oct 2024 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878218; cv=none; b=hdGyGtZciUtruVXLabIusPVCkZcxiCrw/pEULARKK8hZXSqr6bv45KEwtNBgTUxPd0X1H0nAf7KQMwJnoCH+P+2o4w9VvGMQ/F+R23WnBjrV1wYNi+wNXqahIy7gwq6hpgmY8bKpvb8puWs4V7hNVYCViIiOg6aZyVRAzYgsKMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878218; c=relaxed/simple;
	bh=4e7Gj2HXJg++ejJDts+4P4bZbTDF8hoZSGfVdRX4ZeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twSlIXufHhsfAOy3Pvydz9qPlxwUgqeRwzqXxm85QzeTXNpIumaw5tG9AOWqtyaZoETNgd+M64XOIq1n5vSASAIsbb2ZeD+UIuFjjfFYQVXitwPp9z0H+JkoKd2yXTAXMrMRydFb8iHZ9pss/DK441NpU7xMV5CAl0M6CNpAFSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqrEyuDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqrEyuDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2058CC4CEC2;
	Wed,  2 Oct 2024 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878218;
	bh=4e7Gj2HXJg++ejJDts+4P4bZbTDF8hoZSGfVdRX4ZeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqrEyuDtP4SHLQd/kMn/Lg585RjX/99sqcUYrIi3nMnS5f9nYAmb48pSq39UI9x+4
	 xOOw7d0/qLtrK+rU/gCedHLa/J9h/aGUNshEYmNsFb66r4v9lJSR2zAsJEPyflVBDU
	 CYAJMmW/1P+3+32YkHbKI5JArDW9jrLa+OZOt8xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 307/634] perf mem: Fix missed p-core mem events on ADL and RPL
Date: Wed,  2 Oct 2024 14:56:47 +0200
Message-ID: <20241002125823.226023436@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 5ad7db2c3f941cde3045ce38a9c4c40b0c7d56b9 ]

The p-core mem events are missed when launching 'perf mem record' on ADL
and RPL.

  root@number:~# perf mem record sleep 1
  Memory events are enabled on a subset of CPUs: 16-27
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.032 MB perf.data ]
  root@number:~# perf evlist
  cpu_atom/mem-loads,ldlat=30/P
  cpu_atom/mem-stores/P
  dummy:u

A variable 'record' in the 'struct perf_mem_event' is to indicate
whether a mem event in a mem_events[] should be recorded. The current
code only configure the variable for the first eligible PMU.

It's good enough for a non-hybrid machine or a hybrid machine which has
the same mem_events[].

However, if a different mem_events[] is used for different PMUs on a
hybrid machine, e.g., ADL or RPL, the 'record' for the second PMU never
get a chance to be set.

The mem_events[] of the second PMU are always ignored.

'perf mem' doesn't support the per-PMU configuration now. A per-PMU
mem_events[] 'record' variable doesn't make sense. Make it global.

That could also avoid searching for the per-PMU mem_events[] via
perf_pmu__mem_events_ptr every time.

Committer testing:

  root@number:~# perf evlist -g
  cpu_atom/mem-loads,ldlat=30/P
  cpu_atom/mem-stores/P
  {cpu_core/mem-loads-aux/,cpu_core/mem-loads,ldlat=30/}
  cpu_core/mem-stores/P
  dummy:u
  root@number:~#

The :S for '{cpu_core/mem-loads-aux/,cpu_core/mem-loads,ldlat=30/}' is
not being added by 'perf evlist -g', to be checked.

Fixes: abbdd79b786e036e ("perf mem: Clean up perf_mem_events__name()")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Closes: https://lore.kernel.org/lkml/Zthu81fA3kLC2CS2@x1/
Link: https://lore.kernel.org/r/20240905170737.4070743-2-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c     | 12 ++++--------
 tools/perf/builtin-mem.c     | 17 ++++++-----------
 tools/perf/util/mem-events.c |  6 ++++--
 tools/perf/util/mem-events.h |  2 +-
 4 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 0b2cb59212938..7298f36070622 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -3290,19 +3290,15 @@ static int perf_c2c__record(int argc, const char **argv)
 		 * PERF_MEM_EVENTS__LOAD_STORE if it is supported.
 		 */
 		if (e->tag) {
-			e->record = true;
+			perf_mem_record[PERF_MEM_EVENTS__LOAD_STORE] = true;
 			rec_argv[i++] = "-W";
 		} else {
-			e = perf_pmu__mem_events_ptr(pmu, PERF_MEM_EVENTS__LOAD);
-			e->record = true;
-
-			e = perf_pmu__mem_events_ptr(pmu, PERF_MEM_EVENTS__STORE);
-			e->record = true;
+			perf_mem_record[PERF_MEM_EVENTS__LOAD] = true;
+			perf_mem_record[PERF_MEM_EVENTS__STORE] = true;
 		}
 	}
 
-	e = perf_pmu__mem_events_ptr(pmu, PERF_MEM_EVENTS__LOAD);
-	if (e->record)
+	if (perf_mem_record[PERF_MEM_EVENTS__LOAD])
 		rec_argv[i++] = "-W";
 
 	rec_argv[i++] = "-d";
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 7fdbaaed14af2..08724fa508e14 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -126,22 +126,17 @@ static int __cmd_record(int argc, const char **argv, struct perf_mem *mem)
 	if (e->tag &&
 	    (mem->operation & MEM_OPERATION_LOAD) &&
 	    (mem->operation & MEM_OPERATION_STORE)) {
-		e->record = true;
+		perf_mem_record[PERF_MEM_EVENTS__LOAD_STORE] = true;
 		rec_argv[i++] = "-W";
 	} else {
-		if (mem->operation & MEM_OPERATION_LOAD) {
-			e = perf_pmu__mem_events_ptr(pmu, PERF_MEM_EVENTS__LOAD);
-			e->record = true;
-		}
+		if (mem->operation & MEM_OPERATION_LOAD)
+			perf_mem_record[PERF_MEM_EVENTS__LOAD] = true;
 
-		if (mem->operation & MEM_OPERATION_STORE) {
-			e = perf_pmu__mem_events_ptr(pmu, PERF_MEM_EVENTS__STORE);
-			e->record = true;
-		}
+		if (mem->operation & MEM_OPERATION_STORE)
+			perf_mem_record[PERF_MEM_EVENTS__STORE] = true;
 	}
 
-	e = perf_pmu__mem_events_ptr(pmu, PERF_MEM_EVENTS__LOAD);
-	if (e->record)
+	if (perf_mem_record[PERF_MEM_EVENTS__LOAD])
 		rec_argv[i++] = "-W";
 
 	rec_argv[i++] = "-d";
diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index c844aca0726ce..1f1e1063efe37 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -28,6 +28,8 @@ struct perf_mem_event perf_mem_events[PERF_MEM_EVENTS__MAX] = {
 };
 #undef E
 
+bool perf_mem_record[PERF_MEM_EVENTS__MAX] = { 0 };
+
 static char mem_loads_name[100];
 static char mem_stores_name[100];
 
@@ -162,7 +164,7 @@ int perf_pmu__mem_events_parse(struct perf_pmu *pmu, const char *str)
 				continue;
 
 			if (strstr(e->tag, tok))
-				e->record = found = true;
+				perf_mem_record[j] = found = true;
 		}
 
 		tok = strtok_r(NULL, ",", &saveptr);
@@ -259,7 +261,7 @@ int perf_mem_events__record_args(const char **rec_argv, int *argv_nr)
 		for (int j = 0; j < PERF_MEM_EVENTS__MAX; j++) {
 			e = perf_pmu__mem_events_ptr(pmu, j);
 
-			if (!e->record)
+			if (!perf_mem_record[j])
 				continue;
 
 			if (!e->supported) {
diff --git a/tools/perf/util/mem-events.h b/tools/perf/util/mem-events.h
index a6fc2a5939388..8dc27db9fd52f 100644
--- a/tools/perf/util/mem-events.h
+++ b/tools/perf/util/mem-events.h
@@ -6,7 +6,6 @@
 #include <linux/types.h>
 
 struct perf_mem_event {
-	bool		record;
 	bool		supported;
 	bool		ldlat;
 	u32		aux_event;
@@ -28,6 +27,7 @@ struct perf_pmu;
 
 extern unsigned int perf_mem_events__loads_ldlat;
 extern struct perf_mem_event perf_mem_events[PERF_MEM_EVENTS__MAX];
+extern bool perf_mem_record[PERF_MEM_EVENTS__MAX];
 
 int perf_pmu__mem_events_parse(struct perf_pmu *pmu, const char *str);
 int perf_pmu__mem_events_init(void);
-- 
2.43.0



