Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87D93A874B;
	Tue, 21 Jul 2026 19:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662377; cv=none; b=V2QIm/odj38LczO5FJ5chnrbwaBJsT6yyEwd9yocyVt2Y9093byC1MDI6/ZlzH3+klsqNHiTluye6eVxUBHWzL4FukndDWQqTUsuGVxJoL/COAubI859lBsxY1LixzgbVdryWIg6V/6yBuHbKQb6BadeJCqYIK7hD4fa3VpNPDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662377; c=relaxed/simple;
	bh=g6SNexJgEOc0KtoySRKsl+xcP4imKv23JoKbxWsPXFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Clnou5JV6GI0A0JReEbS+gAlbUiS3OBhtMICqVRDv4O7po4SAaS9nweYi52VczqQl5kF8OqmWekjO+lSzxZGzD+hln3T/COLNDFshMlXPr/t3MAxXOOUnVX3ABbnL+zqHcFLHQhYP4a/Vh+FxlCmQ4rQAkwAT7G+LERsszoMZ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOFKFLv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOFKFLv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2396B1F000E9;
	Tue, 21 Jul 2026 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662375;
	bh=4wK0P/V2c92gfWJOZ2MHnPQiOUg9PXqxjIqquaORA1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOFKFLv0JSuzFjtheT4mcLjwo43R0D/3m0uLxqBtqO5iFMyYc2zp71xQH9/M9Jdp5
	 XMfa7bVn48CA7zZZwet3kZlhkVxVMDKHYXi1yfWt+DW+UeIxh+UZhY3/JtD5McEU51
	 d2gWfwfcFisGkbIUORly1f//wBBO2Ay/GaD4FXqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Zecheng Li <zli94@ncsu.edu>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0414/1276] perf debuginfo: Fix libdw API contract violations
Date: Tue, 21 Jul 2026 17:14:17 +0200
Message-ID: <20260721152455.362998375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 31088ccf0312b1a547046f1f69890ede07834a30 ]

Check return value of `dwfl_report_end` during offline initialization.
Validate `dwfl_module_relocation_info` result before passing to `strcmp`
to avoid potential segmentation faults.

Additionally:
 - Fix a file descriptor leak in `debuginfo__init_offline_dwarf()` when
   `dwfl_report_offline()` or subsequent setup calls fail.

Fixes: 6f1b6291cf73cb32 ("perf tools: Add util/debuginfo.[ch] files")
Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zecheng Li <zli94@ncsu.edu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/debuginfo.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/debuginfo.c b/tools/perf/util/debuginfo.c
index 19acf4775d3587..f5af3b4408b950 100644
--- a/tools/perf/util/debuginfo.c
+++ b/tools/perf/util/debuginfo.c
@@ -42,6 +42,7 @@ static int debuginfo__init_offline_dwarf(struct debuginfo *dbg,
 {
 	GElf_Addr dummy;
 	int fd;
+	bool fd_consumed = false;
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
@@ -55,6 +56,7 @@ static int debuginfo__init_offline_dwarf(struct debuginfo *dbg,
 	dbg->mod = dwfl_report_offline(dbg->dwfl, "", "", fd);
 	if (!dbg->mod)
 		goto error;
+	fd_consumed = true;
 
 	dbg->dbg = dwfl_module_getdwarf(dbg->mod, &dbg->bias);
 	if (!dbg->dbg)
@@ -62,13 +64,14 @@ static int debuginfo__init_offline_dwarf(struct debuginfo *dbg,
 
 	dwfl_module_build_id(dbg->mod, &dbg->build_id, &dummy);
 
-	dwfl_report_end(dbg->dwfl, NULL, NULL);
+	if (dwfl_report_end(dbg->dwfl, NULL, NULL) != 0)
+		goto error;
 
 	return 0;
 error:
 	if (dbg->dwfl)
 		dwfl_end(dbg->dwfl);
-	else
+	if (!fd_consumed)
 		close(fd);
 	memset(dbg, 0, sizeof(*dbg));
 
@@ -160,7 +163,7 @@ int debuginfo__get_text_offset(struct debuginfo *dbg, Dwarf_Addr *offs,
 	/* Search the relocation related .text section */
 	for (i = 0; i < n; i++) {
 		p = dwfl_module_relocation_info(dbg->mod, i, &shndx);
-		if (strcmp(p, ".text") == 0) {
+		if (p && strcmp(p, ".text") == 0) {
 			/* OK, get the section header */
 			scn = elf_getscn(elf, shndx);
 			if (!scn)
-- 
2.53.0



