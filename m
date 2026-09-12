Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5072455621;
	Sat, 12 Sep 2026 08:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202787; cv=none; b=aiqS0Dxbr8tc8jiXAdu+RKj3Kvlr4A3AG9DCmJy5ec0aQeXpZH4fuhA/zmPIZ4yGlWWzRlQufkxlOpD8hFuH8sMPX3PH6mVfKpIcY3aBMjms0lAi2jEV7y8/rMeMYUqgHOF9JUGYFa+5NtUAiud2LCI6ukITM4JfmUAufXF3h5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202787; c=relaxed/simple;
	bh=HmdxQnFSxxsyT7mOUalaJEiXftABQuSaG552NrMwpvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvR5+380rdgky/Zk24wC7auEElprz0YfqUOsgCy+IG87LNdCF796oZUaqLNws1qp1DtqL/43qvnGd+vx0Y6ZLNr2tr0psJUc1dLajRCtfd5+mKclSF5yA22GanU1uk4Wlnf7GwUYeVS+V3+s8tGpSByJ7J4JybC3OjYuRGTFHkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTkC/2Zr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTkC/2Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDC91F000FF;
	Sat, 12 Sep 2026 08:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202786;
	bh=RbHgNXn/uDUKlJ7yKRl2+gCz/apFlZWnsTKsEJHYjkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTkC/2ZrOPSfhoBD4INNZHEGMVeskkCiZXqKOOOXPHd4QCG2vgHBqtXzhoZuxc0qV
	 aD0kme/Vti9/MvBIkjkLm7GVf0LHtY30GMOEWPeSIJBgMOPJ/chPp3N8VpB0fNUiT2
	 0mrspU+wzJrMXjH/88Zhu+Pc+DQmzR0ySnELGkjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1273/1815] perf stat: Fix evsel_list leak in cmd_stat
Date: Sat, 12 Sep 2026 08:50:23 +0200
Message-ID: <20260912065718.903018235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 92cdb2df7285b..10681a4880086 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2726,7 +2726,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			return -1;
+			status = -1;
+			goto out;
 		}
 		if (!stat_config.json_output) {
 			clock_gettime(CLOCK_REALTIME, &tm);
@@ -2737,7 +2738,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fdopen(output_fd, mode);
 		if (!output) {
 			perror("Failed opening logfd");
-			return -errno;
+			status = -errno;
+			goto out;
 		}
 	}
 
@@ -2746,7 +2748,8 @@ int cmd_stat(int argc, const char **argv)
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



