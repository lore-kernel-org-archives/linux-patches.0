Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B9E198E9A;
	Thu,  6 Jun 2024 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683508; cv=none; b=rTIp6afY4MFThfk3BpnxiH2MZz+lKFF1u3JbHkYRPadhK726mq5gAMyWKplmSECkDyqxZIbQ70N7aRuswQAW0685HOC+Wz1bmkxDYjc+zZKPLSgzOlOSTRZOgllxmxKCqWMSjpn/49oA1Lgl6Ng0Qn596+wnp5wGXq1H8cWW+2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683508; c=relaxed/simple;
	bh=4CIDX6EMyVvyHQLXy2WIm9GKuKsveHwqTJS2SggCSjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEy2jABkUOrmNnfk/yAGHbsR6YtL/tg61/II2eMZLUhkMlDuYeTO9IFNHNKMVlPXzp71tN4jirZqGuAuEJnHPaYKWbbBFoXpGynKBpMUDA9KD9GpAjcpuZN8k26o/GqDXUjheT6C3YW+MXSz+Y5Z0j/+AuXGyJhz/ZcVtNdR79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjchLZ2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjchLZ2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C12FC32781;
	Thu,  6 Jun 2024 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683508;
	bh=4CIDX6EMyVvyHQLXy2WIm9GKuKsveHwqTJS2SggCSjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjchLZ2rUv+mS2ZOHkB5K1TjFU9QjhS3BBgVx7w1DPVheDEkM/pDWRC5PabvUTWv+
	 HFPGBTToIRKOHnvta90LS7zqpYLrNWqugkX5wOTt4MxdJdCdJrCtDPfwh3fLyxq6gT
	 qvZxSevTSQTFV4hwuzBiGjtDCoU4dcW+/UmlXZMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 427/744] perf record: Move setting tracking events before record__init_thread_masks()
Date: Thu,  6 Jun 2024 16:01:39 +0200
Message-ID: <20240606131746.166036358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 1285ab300d598ead593b190af65a16f4b0843c68 ]

User space tasks can migrate between CPUs, so when tracing selected CPUs,
sideband for all CPUs is needed. In this case set the cpu map of the evsel
to all online CPUs. This may modify the original cpu map of the evlist.

Therefore, need to check whether the preceding scenario exists before
record__init_thread_masks().

Dummy tracking has been set in record__open(), move it before
record__init_thread_masks() and add a helper for unified processing.

