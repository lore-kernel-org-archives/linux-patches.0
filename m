Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9674407CCF;
	Tue, 21 Jul 2026 18:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660065; cv=none; b=CN36+GobW2ejagsfw/YJJuA0jZm1+FbZDxytCHnol0qFHzEq0OPSCvh4G7a+AUo1tym+FGSv4CSbHudCsV4zWbYXQ2/CRk0zc/j/VViwL6GCI4pVHJfC3QlxirunP2OUUVH9WsKd58rhkZmcY2MPVzqVuXyjdkKJH8WFYgO2k0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660065; c=relaxed/simple;
	bh=Xszec2MrTdxIrmsIHBLcnBj0PhBDcVQuZWxWbheVKno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSWTVPP6cYD4wIng+tQsNN/+AAN9JybPQbv2Tsj0sMOl0T3uus0ifhQ+JBWN8+yrqR8wUAaa7toWDKkAb3KE6it342ugFXu/FL9Saqwv7bFBkDDDMGQ1KkTTZVmnfIXdWK2HpmGpI3t6/5Hf5Rdg/TS5ycQXl51YNyJqe2kNqKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDGvyuMx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDGvyuMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3061F000E9;
	Tue, 21 Jul 2026 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660063;
	bh=wZFRp1Rse7jqzbXtoFhZC9s7vGL+cTMtdO7grc1htqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDGvyuMx70QfWeYk21kIh32Lid2n6f2JV1f0M97n8VAlRcO/5CVt0t5BBT1Kp9Myn
	 LV64Zifv9yhCMgxQ7R2i+SmOyBQSPfm+AdX2c/sa7OvRC05/8mNlm4AujMDUyiGays
	 wNPuggx7L3l4cQRoapl4OyHIijzkicK9dcFCQ0ao=
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
Subject: [PATCH 7.1 0839/2077] perf annotate-data: Fix libdw API contract violations
Date: Tue, 21 Jul 2026 17:08:32 +0200
Message-ID: <20260721152612.579270293@linuxfoundation.org>
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

[ Upstream commit 5aa1941900050a2c80d29bc7ee0dfbddbad8f294 ]

Check return values of `dwarf_aggregate_size` and `dwarf_formudata`.

Additionally:
 - Avoid `vfprintf` undefined behavior with `NULL` strings by using
   the `die_name()` helper for `dwarf_diename()` in `pr_*` calls.
 - Use `die_get_data_member_location()` (updated to use
   `dwarf_attr_integrate`) to correctly parse location expressions
   for inherited member locations in the fallback path when
   `dwarf_formudata()` fails.

Fixes: 2bc3cf575a162a2c ("perf annotate-data: Improve debug message with location info")
Fixes: 4a111cadac85362e ("perf annotate-data: Add member field in the data type")
Fixes: 8b1042c425f6a5a9 ("perf annotate-data: Set bitfield member offset and size properly")
Fixes: fc044c53b99fad03 ("perf annotate-data: Add dso->data_types tree")
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
 tools/perf/util/annotate-data.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/annotate-data.c b/tools/perf/util/annotate-data.c
index 1eff0a27237d94..63e3c54fab421f 100644
--- a/tools/perf/util/annotate-data.c
+++ b/tools/perf/util/annotate-data.c
@@ -74,7 +74,8 @@ void pr_debug_type_name(Dwarf_Die *die, enum type_state_kind kind)
 		break;
 	}
 
-	dwarf_aggregate_size(die, &size);
+	if (dwarf_aggregate_size(die, &size) != 0)
+		size = 0;
 
 	strbuf_init(&sb, 32);
 	die_get_typename_from_type(die, &sb);
@@ -146,9 +147,9 @@ static void pr_debug_scope(Dwarf_Die *scope_die)
 
 	tag = dwarf_tag(scope_die);
 	if (tag == DW_TAG_subprogram)
-		pr_info("[function] %s\n", dwarf_diename(scope_die));
+		pr_info("[function] %s\n", die_name(scope_die));
 	else if (tag == DW_TAG_inlined_subroutine)
-		pr_info("[inlined] %s\n", dwarf_diename(scope_die));
+		pr_info("[inlined] %s\n", die_name(scope_die));
 	else if (tag == DW_TAG_lexical_block)
 		pr_info("[block]\n");
 	else
@@ -250,9 +251,12 @@ static int __add_member_cb(Dwarf_Die *die, void *arg)
 	if (dwarf_aggregate_size(&die_mem, &size) < 0)
 		size = 0;
 
-	if (dwarf_attr_integrate(die, DW_AT_data_member_location, &attr))
-		dwarf_formudata(&attr, &loc);
-	else {
+	if (dwarf_attr_integrate(die, DW_AT_data_member_location, &attr)) {
+		if (dwarf_formudata(&attr, &loc) != 0) {
+			if (die_get_data_member_location(die, &loc) != 0)
+				loc = 0;
+		}
+	} else {
 		/* bitfield member */
 		if (dwarf_attr_integrate(die, DW_AT_data_bit_offset, &attr) &&
 		    dwarf_formudata(&attr, &loc) == 0)
@@ -273,7 +277,9 @@ static int __add_member_cb(Dwarf_Die *die, void *arg)
 				     dwarf_diename(die), (long)bit_size) < 0)
 				member->var_name = NULL;
 		} else {
-			member->var_name = strdup(dwarf_diename(die));
+			const char *name = dwarf_diename(die);
+
+			member->var_name = name ? strdup(name) : NULL;
 		}
 
 		if (member->var_name == NULL) {
@@ -370,7 +376,8 @@ static struct annotated_data_type *dso__findnew_data_type(struct dso *dso,
 	if (dwarf_tag(type_die) == DW_TAG_typedef)
 		die_get_real_type(type_die, type_die);
 
-	dwarf_aggregate_size(type_die, &size);
+	if (dwarf_aggregate_size(type_die, &size) != 0)
+		size = 0;
 
 	/* Check existing nodes in dso->data_types tree */
 	key.self.type_name = type_name;
@@ -1569,7 +1576,7 @@ static int find_data_type_die(struct data_loc_info *dloc, Dwarf_Die *type_die)
 	offset = loc->offset;
 
 	pr_debug_dtp("CU for %s (die:%#lx)\n",
-		     dwarf_diename(&cu_die), (long)dwarf_dieoffset(&cu_die));
+		     die_name(&cu_die), (long)dwarf_dieoffset(&cu_die));
 
 	if (reg == DWARF_REG_PC) {
 		if (get_global_var_type(&cu_die, dloc, dloc->ip, dloc->var_addr,
@@ -1636,7 +1643,7 @@ static int find_data_type_die(struct data_loc_info *dloc, Dwarf_Die *type_die)
 		}
 
 		pr_debug_dtp("found \"%s\" (die: %#lx) in scope=%d/%d (die: %#lx) ",
-			     dwarf_diename(&var_die), (long)dwarf_dieoffset(&var_die),
+			     die_name(&var_die), (long)dwarf_dieoffset(&var_die),
 			     i+1, nr_scopes, (long)dwarf_dieoffset(&scopes[i]));
 
 		if (reg == DWARF_REG_PC) {
-- 
2.53.0



