Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BD643E4A1;
	Tue, 16 Jun 2026 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623110; cv=none; b=neZKd/RDiLovzcCL9bz/3eNqibDkpDPSrGFdnijqT/RaSrxdHFKIoAryiT4i9RwpPKjPfIV9BrO747VCS7t03M++iR2Ksr7FAv9z9uQf2R3DAWudPRBSJxEDNn5X+unyPdLSol9oDeYwe3eYsyKdj5ysY13jHHhSR7+LK8hTnYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623110; c=relaxed/simple;
	bh=yT4G5Ciwrov4YPAJjotMdzFOY/XpcsTp1v+4U0QaUMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqyT4MCUxTs/i2XtGjv1XayE5+1MfjFOFiyUY6RKP3WWLw6A/jE+UqUok/E3ilTPdU3CPO429KJsp7vwu7op15htzeJepLtKqSkmamN4z8TXYxWx2ncVAdqtV4TWlXGo0fXmiObcZR28cK2hDzEE8OJIlw+zb418tSMiZT6T0a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdAbgaD7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdAbgaD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A41E1F000E9;
	Tue, 16 Jun 2026 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623109;
	bh=diQc9+U4wrcwZwo694zEt86ZxOHDIeQRXDwDTM0RDJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdAbgaD7cXnhAUVJzAZwowSQtarLFQeUkD/GXZN3VgFof5rPBNGYOEN11i9Yvv0B1
	 tcT/htG/1rvc/9D1MmO4Osw70g72r4xs7b96zFtyn/7aFKxJWG1eVVnl86KkHmKJad
	 9k6tXxF+Wt6o2fluPH5o1bjGi30jsupbQvSBuHrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 089/378] rtla: Fix parsing of multi-character short options
Date: Tue, 16 Jun 2026 20:25:20 +0530
Message-ID: <20260616145114.947575865@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit e9e41d3035032ed6053d8bad7b7077e1cb3a6540 ]

A bug was reported where the parsing of multi-character short options,
be it a short option with an argument specified without space (e.g.
"-p100") or multiple short options in one argument (e.g. -un), ignores
options specific to individual tools.

Furthermore, if the rest of the option is supposed to be an argument, it
gets reinterpreted as a string of options. For example, -p100 gets
interpreted as -100, which is due to hackish implementation read as
--no-thread --no-irq --no-irq with timerlat hist, causing rtla to error
out:

$ rtla timerlat hist -p100
no-irq and no-thread set, there is nothing to do here

This behavior is caused by getopt_long() being called twice on each
argument, once in common_parse_options(), once in [tool]_parse_args():

- common_parse_options() calls getopt_long() with an array of options
  common for all rtla tools, while suppressing errors (opterr = 0).
- If the option fails to parse, common_parse_options() returns 0.
- If 0 is returned from common_parse_options(), [tool]_parse_args()
  calls getopt_long() again, with its own set of options.

* [tool] means one of {osnoise,timerlat}_{top,hist}

At least in glibc, getopt_long() increments its internal nextchar
variable even if the option is not recognized. That means that in the
case of "-p100", common_parse_options() sets nextchar pointing to '1',
and timerlat_hist_parse_args() sees '1', not 'p'; the same then repeats
for the first and second '0'.

As there is no way to restore the correct internal state of
getopt_long() reliably, fix the issue by merging the common options back
to the longopt array and option string of the [tool]_parse_args()
functions using a macro; only the switch part is left in the original
function, which is renamed to set_common_option().

Fixes: 850cd24cb6d6 ("tools/rtla: Add common_parse_options()")
Reported-by: John Kacur <jkacur@redhat.com>
Tested-by: John Kacur <jkacur@redhat.com>
Link: https://lore.kernel.org/r/20260602125506.3325345-1-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/common.c        | 28 +++++---------------------
 tools/tracing/rtla/src/common.h        | 12 ++++++++++-
 tools/tracing/rtla/src/osnoise_hist.c  |  7 ++++---
 tools/tracing/rtla/src/osnoise_top.c   |  7 ++++---
 tools/tracing/rtla/src/timerlat_hist.c |  7 ++++---
 tools/tracing/rtla/src/timerlat_top.c  |  7 ++++---
 6 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/tools/tracing/rtla/src/common.c b/tools/tracing/rtla/src/common.c
index 839c78c065e12f..01d5b8d5aeaf2e 100644
--- a/tools/tracing/rtla/src/common.c
+++ b/tools/tracing/rtla/src/common.c
@@ -82,37 +82,20 @@ int getopt_auto(int argc, char **argv, const struct option *long_opts)
 }
 
 /*
- * common_parse_options - parse common command line options
+ * set_common_option - set common options
  *
+ * @c: option character
  * @argc: argument count
  * @argv: argument vector
  * @common: common parameters structure
  *
  * Parse command line options that are common to all rtla tools.
  *
- * Returns: non zero if a common option was parsed, or 0
- * if the option should be handled by tool-specific parsing.
+ * Returns: 1 if the option was set, 0 otherwise.
  */
