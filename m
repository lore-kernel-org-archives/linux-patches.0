Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D23803C3;
	Sat, 12 Sep 2026 08:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201079; cv=none; b=f3xbp6GVks412+jyINouedey2k1r/3SDYobcsalhHorR9DKAFeLTobtxfYEOHx9OtPJweLgqmQepWTCgsasSu8PKVipQIiVohrFM56Jj75pHQ68NNC01l5UqBOGbdN/Mw7V2uF+PaWIBCYDLefu+id9IsLwmGyX1PZUbWs52Ub4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201079; c=relaxed/simple;
	bh=NbLV3BKBxPNG5CmM6rLcioQSzNyxI98V9Sp+Rueat8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nb8HsJplRcO42Gxha4+FR2Thd0Rpn9CB4RoTZfW4sdgIZUxla+8iWNFnLQOIvPGvKGl5N+2vRjwXbh4n88ZwaHjK7S7WTzF00N1iG6gQvaL4M65om+g0B4sSxtq67tctO2gnw8WdD0LAJp4s5cDjT987vRFJFaHWg4+61q8iY7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Qav1xmY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Qav1xmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E76A1F000FF;
	Sat, 12 Sep 2026 08:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201077;
	bh=+FwYFIedI5gSSe+sKeMmVV9sGJ05O5xgBs/yzvptgUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Qav1xmYtrqpmmuqhoUrLezLqQKcPlrullcZG7j+ThUhv+oc16j/wmbphDWrKTnSW
	 079inrlPMa8tNGq6i7nWnx847R8Z1j+fdC7l2rMGD6tCsyZrjH+fkev0dciUpwbYAo
	 30Vi3hV7bjoZwiOZOZyI53fgyEKv6nVnY00XI1ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Liang <mliang@purestorage.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0923/1815] perf libdw: Fix outer-frame name resolution and spurious "(inlined)" tag
Date: Sat, 12 Sep 2026 08:44:33 +0200
Message-ID: <20260912065710.600163989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Liang <mliang@purestorage.com>

[ Upstream commit 022bcb6ba2d384d772f68477d11b2684afd6e715 ]

cu_walk_functions_at() calls libdw_a2l_cb() with the containing
DW_TAG_subprogram DIE first, then each DW_TAG_inlined_subroutine
nested inside.  The callback treated both the same way, causing two
bugs:

  1) die_name() returns the unqualified DW_AT_name, so every C++
     frame lost its namespace/class prefix (ns::Class::method
     collapsed to method).

  2) new_inline_sym() re-uses base_sym only when funcname matches
     base_sym->name exactly; otherwise it fabricates a fake symbol
     tagged "(inlined)".  Any mismatch between the DWARF name and
     the ELF symbol name mis-tags an outer, non-inline frame as
     inlined.  This hits C++ (die_name()'s unqualified output never
     matches the demangled ELF symbol) and it also hits C functions
     that GCC IPA-cloned (foo vs foo.isra.0 / .constprop / .part /
     .cold), since DW_AT_linkage_name doesn't reflect those renames.

Fix both:

  * Prefer die_get_linkage_name() (mangled, fully qualified),
    falling back to die_name() when absent (C, extern "C").
    new_inline_sym() already demangles via dso__demangle_sym().

  * For DW_TAG_subprogram DIEs, use base_sym directly -- the DIE
    tag already tells us it is the outer function, sidestepping
    the name comparison entirely for both C++ qualification and
    GCC IPA-clone renames.

Fixes: 88c51002d06f9a68 ("perf addr2line: Add a libdw implementation")
Signed-off-by: Michael Liang <mliang@purestorage.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libdw.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/libdw.c b/tools/perf/util/libdw.c
index d5d2958902c0a..4ca7e7e4fbe93 100644
--- a/tools/perf/util/libdw.c
+++ b/tools/perf/util/libdw.c
@@ -82,13 +82,39 @@ struct libdw_a2l_cb_args {
 static int libdw_a2l_cb(Dwarf_Die *die, void *_args)
 {
 	struct libdw_a2l_cb_args *args  = _args;
-	struct symbol *inline_sym = new_inline_sym(args->dso, args->sym, die_name(die));
 	const char *call_fname = die_get_call_file(die);
 	int call_lineno = die_get_call_lineno(die);
 	char *call_srcline = srcline__unknown;
-
-	if (!inline_sym)
-		goto abort_enomem;
+	struct symbol *inline_sym;
+
+	if (dwarf_tag(die) == DW_TAG_subprogram && args->sym) {
+		/*
+		 * cu_walk_functions_at() opens the walk with the
+		 * containing DW_TAG_subprogram DIE (the non-inlined outer
+		 * function). That's just the base symbol -- use it
+		 * directly. Avoids a fragile name-vs-name compare in
+		 * new_inline_sym() that misfires when GCC IPA passes
+		 * (.isra/.constprop/.part/.cold) rename the ELF symbol
+		 * while DWARF keeps the pre-clone linkage name, which
+		 * left the outer frame spuriously tagged "(inlined)".
+		 */
+		inline_sym = args->sym;
+	} else {
+		/*
+		 * Prefer DW_AT_linkage_name so C++ inline frames keep
+		 * their namespace/class qualification. new_inline_sym()
+		 * runs the name through dso__demangle_sym(), so the
+		 * mangled linkage name is turned back into
+		 * "Namespace::Class::method". Fall back to DW_AT_name
+		 * (unqualified) when no linkage name is present, e.g.
+		 * for C code or extern "C" functions.
+		 */
+		const char *funcname = die_get_linkage_name(die) ?: die_name(die);
+
+		inline_sym = new_inline_sym(args->dso, args->sym, funcname);
+		if (!inline_sym)
+			goto abort_enomem;
+	}
 
 	/* Assign caller information to the parent. */
 	if (call_fname)
-- 
2.53.0



