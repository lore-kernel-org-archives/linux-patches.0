Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B221EEE0;
	Thu, 13 Jun 2024 12:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282319; cv=none; b=Q0qKa7ehoqnn8VlQ+N/owZ3SYKKoop5FatoCD2KytKvV4wtI2ICUIsjDoafB51odDEViv7lNIze6PU9gP8FJAuMA/bM1EYSQyeQZCmJ351yT8ulTjfS329XNoN7VmCuKEFHfGxbTKu2UMHmnUBEivveXRY0bfef5DuzK4VaeaLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282319; c=relaxed/simple;
	bh=DmFieurOx4bY50/7PjyDz/keCCn8+vexyKeTw1ZBoAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+/67f8YpDWywePtpyUlHLwNrrBxGtj/tuq7hHqzT/+3HDX75To2A4lH61HuqsyskM8zg1amUxDP4d6a8EU1ul72V1dAb+517XOnS03z+Fcqcyn0z+6VVUeVc4MB/pqETle+RGH5/5UWvMYdg+iSsQRf99DYywi7h10g4z/Wqnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCVPDoar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCVPDoar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4F3C2BBFC;
	Thu, 13 Jun 2024 12:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282319;
	bh=DmFieurOx4bY50/7PjyDz/keCCn8+vexyKeTw1ZBoAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCVPDoaraOUM0BzV8g7GumVX4hm3E2WQoPDxl5ZkXdvHC+3hLwIJ7nC+44HEHXHOD
	 StDFeN1ooRh5Gg1Zd8drkLdFYshpfUN/Qp9Fqi3zm1ZRYF66re8sQiA+cgxrhgMh1d
	 9wpW3xz0jKKMTULRtN8aunEPmTjJuqEwMU173NLg=
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
Subject: [PATCH 5.15 236/402] libsubcmd: Fix parse-options memory leak
Date: Thu, 13 Jun 2024 13:33:13 +0200
Message-ID: <20240613113311.349772279@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 39ebf6192016d..e799d35cba434 100644
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



