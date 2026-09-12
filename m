Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ABC4BEE2A;
	Sat, 12 Sep 2026 10:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210566; cv=none; b=fgUzhAUOLF5AGxlaZjT5FVZV1Twa+GuDG9N0Nu0C5Q5rrb16Pttueer2ROAqxwIXgm9bc0SoRb0MSFWuTgGCndKUKnE80WTXlEgSdO9tI6k/W0io2HuUZiJC7V+tf5nOoah5xcfCeUgxMHB2M5o9I8b14UqhFZK3FomPdO272S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210566; c=relaxed/simple;
	bh=5eFS0mzb6jV/ZPxGQjNCsTUsK2TBf+Y3vqUqDMuUXsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7z4oxMaOMC30N0LS/YftoXteMABt202HH9AM5Nm4k1wraOY7mj5lH7OO/xvO7SNDPoRG7151ZB+n6Y/ZoPNvTYLZ//7TVB9DwnApfKegbnQtqOz8AfYurQqNTi7DefAC8efpVKpokT0maLg7M5nwceEwi6hmTfK5d+QPZPPBUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExpWclxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExpWclxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0881F000FF;
	Sat, 12 Sep 2026 10:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210565;
	bh=VH1lkQIGzfPvmImfC59Q1fHoaH3WfLboHAyf8xnbSSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExpWclxRO7T558+v5CQHM3hYyNRDS1o76MGSGxRFL1Gp9QZIbs8KIx+5+GCwEp9OD
	 JEeES0TZQfP0MfSCNluwBrqKwtDk3pdKsG170Dq2rt/25WwibhZqE1PUu/+a3MelPk
	 xGk5YQD6qBCVK5H2EnF7BVrDbCVA64Q6K/2RbVIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1050/1518] perf stat: Fix evsel_list leak in cmd_stat
Date: Sat, 12 Sep 2026 08:53:39 +0200
Message-ID: <20260912065647.202776156@linuxfoundation.org>
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
index 1202ceb425f07..3fc05180b157c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2637,7 +2637,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			return -1;
+			status = -1;
+			goto out;
 		}
 		if (!stat_config.json_output) {
 			clock_gettime(CLOCK_REALTIME, &tm);
@@ -2648,7 +2649,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fdopen(output_fd, mode);
 		if (!output) {
 			perror("Failed opening logfd");
-			return -errno;
+			status = -errno;
+			goto out;
 		}
 	}
 
@@ -2657,7 +2659,8 @@ int cmd_stat(int argc, const char **argv)
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



