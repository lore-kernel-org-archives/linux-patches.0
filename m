Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1AF171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FA6C433EF;
	Mon, 22 May 2023 19:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785160;
	bh=oKuHxRaeq4Ak/X04jZOcDEODKRW2mGnj1ik8sWUYYHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXzq6gGx7QYWUPRPrpPo4Tc9cM5I1A/t4IxSVMZXT6Z7wrlbeF+1KY3bDwYffWe+6
	 39q3tU7ZL6jqJYcPHL5djSeGxOCfBjIIMotE/fAZIQztxYu281aELITVc+QJHNGzOi
	 Hlildedo0vM8cT5JYnUJTtmM5fp0P3dpo1OUrm/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ananth Narayan <ananth.narayan@amd.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Terrell <terrelln@fb.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.3 330/364] perf script: Skip aggregation for stat events
Date: Mon, 22 May 2023 20:10:35 +0100
Message-Id: <20230522190421.026996479@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sandipan Das <sandipan.das@amd.com>

commit 2fe6575924612f1014a0539ab3053b106aded926 upstream.

The script command does not support aggregation modes by itself although
that can be achieved using post-processing scripts. Because of this, it
does not allocate memory for aggregated event values.

Upon running perf stat record, the aggregation mode is set in the perf
data file. If the mode is AGGR_GLOBAL, the aggregated event values are
accessed and this leads to a segmentation fault since these were never
allocated to begin with. Set the mode to AGGR_NONE explicitly to avoid
this.

E.g.

  $ perf stat record -e cycles true
  $ perf script

Before:
  Segmentation fault (core dumped)

After:
  CPU   THREAD             VAL             ENA             RUN            TIME EVENT
   -1   231919          162831          362069          362069          935289 cycles:u

Fixes: 8b76a3188b85724f ("perf stat: Remove unused perf_counts.aggr field")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ananth Narayan <ananth.narayan@amd.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: stable@vger.kernel.org # v6.2+
Link: https://lore.kernel.org/r/83d6c6c05c54bf00c5a9df32ac160718efca0c7a.1683280603.git.sandipan.das@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-script.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3652,6 +3652,13 @@ static int process_stat_config_event(str
 				     union perf_event *event)
 {
 	perf_event__read_stat_config(&stat_config, &event->stat_config);
+
+	/*
+	 * Aggregation modes are not used since post-processing scripts are
+	 * supposed to take care of such requirements
+	 */
+	stat_config.aggr_mode = AGGR_NONE;
+
 	return 0;
 }
 


