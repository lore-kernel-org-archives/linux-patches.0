Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4123909BF;
	Sat, 12 Sep 2026 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243161; cv=none; b=cW73Jccy8IMrq33O6XgV5Z4l3Jk1Fizv9Csp2iY5tkPNUm2HrkGrtlSjNCTd+yd0Cz5Qgjf7AmrXvPT7qt3otVx/xvo7TAAVpHKBNgGvqPhUqfkT72Ojn2nCB7iC+x/rIVX+6sx1iMM5O2iC60a5bxRCkPSnhvDzswc8JrhOwbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243161; c=relaxed/simple;
	bh=oU0BVFreDTA6pKqjD0uoOyGkd1YoyMKvQxCQuJzxyhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFE8ZZpDz0S6TV9TSr216KZ5qlu9iGfol6eE8NB41d9tBO+8J9xKY8J1qept40Uz+S8XdKt99b2JOdg15N9vx4lbJS5jEpQaiddHCP/o27rv10ifB2g7hdh7VZITe0gkZl6DpkAJkfxhJN7i2m9Wj1az+CyRrK+LEd+BdRCULpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJqcOduF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJqcOduF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812631F000FF;
	Sat, 12 Sep 2026 19:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243160;
	bh=3+/YIVhZSYeZ9+SmKAYLe2LHQYuDh19Hct/TSfMLJdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJqcOduFg1nzFpSru8AnrLSCsI5EqD8w0juvEupcQ1Eixa6RC6KC5NElo/u2FXm+c
	 K4UiLDInGmSgZ4bYVJEbLPh9MiiCiLWA99nqkRWla8u/TCebTLan7Km64V22sH1ziy
	 6U8xWcTIsMLf3r7ZWvDhA6p2fSLVIku4XRZilHtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 659/798] perf stat: Fix evsel_list leak in cmd_stat
Date: Sat, 12 Sep 2026 09:04:47 +0200
Message-ID: <20260912065532.215773807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 340641a4b5fff4f4b12261c9d92169f6e2ea11f4 ]

Fix a memory leak in cmd_stat() where evsel_list is leaked if an error
occurs while opening the output file.

Assisted-by: Antigravity:gemini-3.1-pro
Fixes: 361c99a661a7 ("perf evsel: Introduce perf_evlist")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index dd819e8b33977..7efddd585d58c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2139,7 +2139,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			return -1;
+			status = -1;
+			goto out;
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
@@ -2148,7 +2149,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fdopen(output_fd, mode);
 		if (!output) {
 			perror("Failed opening logfd");
-			return -errno;
+			status = -errno;
+			goto out;
 		}
 	}
 
@@ -2157,7 +2159,8 @@ int cmd_stat(int argc, const char **argv)
 		parse_options_usage(stat_usage, stat_options, "o", 1);
 		parse_options_usage(NULL, stat_options, "log-fd", 0);
 		parse_options_usage(NULL, stat_options, "interval-clear", 0);
-		return -1;
+		status = -1;
+		goto out;
 	}
 
 	stat_config.output = output;
-- 
2.53.0