The sys_perf_event_open invoked is as follows:

  # perf --debug verbose=3 record -e cpu-clock -D 100 true
  <SNIP>
  Opening: cpu-clock
  ------------------------------------------------------------
  perf_event_attr:
    type                             1 (PERF_TYPE_SOFTWARE)
    size                             136
    config                           0 (PERF_COUNT_SW_CPU_CLOCK)
    { sample_period, sample_freq }   4000
    sample_type                      IP|TID|TIME|PERIOD|IDENTIFIER
    read_format                      ID|LOST
    disabled                         1
    inherit                          1
    freq                             1
    sample_id_all                    1
    exclude_guest                    1
  ------------------------------------------------------------
  sys_perf_event_open: pid 10318  cpu 0  group_fd -1  flags 0x8 = 5
  sys_perf_event_open: pid 10318  cpu 1  group_fd -1  flags 0x8 = 6
  sys_perf_event_open: pid 10318  cpu 2  group_fd -1  flags 0x8 = 7
  sys_perf_event_open: pid 10318  cpu 3  group_fd -1  flags 0x8 = 9
  sys_perf_event_open: pid 10318  cpu 4  group_fd -1  flags 0x8 = 10
  sys_perf_event_open: pid 10318  cpu 5  group_fd -1  flags 0x8 = 11
  sys_perf_event_open: pid 10318  cpu 6  group_fd -1  flags 0x8 = 12
  sys_perf_event_open: pid 10318  cpu 7  group_fd -1  flags 0x8 = 13
  Opening: dummy:u
  ------------------------------------------------------------
  perf_event_attr:
    type                             1 (PERF_TYPE_SOFTWARE)
    size                             136
    config                           0x9 (PERF_COUNT_SW_DUMMY)
    { sample_period, sample_freq }   1
    sample_type                      IP|TID|TIME|IDENTIFIER
    read_format                      ID|LOST
    disabled                         1
    inherit                          1
    exclude_kernel                   1
    exclude_hv                       1
    mmap                             1
    comm                             1
    enable_on_exec                   1
    task                             1
    sample_id_all                    1
    exclude_guest                    1
    mmap2                            1
    comm_exec                        1
    ksymbol                          1
    bpf_event                        1
  ------------------------------------------------------------
  sys_perf_event_open: pid 10318  cpu 0  group_fd -1  flags 0x8 = 14
  sys_perf_event_open: pid 10318  cpu 1  group_fd -1  flags 0x8 = 15
  sys_perf_event_open: pid 10318  cpu 2  group_fd -1  flags 0x8 = 16
  sys_perf_event_open: pid 10318  cpu 3  group_fd -1  flags 0x8 = 17
  sys_perf_event_open: pid 10318  cpu 4  group_fd -1  flags 0x8 = 18
  sys_perf_event_open: pid 10318  cpu 5  group_fd -1  flags 0x8 = 19
  sys_perf_event_open: pid 10318  cpu 6  group_fd -1  flags 0x8 = 20
  sys_perf_event_open: pid 10318  cpu 7  group_fd -1  flags 0x8 = 21
  <SNIP>

'perf test' needs to update base-record & system-wide-dummy attr expected values
for test-record-C0:

1. Because a dummy sideband event is added to the sampling of specified
   CPUs. When evlist contains evsel of different sample_type,
   evlist__config() will change the default PERF_SAMPLE_ID bit to
   PERF_SAMPLE_IDENTIFICATION bit.
   The attr sample_type expected value of base-record and system-wide-dummy
   in test-record-C0 needs to be updated.

2. The perf record uses evlist__add_aux_dummy() instead of
   evlist__add_dummy() to add a dummy event.
   The expected value of system-wide-dummy attr needs to be updated.

The 'perf test' result is as follows:

  # ./perf test list  2>&1 | grep 'Setup struct perf_event_attr'
   17: Setup struct perf_event_attr
  # ./perf test 17
   17: Setup struct perf_event_attr                                    : Ok

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/20230904023340.12707-4-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 792bc998baf9 ("perf record: Fix debug message placement for test consumption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c             | 59 ++++++++++++++++---------
 tools/perf/tests/attr/system-wide-dummy | 14 +++---
 tools/perf/tests/attr/test-record-C0    |  4 +-
 3 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 16e21a3e883a7..96a3e122655b7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -906,6 +906,37 @@ static int record__config_off_cpu(struct record *rec)
 	return off_cpu_prepare(rec->evlist, &rec->opts.target, &rec->opts);
 }
 
