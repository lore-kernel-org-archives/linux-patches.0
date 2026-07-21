Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF42D8376;
	Tue, 21 Jul 2026 18:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660057; cv=none; b=ucqwIYvXZtS2GeQHdV3z0BOe7mnn3RWX6T+t1f8jch8DOa88O3en3J+B21NNSR1UX86g/f1Ylcy5aV5WN7oLtdRLXz3+1HTOlUNmANagwdBfLuMxSBWVMH6jbPgMOqG+jve+g4O0xxO7w178hKjZ4LvKKyRq628ZoRKuv4zLCgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660057; c=relaxed/simple;
	bh=HJszdNKULSFxGHv9klc3iz/aHjpnBAYB4fiJ51LRSEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+scgH5utXbExz3QRCL94Vw9vYMIHPn/914RTArXz28+ddkPPvVWADJA4nHLg5Do+eliWWfQDyCUdHmG0VwLllEjCQ+52oNW5OYabkFwHqDcFmzH/BpxXUTEyUeHV08o/8TGRWOcEHemPABMGFq0vAN9DEnfl9TVstguH9I0QSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0yT26nv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0yT26nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2E71F00A3A;
	Tue, 21 Jul 2026 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660056;
	bh=NUvvWOLNPfBAHU49L1zdcPy+noVEJSD1i/8H1mA+hg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0yT26nvsrYrNnlHRZcdG8VriMs6L9f86dXsrPI9NkulJus7fBWBWEWPN3Hk/mHVx
	 C13t568RCw/OJZ/rL0H+uq4Y7PHBl+5eJMoBr+Cz46tlFYtP/3A6ygoABbYKVDh4jn
	 ouMQqFxTtebBmcJZtoqs868VkWv2pu+itgouQpnc=
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
Subject: [PATCH 7.1 0836/2077] perf dwarf-aux: Fix libdw API contract violations
Date: Tue, 21 Jul 2026 17:08:29 +0200
Message-ID: <20260721152612.507132288@linuxfoundation.org>
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

[ Upstream commit 17e9b4243e76f0a0fe951d30ce990d6081a8b426 ]

Check return values of `dwarf_decl_line` (where non-optional),
`dwarf_getfuncs`, and `dwarf_lineaddr` to prevent using uninitialized
stack variables or incorrectly reporting success on failure.

For the root DIE in `die_walk_lines()`, `dwarf_decl_line` and
`die_get_decl_file` are optional and their failures are handled
gracefully to avoid breaking line walking on valid functions.
Specifically, remove the strict `!decf` (declared file) check that
would prematurely abort line walking on generated or artificial
functions lacking this optional attribute.

Additionally:
 - Add NULL pointer protection for `strcmp()` in `die_walk_lines()`
   when `inf` or `decf` are NULL to prevent crashes on generated
   code.
 - Use `dwarf_attr_integrate` in `die_get_data_member_location` to
   correctly resolve inherited member locations (e.g. via abstract
   origin or specification).

Fixes: 57f95bf5f882 ("perf probe: Show correct statement line number by perf probe -l")
Fixes: 3f4460a28fb2 ("perf probe: Filter out redundant inline-instances")
Fixes: 75186a9b09e4 ("perf probe: Fix to show lines of sys_ functions correctly")
Fixes: e0d153c69040 ("perf-probe: Move dwarf library routines to dwarf-aux.{c, h}")
Fixes: 6243b9dc4c99 ("perf probe: Move dwarf specific functions to dwarf-aux.c")
Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Ian Rogers <irogers@google.com>
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
 tools/perf/util/dwarf-aux.c | 34 +++++++++++++++++-----------------
 tools/perf/util/dwarf-aux.h |  5 +++++
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 109a166a6d19ce..d7160f87ac7d7a 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -125,7 +125,8 @@ int cu_find_lineinfo(Dwarf_Die *cu_die, Dwarf_Addr addr,
 	    && die_entrypc(&die_mem, &faddr) == 0 &&
 	    faddr == addr) {
 		*fname = die_get_decl_file(&die_mem);
-		dwarf_decl_line(&die_mem, lineno);
+		if (dwarf_decl_line(&die_mem, lineno) != 0)
+			return -ENOENT;
 		goto out;
 	}
 
