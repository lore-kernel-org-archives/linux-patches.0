Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD9B5475F;
	Sat, 12 Sep 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225366; cv=none; b=buJFzDtDDJP6L4VHm3RKRiXKF+dVv939hgPk5G1nk96UiJs0IMw3DUYrBQeiRh8tUxKCpdKouAvW/9NaqB0Oh/XVXPkJs+zaW6gWhcYn5fuJ/ztROqxyonEJOzt+4THEytwerNvIEUeyJVT/mqz9sMBCK7vsuXo/XNOsAEthM+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225366; c=relaxed/simple;
	bh=AIfm1BwVJs2s6xLKjoFsFT+aSJuDHbgKIdJLsNzkjRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG6qZtgxeGtybmx7mZpP4vNw2ti+4lX/iqCx5wvgh+lS928hm07KfRcpJeKEuslaB0q8HEtw9fSP8jK7ZP0AgC2yannq7KveTBd26liS4jiigLwcFRr5rmho6eQ/rbHT2AAtwXF/DLi6GpICffUHYQC3J6SzlH1gSmolOB+CixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWH9PbMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWH9PbMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC931F000FF;
	Sat, 12 Sep 2026 15:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225365;
	bh=F8zuBfVSrWSA9B7PLhw+LaIE57CCrLdzC9Ujq2VYkdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWH9PbMb3JXdoMeIbui7f2kzfOCYFQAQvBXTZZzpDVsHCcwE7u9eEDsY/QogX089q
	 w13hK03mEBXqqWLD++LuWNUAFgMYzqeXhzsTnLw8CsxUOxJlYrttt6nlZUCL+jebZQ
	 94ndjtMFnuGlKA1XPTLNryOKhI+yFfypS9wBHHXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1140/1424] perf stat: Fix evsel_list leak in cmd_stat
Date: Sat, 12 Sep 2026 08:59:32 +0200
Message-ID: <20260912065632.828010604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1512fedd90cf9..7ab980bf3c71d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2596,7 +2596,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			return -1;
+			status = -1;
+			goto out;
 		}
 		if (!stat_config.json_output) {
 			clock_gettime(CLOCK_REALTIME, &tm);
@@ -2607,7 +2608,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fdopen(output_fd, mode);
 		if (!output) {
 			perror("Failed opening logfd");
-			return -errno;
+			status = -errno;
+			goto out;
 		}
 	}
 
@@ -2616,7 +2618,8 @@ int cmd_stat(int argc, const char **argv)
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



