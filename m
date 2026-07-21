Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77BF2DEA74;
	Tue, 21 Jul 2026 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660060; cv=none; b=Wk82myC364W6Oa4JhXo//zMoJTmJXU4RY3OQ/X5sjs/XFFVpOYhlquqLN/PCjhhdhr+ALDMxSNBwgYX+aPGqojS7GQj2bCu+EI0WlEe7OqMW5D01r6fKsWeRYKwx12oeD9sWCQVbZ0Xsimyhw9dTOmVvtmIXMe8pSxjoFMqPiA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660060; c=relaxed/simple;
	bh=Ke9HMo6z3+44idy+Q2RTdS+mUy6cKMar5EQA7VFhpus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siidHYpcyianSN+3T83kIXRjUFzlEoAa77kivMMQOjF7xgHNBpuAveHi7hUXYXRoDPVNJC0cscqiRDbvO7Rrx6iGfv62+BBA3OHyO/HmJslFj1v4rOnhc/d7labd0v9N8H+ovBQR9+4SRD+7kuqPJ4CjDnbtvghHjxOh8i4G5m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOomRw4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOomRw4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0871F000E9;
	Tue, 21 Jul 2026 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660058;
	bh=xV7miY7xCKPASISC8p97Y2p/uokdxTaFDVUXp2iuQQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOomRw4ksFDqLWLuWs+u3EgU80vAJrsYkwaesXN+xbuAZOgNRSMiB7q5AwxBTpwMR
	 XNQYX0O8eaE1uzw48jhfbInS1ZsJo5n3xOQwRZSOCA0t4h7WXhTlopqdknR5Eu2Ag5
	 zc5cVYbYx3SrtlBIoLLDyrhqy2nXv0BSXCwp29X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Zecheng Li <zli94@ncsu.edu>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0837/2077] perf libdw: Fix libdw API contract violations and memory leaks
Date: Tue, 21 Jul 2026 17:08:30 +0200
Message-ID: <20260721152612.529845867@linuxfoundation.org>
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

[ Upstream commit 9c6d535ddb794fb540c3b142ab1d7416d469c1de ]

Check return values of `dwfl_report_end` and `dwfl_module_addrdie`
to prevent using uninitialized stack variables or reporting success on
failure.

Additionally:
 - Ensure `*file` is freed and inline frames are cleared on error in
   `libdw__addr2line()` to prevent memory leaks and duplicated
   callchains when falling back to other unwinders.
 - Use `die_name()` safe wrapper inside the inline function unwinding
   callback (`libdw_a2l_cb`).
 - Refactor `libdw_a2l_cb`'s repeated memory error handling/cleanup
   paths using a cleaner goto control flow.

Fixes: b7a2b011e9627ff3 ("perf powerpc: Unify the skip-callchain-idx libdw with that for addr2line")
Fixes: 88c51002d06f9a68 ("perf addr2line: Add a libdw implementation")
Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
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
 tools/perf/util/libdw.c | 49 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/libdw.c b/tools/perf/util/libdw.c
index 21697788410308..15bf646d104f5a 100644
--- a/tools/perf/util/libdw.c
+++ b/tools/perf/util/libdw.c
@@ -60,7 +60,10 @@ struct Dwfl *dso__libdw_dwfl(struct dso *dso)
 		return NULL;
 	}
 
-	dwfl_report_end(dwfl, /*removed=*/NULL, /*arg=*/NULL);
+	if (dwfl_report_end(dwfl, /*removed=*/NULL, /*arg=*/NULL) != 0) {
+		dwfl_end(dwfl);
+		return NULL;
+	}
 	dso__set_libdw(dso, dwfl);
 
 	return dwfl;
@@ -72,18 +75,19 @@ struct libdw_a2l_cb_args {
 	struct inline_node *node;
 	char *leaf_srcline;
 	bool leaf_srcline_used;
+	int err;
 };
 
 static int libdw_a2l_cb(Dwarf_Die *die, void *_args)
 {
 	struct libdw_a2l_cb_args *args  = _args;
-	struct symbol *inline_sym = new_inline_sym(args->dso, args->sym, dwarf_diename(die));
+	struct symbol *inline_sym = new_inline_sym(args->dso, args->sym, die_name(die));
 	const char *call_fname = die_get_call_file(die);
 	char *call_srcline = srcline__unknown;
 	struct inline_list *ilist;
 
 	if (!inline_sym)
-		return -ENOMEM;
+		goto abort_enomem;
 
 	/* Assign caller information to the parent. */
 	if (call_fname)
@@ -103,12 +107,27 @@ static int libdw_a2l_cb(Dwarf_Die *die, void *_args)
 
 	/* Add this symbol to the chain as the leaf. */
 	if (!args->leaf_srcline_used) {
-		inline_list__append_tail(inline_sym, args->leaf_srcline, args->node);
+		if (inline_list__append_tail(inline_sym, args->leaf_srcline, args->node) != 0)
+			goto abort_delete_sym;
 		args->leaf_srcline_used = true;
 	} else {
-		inline_list__append_tail(inline_sym, strdup(args->leaf_srcline), args->node);
+		char *srcline = strdup(args->leaf_srcline);
+
+		if (!srcline)
+			goto abort_delete_sym;
+		if (inline_list__append_tail(inline_sym, srcline, args->node) != 0) {
+			free(srcline);
+			goto abort_delete_sym;
+		}
 	}
 	return 0;
+
+abort_delete_sym:
+	if (inline_sym->inlined)
+		symbol__delete(inline_sym);
+abort_enomem:
+	args->err = -ENOMEM;
+	return DWARF_CB_ABORT;
 }
 
 int libdw__addr2line(u64 addr, char **file, unsigned int *line_nr,
@@ -162,11 +181,29 @@ int libdw__addr2line(u64 addr, char **file, unsigned int *line_nr,
 			.leaf_srcline = srcline_from_fileline(src ?: "<unknown>", lineno),
 		};
 
+		if (!args.leaf_srcline) {
+			if (file && *file) {
+				free(*file);
+				*file = NULL;
+			}
+			return 0;
+		}
+
 		/* Walk from the parent down to the leaf. */
-		cu_walk_functions_at(cudie, addr, libdw_a2l_cb, &args);
+		if (cudie)
+			cu_walk_functions_at(cudie, addr, libdw_a2l_cb, &args);
 
 		if (!args.leaf_srcline_used)
 			free(args.leaf_srcline);
+
+		if (args.err) {
+			if (file && *file) {
+				free(*file);
+				*file = NULL;
+			}
+			inline_node__clear_frames(node);
+			return 0;
+		}
 	}
 	return 1;
 }
-- 
2.53.0



