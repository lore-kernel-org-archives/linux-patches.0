Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7671408039;
	Tue, 21 Jul 2026 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660055; cv=none; b=Oe1owOSlTayLSwcV/Rx6vGfaHK0b4xVpPqLsh0JKNM4vlIlmQljKzTc/fQPSDQKpYeP40Djftc4v3GMEEVt41giCCbAeMbo73Bde845t2ucelwxTYIzcCPQMkQbKiA91nT9htLsKzpUGCwC2nsobz+oIErleeYHow3Hvq3ZPtPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660055; c=relaxed/simple;
	bh=hX7ZvxhUEMM+rhz8C2oie2FLzSlaz+xQ8Nk2woVHfOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mww1XAveVA1nWCEEKDANaCITK963q9g8U194QW7+ctDGtP15lK312BLkm4eYVn3LHSEviwD5BB42zRWnVHi1bXMzNGinQoDnUVkduQDSUw2znZ9h4Mj3PEZnQzsbygDesSFfqPDv7J2hlhpi0BFr7a6qcK+0SsnSvuVQCJSxM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Tx6xbfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Tx6xbfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC8C1F000E9;
	Tue, 21 Jul 2026 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660053;
	bh=vqoZWSbNTiH+ai59udkWb14Soh5K/zXH1m/XJ+icXjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Tx6xbfqNN0J/zeKrPTz1z4gG8vQprCFYrMj21N8AEf1pza77EEmwQ4QqaJLCupso
	 lKU/xabjgTd3PMmRmFBZuO5YOCeB2ii6pTVvniIPApuqdCNWDfP8uCU0nx069DdSgG
	 oDkHeRdxv8Y/E0TBiKrZdNXWgO2FOdPQvda6STrY=
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
Subject: [PATCH 7.1 0835/2077] perf dwarf-aux: Fix libdw segmentation fault in cu_walk_functions_at
Date: Tue, 21 Jul 2026 17:08:28 +0200
Message-ID: <20260721152612.483551767@linuxfoundation.org>
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

[ Upstream commit d37a5467709e627370124d7346ef71ce605ababa ]

A segmentation fault was observed in `libdw` when running `perf kmem`
with `--page stat` on some workloads. The crash occurred deep inside
`libdw` (specifically in `dwarf_child` and `dwarf_diename`) when
processing DWARF information.

The root cause was improper error handling of `dwarf_getfuncs` in
`die_find_realfunc` and `die_find_tailfunc`.

`dwarf_getfuncs` returns:
 - `0` on success (when all functions have been processed).
 - A positive offset if the callback aborts early (e.g., via
   `DWARF_CB_ABORT` when a match is found).
 - `-1` on error.

The original code used `if (!dwarf_getfuncs(...)) return NULL;`. On
error (`-1`), `!-1` evaluates to `0` (false), bypassing the error
check. Execution then proceeded as if a match was found, returning
uninitialized stack memory (`die_mem`) to the caller
(`cu_walk_functions_at`). When `cu_walk_functions_at` passed this
uninitialized memory to `libdw` via `dwarf_diename`, it caused a
segmentation fault.

Fix this by correcting the error check to `if (dwarf_getfuncs(...) <= 0)`.

Fixes: e0d153c69040 ("perf-probe: Move dwarf library routines to dwarf-aux.{c, h}")
Fixes: d4c537e6bf86 ("perf probe: Ignore tail calls to probed functions")
Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zecheng Li <zli94@ncsu.edu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 92db2fccc788ab..109a166a6d19ce 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -171,7 +171,6 @@ int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 	}
 
 	return ret;
-
 }
 
 /**
@@ -620,7 +619,7 @@ Dwarf_Die *die_find_tailfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 	ad.addr = addr;
 	ad.die_mem = die_mem;
 	/* dwarf_getscopes can't find subprogram. */
-	if (!dwarf_getfuncs(cu_die, __die_search_func_tail_cb, &ad, 0))
+	if (dwarf_getfuncs(cu_die, __die_search_func_tail_cb, &ad, 0) <= 0)
 		return NULL;
 	else
 		return die_mem;
@@ -659,7 +658,7 @@ Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 	ad.addr = addr;
 	ad.die_mem = die_mem;
 	/* dwarf_getscopes can't find subprogram. */
-	if (!dwarf_getfuncs(cu_die, __die_search_func_cb, &ad, 0))
+	if (dwarf_getfuncs(cu_die, __die_search_func_cb, &ad, 0) <= 0)
 		return NULL;
 	else
 		return die_mem;
-- 
2.53.0



