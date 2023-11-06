Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E145A200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOw8T+mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D574C433C7;
	Mon,  6 Nov 2023 13:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276101;
	bh=V19mlyLnlUIHZi7AI4Dzoz9ktoduZBbyR+5cfkTWsLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOw8T+mpIJglLLpTvUSV31LZ46FcBfq+0LkNMzprkhVf52K4hJwqdimwrgfSoVeHD
	 hbxYHg89fdU0t0NJ8lhe6fgITRRU2dVzK0Bs5kJgAjIEiXdJuT7ThosnOzQ8+GEtnW
	 wOX+KiF22tl3xNbKtyAdSfFoUODAan8p2HaEE5PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/30] perf evlist: Avoid frequency mode for the dummy event
Date: Mon,  6 Nov 2023 14:03:21 +0100
Message-ID: <20231106130258.025945192@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
References: <20231106130257.903265688@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit f9cdeb58a9cf46c09b56f5f661ea8da24b6458c3 ]

Dummy events are created with an attribute where the period and freq
are zero. evsel__config will then see the uninitialized values and
initialize them in evsel__default_freq_period. As fequency mode is
used by default the dummy event would be set to use frequency
mode. However, this has no effect on the dummy event but does cause
unnecessary timers/interrupts. Avoid this overhead by setting the
period to 1 for dummy events.

evlist__add_aux_dummy calls evlist__add_dummy then sets freq=0 and
period=1. This isn't necessary after this change and so the setting is
removed.

>From Stephane:

The dummy event is not counting anything. It is used to collect mmap
records and avoid a race condition during the synthesize mmap phase of
perf record. As such, it should not cause any overhead during active
profiling. Yet, it did. Because of a bug the dummy event was
programmed as a sampling event in frequency mode. Events in that mode
incur more kernel overheads because on timer tick, the kernel has to
look at the number of samples for each event and potentially adjust
the sampling period to achieve the desired frequency. The dummy event
was therefore adding a frequency event to task and ctx contexts we may
otherwise not have any, e.g.,

  perf record -a -e cpu/event=0x3c,period=10000000/.

On each timer tick the perf_adjust_freq_unthr_context() is invoked and
if ctx->nr_freq is non-zero, then the kernel will loop over ALL the
events of the context looking for frequency mode ones. In doing, so it
locks the context, and enable/disable the PMU of each hw event. If all
the events of the context are in period mode, the kernel will have to
traverse the list for nothing incurring overhead. The overhead is
multiplied by a very large factor when this happens in a guest kernel.
There is no need for the dummy event to be in frequency mode, it does
not count anything and therefore should not cause extra overhead for
no reason.

Fixes: 5bae0250237f ("perf evlist: Introduce perf_evlist__new_dummy constructor")
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20230916035640.1074422-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7ef43f72098e0..c779b9f2e6220 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -251,6 +251,9 @@ static struct evsel *evlist__dummy_event(struct evlist *evlist)
 		.type	= PERF_TYPE_SOFTWARE,
 		.config = PERF_COUNT_SW_DUMMY,
 		.size	= sizeof(attr), /* to capture ABI version */
+		/* Avoid frequency mode for dummy events to avoid associated timers. */
+		.freq = 0,
+		.sample_period = 1,
 	};
 
 	return evsel__new_idx(&attr, evlist->core.nr_entries);
@@ -277,8 +280,6 @@ struct evsel *evlist__add_aux_dummy(struct evlist *evlist, bool system_wide)
 	evsel->core.attr.exclude_kernel = 1;
 	evsel->core.attr.exclude_guest = 1;
 	evsel->core.attr.exclude_hv = 1;
-	evsel->core.attr.freq = 0;
-	evsel->core.attr.sample_period = 1;
 	evsel->core.system_wide = system_wide;
 	evsel->no_aux_samples = true;
 	evsel->name = strdup("dummy:u");
-- 
2.42.0