-int common_parse_options(int argc, char **argv, struct common_params *common)
+int set_common_option(int c, int argc, char **argv, struct common_params *common)
 {
 	struct trace_events *tevent;
-	int saved_state = optind;
-	int c;
-
-	static struct option long_options[] = {
-		{"cpus",                required_argument,      0, 'c'},
-		{"cgroup",              optional_argument,      0, 'C'},
-		{"debug",               no_argument,            0, 'D'},
-		{"duration",            required_argument,      0, 'd'},
-		{"event",               required_argument,      0, 'e'},
-		{"house-keeping",       required_argument,      0, 'H'},
-		{"priority",            required_argument,      0, 'P'},
-		{0, 0, 0, 0}
-	};
-
-	opterr = 0;
-	c = getopt_auto(argc, argv, long_options);
-	opterr = 1;
 
 	switch (c) {
 	case 'c':
@@ -152,11 +135,10 @@ int common_parse_options(int argc, char **argv, struct common_params *common)
 		common->set_sched = 1;
 		break;
 	default:
-		optind = saved_state;
 		return 0;
 	}
 
-	return c;
+	return 1;
 }
 
 /*
diff --git a/tools/tracing/rtla/src/common.h b/tools/tracing/rtla/src/common.h
index d4b3715700be73..e00e3930ddb0b5 100644
--- a/tools/tracing/rtla/src/common.h
+++ b/tools/tracing/rtla/src/common.h
@@ -158,7 +158,17 @@ int osnoise_set_stop_total_us(struct osnoise_context *context,
 			      long long stop_total_us);
 
 int getopt_auto(int argc, char **argv, const struct option *long_opts);
-int common_parse_options(int argc, char **argv, struct common_params *common);
+
+#define COMMON_OPTIONS \
+	{"cpus",                required_argument,      0, 'c'},\
+	{"cgroup",              optional_argument,      0, 'C'},\
+	{"debug",               no_argument,            0, 'D'},\
+	{"duration",            required_argument,      0, 'd'},\
+	{"event",               required_argument,      0, 'e'},\
+	{"house-keeping",       required_argument,      0, 'H'},\
+	{"priority",            required_argument,      0, 'P'}
+int set_common_option(int c, int argc, char **argv, struct common_params *common);
+
 int common_apply_config(struct osnoise_tool *tool, struct common_params *params);
 int top_main_loop(struct osnoise_tool *tool);
 int hist_main_loop(struct osnoise_tool *tool);
diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index 5c863e7aad28b4..5dd1d4ba0b887d 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -480,6 +480,7 @@ static struct common_params
 
 	while (1) {
 		static struct option long_options[] = {
+			COMMON_OPTIONS,
 			{"auto",		required_argument,	0, 'a'},
 			{"bucket-size",		required_argument,	0, 'b'},
 			{"entries",		required_argument,	0, 'E'},
@@ -503,15 +504,15 @@ static struct common_params
 			{0, 0, 0, 0}
 		};
 
-		if (common_parse_options(argc, argv, &params->common))
-			continue;
-
 		c = getopt_auto(argc, argv, long_options);
 
 		/* detect the end of the options. */
 		if (c == -1)
 			break;
 
+		if (set_common_option(c, argc, argv, &params->common))
+			continue;
+
 		switch (c) {
 		case 'a':
 			/* set sample stop to auto_thresh */
diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index b7aed40fd2164f..5c278c68b1a2c8 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -337,6 +337,7 @@ struct common_params *osnoise_top_parse_args(int argc, char **argv)
 
 	while (1) {
 		static struct option long_options[] = {
+			COMMON_OPTIONS,
 			{"auto",		required_argument,	0, 'a'},
 			{"help",		no_argument,		0, 'h'},
 			{"period",		required_argument,	0, 'p'},
@@ -355,15 +356,15 @@ struct common_params *osnoise_top_parse_args(int argc, char **argv)
 			{0, 0, 0, 0}
 		};
 
-		if (common_parse_options(argc, argv, &params->common))
-			continue;
-
 		c = getopt_auto(argc, argv, long_options);
 
 		/* Detect the end of the options. */
 		if (c == -1)
 			break;
 
+		if (set_common_option(c, argc, argv, &params->common))
+			continue;
+
 		switch (c) {
 		case 'a':
 			/* set sample stop to auto_thresh */
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 096de8ba3efbb6..5089b72c7a9439 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -789,6 +789,7 @@ static struct common_params
 
 	while (1) {
 		static struct option long_options[] = {
+			COMMON_OPTIONS,
 			{"auto",		required_argument,	0, 'a'},
 			{"bucket-size",		required_argument,	0, 'b'},
 			{"entries",		required_argument,	0, 'E'},
@@ -822,11 +823,11 @@ static struct common_params
 			{0, 0, 0, 0}
 		};
 
-		if (common_parse_options(argc, argv, &params->common))
-			continue;
-
 		c = getopt_auto(argc, argv, long_options);
 
+		if (set_common_option(c, argc, argv, &params->common))
+			continue;
+
 		/* detect the end of the options. */
 		if (c == -1)
 			break;
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 27c14aa71a8bc8..1311afc981e24c 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -558,6 +558,7 @@ static struct common_params
 
 	while (1) {
 		static struct option long_options[] = {
+			COMMON_OPTIONS,
 			{"auto",		required_argument,	0, 'a'},
 			{"help",		no_argument,		0, 'h'},
 			{"irq",			required_argument,	0, 'i'},
@@ -585,11 +586,11 @@ static struct common_params
 			{0, 0, 0, 0}
 		};
 
-		if (common_parse_options(argc, argv, &params->common))
-			continue;
-
 		c = getopt_auto(argc, argv, long_options);
 
+		if (set_common_option(c, argc, argv, &params->common))
+			continue;
+
 		/* detect the end of the options. */
 		if (c == -1)
 			break;
-- 
2.53.0



