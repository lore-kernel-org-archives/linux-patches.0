Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE63F23BE;
	Sat, 12 Sep 2026 10:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209871; cv=none; b=nD61s/HsflGUL8++U51Jf2kY2wmtYBRriwyNkhg/2aC8L5lidx+gw7gmjudPk+UN294wJCMQt3ZlToPK3TAEq5OtelMQsit0IcT/d5xMdeZO/IhuV0zsyMvKfl0UHoLmsCeZzQ+EafvbDmAknm685z9m6EeMp9x0MxFEA8pQG3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209871; c=relaxed/simple;
	bh=tvfQenSyFG5EsqKBzwMs++Y1OAskFOiZw7J1p3ukmTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGta50RCEHaLzcEPSyfgm1DXg9LDTUrIjRN+6YpC17Mu73GYlsLLj7KJlTSa3rVH1Cp0eVEiWKQP/cJnUzBJddZq5BEXhy2Y07PuR+gRDGD1BuawV0pzSz++LHCkKNjWJoWopOieSMvjJ2Z6B6CRoOhidol2ONG3+legORqfUlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncCwVlg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncCwVlg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692D61F000FF;
	Sat, 12 Sep 2026 10:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209869;
	bh=UczOtFoGkb7OgUNLyS1jpaWp3o7MdbKCM1ZAyve5YxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncCwVlg5Ng0h/RjM41BMsXQVW7750aBM7IuEvRgiH+L5zsy6QF8wasOxk5ISA3nyg
	 NsF/k6fJv3MkJB4QSOtlSOuOQSR9uJoteE+S7jbGS4IokrXmSQ6eBjbCZj3rlWolFx
	 ZFwGAg8BC3nJJrgs894upLYOBfmFRNdhGVhf8tfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0909/1518] perf c2c: Fix error masking, OOM, and unchecked caller errors in hpp_list__parse()
Date: Sat, 12 Sep 2026 08:51:18 +0200
Message-ID: <20260912065644.016842449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f53f5c2437c1bd76fc0063a30a069a5207de8802 ]

hpp_list__parse() has three bugs:

1. The PARSE_LIST macro resets ret = 0 at the start of each invocation,
   so an error from output parsing is silently overwritten when the sort
   parsing block runs.  The function returns success with partially
   initialized state.

2. When the caller passes a non-NULL output_ or sort_ string, but
   strdup() returns NULL due to OOM, NULL is passed to PARSE_LIST which
   treats it as empty input (the "if (!_list) break" branch).  No error
   is returned.

3. When the called _fn function fails and returns something other than
   -ESRCH or -EINVAL (-ENOMEM, for instance) it was not bailing out of
   the strtok loop.

Fix them by checking strdup() return values before proceeding and adding
a cleanup label so that ret from each PARSE_LIST call is checked before
the next runs, preserving the first error.

The early exits now skip perf_hpp__setup_output_field(), which means
c2c_hists__reinit() can return a non-zero value in cases that previously
always succeeded silently.  Both callers discarded its return:
resort_cl_cb() continued into hists__collapse_resort() on a broken list,
and perf_c2c__report() proceeded with uninitialised hists.  Fix the full
chain: check and propagate the error in resort_cl_cb() -- hists__iterate_cb()
already stops iteration and returns the callback error -- and check both
c2c_hists__reinit() and hists__iterate_cb() in perf_c2c__report().

Also turn PARSE_LIST into a function, using a switch to catch other
errors, converting the called functions to return an appropriate errno
instead of -1 on failure.

Also make the two callers that iterate sort_dimension__add() and
output_field_add() handle the newly propagated errors: setup_sort_list()
and setup_output_list() only checked for -EINVAL and -ESRCH, so an
-ENOMEM from a failed allocation was silently overwritten by the next
loop iteration.  Break out of the loop and propagate any other error.

The hpp_list__parse() fixes were developed with AI assistance from
Claude:claude-sonnet-4.6, and the setup_sort_list()/setup_output_list()
caller fixes with AI assistance from Opencode:mimo-v2.5-free and
Opencode:DeepSeek-V4-Flash-free.

