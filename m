Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDA4231826;
	Mon,  2 Jun 2025 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876739; cv=none; b=Rwgwya/3RbKFw5m5UeQr0Zja+MIbvVDw9mZmxJJtsw6PTuaYRCJcxedfYu3LvOszq4kX33ID6ET2qiCKGAArRtiCo/B4Kwg6aXkiVjtzq4SwtxvCTIb0WBlRw2M9THoP8gPfN/MIoOTQsFAQMmBWJjFas/bBUMnP0I1IGLtyCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876739; c=relaxed/simple;
	bh=j9QZ08CInXG7O4VF6JdV9PguEBKGpsMLQI+PGgUSkvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHVax8Mz5CYaRSrMUiirAUu9Qw1vTUqeEvGbctozScEcpeADKO8liXB25jfxq76gUR4r4e82VlSTA+x0Uog/91PgICU/iXdILZeqBXFuxveab3xpLGxH8Jnbk4IwCtVtIog2Sup84Sv+FrXtsUSuaYwEIdFlNoDP+gGcxV2VmDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPFg2Hf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPFg2Hf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0153EC4CEEB;
	Mon,  2 Jun 2025 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876739;
	bh=j9QZ08CInXG7O4VF6JdV9PguEBKGpsMLQI+PGgUSkvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPFg2Hf+XMkTr5yj7Q2xbjMBn7w+bXmGCby0i6YMKCOVJMGdZPjC4rQlluJhUk0bG
	 vcpvmQAmIMJ44SYEXEPrktQQkXYOS5w25SuHLmbZndthcEjcSF3DFQGlcVyc2R56ON
	 xH+mfanD+6IUwsyxyrw7ODbZ3hbYIWXgB2O6gLb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/325] objtool: Properly disable uaccess validation
Date: Mon,  2 Jun 2025 15:45:17 +0200
Message-ID: <20250602134321.421427030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit e1a9dda74dbffbc3fa2069ff418a1876dc99fb14 ]

If opts.uaccess isn't set, the uaccess validation is disabled, but only
partially: it doesn't read the uaccess_safe_builtin list but still tries
to do the validation.  Disable it completely to prevent false warnings.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/0e95581c1d2107fb5f59418edf2b26bba38b0cbb.1742852846.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 828c91aaf55bd..bf75628c5389a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3083,7 +3083,7 @@ static int handle_insn_ops(struct instruction *insn,
 		if (update_cfi_state(insn, next_insn, &state->cfi, op))
 			return 1;
 
-		if (!insn->alt_group)
+		if (!opts.uaccess || !insn->alt_group)
 			continue;
 
 		if (op->dest.type == OP_DEST_PUSHF) {
@@ -3535,6 +3535,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			return 0;
 
 		case INSN_STAC:
+			if (!opts.uaccess)
+				break;
+
 			if (state.uaccess) {
 				WARN_FUNC("recursive UACCESS enable", sec, insn->offset);
 				return 1;
@@ -3544,6 +3547,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			break;
 
 		case INSN_CLAC:
+			if (!opts.uaccess)
+				break;
+
 			if (!state.uaccess && func) {
 				WARN_FUNC("redundant UACCESS disable", sec, insn->offset);
 				return 1;
@@ -3956,7 +3962,8 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 	if (!insn || insn->ignore || insn->visited)
 		return 0;
 
-	state->uaccess = sym->uaccess_safe;
+	if (opts.uaccess)
+		state->uaccess = sym->uaccess_safe;
 
 	ret = validate_branch(file, insn->func, insn, *state);
 	if (ret && opts.backtrace)
-- 
2.39.5



