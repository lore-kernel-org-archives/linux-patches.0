Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643721CAA99;
	Thu, 17 Apr 2025 18:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915091; cv=none; b=r1hKZyh2BRzR/J4RnHIJfzuVrID5nMW9o4g2ofbaPDh44BAdibvVB04kTz7ID7Wk+uizhBQ7ZCvRq2l5wLcNppDNWKSgHnYUtULXHNvwSV3KtCJIpQKafuBXD3DR76yhEG1RpPl3yEa+LKURzTVXx38NdzAHZzad1x2SP5vOY+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915091; c=relaxed/simple;
	bh=ysvXi3Km1Q8gByeinX46wBdlU0Vu7+SYuE9qnfyF8ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtDJucuAelTfuramDUJElP3oSc/bDyIgA+RogtHKGXGOPiZf8YaYaeg6ubIWM2rqw6/Rz1IqXqwyv5xfqG4oUBq5C02Iyhq/jP3DAK7+NPPDCyk0l4Xh/5zrsJW4PAc00XapYoBpHpzLLGL8c1l27oxhgNISZjiEl4A2F79sKec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnYe95wW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnYe95wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA329C4CEE4;
	Thu, 17 Apr 2025 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915091;
	bh=ysvXi3Km1Q8gByeinX46wBdlU0Vu7+SYuE9qnfyF8ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnYe95wWVYQFPjzc5t8jK4GIN2teqdW3BkhFa3sxLfq3oxQ7DBeO9t6M55kuOBu74
	 BMZwuLujPL3KeO16gFLlqF6VP+HtQ9XPyOZro47lEg2LnSwyQEvScpCYSi2NEg+vu7
	 atYSp/DxPZEnU2+ZTjtjHUP/nokHsqXwRm1zv4yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/393] objtool: Fix INSN_CONTEXT_SWITCH handling in validate_unret()
Date: Thu, 17 Apr 2025 19:47:05 +0200
Message-ID: <20250417175108.248968342@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 286a2c0af02aa..127862fa05c61 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3990,6 +3990,11 @@ static int validate_unret(struct objtool_file *file, struct instruction *insn)
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



