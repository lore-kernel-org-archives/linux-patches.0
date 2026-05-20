Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FDF3E123F;
	Wed, 20 May 2026 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298699; cv=none; b=KPB9yih05HQ5DC774SSjYwFmOhgk1WX60BhwFqI7doqQpreG5lj01Xxy4VTpy3Yck4CuwXBu5/UkHUONWxJhk1nkko9MoKDxNKix0+BHlgfAfVet+WdrL8APW68RKVEP1tUB9r24JRcpfcuyhlWfKckmAtO5wiHpdkJq4fIpyjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298699; c=relaxed/simple;
	bh=sGq9d1SOj7p9mUArv43d6QKt/8jjWpqD5Mlb73X5ftk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzbk0fOzuAyQ55jwEfXg+5fvuuLwvpjsKb1XvdKBaj49zkUerD5jF5/Ugq2f2fgTGkv4H24dKDQVJC3U5/ZP7pE6Q00x26H4AAeVfZ+CAD4W3Qm88gRGcxJ+5SoQtJyri0o84t7icbomlRbbK9xopZGy8nP+NyfffzeRbJvgiDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMWA3RyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMWA3RyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E311F000E9;
	Wed, 20 May 2026 17:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298698;
	bh=eDkDZmvrCAZggG/s5eVVvRgL650h+vG79GaCrp48wZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMWA3RyUpnx6xWvcHmgl+Kb90XugFOu8siZtzPiPX30gNa8j4oGSpV+uiw4YnpxGj
	 kBrjZReP/bSqmAv72D1unKYAdEDCS5A/ievvmV+vL9E6ZgWt3X0db4/Xw4ltpXyT1T
	 0eIVoT4I3D53kOlV/p6tiCSpauwhURwcaQgvwdpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 510/957] perf stat: Fix opt->value type for parse_cache_level
Date: Wed, 20 May 2026 18:16:33 +0200
Message-ID: <20260520162145.597486000@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 44311ae84ad9177fb311aee856027861c22f17b2 ]

