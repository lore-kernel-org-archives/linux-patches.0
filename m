Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2DB1FBC8C;
	Mon,  2 Jun 2025 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873175; cv=none; b=uLSMXBJ4y/7B+EjkHoeIObmvr1j6RHdhpGnniVJr7G6y34gR18Y1TUa1Qf7KtBFlfgEWpMPWpQlfQFG/XSOGrdjPGjSCn6rPHAeuMrS9k1tY2GYv1BBJySASuLF/AvACbqJ6Ho8o4NJDEsA0I3eYtXwhnnDMP0KXPlHK5apQpRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873175; c=relaxed/simple;
	bh=9CvzfTSd6r0FZUqUGRpIYrZbGioE+kiMcLDgm2l9AOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUZfDXy9JVlraaf5ULLjwe9EP/mYk5VMR/a9B6C3bhUgWwbVOP84SqMqrjkq5nVdQIa1YTTl0Fqof7fw0dud68kU9VjGRO6xXdV/AW8O+PCgQqKehhRL/efvubfVG6kmDVaL/adfwFfGQmkVcIad9imzHMZXNO9xFZofg+E6qWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLh2mTs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLh2mTs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E0BC4CEEB;
	Mon,  2 Jun 2025 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873174;
	bh=9CvzfTSd6r0FZUqUGRpIYrZbGioE+kiMcLDgm2l9AOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLh2mTs6hOLVb5yfjv1O6bEIQU+j9ijfmPCu6TjT+mV31EMocCNGwiPkp/N3jtYu7
	 l8rBiPdUQQFvv4O7b13KbeOHqbFXPXXeaKJ+BD33oddSHdt25ddpcunfVR4EyoS4VF
	 yKa4ejxPh5fg7btI+rFLNZtdGbXc0tzlAUOFeSKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/444] objtool: Properly disable uaccess validation
Date: Mon,  2 Jun 2025 15:42:05 +0200
Message-ID: <20250602134343.402045337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a1b14378bab04..f5af48502c9c8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3287,7 +3287,7 @@ static int handle_insn_ops(struct instruction *insn,
 		if (update_cfi_state(insn, next_insn, &state->cfi, op))
 			return 1;
 
-		if (!insn->alt_group)
+		if (!opts.uaccess || !insn->alt_group)
 			continue;
 
 		if (op->dest.type == OP_DEST_PUSHF) {
@@ -3754,6 +3754,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			return 0;
 
 		case INSN_STAC:
+			if (!opts.uaccess)
+				break;
+
 			if (state.uaccess) {
 				WARN_INSN(insn, "recursive UACCESS enable");
 				return 1;
@@ -3763,6 +3766,9 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			break;
 
 		case INSN_CLAC:
+			if (!opts.uaccess)
+				break;
+
 			if (!state.uaccess && func) {
 				WARN_INSN(insn, "redundant UACCESS disable");
 				return 1;
@@ -4238,7 +4244,8 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 	if (!insn || insn->ignore || insn->visited)
 		return 0;
 
-	state->uaccess = sym->uaccess_safe;
+	if (opts.uaccess)
+		state->uaccess = sym->uaccess_safe;
 
 	ret = validate_branch(file, insn_func(insn), insn, *state);
 	if (ret)
-- 
2.39.5



