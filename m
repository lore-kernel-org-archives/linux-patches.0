Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D97407CCF;
	Tue, 21 Jul 2026 18:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660067; cv=none; b=bR+9jEqj+JuxZjt6EFmed6/tvGk8Z3PUWmsEnmtl//D5NzE7wEMdwZJ3hgHhCLcHAekL01+Fg0caX9RyMhrpSoZYQwEQqqTcrZoub9lA+3OCY1vMKvEeUuWRRj+SHmREYsZEWXw9InyviohgU/6RSujgXQn0psp+g+kia+GwbAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660067; c=relaxed/simple;
	bh=2RvTJUHO7vZ5fWsJPsVfv95/RAur6itxMXh2bjv2uBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDW4tZqoLNg12DeBEQDx2SrGfly1jrg806sDXbOX+jW5ITSQ96ooVCLdzW4bXQ3wU86kolWaWonC0BzzPRgWKSWff8HRwALLbLic6QWJwdE+C07i7STTNsdD5FpDVUlfIcJLgCN/dr7MNTPp6dOb6AxaxWAvi7Y3Av8+5zhCOUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1r/57v5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1r/57v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A021F000E9;
	Tue, 21 Jul 2026 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660066;
	bh=KLS3LDd7OmmHSulDsBLyozPUyD7LUz13WiSCTC3bxug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1r/57v5gSCIofaXJbXz41/6wO/b/mGWPwYnfeBwadoaJwJPyBMRijMkVlsHsMpMs
	 YovJrk4BaxwFwPjupVGy76+25Y0NHW2Qo6CGyrOWuDFHv0k8KZxd/lol3+uyR2kLwl
	 OCMUtY/nNgqYJQc7cCgEYh/kSf79xyMG87hRkN+o=
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
Subject: [PATCH 7.1 0840/2077] perf debuginfo: Fix libdw API contract violations
Date: Tue, 21 Jul 2026 17:08:33 +0200
Message-ID: <20260721152612.603975149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0e35c13abd041c..84a78b30ceac10 100644
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
 
@@ -167,7 +170,7 @@ int debuginfo__get_text_offset(struct debuginfo *dbg, Dwarf_Addr *offs,
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



