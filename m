Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602341B87F2;
	Tue, 12 Aug 2025 18:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022628; cv=none; b=pV1WpMgJ7J+e8ijyiPofuCTSR23nrWi6u+wetQ2wKxJVV6xL9HOeijlJ3usOHlffHo8lDy+ICmn/jN3CgI2hojoZbhnRXWbnW8iMgxlerYg/l1+2pK/EhdTaZD9GAsYZlIyKFgIKsUpuXcfcab8w9im0Up9UaZfT0B+uXj/TAS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022628; c=relaxed/simple;
	bh=UpX9EYgCimc2ql0jVN4ryqdjXFy4MURdm86R4sqES8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fud56OfWoQYjBDUoIsBCkmqFq1FtEFoXV+dvCYWixR+w0VutT+8xaxV0MA3rLuNtJNrlvjWCag7Qd48FqCvgDOrcYbBm4VzWvDkY7GYbIiytxI0nym3coT3WBEBwGB3vam3PlPZkw3zDyU0EmVb8LwrxV/BAo2MlvMXMRYtuS1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nvt33YCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nvt33YCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBF8C4CEF0;
	Tue, 12 Aug 2025 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022628;
	bh=UpX9EYgCimc2ql0jVN4ryqdjXFy4MURdm86R4sqES8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nvt33YCeCCGl+9x1TKUq4pPa2ta4kqrPRBYLwrcV+zlxOtFfldT55RJK5Mz5Q0Q5N
	 eE6c6tjIbV5c/ncAEKkqH11514psNxLuZA+avnRb+ghhAv+HOcBdStYsthPRbn1cas
	 HF6btl88GfNq/R7uDz7trGxjKgQoOhvh7QChzIlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/369] perf sched: Make sure it frees the usage string
Date: Tue, 12 Aug 2025 19:27:55 +0200
Message-ID: <20250812173021.470258084@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5981cc51abc8..864fcb76e758 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3891,9 +3891,9 @@ int cmd_sched(int argc, const char **argv)
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
@@ -3902,7 +3902,7 @@ int cmd_sched(int argc, const char **argv)
 				usage_with_options(latency_usage, latency_options);
 		}
 		setup_sorting(&sched, latency_options, latency_usage);
-		return perf_sched__lat(&sched);
+		ret = perf_sched__lat(&sched);
 	} else if (!strcmp(argv[0], "map")) {
 		if (argc) {
 			argc = parse_options(argc, argv, map_options, map_usage, 0);
@@ -3913,13 +3913,14 @@ int cmd_sched(int argc, const char **argv)
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
@@ -3927,7 +3928,7 @@ int cmd_sched(int argc, const char **argv)
 			if (argc)
 				usage_with_options(replay_usage, replay_options);
 		}
-		return perf_sched__replay(&sched);
+		ret = perf_sched__replay(&sched);
 	} else if (!strcmp(argv[0], "timehist")) {
 		if (argc) {
 			argc = parse_options(argc, argv, timehist_options,
@@ -3943,19 +3944,19 @@ int cmd_sched(int argc, const char **argv)
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



