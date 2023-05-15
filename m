Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E80FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D3BC433D2;
	Mon, 15 May 2023 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169598;
	bh=OeO/2ubp2e4QEVb0Tp+cJ/qWhTGJBFHQEAL0uVrP2mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEG3ltGfX/1rUNak/IDK0B6+5llvVzT3kdC0LOsqZp/8gvEVYsh7+VwCKraPG2UfJ
	 D597qMbDz+hTrfAEa17pSvreFAJIKp4/cYZXdSiY07LszsbMCWnISTUypU+BDkzUOG
	 jOkXLa5BXsA7yv/oHNR5vNcaC0EU5cruKSHgoUO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 109/246] perf ftrace: Make system wide the default target for latency subcommand
Date: Mon, 15 May 2023 18:25:21 +0200
Message-Id: <20230515161725.847304012@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit ecd4960d908e27e40b63a7046df2f942c148c6f6 ]

If no target is specified for 'latency' subcommand, the execution fails
because - 1 (invalid value) is written to set_ftrace_pid tracefs file.
Make system wide the default target, which is the same as the default
behavior of 'trace' subcommand.

Before the fix:

  # perf ftrace latency -T schedule
  failed to set ftrace pid

After the fix:

  # perf ftrace latency -T schedule
  ^C#   DURATION     |      COUNT | GRAPH                                          |
       0 - 1    us |          0 |                                                |
       1 - 2    us |          0 |                                                |
       2 - 4    us |          0 |                                                |
       4 - 8    us |       2828 | ####                                           |
       8 - 16   us |      23953 | ########################################       |
      16 - 32   us |        408 |                                                |
      32 - 64   us |        318 |                                                |
      64 - 128  us |          4 |                                                |
     128 - 256  us |          3 |                                                |
     256 - 512  us |          0 |                                                |
     512 - 1024 us |          1 |                                                |
       1 - 2    ms |          4 |                                                |
       2 - 4    ms |          0 |                                                |
       4 - 8    ms |          0 |                                                |
       8 - 16   ms |          0 |                                                |
      16 - 32   ms |          0 |                                                |
      32 - 64   ms |          0 |                                                |
      64 - 128  ms |          0 |                                                |
     128 - 256  ms |          4 |                                                |
     256 - 512  ms |          2 |                                                |
     512 - 1024 ms |          0 |                                                |
       1 - ...   s |          0 |                                                |

Fixes: 53be50282269b46c ("perf ftrace: Add 'latency' subcommand")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230324032702.109964-1-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-ftrace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index d7fe00f66b831..fb1b66ef2e167 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1228,10 +1228,12 @@ int cmd_ftrace(int argc, const char **argv)
 		goto out_delete_filters;
 	}
 
+	/* Make system wide (-a) the default target. */
+	if (!argc && target__none(&ftrace.target))
+		ftrace.target.system_wide = true;
+
 	switch (subcmd) {
 	case PERF_FTRACE_TRACE:
-		if (!argc && target__none(&ftrace.target))
-			ftrace.target.system_wide = true;
 		cmd_func = __cmd_ftrace;
 		break;
 	case PERF_FTRACE_LATENCY:
-- 
2.39.2



