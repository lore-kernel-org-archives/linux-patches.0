Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26AD7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCA3C433C7;
	Sun, 17 Sep 2023 19:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980039;
	bh=D8FTanhLaog0tkefOkcOEUiqo9sH1hFugOgEUEZ/32Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uryOUL1cWTXeBMj3+SmMIIChauK+IXwCcX7xLUgQOReTNPywLA6/wcuGzSoisVLRx
	 HEpX/nkMDD94A01CXEPJn+yKb64mqQX5JIBlZtN25g452MhTmHE3QwMvNFM4QO0Op8
	 PPH6VAlAVN6EeCcG2TE1sXwDwzSnFmyMbFZ2yei8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Babrou <ivan@cloudflare.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	kernel-team@cloudflare.com,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 080/285] perf script: Print "cgroup" field on the same line as "comm"
Date: Sun, 17 Sep 2023 21:11:20 +0200
Message-ID: <20230917191054.479670333@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Babrou <ivan@cloudflare.com>

[ Upstream commit 8c49c6e1a7b790c4cb9f464c5485117451d91c60 ]

Commit 3fd7a168bf51 ("perf script: Add 'cgroup' field for output")
added support for printing cgroup path in perf script output.

It was okay if you didn't want any stacks:

    $ sudo perf script --comms jpegtran:23f4bf -F comm,tid,cpu,time,cgroup
    jpegtran:23f4bf 3321915 [013] 404718.587488:  /idle.slice/polish.service
    jpegtran:23f4bf 3321915 [031] 404718.592073:  /idle.slice/polish.service

With stacks it gets messier as cgroup is printed after the stack:

    $ perf script --comms jpegtran:23f4bf -F comm,tid,cpu,time,cgroup,ip,sym
    jpegtran:23f4bf 3321915 [013] 404718.587488:
                    5c554 compress_output
                    570d9 jpeg_finish_compress
                    3476e jpegtran_main
                    330ee jpegtran::main
                    326e2 core::ops::function::FnOnce::call_once (inlined)
                    326e2 std::sys_common::backtrace::__rust_begin_short_backtrace
    /idle.slice/polish.service
    jpegtran:23f4bf 3321915 [031] 404718.592073:
                    8474d jsimd_encode_mcu_AC_first_prepare_sse2.PADDING
                55af68e62fff [unknown]
    /idle.slice/polish.service

Let's instead print cgroup on the same line as comm:

    $ perf script --comms jpegtran:23f4bf -F comm,tid,cpu,time,cgroup,ip,sym
    jpegtran:23f4bf 3321915 [013] 404718.587488:  /idle.slice/polish.service
                    5c554 compress_output
                    570d9 jpeg_finish_compress
                    3476e jpegtran_main
                    330ee jpegtran::main
                    326e2 core::ops::function::FnOnce::call_once (inlined)
                    326e2 std::sys_common::backtrace::__rust_begin_short_backtrace

    jpegtran:23f4bf 3321915 [031] 404718.592073:  /idle.slice/polish.service
                    8474d jsimd_encode_mcu_AC_first_prepare_sse2.PADDING
                55af68e62fff [unknown]

Fixes: 3fd7a168bf514979 ("perf script: Add 'cgroup' field for output")
Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-team@cloudflare.com
Link: https://lore.kernel.org/r/20230718000737.49077-1-ivan@cloudflare.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 200b3e7ea8dad..517bf25750c8b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2199,6 +2199,17 @@ static void process_event(struct perf_script *script,
 	if (PRINT_FIELD(RETIRE_LAT))
 		fprintf(fp, "%16" PRIu16, sample->retire_lat);
 
+	if (PRINT_FIELD(CGROUP)) {
+		const char *cgrp_name;
+		struct cgroup *cgrp = cgroup__find(machine->env,
+						   sample->cgroup);
+		if (cgrp != NULL)
+			cgrp_name = cgrp->name;
+		else
+			cgrp_name = "unknown";
+		fprintf(fp, " %s", cgrp_name);
+	}
+
 	if (PRINT_FIELD(IP)) {
 		struct callchain_cursor *cursor = NULL;
 
@@ -2243,17 +2254,6 @@ static void process_event(struct perf_script *script,
 	if (PRINT_FIELD(CODE_PAGE_SIZE))
 		fprintf(fp, " %s", get_page_size_name(sample->code_page_size, str));
 
-	if (PRINT_FIELD(CGROUP)) {
-		const char *cgrp_name;
-		struct cgroup *cgrp = cgroup__find(machine->env,
-						   sample->cgroup);
-		if (cgrp != NULL)
-			cgrp_name = cgrp->name;
-		else
-			cgrp_name = "unknown";
-		fprintf(fp, " %s", cgrp_name);
-	}
-
 	perf_sample__fprintf_ipc(sample, attr, fp);
 
 	fprintf(fp, "\n");
-- 
2.40.1



