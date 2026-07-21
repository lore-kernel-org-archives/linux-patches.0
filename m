Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A462246D0B2;
	Tue, 21 Jul 2026 18:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656945; cv=none; b=PWRRDEb2FcKjURPuRW65Y6bOD7wPrOJEI8mJWEoW1bjZSN9VnESAXB21iZzibqmdqNuvY5dR0LMZk/OJmoo2gc+77qpzlZwsnL8Ox1nUTaZnCL/Z5urydfei5CNuflyk8yxZiHuw2W4VueOTkTUiplgm5TNwUlxHim4H7jN/pVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656945; c=relaxed/simple;
	bh=8dsN74cQzm22PTG+7NziphQVflZccR7z7GpafTsdQp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwAHjEjz4SXP+mgJW9/ocPJABRTqivdPrhNCqiQxoGqHpwezwjZaK1zeT/ryyU/uP7u5w1AvVs7gFhYgbbV+ognpdzOGxbABFLppbLAsvYwpkjJfMNQGi8eHIVqMgLXLo8iI//ECdYP4LC69YLPGgYEfGR6e11JAcEj6WdE1OWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbNrjU9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbNrjU9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E841F000E9;
	Tue, 21 Jul 2026 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656944;
	bh=shkppgyhbBj42RjxMfctYDLTENLkprg4wkJscWCeLYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbNrjU9jcA0zWvvEEJ8Ipn2rB9hjwNLmKbBJKSEdKB76+kK7HizC+PUOEvLjv/PZz
	 WAmmG/D+bwVRIFYVMjOCkSa0FZHdcEOWuZ1WiFCgFLC4ORju+AQaa7pQiX1SDhiqt8
	 sc7m/1vb3K11R0gczpHCg0sQR9yO5zbbrudYPNiA=
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
Subject: [PATCH 6.18 0578/1611] perf debuginfo: Fix libdw API contract violations
Date: Tue, 21 Jul 2026 17:11:34 +0200
Message-ID: <20260721152528.379164352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index bb9ebd84ec2d2a..07099b50f21926 100644
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
 
@@ -168,7 +171,7 @@ int debuginfo__get_text_offset(struct debuginfo *dbg, Dwarf_Addr *offs,
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



