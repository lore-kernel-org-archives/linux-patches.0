Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E071EB5E;
	Thu, 13 Jun 2024 12:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282666; cv=none; b=OJwRnLfIFywN7mnAvXZZPo9gTC31u56nVF7CwJjGs9KxAlZg7l5d7c4bAmFMfKhtwGGuMGJ1QWHEvGsWxMdsRPVKD1tpWhHJb3XMTEbzGrDR0IHUWxMIu//VlqgO27rVp0WmWZdt9gk1Ix6aQb+LBfklXi31rUe1m5GYiAc8Qlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282666; c=relaxed/simple;
	bh=jpaSiT0yhpCWiDwd1xdh9xABJrMnY1zcC+iKCrbC9qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnyR4HPGiIvBo564PW4ujdWEFstqVNgGn08lMTE2TjzNSRRXx5ChLzwCFzloQpi8ng6nszmwHQcWKShE7jUeDHC64lBeBOY8J8KLnxdWus4txbA74+f+ahLcKjrGTMzNFpB6oRQJVQ2q2Yoh/Avg/vA8DtFMAMPI8Sx1xeHkiBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyT1mwUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyT1mwUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E79FC2BBFC;
	Thu, 13 Jun 2024 12:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282666;
	bh=jpaSiT0yhpCWiDwd1xdh9xABJrMnY1zcC+iKCrbC9qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyT1mwUuOscIoeSvkLrGJdLXxmwk1o8mrQgXZo95JI2qYWF3KpniRhLanwN8wTsqe
	 izPAv3oE3D4jbOoh2zRNAjiOPwClRVTj6wUsNSb7zMnRktsmvfn+Vog4mF+UEU9EbW
	 nwuUAdB4YX+Tv2YjGfJqH7Gd0Tw6J5U83X1rKdoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/402] kconfig: fix comparison to constant symbols, m, n
Date: Thu, 13 Jun 2024 13:34:41 +0200
Message-ID: <20240613113314.775930148@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit aabdc960a283ba78086b0bf66ee74326f49e218e ]

Currently, comparisons to 'm' or 'n' result in incorrect output.

[Test Code]

    config MODULES
            def_bool y
            modules

    config A
            def_tristate m

    config B
            def_bool A > n

CONFIG_B is unset, while CONFIG_B=y is expected.

The reason for the issue is because Kconfig compares the tristate values
as strings.

Currently, the .type fields in the constant symbol definitions,
symbol_{yes,mod,no} are unspecified, i.e., S_UNKNOWN.

When expr_calc_value() evaluates 'A > n', it checks the types of 'A' and
'n' to determine how to compare them.

The left-hand side, 'A', is a tristate symbol with a value of 'm', which
corresponds to a numeric value of 1. (Internally, 'y', 'm', and 'n' are
represented as 2, 1, and 0, respectively.)

The right-hand side, 'n', has an unknown type, so it is treated as the
string "n" during the comparison.

expr_calc_value() compares two values numerically only when both can
have numeric values. Otherwise, they are compared as strings.

    symbol    numeric value    ASCII code
    -------------------------------------
      y           2             0x79
      m           1             0x6d
      n           0             0x6e

'm' is greater than 'n' if compared numerically (since 1 is greater
than 0), but smaller than 'n' if compared as strings (since the ASCII
code 0x6d is smaller than 0x6e).

Specifying .type=S_TRISTATE for symbol_{yes,mod,no} fixes the above
test code.

Doing so, however, would cause a regression to the following test code.

[Test Code 2]

    config MODULES
            def_bool n
            modules

    config A
            def_tristate n

    config B
            def_bool A = m

You would get CONFIG_B=y, while CONFIG_B should not be set.

The reason is because sym_get_string_value() turns 'm' into 'n' when the
module feature is disabled. Consequently, expr_calc_value() evaluates
'A = n' instead of 'A = m'. This oddity has been hidden because the type
of 'm' was previously S_UNKNOWN instead of S_TRISTATE.

sym_get_string_value() should not tweak the string because the tristate
value has already been correctly calculated. There is no reason to
return the string "n" where its tristate value is mod.

Fixes: 31847b67bec0 ("kconfig: allow use of relations other than (in)equality")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/symbol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 7f8013dcef002..f9786621a178e 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -13,18 +13,21 @@
 
 struct symbol symbol_yes = {
 	.name = "y",
+	.type = S_TRISTATE,
 	.curr = { "y", yes },
 	.flags = SYMBOL_CONST|SYMBOL_VALID,
 };
 
 struct symbol symbol_mod = {
 	.name = "m",
+	.type = S_TRISTATE,
 	.curr = { "m", mod },
 	.flags = SYMBOL_CONST|SYMBOL_VALID,
 };
 
 struct symbol symbol_no = {
 	.name = "n",
+	.type = S_TRISTATE,
 	.curr = { "n", no },
 	.flags = SYMBOL_CONST|SYMBOL_VALID,
 };
@@ -775,8 +778,7 @@ const char *sym_get_string_value(struct symbol *sym)
 		case no:
 			return "n";
 		case mod:
-			sym_calc_value(modules_sym);
-			return (modules_sym->curr.tri == no) ? "n" : "m";
+			return "m";
 		case yes:
 			return "y";
 		}
-- 
2.43.0



