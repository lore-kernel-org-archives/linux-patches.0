Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF1746A5E4;
	Tue, 21 Jul 2026 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648234; cv=none; b=p7wjVMvQ3qvS0BM+w25oyzOArPPxSz+QDZu4WWxy5niwUoaGGs4DwTDDgx07Y0kGrz+/lCpzLGztIqbK1NZdMe1esu+qXG0VY7P22BF/5nMmGWUOH6PrHjsZeRtB8xp+bOtO+7aBcheSuJCwiqV/Dd++ZoDjEsoYOjnwcECJzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648234; c=relaxed/simple;
	bh=NjPJUbojGpnIwhBxQJN6epbEatsWVSd9GNjMIFrOx8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVew+wQnK6/sA8IiTrtBQCY708OTYlOD61aPFHvtHG1EdS2bNUlOXhdsvOcCen5GMR1kiKJ5eLirwoarqdeKdwumQODKAlbaeekf1MnqtNEVw+0hBv1gC6A5Z9xOvZFCwkY6M0xpIVZf83G24B6ImgblFdRWKF/Tz1LdTJj15Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOtNfRoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOtNfRoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579351F000E9;
	Tue, 21 Jul 2026 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648232;
	bh=9B2+9DFX7g0Tm8F/S5U8QO/H91pK0AT9LkZrunSLpoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOtNfRoQJT/dQJHSpRmBfbLA8T7LOfnhXqHviGKvTeAQHVUBMgElNWatiL4wAOjAy
	 yOtB88gccTq+r8I1ydGthi4eKU9OHUAyjajN2I7N5vSpHIaGxxo2e4DhEDM/i4EhQL
	 j3rBIY6JPjXmstrZBUXvS+ciBGFiZqPHpWti3V4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0121/2077] objtool/klp: Fix is_uncorrelated_static_local() for Clang
Date: Tue, 21 Jul 2026 16:56:34 +0200
Message-ID: <20260721152555.553295876@linuxfoundation.org>
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

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 84c304a534b844703d3437811e8f072166e3f116 ]

For naming function-local static locals, GCC uses <var>.<id>, e.g.
__already_done.15, while Clang uses <func>.<var> with optional .<id>,
e.g. create_worker.__already_done.111

The existing is_uncorrelated_static_local() check only matches the GCC
convention where the variable name is a prefix.  Handle both cases by
checking for a prefix match (GCC) and by checking after the first dot
separator (Clang).

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 0b0d1503851ff9..b1b068e9b4c708 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -242,16 +242,17 @@ static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
 static bool is_uncorrelated_static_local(struct symbol *sym)
 {
 	static const char * const vars[] = {
-		"__already_done.",
-		"__func__.",
-		"__key.",
-		"__warned.",
-		"_entry.",
-		"_entry_ptr.",
-		"_rs.",
-		"descriptor.",
-		"CSWTCH.",
+		"__already_done",
+		"__func__",
+		"__key",
+		"__warned",
+		"_entry",
+		"_entry_ptr",
+		"_rs",
+		"descriptor",
+		"CSWTCH",
 	};
+	const char *dot;
 
 	if (!is_object_sym(sym) || !is_local_sym(sym))
 		return false;
@@ -259,8 +260,20 @@ static bool is_uncorrelated_static_local(struct symbol *sym)
 	if (!strcmp(sym->sec->name, ".data.once"))
 		return true;
 
+	dot = strchr(sym->name, '.');
+	if (!dot)
+		return false;
+
 	for (int i = 0; i < ARRAY_SIZE(vars); i++) {
-		if (strstarts(sym->name, vars[i]))
+		size_t len = strlen(vars[i]);
+
+		/* GCC: <var>.<id> */
+		if (strstarts(sym->name, vars[i]) && (sym->name[len] == '.'))
+			return true;
+
+		/* Clang: <func>.<var>[.<id>] */
+		if (strstarts(dot + 1, vars[i]) &&
+		    (dot[1 + len] == '.' || dot[1 + len] == '\0'))
 			return true;
 	}
 
-- 
2.53.0



