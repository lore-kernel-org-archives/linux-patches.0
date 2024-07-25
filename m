Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829519D086;
	Thu, 25 Jul 2024 14:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918406; cv=none; b=E+MaPFiYPCcGvu+wxO81scPcODKrZzCB3kjU9jpqERhn4Uoz2q1aSRczbqg4hJw26ZqJNLpRV0/n0mxiUtK4vjPqiGAYxiJXi/jHo7w/r4jl8dhvyyjV5qkbjxAFIZjKZJjC02YYECMVa+HQOOwfi761957UXCYyldj/bDezhSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918406; c=relaxed/simple;
	bh=JZzuceccPAKi7i7zjb9Qi2ngoBZt+ag/GATkL7So9MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFZ2Lzszkh+iUZOxcBPLvtiHJ31DtSRvS+XgIgZoei7BO1szgUIlJQLNfRqPhTP9B88HejGkVOdr5cDFBizZxSQGgqBw62Qs7CnwEfN1ypkYhNp7bCGxmrAp09Qucro0FtcdGFMA+YPdwgKyUSa+0CXbdQhTX9S3AG3V4Rrdjsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjPdnNtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjPdnNtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04E2C116B1;
	Thu, 25 Jul 2024 14:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918406;
	bh=JZzuceccPAKi7i7zjb9Qi2ngoBZt+ag/GATkL7So9MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjPdnNtfPhTJTijcYaAXfNWktyyFa+C7Rxli7z0a3kdBXxzR3JfpNAZzB1T4iR8ca
	 aEu8pvc2l5Pi+qFfFRZl7fKrrdvtBvN9ioi7/BaupK82hJgc88WxFfyOBxszklB1v1
	 Lw+3Qk0UBShsO89dvbGGau9mHp0UtM+p4k9HX+S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/33] kconfig: remove wrong expr_trans_bool()
Date: Thu, 25 Jul 2024 16:36:33 +0200
Message-ID: <20240725142728.911910274@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7e38070ee523b..1c69de8cacf6d 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -395,35 +395,6 @@ static struct expr *expr_eliminate_yn(struct expr *e)
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
index 43a87f8ea738c..968219750244a 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -302,7 +302,6 @@ struct expr *expr_copy(const struct expr *org);
 void expr_free(struct expr *e);
 void expr_eliminate_eq(struct expr **ep1, struct expr **ep2);
 tristate expr_calc_value(struct expr *e);
-struct expr *expr_trans_bool(struct expr *e);
 struct expr *expr_eliminate_dups(struct expr *e);
 struct expr *expr_transform(struct expr *e);
 int expr_contains_symbol(struct expr *dep, struct symbol *sym);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 4cf15d449c05d..4d48ff3083bd8 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -390,8 +390,6 @@ void menu_finalize(struct menu *parent)
 				dep = expr_transform(dep);
 				dep = expr_alloc_and(expr_copy(basedep), dep);
 				dep = expr_eliminate_dups(dep);
-				if (menu->sym && menu->sym->type != S_TRISTATE)
-					dep = expr_trans_bool(dep);
 				prop->visible.expr = dep;
 
 				/*
-- 
2.43.0