Commit f5803651b4a4 ("perf stat: Choose the most disaggregate command
line option") changed aggregation option handling for `perf stat` but
not `perf stat report` leading to parse_cache_level being passed a
struct in the `perf stat` case but erroneously an aggr_mode enum value
for `perf stat report`. Change the `perf stat report` aggregation
handling to use the same opt_aggr_mode as `perf stat`. Also, just pass
the boolean for consistency with other boolean argument handling.

Fixes: f5803651b4a4 ("perf stat: Choose the most disaggregate command line option")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 43 +++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b6533dcf5465b..9eb0876633c05 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -153,7 +153,7 @@ struct opt_aggr_mode {
 };
 
 /* Turn command line option into most generic aggregation mode setting. */
-static enum aggr_mode opt_aggr_mode_to_aggr_mode(struct opt_aggr_mode *opt_mode)
+static enum aggr_mode opt_aggr_mode_to_aggr_mode(const struct opt_aggr_mode *opt_mode)
 {
 	enum aggr_mode mode = AGGR_GLOBAL;
 
@@ -1161,8 +1161,8 @@ static int parse_cache_level(const struct option *opt,
 			     int unset __maybe_unused)
 {
 	int level;
-	struct opt_aggr_mode *opt_aggr_mode = (struct opt_aggr_mode *)opt->value;
-	u32 *aggr_level = (u32 *)opt->data;
+	bool *per_cache = opt->value;
+	u32 *aggr_level = opt->data;
 
 	/*
 	 * If no string is specified, aggregate based on the topology of
@@ -1200,7 +1200,7 @@ static int parse_cache_level(const struct option *opt,
 		return -EINVAL;
 	}
 out:
-	opt_aggr_mode->cache = true;
+	*per_cache = true;
 	*aggr_level = level;
 	return 0;
 }
@@ -2262,24 +2262,23 @@ static struct perf_stat perf_stat = {
 static int __cmd_report(int argc, const char **argv)
 {
 	struct perf_session *session;
+	struct opt_aggr_mode opt_mode = {};
 	const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
-	OPT_SET_UINT(0, "per-socket", &perf_stat.aggr_mode,
-		     "aggregate counts per processor socket", AGGR_SOCKET),
-	OPT_SET_UINT(0, "per-die", &perf_stat.aggr_mode,
-		     "aggregate counts per processor die", AGGR_DIE),
-	OPT_SET_UINT(0, "per-cluster", &perf_stat.aggr_mode,
-		     "aggregate counts perf processor cluster", AGGR_CLUSTER),
-	OPT_CALLBACK_OPTARG(0, "per-cache", &perf_stat.aggr_mode, &perf_stat.aggr_level,
-			    "cache level",
-			    "aggregate count at this cache level (Default: LLC)",
+	OPT_BOOLEAN(0, "per-thread", &opt_mode.thread, "aggregate counts per thread"),
+	OPT_BOOLEAN(0, "per-socket", &opt_mode.socket,
+		    "aggregate counts per processor socket"),
+	OPT_BOOLEAN(0, "per-die", &opt_mode.die, "aggregate counts per processor die"),
+	OPT_BOOLEAN(0, "per-cluster", &opt_mode.cluster,
+		    "aggregate counts per processor cluster"),
+	OPT_CALLBACK_OPTARG(0, "per-cache", &opt_mode.cache, &perf_stat.aggr_level,
+			    "cache level", "aggregate count at this cache level (Default: LLC)",
 			    parse_cache_level),
-	OPT_SET_UINT(0, "per-core", &perf_stat.aggr_mode,
-		     "aggregate counts per physical processor core", AGGR_CORE),
-	OPT_SET_UINT(0, "per-node", &perf_stat.aggr_mode,
-		     "aggregate counts per numa node", AGGR_NODE),
-	OPT_SET_UINT('A', "no-aggr", &perf_stat.aggr_mode,
-		     "disable CPU count aggregation", AGGR_NONE),
+	OPT_BOOLEAN(0, "per-core", &opt_mode.core,
+		    "aggregate counts per physical processor core"),
+	OPT_BOOLEAN(0, "per-node", &opt_mode.node, "aggregate counts per numa node"),
+	OPT_BOOLEAN('A', "no-aggr", &opt_mode.no_aggr,
+		    "disable aggregation across CPUs or PMUs"),
 	OPT_END()
 	};
 	struct stat st;
@@ -2287,6 +2286,10 @@ static int __cmd_report(int argc, const char **argv)
 
 	argc = parse_options(argc, argv, options, stat_report_usage, 0);
 
+	perf_stat.aggr_mode = opt_aggr_mode_to_aggr_mode(&opt_mode);
+	if (perf_stat.aggr_mode == AGGR_GLOBAL)
+		perf_stat.aggr_mode = AGGR_UNSET; /* No option found so leave unset. */
+
 	if (!input_name || !strlen(input_name)) {
 		if (!fstat(STDIN_FILENO, &st) && S_ISFIFO(st.st_mode))
 			input_name = "-";
@@ -2462,7 +2465,7 @@ int cmd_stat(int argc, const char **argv)
 		OPT_BOOLEAN(0, "per-die", &opt_mode.die, "aggregate counts per processor die"),
 		OPT_BOOLEAN(0, "per-cluster", &opt_mode.cluster,
 			"aggregate counts per processor cluster"),
-		OPT_CALLBACK_OPTARG(0, "per-cache", &opt_mode, &stat_config.aggr_level,
+		OPT_CALLBACK_OPTARG(0, "per-cache", &opt_mode.cache, &stat_config.aggr_level,
 				"cache level", "aggregate count at this cache level (Default: LLC)",
 				parse_cache_level),
 		OPT_BOOLEAN(0, "per-core", &opt_mode.core,
-- 
2.53.0



