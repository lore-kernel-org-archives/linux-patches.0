Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF2F217F35;
	Tue, 12 Aug 2025 19:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026229; cv=none; b=NB1W0PTcpcvKGCOo/7QViscp4vYCscDbSv+reQ/0X1UhGAXXpYcqPLbpdZVjLjantN+VjJAQxm2ZAXGInoD6Ie1V+/ZK/a8Pvj4lGYt40HN6jQfWpOyUzxvPgE8h4M+MZo5seMgvQ/XntrOBX1YZLkQgRY1PpZnwq6+T9zGDxkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026229; c=relaxed/simple;
	bh=11tFE41Gab5VKXH2VZvUWliZXYoiu5VYoBTF+VBqNJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4pEpwh3ROsu1G5I37i7kbh0UfgeQokAHbsoruquaMuN8ojvMQWZd/r27m8eAF54dgUI57EfhHVRInO0YdjVDc1ylwcMBNUewMs2FrFt7TLGYf4zpPmwA78avaWa5NSNOen682n2WzT1HXkAMIngkRKdmUrh+jsXCQ6L5AtIC34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sajvzOXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sajvzOXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52957C4CEF0;
	Tue, 12 Aug 2025 19:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026228;
	bh=11tFE41Gab5VKXH2VZvUWliZXYoiu5VYoBTF+VBqNJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sajvzOXvKuoepBs7kVJFde1WDcfRm61NORGi/zWQrh+pUFZjkNlVTfxXcAAvD8bg0
	 RA0YGa7+R+iSGjoV06Vvc830ADBq9ztLARtUImpPweqKbf3LH8yMQW+gtXEbaRVPM7
	 FBN9wNO3kHV96eHO+gn2WsWtstILPQqH+SNmpozs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 258/480] perf sched: Make sure it frees the usage string
Date: Tue, 12 Aug 2025 19:47:46 +0200
Message-ID: <20250812174408.084426494@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 10d9b89203765fb776512742c13af8dd92821842 ]

The parse_options_subcommand() allocates the usage string based on the
given subcommands.  So it should reach the end of the function to free
the string to prevent memory leaks.

Fixes: 1a5efc9e13f357ab ("libsubcmd: Don't free the usage string")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-2-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 26ece6e9bfd1..b7bbfad0ed60 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3902,9 +3902,9 @@ int cmd_sched(int argc, const char **argv)
 	 * Aliased to 'perf script' for now:
 	 */
 	if (!strcmp(argv[0], "script")) {
-		return cmd_script(argc, argv);
+		ret = cmd_script(argc, argv);
 	} else if (strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
-		return __cmd_record(argc, argv);
+		ret = __cmd_record(argc, argv);
 	} else if (strlen(argv[0]) > 2 && strstarts("latency", argv[0])) {
 		sched.tp_handler = &lat_ops;
 		if (argc > 1) {
@@ -3913,7 +3913,7 @@ int cmd_sched(int argc, const char **argv)
 				usage_with_options(latency_usage, latency_options);
 		}
 		setup_sorting(&sched, latency_options, latency_usage);
-		return perf_sched__lat(&sched);
+		ret = perf_sched__lat(&sched);
 	} else if (!strcmp(argv[0], "map")) {
 		if (argc) {
 			argc = parse_options(argc, argv, map_options, map_usage, 0);
@@ -3924,13 +3924,14 @@ int cmd_sched(int argc, const char **argv)
 				sched.map.task_names = strlist__new(sched.map.task_name, NULL);
 				if (sched.map.task_names == NULL) {
 					fprintf(stderr, "Failed to parse task names\n");
-					return -1;
+					ret = -1;
+					goto out;
 				}
 			}
 		}
 		sched.tp_handler = &map_ops;
 		setup_sorting(&sched, latency_options, latency_usage);
-		return perf_sched__map(&sched);
+		ret = perf_sched__map(&sched);
 	} else if (strlen(argv[0]) > 2 && strstarts("replay", argv[0])) {
 		sched.tp_handler = &replay_ops;
 		if (argc) {
@@ -3938,7 +3939,7 @@ int cmd_sched(int argc, const char **argv)
 			if (argc)
 				usage_with_options(replay_usage, replay_options);
 		}
-		return perf_sched__replay(&sched);
+		ret = perf_sched__replay(&sched);
 	} else if (!strcmp(argv[0], "timehist")) {
 		if (argc) {
 			argc = parse_options(argc, argv, timehist_options,
@@ -3954,19 +3955,19 @@ int cmd_sched(int argc, const char **argv)
 				parse_options_usage(NULL, timehist_options, "w", true);
 			if (sched.show_next)
 				parse_options_usage(NULL, timehist_options, "n", true);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		ret = symbol__validate_sym_arguments();
-		if (ret)
-			return ret;
-
-		return perf_sched__timehist(&sched);
+		if (!ret)
+			ret = perf_sched__timehist(&sched);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
 
+out:
 	/* free usage string allocated by parse_options_subcommand */
 	free((void *)sched_usage[0]);
 
-	return 0;
+	return ret;
 }
-- 
2.39.5



