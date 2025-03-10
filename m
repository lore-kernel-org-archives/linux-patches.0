Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E332B17CA12;
	Mon, 10 Mar 2025 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629098; cv=none; b=JsEqxoQhRp/0tqCsIVeGJyZUlQSz1GtCOK4J4rGOnlYiu3nb22L4WETxt5SojAIiyPz7zuGDx5OTqSxahupODijdxwOIv4CfGq7SgB9l7UwFgjSbx/bg3kovontQOgt7EDAJRtQFsIWB9Buh3zfAqyTdC5FprUL9Zgoj7rDFVE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629098; c=relaxed/simple;
	bh=9LTOcx0Bnouh5U+JnoO/KssGWFE4xkBOSMVo26vwRDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNUDC4P9fUM2FO1LhgOahJGQ1/j+TGY+WS8J9XS5XPmM07EzNjXaVPeI+YTr4pyxg7vmzPzl7Mn9VMlCNn5wQhKDnpHPFiBTM40jkeUo+j6YUiY3nS74Nho/godVj5ULFCg+Y77WXuMXAY942AQitcThB/GyLj3okiyUTOte8u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOYzIE6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOYzIE6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBF4C4CEE5;
	Mon, 10 Mar 2025 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629097;
	bh=9LTOcx0Bnouh5U+JnoO/KssGWFE4xkBOSMVo26vwRDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOYzIE6PtdtWKMAcMEtq1QQM/cK33X/+s8wjcXDwODV/6ON+kkZeePE5qlOQlwLtz
	 CB//8PunBQOXldAfa7kLYLU2KcueCEYO9CRW99m/jGU307k+CEFDeBOVimWG58v9Qo
	 Sj4XJ5+W3CQKSV80FibpfgPFgvKfadKZl0FjhfBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/620] genksyms: fix memory leak when the same symbol is added from source
Date: Mon, 10 Mar 2025 18:00:21 +0100
Message-ID: <20250310170552.532744937@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 45c9c4101d3d2fdfa00852274bbebba65fcc3cf2 ]

When a symbol that is already registered is added again, __add_symbol()
returns without freeing the symbol definition, making it unreachable.

The following test cases demonstrate different memory leak points.

[Test Case 1]

Forward declaration with exactly the same definition

  $ cat foo.c
  #include <linux/export.h>
  void foo(void);
  void foo(void) {}
  EXPORT_SYMBOL(foo);

[Test Case 2]

Forward declaration with a different definition (e.g. attribute)

  $ cat foo.c
  #include <linux/export.h>
  void foo(void);
  __attribute__((__section__(".ref.text"))) void foo(void) {}
  EXPORT_SYMBOL(foo);

[Test Case 3]

Preserving an overridden symbol (compile with KBUILD_PRESERVE=1)

  $ cat foo.c
  #include <linux/export.h>
  void foo(void);
  void foo(void) { }
  EXPORT_SYMBOL(foo);

  $ cat foo.symref
  override foo void foo ( int )

The memory leaks in Test Case 1 and 2 have existed since the introduction
of genksyms into the kernel tree. [1]

The memory leak in Test Case 3 was introduced by commit 5dae9a550a74
("genksyms: allow to ignore symbol checksum changes").

When multiple init_declarators are reduced to an init_declarator_list,
the decl_spec must be duplicated. Otherwise, the following Test Case 4
would result in a double-free bug.

[Test Case 4]

  $ cat foo.c
  #include <linux/export.h>

  extern int foo, bar;

  int foo, bar;
  EXPORT_SYMBOL(foo);

In this case, 'foo' and 'bar' share the same decl_spec, 'int'. It must
be unshared before being passed to add_symbol().

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/?id=46bd1da672d66ccd8a639d3c1f8a166048cca608

Fixes: 5dae9a550a74 ("genksyms: allow to ignore symbol checksum changes")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/genksyms/genksyms.c |  3 +++
 scripts/genksyms/parse.y    | 14 ++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 4827c5abe5b71..de64aea6e8b4c 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -241,6 +241,7 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 						"unchanged\n");
 				}
 				sym->is_declared = 1;
+				free_list(defn, NULL);
 				return sym;
 			} else if (!sym->is_declared) {
 				if (sym->is_override && flag_preserve) {
@@ -249,6 +250,7 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 					print_type_name(type, name);
 					fprintf(stderr, " modversion change\n");
 					sym->is_declared = 1;
+					free_list(defn, NULL);
 					return sym;
 				} else {
 					status = is_unknown_symbol(sym) ?
@@ -256,6 +258,7 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 				}
 			} else {
 				error_with_pos("redefinition of %s", name);
+				free_list(defn, NULL);
 				return sym;
 			}
 			break;
diff --git a/scripts/genksyms/parse.y b/scripts/genksyms/parse.y
index 8e9b5e69e8f01..840371d01bf48 100644
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -152,14 +152,19 @@ simple_declaration:
 	;
 
 init_declarator_list_opt:
-	/* empty */				{ $$ = NULL; }
-	| init_declarator_list
+	/* empty */			{ $$ = NULL; }
+	| init_declarator_list		{ free_list(decl_spec, NULL); $$ = $1; }
 	;
 
 init_declarator_list:
 	init_declarator
 		{ struct string_list *decl = *$1;
 		  *$1 = NULL;
+
+		  /* avoid sharing among multiple init_declarators */
+		  if (decl_spec)
+		    decl_spec = copy_list_range(decl_spec, NULL);
+
 		  add_symbol(current_name,
 			     is_typedef ? SYM_TYPEDEF : SYM_NORMAL, decl, is_extern);
 		  current_name = NULL;
@@ -170,6 +175,11 @@ init_declarator_list:
 		  *$3 = NULL;
 		  free_list(*$2, NULL);
 		  *$2 = decl_spec;
+
+		  /* avoid sharing among multiple init_declarators */
+		  if (decl_spec)
+		    decl_spec = copy_list_range(decl_spec, NULL);
+
 		  add_symbol(current_name,
 			     is_typedef ? SYM_TYPEDEF : SYM_NORMAL, decl, is_extern);
 		  current_name = NULL;
-- 
2.39.5