@@ -459,7 +460,7 @@ int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
 	size_t nexpr;
 	int ret;
 
-	if (dwarf_attr(mb_die, DW_AT_data_member_location, &attr) == NULL)
+	if (dwarf_attr_integrate(mb_die, DW_AT_data_member_location, &attr) == NULL)
 		return -ENOENT;
 
 	if (dwarf_formudata(&attr, offs) != 0) {
@@ -795,8 +796,7 @@ static int __die_walk_instances_cb(Dwarf_Die *inst, void *data)
 
 	/* Ignore redundant instances */
 	if (dwarf_tag(inst) == DW_TAG_inlined_subroutine) {
-		dwarf_decl_line(origin, &tmp);
-		if (die_get_call_lineno(inst) == tmp) {
+		if (dwarf_decl_line(origin, &tmp) == 0 && die_get_call_lineno(inst) == tmp) {
 			tmp = die_get_decl_fileno(origin);
 			if (die_get_call_fileno(inst) == tmp)
 				return DIE_FIND_CB_CONTINUE;
@@ -950,11 +950,6 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 		cu_die = dwarf_diecu(rt_die, &die_mem, NULL, NULL);
 		dwarf_decl_line(rt_die, &decl);
 		decf = die_get_decl_file(rt_die);
-		if (!decf) {
-			pr_debug2("Failed to get the declared file name of %s\n",
-				  dwarf_diename(rt_die));
-			return -EINVAL;
-		}
 	} else
 		cu_die = rt_die;
 	if (!cu_die) {
@@ -998,11 +993,12 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 			if (die_find_inlinefunc(rt_die, addr, &die_mem)) {
 				/* Call-site check */
 				inf = die_get_call_file(&die_mem);
-				if ((inf && !strcmp(inf, decf)) &&
+				if ((inf == decf || (inf && decf && !strcmp(inf, decf))) &&
 				    die_get_call_lineno(&die_mem) == lineno)
 					goto found;
 
-				dwarf_decl_line(&die_mem, &inl);
+				if (dwarf_decl_line(&die_mem, &inl) != 0)
+					inl = 0;
 				if (inl != decl ||
 				    decf != die_get_decl_file(&die_mem))
 					continue;
@@ -1034,8 +1030,10 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 			.data = data,
 			.retval = 0,
 		};
-		dwarf_getfuncs(cu_die, __die_walk_culines_cb, &param, 0);
-		ret = param.retval;
+		if (dwarf_getfuncs(cu_die, __die_walk_culines_cb, &param, 0) < 0)
+			ret = -EINVAL;
+		else
+			ret = param.retval;
 	}
 
 	return ret;
@@ -1939,10 +1937,12 @@ static bool die_get_postprologue_addr(unsigned long entrypc_idx,
 			break;
 	}
 
-	dwarf_lineaddr(line, postprologue_addr);
-	if (*postprologue_addr >= highpc)
-		dwarf_lineaddr(dwarf_onesrcline(lines, i - 1),
-			       postprologue_addr);
+	if (dwarf_lineaddr(line, postprologue_addr) != 0)
+		return false;
+	if (*postprologue_addr >= highpc) {
+		if (dwarf_lineaddr(dwarf_onesrcline(lines, i - 1), postprologue_addr) != 0)
+			return false;
+	}
 
 	return true;
 }
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index a79968a2e573b3..161f0bf980b6ee 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -10,6 +10,11 @@
 #include <elfutils/libdwfl.h>
 #include <elfutils/version.h>
 
+static inline const char *die_name(Dwarf_Die *die)
+{
+	return dwarf_diename(die) ?: "<unknown>";
+}
+
 struct strbuf;
 
 /* Find the realpath of the target file */
-- 
2.53.0



