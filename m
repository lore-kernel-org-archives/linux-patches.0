Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FAD7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC418C433C7;
	Sun, 17 Sep 2023 20:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981849;
	bh=nV+olbpluTlkhnMzUvXkYmqB9mWX8A5iWfdBmQN6htI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlrGVwgxiqCIyp5H+Kdaa8MC4rxdpeHsoQgg2hvPVoi3ftNKZB2qpcCcxrlnEqIxU
	 to1qLwo/XuZ4mem5ji/EPOOfJlV3AjxXER40FwK9yWBkrjHo1sRd8iOU3UIupK+jQU
	 veq3fprn/kDud0CXxSlPwTet1CxTWCzW+mKY9vYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.1 180/219] perf tools: Handle old data in PERF_RECORD_ATTR
Date: Sun, 17 Sep 2023 21:15:07 +0200
Message-ID: <20230917191047.463907746@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit 9bf63282ea77a531ea58acb42fb3f40d2d1e4497 upstream.

The PERF_RECORD_ATTR is used for a pipe mode to describe an event with
attribute and IDs.  The ID table comes after the attr and it calculate
size of the table using the total record size and the attr size.

  n_ids = (total_record_size - end_of_the_attr_field) / sizeof(u64)

This is fine for most use cases, but sometimes it saves the pipe output
in a file and then process it later.  And it becomes a problem if there
is a change in attr size between the record and report.

  $ perf record -o- > perf-pipe.data  # old version
  $ perf report -i- < perf-pipe.data  # new version

For example, if the attr size is 128 and it has 4 IDs, then it would
save them in 168 byte like below:

   8 byte: perf event header { .type = PERF_RECORD_ATTR, .size = 168 },
 128 byte: perf event attr { .size = 128, ... },
  32 byte: event IDs [] = { 1234, 1235, 1236, 1237 },

But when report later, it thinks the attr size is 136 then it only read
the last 3 entries as ID.

   8 byte: perf event header { .type = PERF_RECORD_ATTR, .size = 168 },
 136 byte: perf event attr { .size = 136, ... },
  24 byte: event IDs [] = { 1235, 1236, 1237 },  // 1234 is missing

So it should use the recorded version of the attr.  The attr has the
size field already then it should honor the size when reading data.

Fixes: 2c46dbb517a10b18 ("perf: Convert perf header attrs into attr events")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230825152552.112913-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/header.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -4331,7 +4331,8 @@ int perf_event__process_attr(struct perf
 			     union perf_event *event,
 			     struct evlist **pevlist)
 {
-	u32 i, ids, n_ids;
+	u32 i, n_ids;
+	u64 *ids;
 	struct evsel *evsel;
 	struct evlist *evlist = *pevlist;
 
@@ -4347,9 +4348,8 @@ int perf_event__process_attr(struct perf
 
 	evlist__add(evlist, evsel);
 
-	ids = event->header.size;
-	ids -= (void *)&event->attr.id - (void *)event;
-	n_ids = ids / sizeof(u64);
+	n_ids = event->header.size - sizeof(event->header) - event->attr.attr.size;
+	n_ids = n_ids / sizeof(u64);
 	/*
 	 * We don't have the cpu and thread maps on the header, so
 	 * for allocating the perf_sample_id table we fake 1 cpu and
@@ -4358,8 +4358,9 @@ int perf_event__process_attr(struct perf
 	if (perf_evsel__alloc_id(&evsel->core, 1, n_ids))
 		return -ENOMEM;
 
+	ids = (void *)&event->attr.attr + event->attr.attr.size;
 	for (i = 0; i < n_ids; i++) {
-		perf_evlist__id_add(&evlist->core, &evsel->core, 0, i, event->attr.id[i]);
+		perf_evlist__id_add(&evlist->core, &evsel->core, 0, i, ids[i]);
 	}
 
 	return 0;


