Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3F01C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D76C433EF;
	Wed, 28 Dec 2022 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246571;
	bh=aUsKvdG3nUsHTgnW+Cgf0k4Wr+owAUxm8FlOTM28c7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBtVTgrUM+t22rYs703itOlihjgJ4HCclVi/uDHPs0NHudO9HMMAnUV9WPiAGdjPG
	 Fqmmgwv6z06pQgpb6eYatuo8yo9Q8G1iwpxEbddamwbbO5oAAu08LgrHzmUs+sSqBv
	 LwuIQBOrruNwNKEWAASOfjxt7EtVX9WshtEMLVJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Carsten Haitzler <carsten.haitzler@arm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1085/1146] perf probe: Check -v and -q options in the right place
Date: Wed, 28 Dec 2022 15:43:44 +0100
Message-Id: <20221228144359.670992726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 8b269b75551227796c1ddac2dbdb2ba504158c61 ]

Check the -q and -v options first to return earlier on error.

Before:

  # perf probe -q -v test
  probe-definition(0): test
  symbol:test file:(null) line:0 offset:0 return:0 lazy:(null)
  0 arguments
    Error: -v and -q are exclusive.

After:

  # perf probe -q -v test
    Error: -v and -q are exclusive.

Fixes: 5e17b28f1e246b98 ("perf probe: Add --quiet option to suppress output result message")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Carsten Haitzler <carsten.haitzler@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20221220035702.188413-4-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-probe.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2ae50fc9e597..ed73d0b89ca2 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -612,6 +612,15 @@ __cmd_probe(int argc, const char **argv)
 
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (quiet) {
+		if (verbose != 0) {
+			pr_err("  Error: -v and -q are exclusive.\n");
+			return -EINVAL;
+		}
+		verbose = -1;
+	}
+
 	if (argc > 0) {
 		if (strcmp(argv[0], "-") == 0) {
 			usage_with_options_msg(probe_usage, options,
@@ -633,14 +642,6 @@ __cmd_probe(int argc, const char **argv)
 	if (ret)
 		return ret;
 
-	if (quiet) {
-		if (verbose != 0) {
-			pr_err("  Error: -v and -q are exclusive.\n");
-			return -EINVAL;
-		}
-		verbose = -1;
-	}
-
 	if (probe_conf.max_probes == 0)
 		probe_conf.max_probes = MAX_PROBES;
 
-- 
2.35.1



