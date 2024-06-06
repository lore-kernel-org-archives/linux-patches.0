Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E35F1C2241;
	Thu,  6 Jun 2024 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683641; cv=none; b=cGOFzEOGTRo8/s7AZmnDr661rJCR8oxuXz8+KNHGW0ZnHS5tw9DSWCH96oZAATAJrwe3HPGpSbJ+4gjHxV5b6WWpcpfMnmEvu4mPFO+5OiPQBp2A0JmLVE3MuOTvdJ/QfhD/ccDTW0T7Z63yzrXKwBpCaVPtZzLS8w1KFKjEsXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683641; c=relaxed/simple;
	bh=ORu1IefJUZvqb0LsdHAoVkxpNbyZ94r9zTIr8JzorDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJWmSHn7mIa6XBW9DgxWUpz9OJ+M7woP+umJgQFmszWGYEscpKks3JrxAWG8OZIctcrdKFT3A/YNY5kAwoP8cTqQv22VMhJeW8w5NtXKZUU0STlow7u3pYE2jUNJp6TEgPGuk72AhnmJ6rz1BdHNcRNun3oKVVSxS9M0CwEFuM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5RGxFzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5RGxFzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B637C32786;
	Thu,  6 Jun 2024 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683641;
	bh=ORu1IefJUZvqb0LsdHAoVkxpNbyZ94r9zTIr8JzorDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5RGxFzlv61U802coFLcDwdlzXq6LoLMOIgU22zhmUybE31hmpwOay2lmZaJuaFcH
	 24ZybTwtEdTbOay8lZmXW7F/pi7aeZafVGx+PhxORLY3Y3BCJWx5mpf7djz/I1eobS
	 +A4zm5BGFEGaoH5LFBBeWBjgZyZiHTgcqe6kbILw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 461/473] kconfig: fix comparison to constant symbols, m, n
Date: Thu,  6 Jun 2024 16:06:30 +0200
Message-ID: <20240606131714.923662541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a76925b46ce63..7b1df55b01767 100644
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



