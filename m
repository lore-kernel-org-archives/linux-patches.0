Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0713D600;
	Tue, 23 Jul 2024 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759593; cv=none; b=I0E7Xnm+8c1IYXz+CVhjo6KaPoooeR7kHRcuB6HFx+ckqJ+uRv8d9ESaREklr9De2clWjlPAPscOshURRF0KUdsotVK34cgTdT2S2ooBUOHfXFZEb9cIYHjyB5AVbwTs6zefLhV4sGowv6WMo+NHzK2qqDxwu4ufV1zvUyKu0B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759593; c=relaxed/simple;
	bh=J3DuDjzyIAq7RLDEzMu0qbuOxVeomBHSu+IH8mTyQMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYi4qhhDWmxgFSy1Vba1amEoh+bN7ERu5XZTEtztpxTayc1PhjcG3FAPUgRUMXw2kqefLkcJHYJkjDSdLpkgNqHyL6MvQVLWyzRoP0WN3H3e3uOWMmWAC1CyoeKN4lOBZR8LiJ20UkDaoG4sj/xTG60wkJWd2MWSd2s+Kh/XxJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7oCcLci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7oCcLci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782ECC4AF0A;
	Tue, 23 Jul 2024 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759592;
	bh=J3DuDjzyIAq7RLDEzMu0qbuOxVeomBHSu+IH8mTyQMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7oCcLciiSmfc+vju45cfh1NDKzIiD25GIW+umpv5M//WpwzPAb8YcYGNw8rSzSkB
	 J9165bhdhAwC90PMnagtu2e0P+4siJM8H6lLVzI+Ea2RiIEOLP0yBXVNSuxK1sGAuE
	 strPTCSkArYB4elLeksS2zAhirg31uOSR2/B3tzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/129] kconfig: remove wrong expr_trans_bool()
Date: Tue, 23 Jul 2024 20:23:00 +0200
Message-ID: <20240723180406.031823235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 77a92660d8fe8d29503fae768d9f5eb529c88b36 ]

expr_trans_bool() performs an incorrect transformation.

[Test Code]

    config MODULES
            def_bool y
            modules

    config A
            def_bool y
            select C if B != n

    config B
            def_tristate m

    config C
            tristate

[Result]

    CONFIG_MODULES=y
    CONFIG_A=y
    CONFIG_B=m
    CONFIG_C=m

This output is incorrect because CONFIG_C=y is expected.

Documentation/kbuild/kconfig-language.rst clearly explains the function
of the '!=' operator:

    If the values of both symbols are equal, it returns 'n',
    otherwise 'y'.

Therefore, the statement:

    select C if B != n

should be equivalent to:

    select C if y

Or, more simply:

    select C

Hence, the symbol C should be selected by the value of A, which is 'y'.

However, expr_trans_bool() wrongly transforms it to:

    select C if B

Therefore, the symbol C is selected by (A && B), which is 'm'.

The comment block of expr_trans_bool() correctly explains its intention:

  * bool FOO!=n => FOO
    ^^^^

If FOO is bool, FOO!=n can be simplified into FOO. This is correct.

However, the actual code performs this transformation when FOO is
tristate:

    if (e->left.sym->type == S_TRISTATE) {
                             ^^^^^^^^^^

While it can be fixed to S_BOOLEAN, there is no point in doing so
because expr_tranform() already transforms FOO!=n to FOO when FOO is
bool. (see the "case E_UNEQUAL" part)

expr_trans_bool() is wrong and unnecessary.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/expr.c | 29 -----------------------------
 scripts/kconfig/expr.h |  1 -
 scripts/kconfig/menu.c |  2 --
 3 files changed, 32 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index 81ebf8108ca74..81dfdf4470f75 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -396,35 +396,6 @@ static struct expr *expr_eliminate_yn(struct expr *e)
 	return e;
 }
 
-/*
- * bool FOO!=n => FOO
- */
-struct expr *expr_trans_bool(struct expr *e)
-{
-	if (!e)
-		return NULL;
-	switch (e->type) {
-	case E_AND:
-	case E_OR:
-	case E_NOT:
-		e->left.expr = expr_trans_bool(e->left.expr);
-		e->right.expr = expr_trans_bool(e->right.expr);
-		break;
-	case E_UNEQUAL:
-		// FOO!=n -> FOO
-		if (e->left.sym->type == S_TRISTATE) {
-			if (e->right.sym == &symbol_no) {
-				e->type = E_SYMBOL;
-				e->right.sym = NULL;
-			}
-		}
-		break;
-	default:
-		;
-	}
-	return e;
-}
-
 /*
  * e1 || e2 -> ?
  */
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 4a9a23b1b7e1f..fa38f9f263f7e 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -295,7 +295,6 @@ void expr_free(struct expr *e);
 void expr_eliminate_eq(struct expr **ep1, struct expr **ep2);
 int expr_eq(struct expr *e1, struct expr *e2);
 tristate expr_calc_value(struct expr *e);
-struct expr *expr_trans_bool(struct expr *e);
 struct expr *expr_eliminate_dups(struct expr *e);
 struct expr *expr_transform(struct expr *e);
 int expr_contains_symbol(struct expr *dep, struct symbol *sym);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 61c442d84aef4..69a77f308fdc1 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -380,8 +380,6 @@ void menu_finalize(struct menu *parent)
 				dep = expr_transform(dep);
 				dep = expr_alloc_and(expr_copy(basedep), dep);
 				dep = expr_eliminate_dups(dep);
-				if (menu->sym && menu->sym->type != S_TRISTATE)
-					dep = expr_trans_bool(dep);
 				prop->visible.expr = dep;
 
 				/*
-- 
2.43.0



