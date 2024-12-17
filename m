Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3B31FC0EC;
	Tue, 17 Dec 2024 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456672; cv=none; b=AHcMU+KqPghbMfks05vCSwu6RivDnjrKqxFia53u49v4vjputSkIdXBt0G+TqL14IKPnAbVaME/ch2o4DM8oFviSGB2Obw8UH5uIlhZzqS9yrFiPpTAogwUvsJsvrU0BTmBljE0r3DZIh0pT3wjOoMKfmOEgBAHUpbyzZ4kImyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456672; c=relaxed/simple;
	bh=W36Wk2kzdUdAvcDBjKJg76WHbYxY13jvOb3bTOA+6Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqK8gjISI1n2T95FlzqKohs4YRPzYXC9tVtvO5wSXu928ZD/fIWJv+lcr2cAqY0YKSuodOJjAGRqlOmUAJzzIJchmCHxt9jsJn2lVqwaUEo90fiHBHPEUYgiWC00hKLTlGU/xG3uKrJp1CDzuB/rZkb1sO3umdv3vZVLMLQw754=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcTnxyxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcTnxyxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60EAC4CED3;
	Tue, 17 Dec 2024 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456672;
	bh=W36Wk2kzdUdAvcDBjKJg76WHbYxY13jvOb3bTOA+6Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcTnxyxlEhEAHhyK98ryueupvSN+q0PCwx+okyyQtrXddoKfSvFyzi9QHRtE3uvKp
	 9JB568t+sr0uonUlYb9x2h5PksyQe1/km4oMZZfuJ+kLAsn4D05gNmQ8UI1IAD1CGM
	 tNmajVhDiVSPhqW3bBQ9secpqGcwSfbFgRFV+SJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/172] libperf: evlist: Fix --cpu argument on hybrid platform
Date: Tue, 17 Dec 2024 18:08:06 +0100
Message-ID: <20241217170551.730535063@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit f7e36d02d771ee14acae1482091718460cffb321 ]

Since the linked fixes: commit, specifying a CPU on hybrid platforms
results in an error because Perf tries to open an extended type event
on "any" CPU which isn't valid. Extended type events can only be opened
on CPUs that match the type.

Before (working):

  $ perf record --cpu 1 -- true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 2.385 MB perf.data (7 samples) ]

After (not working):

  $ perf record -C 1 -- true
  WARNING: A requested CPU in '1' is not supported by PMU 'cpu_atom' (CPUs 16-27) for event 'cycles:P'
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (cpu_atom/cycles:P/).
  /bin/dmesg | grep -i perf may provide additional information.

(Ignore the warning message, that's expected and not particularly
relevant to this issue).

This is because perf_cpu_map__intersect() of the user specified CPU (1)
and one of the PMU's CPUs (16-27) correctly results in an empty (NULL)
CPU map. However for the purposes of opening an event, libperf converts
empty CPU maps into an any CPU (-1) which the kernel rejects.

Fix it by deleting evsels with empty CPU maps in the specific case where
user requested CPU maps are evaluated.

Fixes: 251aa040244a ("perf parse-events: Wildcard most "numeric" events")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20241114160450.295844-2-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index c6d67fc9e57e..83c43dc13313 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -47,6 +47,20 @@ static void __perf_evlist__propagate_maps(struct perf_evlist *evlist,
 		 */
 		perf_cpu_map__put(evsel->cpus);
 		evsel->cpus = perf_cpu_map__intersect(evlist->user_requested_cpus, evsel->own_cpus);
+
+		/*
+		 * Empty cpu lists would eventually get opened as "any" so remove
+		 * genuinely empty ones before they're opened in the wrong place.
+		 */
+		if (perf_cpu_map__is_empty(evsel->cpus)) {
+			struct perf_evsel *next = perf_evlist__next(evlist, evsel);
+
+			perf_evlist__remove(evlist, evsel);
+			/* Keep idx contiguous */
+			if (next)
+				list_for_each_entry_from(next, &evlist->entries, node)
+					next->idx--;
+		}
 	} else if (!evsel->own_cpus || evlist->has_user_cpus ||
 		(!evsel->requires_cpu && perf_cpu_map__has_any_cpu(evlist->user_requested_cpus))) {
 		/*
@@ -80,11 +94,11 @@ static void __perf_evlist__propagate_maps(struct perf_evlist *evlist,
 
 static void perf_evlist__propagate_maps(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel, *n;
 
 	evlist->needs_map_propagation = true;
 
-	perf_evlist__for_each_evsel(evlist, evsel)
+	list_for_each_entry_safe(evsel, n, &evlist->entries, node)
 		__perf_evlist__propagate_maps(evlist, evsel);
 }
 
-- 
2.39.5



