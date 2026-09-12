Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAFB34250E;
	Sat, 12 Sep 2026 19:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239934; cv=none; b=aKRGRKFYTAVPV6RUZ/V6xuWJF2yyaR3vTyaeqmKplzBciHMDtZ33VFrmpHUzfZlIJcNAIBx+QFuvZ8Dqi/vJrZDqZjIHCwQo48AwidbuoznVGZ7OrODAQZBM6e9KyoxVhESBgcZCPE7/anGdmeCmcwJaXRrEyEY2gpaNDEfI5A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239934; c=relaxed/simple;
	bh=dX5Hq0SEjfPEh0UHrNtR+Iq+JEE0sGg5L1jAQT1CQTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpmrVenQvj2QLDUU/D+53taLWl4FX0vvhkqvq6fPw1cuVI6cdz+/Eb4y0LKKQ7Rh7Jd+0daaOwk90dOIYsOxA8Oktip5jsMIVrD+V5dkuQNC9ZyQMNp3UOIxLYCVJtY8y/Et8w1e7jZ4qPn6TMaCVbPMTjyZzChO29OCcpwrFMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sev7yy+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sev7yy+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56221F000FF;
	Sat, 12 Sep 2026 19:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239932;
	bh=GlIr297foE+DfaM3s742CP+39mPs+dq/8ILWa++cdkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sev7yy+RlHsheLyi8FEcidGFqyYO8U9NcJ34E+Nr9PPiSzbLdKh85yo0zwOShcRrM
	 zc4bQ00SP8215/FNJmUlUSj6z8M8+3pBHzvbP5KQd5EvGZeeBpeImhdNqC19yxae8t
	 dqkt5MVWQdguleY0Udmw42UDDjnbN8vVeYWlniNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 763/935] perf stat: Fix evsel_list leak in cmd_stat
Date: Sat, 12 Sep 2026 09:03:13 +0200
Message-ID: <20260912065544.333905789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12fc5ef1ab84f..5835d2992b4bc 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2290,7 +2290,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			return -1;
+			status = -1;
+			goto out;
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
@@ -2299,7 +2300,8 @@ int cmd_stat(int argc, const char **argv)
 		output = fdopen(output_fd, mode);
 		if (!output) {
 			perror("Failed opening logfd");
-			return -errno;
+			status = -errno;
+			goto out;
 		}
 	}
 
@@ -2308,7 +2310,8 @@ int cmd_stat(int argc, const char **argv)
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



