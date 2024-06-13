Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE75114389D;
	Thu, 13 Jun 2024 11:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278903; cv=none; b=PZclAALULvcI4w56QjjgKpUrdSbCYVHIXDSh+eVd9Ziv0c5IxuYtL2F0XuDR2dFknH/KO6Rif0DNsIk2jnGCf1qUvriaIO5XRMSynSLL47T27ZSvpajhEHGSsWtoqoNI4xBsm7xn+HGbWsmV1OrPHBleBwyv406agUXRwsvXiPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278903; c=relaxed/simple;
	bh=31RgW5TTYJZw9QTdJbX40rydBq5S7JcY2k2wkk848G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoGT/3mW9VoW+s5zEpxtM5YhMMX2oMNyb3EPelVngxH/TVddlnAAKpeBKkEuypwka6l6w50WILG6BDCgLjztR5u01menHHXgajYkkJO8wtySouVcu+9/LLiqlL93Ge7X9tAG20KuD3sRztmWdmjQsG9Jp/Vp0vKw8js2TPoQxKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrLBcQnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrLBcQnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E849C2BBFC;
	Thu, 13 Jun 2024 11:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278902;
	bh=31RgW5TTYJZw9QTdJbX40rydBq5S7JcY2k2wkk848G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrLBcQnN0dLq06ecxe3UpSW32Yz+IK0aXtlfTQv5UPOx3k1z8KbIgUQhhnbHpSJT7
	 WHyzqAepgHx41EbCIckJqpljpxfrN/p206WRM6fvhgT51MRHDIaojlPc2lbmetJrpc
	 qBahOhAEd1Z227HbC6cEYdxyILzwcgAlQWOg1CYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/213] libsubcmd: Fix parse-options memory leak
Date: Thu, 13 Jun 2024 13:32:36 +0200
Message-ID: <20240613113232.167677076@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 230a7a71f92212e723fa435d4ca5922de33ec88a ]

If a usage string is built in parse_options_subcommand, also free it.

Fixes: 901421a5bdf605d2 ("perf tools: Remove subcmd dependencies on strbuf")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240509052015.1914670-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/subcmd/parse-options.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/lib/subcmd/parse-options.c b/tools/lib/subcmd/parse-options.c
index cb7154eccbdc1..bf983f51db50c 100644
--- a/tools/lib/subcmd/parse-options.c
+++ b/tools/lib/subcmd/parse-options.c
@@ -612,11 +612,10 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
 			const char *const subcommands[], const char *usagestr[], int flags)
 {
 	struct parse_opt_ctx_t ctx;
+	char *buf = NULL;
 
 	/* build usage string if it's not provided */
 	if (subcommands && !usagestr[0]) {
-		char *buf = NULL;
-
 		astrcatf(&buf, "%s %s [<options>] {", subcmd_config.exec_name, argv[0]);
 
 		for (int i = 0; subcommands[i]; i++) {
@@ -658,7 +657,10 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
 			astrcatf(&error_buf, "unknown switch `%c'", *ctx.opt);
 		usage_with_options(usagestr, options);
 	}
-
+	if (buf) {
+		usagestr[0] = NULL;
+		free(buf);
+	}
 	return parse_options_end(&ctx);
 }
 
-- 
2.43.0



