Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6DA3090D5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300888; cv=none; b=LAiHVtNhgbvEvjqFEVMHTrbVVEbLJj78+rH8HSh6Pa0NCvqyhpDMicdprelWuZCzEQzLQz21p5PMLc+MZayoms5NaRKNPK0C0z2zIseNyZ85wCXSeB9VwQPDCYohLbXMU4iXovp1aUTkjLAE35akTsiMICLFadQoj1BwivflrbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300888; c=relaxed/simple;
	bh=sDboZ1rh0BW6VFiXWjwbmg4aNe6kKKOJb2Mf1WFx2iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpAyP+28m88ieM5DczKPCxkXdOm/53Z320qYzGmf/Fo5O9vuZhGhZIQme9bRKAJY4LN+++22wIyo4mp/s2/Km9DqCJatmMqM8+j7pZPd/UEd7aJhdzLHIfJYCgpiXZVosIHrwRGTW8RoMSsv7OqOE9gS9PqqDpnKeGm0h0it0xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+4FVE5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+4FVE5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A16C116D0;
	Sat, 28 Feb 2026 17:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300888;
	bh=sDboZ1rh0BW6VFiXWjwbmg4aNe6kKKOJb2Mf1WFx2iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+4FVE5iERq2d8x6wc9x826XDLW2P4C1zH0p8FP30aFTUEV8EDPeDqoOew0U1qYnF
	 /HArKObLjb2SmJr35u8awCT8N9KN9X1EQEYU4rZxlCsk091A2napXH5VSseoIi/K3e
	 ZsDijSD1bDoIjfW9PGT7aIey2iNDZWd/dELQECmWf5Q4IwLgbiBS6gXabil6xeGVK5
	 /dofMcZvyEwEVX/I2vKQlN1gDAA0pRWMO444U2KSnVFo+T5JW2cMvGnOJv7Z1uxzhb
	 8pCH0QEnIOVwKuBjv2SdM+E6vTOKuxmK80NO+FT1KDh+0+IMOf73OIgI/8Oa3qBNDd
	 qJ/iSBkxM5row==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	coresight@lists.linaro.org,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Suzuki Poulouse <suzuki.poulose@arm.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/752] perf cs-etm: Fix decoding for sparse CPU maps
Date: Sat, 28 Feb 2026 12:35:21 -0500
Message-ID: <20260228174750.1542406-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@linaro.org>

[ Upstream commit a70493e2bb0878885aa7a8178162550270693eb1 ]

The ETM decoder incorrectly assumed that auxtrace queue indices were
equivalent to CPU number. This assumption is used for inserting records
into the queue, and for fetching queues when given a CPU number. This
assumption held when Perf always opened a dummy event on every CPU, even
if the user provided a subset of CPUs on the commandline, resulting in
the indices aligning.

For example:

  # event : name = cs_etm//u, , id = { 2451, 2452 }, type = 11 (cs_etm), size = 136, config = 0x4010, { sample_period, samp>
  # event : name = dummy:u, , id = { 2453, 2454, 2455, 2456 }, type = 1 (PERF_TYPE_SOFTWARE), size = 136, config = 0x9 (PER>

  0 0 0x200 [0xd0]: PERF_RECORD_ID_INDEX nr: 6
  ... id: 2451  idx: 2  cpu: 2  tid: -1
  ... id: 2452  idx: 3  cpu: 3  tid: -1
  ... id: 2453  idx: 0  cpu: 0  tid: -1
  ... id: 2454  idx: 1  cpu: 1  tid: -1
  ... id: 2455  idx: 2  cpu: 2  tid: -1
  ... id: 2456  idx: 3  cpu: 3  tid: -1

