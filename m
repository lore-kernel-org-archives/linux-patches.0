Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3836427FD7A;
	Wed, 23 Apr 2025 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419837; cv=none; b=VskMtNmfEX/KRtsMiOrsPb7G2YTXZluyUQvbfy1Mg1HEP3l59N53GmM/GJPY9rMHD9+CEnLd5ZLjB6yQwFXw0M58xJL0qQJvCjRRh5oH/hXT6gRBnz0pqi/HfR4VJlA/IA6p+Aapx2FX1MpfcsGKP3bwoEy6jgqnuLAL+eQG5TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419837; c=relaxed/simple;
	bh=uv17mEvyN9z5nFR2xOXZbzLDCMp8XsoTEZWyMCAFGS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8nV9B/qgwcyER+Hw00SZlrMsqno6/J3s7IVJbywrS4h/9eKQlx7w/fKXUfIE+MxeWWyx2u3nrSM0b7TZ+tTbi+3UiyjHbC5COecqmWhlRihAaK5pOSJR6MqS46Wdo642zoyjeRhNlTXNSLV3h4ly8a9vwLEp9RvAfNsUyhtQPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jimc4qaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jimc4qaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF897C4CEE8;
	Wed, 23 Apr 2025 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419837;
	bh=uv17mEvyN9z5nFR2xOXZbzLDCMp8XsoTEZWyMCAFGS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jimc4qazM8ltmtE1Y7BIObFN5exGyH7yENkO5U4cdN6pHTv9XdLGtbcJMG5uIw5Ok
	 dd2QzzQViwtydKRlFyJZ8xXALir5o3+Wh2LoTFqbFGSk96uAm6q+5a86FxJtW/dyEN
	 A3anMCS0aW7x2g0e9ZkS5ZGVhw5+cWpamY9DZ8Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/393] objtool: Fix INSN_CONTEXT_SWITCH handling in validate_unret()
Date: Wed, 23 Apr 2025 16:38:23 +0200
Message-ID: <20250423142643.567570355@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
index 9102ad5985cc0..8ba5bcfd5cd57 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3926,6 +3926,11 @@ static int validate_unret(struct objtool_file *file, struct instruction *insn)
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