+static int record__config_tracking_events(struct record *rec)
+{
+	struct record_opts *opts = &rec->opts;
+	struct evlist *evlist = rec->evlist;
+	struct evsel *evsel;
+
+	/*
+	 * For initial_delay, system wide or a hybrid system, we need to add
+	 * tracking event so that we can track PERF_RECORD_MMAP to cover the
+	 * delay of waiting or event synthesis.
+	 */
+	if (opts->target.initial_delay || target__has_cpu(&opts->target) ||
+	    perf_pmus__num_core_pmus() > 1) {
+		evsel = evlist__findnew_tracking_event(evlist, false);
+		if (!evsel)
+			return -ENOMEM;
+
+		/*
+		 * Enable the tracking event when the process is forked for
+		 * initial_delay, immediately for system wide.
+		 */
+		if (opts->target.initial_delay && !evsel->immediate &&
+		    !target__has_cpu(&opts->target))
+			evsel->core.attr.enable_on_exec = 1;
+		else
+			evsel->immediate = 1;
+	}
+
+	return 0;
+}
+
 static bool record__kcore_readable(struct machine *machine)
 {
 	char kcore[PATH_MAX];
@@ -1286,28 +1317,6 @@ static int record__open(struct record *rec)
 	struct record_opts *opts = &rec->opts;
 	int rc = 0;
 
-	/*
-	 * For initial_delay, system wide or a hybrid system, we need to add a
-	 * dummy event so that we can track PERF_RECORD_MMAP to cover the delay
-	 * of waiting or event synthesis.
-	 */
-	if (opts->target.initial_delay || target__has_cpu(&opts->target) ||
-	    perf_pmus__num_core_pmus() > 1) {
-		pos = evlist__findnew_tracking_event(evlist, false);
-		if (!pos)
-			return -ENOMEM;
-
-		/*
-		 * Enable the dummy event when the process is forked for
-		 * initial_delay, immediately for system wide.
-		 */
-		if (opts->target.initial_delay && !pos->immediate &&
-		    !target__has_cpu(&opts->target))
-			pos->core.attr.enable_on_exec = 1;
-		else
-			pos->immediate = 1;
-	}
-
 	evlist__config(evlist, opts, &callchain_param);
 
 	evlist__for_each_entry(evlist, pos) {
@@ -4171,6 +4180,12 @@ int cmd_record(int argc, const char **argv)
 		goto out;
 	}
 
+	err = record__config_tracking_events(rec);
+	if (err) {
+		pr_err("record__config_tracking_events failed, error %d\n", err);
+		goto out;
+	}
+
 	err = record__init_thread_masks(rec);
 	if (err) {
 		pr_err("Failed to initialize parallel data streaming masks\n");
diff --git a/tools/perf/tests/attr/system-wide-dummy b/tools/perf/tests/attr/system-wide-dummy
index 2f3e3eb728eb4..a1e1d6a263bf1 100644
--- a/tools/perf/tests/attr/system-wide-dummy
+++ b/tools/perf/tests/attr/system-wide-dummy
@@ -9,8 +9,10 @@ flags=8
 type=1
 size=136
 config=9
-sample_period=4000
-sample_type=455
+sample_period=1
+# PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME |
+# PERF_SAMPLE_CPU | PERF_SAMPLE_IDENTIFIER
+sample_type=65671
 read_format=4|20
 # Event will be enabled right away.
 disabled=0
@@ -18,12 +20,12 @@ inherit=1
 pinned=0
 exclusive=0
 exclude_user=0
-exclude_kernel=0
-exclude_hv=0
+exclude_kernel=1
+exclude_hv=1
 exclude_idle=0
 mmap=1
 comm=1
-freq=1
+freq=0
 inherit_stat=0
 enable_on_exec=0
 task=1
@@ -32,7 +34,7 @@ precise_ip=0
 mmap_data=0
 sample_id_all=1
 exclude_host=0
-exclude_guest=0
+exclude_guest=1
 exclude_callchain_kernel=0
 exclude_callchain_user=0
 mmap2=1
diff --git a/tools/perf/tests/attr/test-record-C0 b/tools/perf/tests/attr/test-record-C0
index 317730b906dd3..198e8429a1bf8 100644
--- a/tools/perf/tests/attr/test-record-C0
+++ b/tools/perf/tests/attr/test-record-C0
@@ -10,9 +10,9 @@ cpu=0
 enable_on_exec=0
 
 # PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME |
-# PERF_SAMPLE_ID | PERF_SAMPLE_PERIOD
+# PERF_SAMPLE_PERIOD | PERF_SAMPLE_IDENTIFIER
 # + PERF_SAMPLE_CPU added by -C 0
-sample_type=455
+sample_type=65927
 
 # Dummy event handles mmaps, comm and task.
 mmap=0
-- 
2.43.0



