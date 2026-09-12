Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057BD1F91E3;
	Sat, 12 Sep 2026 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231162; cv=none; b=Cm/5owLNDDaJMYoUJ5zkxfiJ8oY1exiPyXB0JRmOLW5zWOSzKyXWS4IlwR1ghZ1Q2WLW0DSlTnQxcQkwgtAXEAtEBLoumlHYzZa+TWJT074PacHsrd/FOC8/P0TpEgFtzAlosbmmuNbs1qRybCtaakjIR5YYMzgyj2wkPrmcC18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231162; c=relaxed/simple;
	bh=u3oDHBOjl3AIZHK3IatyT6dFPwiUelkIyq3eDZCqTxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/9U1RtuCpDF66b+XMDjrwbJS72EM6Gfte9L59K2qece9BN5xIiADFyhInzJbZl/oPPq4FfQ0170m7M9TTtRclCj3luFZsaKccy40Pf+QPNrd6vpcWGI35QlTzYBPt37LQXAOY66FupmW618oeBhJR15Z7oUBrtmc7onxYLlocE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itc2y9S8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itc2y9S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EF41F000FF;
	Sat, 12 Sep 2026 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231160;
	bh=w/I5Ph+bVagbHzMPfFn5YmjPOeGd2KcrBFyD6lQ7YaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itc2y9S8qABpdpmVXQyQSaSrQKu/2IT9BPHL5tZpMxhTeDLmsUIFxZE+85cXJ92C9
	 0tqqI5z4kSxWHV+j2Daf2USOu/qh/v7GWwGEjIqmIdwVENvW3s20tEXWazd7wXnZrh
	 vdCuZH9ua/sEW86MF17vH4jSF0aQ6xWkd+xoDDrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0942/1191] perf stat: Fix evsel_list leak in cmd_stat
Date: Sat, 12 Sep 2026 09:01:10 +0200
Message-ID: <20260912065609.383416176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 59628fa170cac..249398953a9a3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2302,7 +2302,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			return -1;
+			status = -1;
+			goto out;
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
@@ -2311,7 +2312,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fdopen(output_fd, mode);
 		if (!output) {
 			perror("Failed opening logfd");
-			return -errno;
+			status = -errno;
+			goto out;
 		}
 	}
 
@@ -2320,7 +2322,8 @@ int cmd_stat(int argc, const char **argv)
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



