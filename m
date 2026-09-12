Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBE2364049;
	Sat, 12 Sep 2026 08:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201330; cv=none; b=pJoL1dQ9I7S9jkO0zj5U8GavrR1sZQVEK/P7YgtMewarmGOIUjnVfxQcT2gv5eb4pda1kDXuL1S/NtT7h83W9mC/sa6qbYLeGQ3cC++/1gJkI6DKs9DIOUU5hUY8ykKmGVUnOHaINC01El4oq2uJKfVf5GLTJqZ8lxB2Vu6CS6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201330; c=relaxed/simple;
	bh=G7VZMnLuoz6rQ6AG4NV5ZSJE/qncbKG3sMC7D9wzFTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRa3/lALO3lmmu5coUVEX/MAOissJ4MV0N+5xOhv1XmJZefrEbuDJow3Y/NZMTteccPcfmP188KjOCLo38zNFYGt+Isrd7TIZrUgsA0Hw8vBR+fKoTQ2VcK6GhTrcpzkbGAM08V5Uq/sT8NuFuoX2sj7Wm88VtMA5auA8WNXg9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoHa1kBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoHa1kBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824041F000FF;
	Sat, 12 Sep 2026 08:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201329;
	bh=nViI678pIKKZO+7yX6RMnMNhiEGa2PssZ2QlCIlO2a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoHa1kBQAs+H1GiAs2ALW5jfxfYE9NNjfCUWc/JwegEoq8NsH9b30Hp9dQ1zDvti5
	 UUYiH0sTA2cF+4JpQfmQLnzDx1QacWRizanto7OAHUO2lr0J0/9qOOhqTnGkUtCLi/
	 7IvTC9QRirgtxAqsOC31ikcnHtKPN1UgEsT5NP5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Procknow <bprockno@redhat.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	live-patching@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0975/1815] objtool/klp: Normalize Module.symvers paths to module names
Date: Sat, 12 Sep 2026 08:45:25 +0200
Message-ID: <20260912065711.870422699@linuxfoundation.org>
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

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 8668bf91e0508abeb8e98b4edd89032be02228a1 ]

Module.symvers contains build-tree object paths as module identifiers
(e.g., "arch/x86/kvm/kvm") rather than runtime module names ("kvm").
Objtool's clone_reloc_klp() uses this field directly for exported
symbols, while unexported symbols correctly go through __find_modname().

This means that exported symbol relocations may land in a .klp.rela
section named with the build path rather than the module name.  That is
a crash waiting to happen: the kernel's livepatch loader silently skips
this relocation because it doesn't match the expected klp_object name.
The unresolved relocation sits in the newly activated code, crashing
when executed.

Normalize export->mod at Module.symvers read time using the same logic
as __find_modname() (refactored into a shared normalize_modname()
helper).

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Reported-by: Ben Procknow <bprockno@redhat.com>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Cc: live-patching@vger.kernel.org
Link: https://patch.msgid.link/dbe1b72931bd3c31b751fd0729613d9f2226fff6.1785727106.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 49 ++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index aeb99d572300c..15d37d955af0e 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -83,6 +83,35 @@ static char *escape_str(const char *orig)
 	return new;
 }
 
+/*
+ * Convert a build-tree object path to a runtime module name: strip
+ * directory components, replace '-' with '_', and remove file
+ * extensions.  Examples:
+ *
+ *   "arch/x86/kvm/kvm" -> "kvm"
+ *   "arch/x86/kvm/kvm-intel" -> "kvm_intel".
+ *
+ * Used by read_exports() to normalize Module.symvers entries and by
+ * __find_modname() as a fallback when .modinfo lacks a "name=" tag.
+ */
+static char *normalize_modname(char *name)
+{
+	char *slash = strrchr(name, '/');
+
+	if (slash)
+		name = slash + 1;
+
+	for (char *c = name; *c; c++) {
+		if (*c == '-')
+			*c = '_';
+		else if (*c == '.') {
+			*c = '\0';
+			break;
+		}
+	}
+	return name;
+}
+
 static int read_exports(void)
 {
 	const char *symvers = "Module.symvers";
@@ -150,6 +179,9 @@ static int read_exports(void)
 			return -1;
 		}
 
+		if (strcmp(export->mod, "vmlinux"))
+			export->mod = normalize_modname(export->mod);
+
 		export->sym = strdup(sym);
 		if (!export->sym) {
 			ERROR_GLIBC("strdup");
@@ -1140,7 +1172,7 @@ static struct export *find_export(struct symbol *sym)
 static const char *__find_modname(struct elfs *e)
 {
 	struct section *sec;
-	char *name, *slash;
+	char *name;
 
 	sec = find_section_by_name(e->orig, ".modinfo");
 	if (!sec) {
@@ -1158,20 +1190,7 @@ static const char *__find_modname(struct elfs *e)
 		return NULL;
 	}
 
-	slash = strrchr(name, '/');
-	if (slash)
-		name = slash + 1;
-
-	for (char *c = name; *c; c++) {
-		if (*c == '-')
-			*c = '_';
-		else if (*c == '.') {
-			*c = '\0';
-			break;
-		}
-	}
-
-	return name;
+	return normalize_modname(name);
 }
 
 /* Get the object's module name as defined by the kernel (and klp_object) */
-- 
2.53.0