Since commit 811082e4b668 ("perf parse-events: Support user CPUs mixed
with threads/processes") the dummy event no longer behaves in this way,
making the ETM event indices start from 0 on the first CPU recorded
regardless of its ID:

  # event : name = cs_etm//u, , id = { 771, 772 }, type = 11 (cs_etm), size = 144, config = 0x4010, { sample_period, sample>
  # event : name = dummy:u, , id = { 773, 774 }, type = 1 (PERF_TYPE_SOFTWARE), size = 144, config = 0x9 (PERF_COUNT_SW_DUM>

  0 0 0x200 [0x90]: PERF_RECORD_ID_INDEX nr: 4
  ... id: 771  idx: 0  cpu: 2  tid: -1
  ... id: 772  idx: 1  cpu: 3  tid: -1
  ... id: 773  idx: 0  cpu: 2  tid: -1
  ... id: 774  idx: 1  cpu: 3  tid: -1

This causes the following segfault when decoding:

  $ perf record -e cs_etm//u -C 2,3 -- true
  $ perf report

  perf: Segmentation fault
  -------- backtrace --------
  #0 0xaaaabf9fd020 in ui__signal_backtrace setup.c:110
  #1 0xffffab5c7930 in __kernel_rt_sigreturn [vdso][930]
  #2 0xaaaabfb68d30 in cs_etm_decoder__reset cs-etm-decoder.c:85
  #3 0xaaaabfb65930 in cs_etm__get_data_block cs-etm.c:2032
  #4 0xaaaabfb666fc in cs_etm__run_per_cpu_timeless_decoder cs-etm.c:2551
  #5 0xaaaabfb6692c in (cs_etm__process_timeless_queues cs-etm.c:2612
  #6 0xaaaabfb63390 in cs_etm__flush_events cs-etm.c:921
  #7 0xaaaabfb324c0 in auxtrace__flush_events auxtrace.c:2915
  #8 0xaaaabfaac378 in __perf_session__process_events session.c:2285
  #9 0xaaaabfaacc9c in perf_session__process_events session.c:2442
  #10 0xaaaabf8d3d90 in __cmd_report builtin-report.c:1085
  #11 0xaaaabf8d6944 in cmd_report builtin-report.c:1866
  #12 0xaaaabf95ebfc in run_builtin perf.c:351
  #13 0xaaaabf95eeb0 in handle_internal_command perf.c:404
  #14 0xaaaabf95f068 in run_argv perf.c:451
  #15 0xaaaabf95f390 in main perf.c:558
  #16 0xffffaab97400 in __libc_start_call_main libc_start_call_main.h:74
  #17 0xffffaab974d8 in __libc_start_main@@GLIBC_2.34 libc-start.c:128
  #18 0xaaaabf8aa8f0 in _start perf[7a8f0]

Fix it by inserting into the queues based on CPU number, rather than
using the index.

Fixes: 811082e4b668db96 ("perf parse-events: Support user CPUs mixed with threads/processes")
Signed-off-by: James Clark <james.clark@linaro.org>
Tested-by: Leo Yan <leo.yan@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: coresight@lists.linaro.org
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 30f4bb3e7fa30..06eb1a56430cb 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -3089,7 +3089,7 @@ static int cs_etm__queue_aux_fragment(struct perf_session *session, off_t file_o
 
 	if (aux_offset >= auxtrace_event->offset &&
 	    aux_offset + aux_size <= auxtrace_event->offset + auxtrace_event->size) {
-		struct cs_etm_queue *etmq = etm->queues.queue_array[auxtrace_event->idx].priv;
+		struct cs_etm_queue *etmq = cs_etm__get_queue(etm, auxtrace_event->cpu);
 
 		/*
 		 * If this AUX event was inside this buffer somewhere, create a new auxtrace event
@@ -3098,6 +3098,7 @@ static int cs_etm__queue_aux_fragment(struct perf_session *session, off_t file_o
 		auxtrace_fragment.auxtrace = *auxtrace_event;
 		auxtrace_fragment.auxtrace.size = aux_size;
 		auxtrace_fragment.auxtrace.offset = aux_offset;
+		auxtrace_fragment.auxtrace.idx = etmq->queue_nr;
 		file_offset += aux_offset - auxtrace_event->offset + auxtrace_event->header.size;
 
 		pr_debug3("CS ETM: Queue buffer size: %#"PRI_lx64" offset: %#"PRI_lx64
-- 
2.51.0

