Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79DC25E83E;
	Tue, 11 Mar 2025 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706719; cv=none; b=fI3QpkCXkJWqFq4P1f10KlkKO3iSmtudo0DXxXqM0qEV/oYMPSYQE4KR25oUOaeclQGdXfh3x2/+/7r79hDpiWLSt5aBcrFQI1Qe1/EdUDBkbOy3NDDR69vFHwRgpr7VeQVXFdhHHIzX9kMBj+FnErcparLT42mCPy7yf0LPtOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706719; c=relaxed/simple;
	bh=S0CGSYJa1j/CJJoimXeacX3uPL2S5hQEKePF9Sl8Vzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kvgu1iJNJh4eGf/e4N4FpgdcOIxMjrtGMDBur7br3La0uQFZ9/ujIZh6bRs6Z0HSwNPcTmQA2dBm9Sq3Oe/RsDE+Elqrl0fyE9H905MIZDITCCuMoqMT+K/STPJ+hieXWPb+1GXRWSo0SMrlPsUpBlhcLWXt4vXsfBOyFxKml7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8xN/f8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8xN/f8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F376C4CEEC;
	Tue, 11 Mar 2025 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706718;
	bh=S0CGSYJa1j/CJJoimXeacX3uPL2S5hQEKePF9Sl8Vzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8xN/f8EcrweKZGQf12RWxeQQZ+ygAQXAsapppm/AZ0XQoggwMheyAc94UrM1JUjG
	 AQTLstUnm9DFFmPyqMRpBprzGcw8yqYv8edHQIx/09Xr3y37GjnfLCj/BRmcuGFq9Y
	 uCJwf1xRnEBmLsAgXWizbUu6ykZCb04H4Le3DTck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/462] genksyms: fix memory leak when the same symbol is added from source
Date: Tue, 11 Mar 2025 15:56:18 +0100
Message-ID: <20250311145802.787822281@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 23eff234184f3..d74bad87ef1a7 100644
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
index e22b42245bcc2..7df3fe290d535 100644
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -149,14 +149,19 @@ simple_declaration:
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
@@ -167,6 +172,11 @@ init_declarator_list:
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



