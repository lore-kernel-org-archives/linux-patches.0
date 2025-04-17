Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6212571D1;
	Thu, 17 Apr 2025 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912453; cv=none; b=ftsmO4d5gWTpOlEhh2xqL/R9/UatKiKpIpr9NjkuM/GXkC4XclSsqwPvPtQvAdGXltu+svF0MCp/H0NSBJYWH4t8GxqsyiHMwd8ogispYSQUJsg2kcFRMGcu7T6B83l27bHtUClD0NJMkVP3fRJE/Z9+J5LR76J/nOYK8n2TUmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912453; c=relaxed/simple;
	bh=dlIasazkXHXiBOVviIVVn4ox/U/OQ/AtY+Pybqa0n5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=legv7UDmiRoqITt/NIoEQdT2yCAwRWUZEWHE/DOU3RetNxTtF4cyh1MJGdDem1c42YQd4mGOOmBvXUTeisVgnFeSMzYdCKEQCmJc35tc5mrOvrOPrO+4SVEATxXssII1IrIITYDa7U9xlO7AYWzAJ/k6tkETFaZhNXwb7M0PDHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJGQfmLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJGQfmLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2C2C4CEE4;
	Thu, 17 Apr 2025 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912453;
	bh=dlIasazkXHXiBOVviIVVn4ox/U/OQ/AtY+Pybqa0n5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJGQfmLs5+TThCN/FKRbytMlTVP/NDGBW+D5n82qfuUyWwQFCk5VouFeiN8MBESfr
	 Cvds8h6EIyIvWrn/K0XFtWDAb25J+ghUzXC3aRwFLcKTrR4arZBXztR4IE11I17ArX
	 TLQK53U/un9RUBGKuTnAOEdHcMCh0NlfR1++TTHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 016/449] objtool: Fix INSN_CONTEXT_SWITCH handling in validate_unret()
Date: Thu, 17 Apr 2025 19:45:04 +0200
Message-ID: <20250417175118.643185424@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit a8df7d0ef92eca28c610206c6748daf537ac0586 ]

The !CONFIG_IA32_EMULATION version of xen_entry_SYSCALL_compat() ends
with a SYSCALL instruction which is classified by objtool as
INSN_CONTEXT_SWITCH.

Unlike validate_branch(), validate_unret() doesn't consider
INSN_CONTEXT_SWITCH in a non-function to be a dead end, so it keeps
going past the end of xen_entry_SYSCALL_compat(), resulting in the
following warning:

  vmlinux.o: warning: objtool: xen_reschedule_interrupt+0x2a: RET before UNTRAIN

Fix that by adding INSN_CONTEXT_SWITCH handling to validate_unret() to
match what validate_branch() is already doing.

Fixes: a09a6e2399ba ("objtool: Add entry UNRET validation")
Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/f5eda46fd09f15b1f5cde3d9ae3b92b958342add.1744095216.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 159fb130e2827..9f4c54fe6f56f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3846,6 +3846,11 @@ static int validate_unret(struct objtool_file *file, struct instruction *insn)
 			WARN_INSN(insn, "RET before UNTRAIN");
 			return 1;
 
+		case INSN_CONTEXT_SWITCH:
+			if (insn_func(insn))
+				break;
+			return 0;
+
 		case INSN_NOP:
 			if (insn->retpoline_safe)
 				return 0;
-- 
2.39.5