Fixes: 2d388bd0c9d3 ("perf c2c report: Add stdio output support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-sonnet-4.6
Assisted-by: Opencode:mimo-v2.5-free
Assisted-by: Opencode:DeepSeek-V4-Flash-free
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 85 ++++++++++++++++++++++++++++------------
 tools/perf/util/sort.c   | 76 +++++++++++++++++++++++------------
 2 files changed, 112 insertions(+), 49 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 0a0ca054f115c..dd4e6e40538f6 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -12,11 +12,14 @@
  */
 #include <errno.h>
 #include <inttypes.h>
+#include <stdlib.h>
+#include <string.h>
 
 #include <asm/bug.h>
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/stringify.h>
 #include <linux/zalloc.h>
 #include <sys/param.h>
@@ -2068,26 +2071,38 @@ static int c2c_hists__init_sort(struct perf_hpp_list *hpp_list, char *name, stru
 	return 0;
 }
 
-#define PARSE_LIST(_list, _fn)							\
-	do {									\
-		char *tmp, *tok;						\
-		ret = 0;							\
-										\
-		if (!_list)							\
-			break;							\
-										\
-		for (tok = strtok_r((char *)_list, ", ", &tmp);			\
-				tok; tok = strtok_r(NULL, ", ", &tmp)) {	\
-			ret = _fn(hpp_list, tok, env);				\
-			if (ret == -EINVAL) {					\
-				pr_err("Invalid --fields key: `%s'", tok);	\
-				break;						\
-			} else if (ret == -ESRCH) {				\
-				pr_err("Unknown --fields key: `%s'", tok);	\
-				break;						\
-			}							\
-		}								\
-	} while (0)
+static int __hpp_list__parse(struct perf_hpp_list *hpp_list, char *_list, struct perf_env *env,
+			     int (*_fn)(struct perf_hpp_list *hpp_list, char *name, struct perf_env *env))
+{
+	char *tmp, *tok;
+	int ret = 0;
+
+	if (!_list)
+		return 0;
+
+	for (tok = strtok_r(_list, ", ", &tmp); tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		ret = _fn(hpp_list, tok, env);
+		switch (ret) {
+		case 0:
+			continue;
+		case -EINVAL:
+			pr_err("Invalid --fields key: `%s'", tok);
+			goto out;
+		case -ESRCH:
+			pr_err("Unknown --fields key: `%s'", tok);
+			goto out;
+		default: {
+			char buf[STRERR_BUFSIZE];
+
+			pr_err("%s for --fields key: `%s'",
+			       str_error_r(-ret, buf, sizeof(buf)), tok);
+			goto out;
+		}
+		}
+	}
+out:
+	return ret;
+}
 
 static int hpp_list__parse(struct perf_hpp_list *hpp_list,
 			   const char *output_,
@@ -2098,8 +2113,18 @@ static int hpp_list__parse(struct perf_hpp_list *hpp_list,
 	char *sort   = sort_   ? strdup(sort_) : NULL;
 	int ret;
 
-	PARSE_LIST(output, c2c_hists__init_output);
-	PARSE_LIST(sort,   c2c_hists__init_sort);
+	/* strdup() returns NULL on OOM, don't silently treat as empty */
+	if ((output_ && !output) || (sort_ && !sort)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = __hpp_list__parse(hpp_list, output, env, c2c_hists__init_output);
+	if (ret)
+		goto out;
+	ret = __hpp_list__parse(hpp_list, sort, env, c2c_hists__init_sort);
+	if (ret)
+		goto out;
 
 	/* copy sort keys to output fields */
 	perf_hpp__setup_output_field(hpp_list);
@@ -2116,6 +2141,7 @@ static int hpp_list__parse(struct perf_hpp_list *hpp_list,
 	perf_hpp__append_sort_keys(&hists->list);
 #endif
 
+out:
 	free(output);
 	free(sort);
 	return ret;
@@ -2286,6 +2312,7 @@ static int resort_cl_cb(struct hist_entry *he, void *arg)
 	struct c2c_hist_entry *c2c_he;
 	struct c2c_hists *c2c_hists;
 	bool display = he__display(he, &c2c.shared_clines_stats);
+	int ret;
 
 	c2c_he = container_of(he, struct c2c_hist_entry, he);
 	c2c_hists = c2c_he->hists;
@@ -2296,7 +2323,9 @@ static int resort_cl_cb(struct hist_entry *he, void *arg)
 		c2c_he->cacheline_idx = idx++;
 		calc_width(c2c_he);
 
-		c2c_hists__reinit(c2c_hists, c2c.cl_output, c2c.cl_resort, env);
+		ret = c2c_hists__reinit(c2c_hists, c2c.cl_output, c2c.cl_resort, env);
+		if (ret)
+			return ret;
 
 		hists__collapse_resort(&c2c_hists->hists, NULL);
 		hists__output_resort_cb(&c2c_hists->hists, NULL, filter_cb);
@@ -3356,13 +3385,19 @@ static int perf_c2c__report(int argc, const char **argv)
 	else if (c2c.display == DISPLAY_SNP_PEER)
 		sort_str = "tot_peer";
 
-	c2c_hists__reinit(&c2c.hists, output_str, sort_str, perf_session__env(session));
+	err = c2c_hists__reinit(&c2c.hists, output_str, sort_str, perf_session__env(session));
+	if (err) {
+		pr_err("Failed to reinitialize hists\n");
+		goto out_mem2node;
+	}
 
 	ui_progress__init(&prog, c2c.hists.hists.nr_entries, "Sorting...");
 
 	hists__collapse_resort(&c2c.hists.hists, NULL);
 	hists__output_resort_cb(&c2c.hists.hists, &prog, resort_shared_cl_cb);
-	hists__iterate_cb(&c2c.hists.hists, resort_cl_cb, perf_session__env(session));
+	err = hists__iterate_cb(&c2c.hists.hists, resort_cl_cb, perf_session__env(session));
+	if (err)
+		goto out_mem2node;
 
 	ui_progress__finish();
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f963d61ac166f..ceabfca862407 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2957,7 +2957,7 @@ static int __sort_dimension__add_hpp_sort(struct sort_dimension *sd,
 	struct hpp_sort_entry *hse = __sort_dimension__alloc_hpp(sd, level);
 
 	if (hse == NULL)
-		return -1;
+		return -ENOMEM;
 
 	perf_hpp_list__register_sort_field(list, &hse->hpp);
 	return 0;
@@ -2970,7 +2970,7 @@ static int __sort_dimension__add_hpp_output(struct sort_dimension *sd,
 	struct hpp_sort_entry *hse = __sort_dimension__alloc_hpp(sd, level);
 
 	if (hse == NULL)
-		return -1;
+		return -ENOMEM;
 
 	perf_hpp_list__column_register(list, &hse->hpp);
 	return 0;
@@ -3592,14 +3592,18 @@ static int __sort_dimension__add(struct sort_dimension *sd,
 				 struct perf_hpp_list *list,
 				 int level)
 {
+	int ret;
+
 	if (sd->taken)
 		return 0;
 
-	if (__sort_dimension__add_hpp_sort(sd, list, level) < 0)
-		return -1;
+	ret = __sort_dimension__add_hpp_sort(sd, list, level);
+	if (ret < 0)
+		return ret;
 
-	if (__sort_dimension__update(sd, list) < 0)
-		return -1;
+	ret = __sort_dimension__update(sd, list);
+	if (ret < 0)
+		return ret;
 
 	sd->taken = 1;
 
@@ -3617,7 +3621,7 @@ static int __hpp_dimension__add(struct hpp_dimension *hd,
 
 	fmt = __hpp_dimension__alloc_hpp(hd, level);
 	if (!fmt)
-		return -1;
+		return -ENOMEM;
 
 	hd->taken = 1;
 	hd->was_taken = 1;
@@ -3629,14 +3633,18 @@ static int __sort_dimension__add_output(struct perf_hpp_list *list,
 					struct sort_dimension *sd,
 					int level)
 {
+	int ret;
+
 	if (sd->taken)
 		return 0;
 
-	if (__sort_dimension__add_hpp_output(sd, list, level) < 0)
-		return -1;
+	ret = __sort_dimension__add_hpp_output(sd, list, level);
+	if (ret < 0)
+		return ret;
 
-	if (__sort_dimension__update(sd, list) < 0)
-		return -1;
+	ret = __sort_dimension__update(sd, list);
+	if (ret < 0)
+		return ret;
 
 	sd->taken = 1;
 	return 0;
@@ -3653,7 +3661,7 @@ static int __hpp_dimension__add_output(struct perf_hpp_list *list,
 
 	fmt = __hpp_dimension__alloc_hpp(hd, level);
 	if (!fmt)
-		return -1;
+		return -ENOMEM;
 
 	hd->taken = 1;
 	perf_hpp_list__column_register(list, fmt);
@@ -3719,8 +3727,7 @@ int sort_dimension__add(struct perf_hpp_list *list, const char *tok,
 				    strlen(tok)))
 			return -EINVAL;
 
-		__sort_dimension__add(sd, list, level);
-		return 0;
+		return __sort_dimension__add(sd, list, level);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
@@ -3732,8 +3739,7 @@ int sort_dimension__add(struct perf_hpp_list *list, const char *tok,
 		if (sort__mode != SORT_MODE__MEMORY)
 			return -EINVAL;
 
-		__sort_dimension__add(sd, list, level);
-		return 0;
+		return __sort_dimension__add(sd, list, level);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++) {
@@ -3823,15 +3829,25 @@ static int setup_sort_list(struct perf_hpp_list *list, char *str,
 			}
 
 			ret = sort_dimension__add(list, tok, evlist, env, level);
-			if (ret == -EINVAL) {
+			switch (ret) {
+			case 0:
+				break;
+			case -EINVAL:
 				if (!cacheline_size() && !strncasecmp(tok, "dcacheline", strlen(tok)))
 					ui__error("The \"dcacheline\" --sort key needs to know the cacheline size and it couldn't be determined on this system");
 				else
 					ui__error("Invalid --sort key: `%s'", tok);
-				break;
-			} else if (ret == -ESRCH) {
+				goto out;
+			case -ESRCH:
 				ui__error("Unknown --sort key: `%s'", tok);
-				break;
+				goto out;
+			default: {
+				char buf[STRERR_BUFSIZE];
+
+				ui__error("%s for --sort key: `%s'",
+					  str_error_r(-ret, buf, sizeof(buf)), tok);
+				goto out;
+			}
 			}
 			prev_level = level;
 		}
@@ -3839,6 +3855,7 @@ static int setup_sort_list(struct perf_hpp_list *list, char *str,
 		level = next_level;
 	} while (tmp);
 
+out:
 	return ret;
 }
 
@@ -4164,15 +4181,26 @@ static int setup_output_list(struct perf_hpp_list *list, char *str)
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
 		ret = output_field_add(list, tok, &level);
-		if (ret == -EINVAL) {
-			ui__error("Invalid --fields key: `%s'", tok);
+		switch (ret) {
+		case 0:
 			break;
-		} else if (ret == -ESRCH) {
+		case -EINVAL:
+			ui__error("Invalid --fields key: `%s'", tok);
+			goto out;
+		case -ESRCH:
 			ui__error("Unknown --fields key: `%s'", tok);
-			break;
+			goto out;
+		default: {
+			char buf[STRERR_BUFSIZE];
+
+			ui__error("%s for --fields key: `%s'",
+				  str_error_r(-ret, buf, sizeof(buf)), tok);
+			goto out;
+		}
 		}
 	}
 
+out:
 	return ret;
 }
 
-- 
2.53.0



