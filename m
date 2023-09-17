Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B96FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300DCC433C7;
	Sun, 17 Sep 2023 19:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979665;
	bh=roCuYcG/qNZj3VN3VCl7lU4TUeE0dXaXWF6i9m6BCxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcMLcZLWBo0dSzYMNYiWTF6BFRngPZJJ+VR2MeLsjgmQcfcrh4ZHHdjIiiMKYBZh/
	 H4TTnEMkdY6zPiLedX9xOOeQSdUqTV0FDVYJeS9g56+SqxUGmESP3CZ/zmL3gx7QvT
	 buwb1ljDttevqcW4omJDI/+PHEelyia0yw7tlm2s=
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
Subject: [PATCH 5.10 379/406] perf tools: Handle old data in PERF_RECORD_ATTR
Date: Sun, 17 Sep 2023 21:13:53 +0200
Message-ID: <20230917191111.272910936@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3987,7 +3987,8 @@ int perf_event__process_attr(struct perf
 			     union perf_event *event,
 			     struct evlist **pevlist)
 {
-	u32 i, ids, n_ids;
+	u32 i, n_ids;
+	u64 *ids;
 	struct evsel *evsel;
 	struct evlist *evlist = *pevlist;
 
@@ -4003,9 +4004,8 @@ int perf_event__process_attr(struct perf
 
 	evlist__add(evlist, evsel);
 
-	ids = event->header.size;
-	ids -= (void *)&event->attr.id - (void *)event;
-	n_ids = ids / sizeof(u64);
+	n_ids = event->header.size - sizeof(event->header) - event->attr.attr.size;
+	n_ids = n_ids / sizeof(u64);
 	/*
 	 * We don't have the cpu and thread maps on the header, so
 	 * for allocating the perf_sample_id table we fake 1 cpu and
@@ -4014,8 +4014,9 @@ int perf_event__process_attr(struct perf
 	if (perf_evsel__alloc_id(&evsel->core, 1, n_ids))
 		return -ENOMEM;
 
+	ids = (void *)&event->attr.attr + event->attr.attr.size;
 	for (i = 0; i < n_ids; i++) {
-		perf_evlist__id_add(&evlist->core, &evsel->core, 0, i, event->attr.id[i]);
+		perf_evlist__id_add(&evlist->core, &evsel->core, 0, i, ids[i]);
 	}
 
 	return 0;


