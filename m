Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419E9315D49;
	Sat, 12 Sep 2026 12:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217770; cv=none; b=ZMPNcj/nM5/F/dhWQKgIVf2cyLrkHpfXuGYfQc0EHPwnbIia5FxHp6Zuf1fFXRyZ29a9IBKWOdnrFoehD8ODVAX3b/yTqsBh2bySxprJXTlvQPibrghNStfL5tu4UAJW8TUNths5t9bjInYdprTdyN2pT7EbnTwXJ3fGSKkUd5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217770; c=relaxed/simple;
	bh=CTmsvavft8q1vRBFpToSCgbyiImG66h1RsbmLGGtLO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvPGbz+DN93T8pVfrcrNsNzdUEo8iCU2Jx/Sy3oxv1RJbzsRC88/7mF2Yg4XNJXsU28qWKgk+bv5qIdjj0DOBHgkrse0VV3ERcM2Fz2XRQJTVxg3N3IPbf7ivcRpcv/M7PsOFRZwxC/Rla51w7myxZJBJnL7xQZL7emzcedtK5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUpJrZDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUpJrZDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5471F000FF;
	Sat, 12 Sep 2026 12:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217769;
	bh=7wpsS/5zGjlpY8bbVRffbj5wCZzH0Zp1/obXDiq2rV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUpJrZDBg1W1fK0AiZFvyewsxj0ZKSEqaqIwdFe1nbq1XWHqbX+tTUCc7e3V2wc7O
	 uwkVvoUcgvmZElTAQdWUIMPQHYSKa/kN5QgHwyFJEdE6S3hmQ29MpFSBzXTUh0u/VC
	 HGXnVcPvPxJx2EFMQLS73wp3H98Qo5uSeAA63ork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1006/1376] perf stat: Fix evsel_list leak in cmd_stat
Date: Sat, 12 Sep 2026 08:57:12 +0200
Message-ID: <20260912065629.986085858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e476598de8083..34c7cfdfec2dd 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2648,7 +2648,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			return -1;
+			status = -1;
+			goto out;
 		}
 		if (!stat_config.json_output) {
 			clock_gettime(CLOCK_REALTIME, &tm);
@@ -2659,7 +2660,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fdopen(output_fd, mode);
 		if (!output) {
 			perror("Failed opening logfd");
-			return -errno;
+			status = -errno;
+			goto out;
 		}
 	}
 
@@ -2668,7 +2670,8 @@ int cmd_stat(int argc, const char **argv)
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



