Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76DC1B5811;
	Thu,  6 Jun 2024 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683458; cv=none; b=UkinGfSQs8eH8MlUKlY9kTWiGfpDz3tiOUNdojKBmczFhpsZyctsVXdFoxrYtSYsGbvzmm1pLsHfWQrPpC32QYBQaS1oPsaF+X39LLkFvDbAsiMxI+RQibcyxhlO9ZQoEpjgoOZQp4I/s+/nc3cKmXa2HHvTNCRBRIHGLmSf1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683458; c=relaxed/simple;
	bh=9oWS08GnaOylBzvxGNkmDcvzUPRDUfi7/5jQM6p5CKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgoezxJ3O1HR+cYg0sB03A2qDbQ1kSB7YPcoSzbiRDnBySJkC6vJCDWnn3A+fhptvzgEOXcagQk601zDqzUSX1pWEALWCdTWf8PYEJTpEIYbe/2QBDj8yXe8ZiLLTU6NrKfKyZLogMjoAGSGKANMcObIAYbQ48CKld1uOfbHkLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ydnj1foO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ydnj1foO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46CCC2BD10;
	Thu,  6 Jun 2024 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683458;
	bh=9oWS08GnaOylBzvxGNkmDcvzUPRDUfi7/5jQM6p5CKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ydnj1foOLSab260XPEVv4DtjNPUs2hE5aGCv2mBl+J2Zf9fTkgXc3z00THWpCXn0N
	 xMR6CKxdwOgUO4T1s8tQg40nJkFNCo6auCTrHJ4vT4XKbQ1st2nagykV1KTNYVdd2v
	 8BGix7phPuCAqc8qO1TjCWmOykZFawqj/mLP5ZWI=
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
Subject: [PATCH 6.1 346/473] libsubcmd: Fix parse-options memory leak
Date: Thu,  6 Jun 2024 16:04:35 +0200
Message-ID: <20240606131711.344517798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9fa75943f2ed1..d943d78b787ed 100644
--- a/tools/lib/subcmd/parse-options.c
+++ b/tools/lib/subcmd/parse-options.c
@@ -633,11 +633,10 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
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
@@ -679,7 +678,10 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
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



