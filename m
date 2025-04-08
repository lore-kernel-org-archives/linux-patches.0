Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4F01B87CF;
	Tue,  8 Apr 2025 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116456; cv=none; b=sUc388S0NE7U7cPgxvV8UXbNkVYqoQS326rKbWkhbOVlRxgGLMeYsJdy0yv6p5yu7K6KqMdvch+LmKJLnGkpDnTYdHlW2gHNwSBsinA/3/8r0S9Cd48dGNR1YSfyk7eNSwjTEl8FltVHq/v/2/nLSh9j59dn6zEjSNXHl4Hyqac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116456; c=relaxed/simple;
	bh=F7CkfHGzWRjKyKEu9shzAbOx3ESVghpHj2dfDJIjRKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCZGDTlyBera2BBauIRvPUAvDZf2iFMHpcNXjdpIu6MYwyWDN2mpW2Kp3j30wxKik5vAltkIrxl4oTO1+kTCN3L7YZA4bPHO2U97Az2xBsJcj6QmcoVN19UtUG16BrRKSFGIVn6Q8YLlQQVr2Tt9Wh2+u7IGI0E20dIEro0mBfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z83+BuNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z83+BuNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91808C4CEEE;
	Tue,  8 Apr 2025 12:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116456;
	bh=F7CkfHGzWRjKyKEu9shzAbOx3ESVghpHj2dfDJIjRKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z83+BuNNVv+oqCFvno85bQ+8vEbtbI82F5Up1ro8PVKpwGGnvaP6FpU+yxEjro76r
	 eCGo6qJS0sJxDedeSTJcR3fqac1gPN3ExT7EExGTQ7yGOYI5ZyuBHdsC36F3rsottJ
	 q4PNPgPnAOg/5yoVglo0Pahdp2F1tqgghVhZjVCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/423] x86/entry: Fix ORC unwinder for PUSH_REGS with save_ret=1
Date: Tue,  8 Apr 2025 12:47:54 +0200
Message-ID: <20250408104849.178278248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

[ Upstream commit 57e2428f8df8263275344566e02c277648a4b7f1 ]

PUSH_REGS with save_ret=1 is used by interrupt entry helper functions that
initially start with a UNWIND_HINT_FUNC ORC state.

However, save_ret=1 means that we clobber the helper function's return
address (and then later restore the return address further down on the
stack); after that point, the only thing on the stack we can unwind through
is the IRET frame, so use UNWIND_HINT_IRET_REGS until we have a full
pt_regs frame.

( An alternate approach would be to move the pt_regs->di overwrite down
  such that it is the final step of pt_regs setup; but I don't want to
  rearrange entry code just to make unwinding a tiny bit more elegant. )

Fixes: 9e809d15d6b6 ("x86/entry: Reduce the code footprint of the 'idtentry' macro")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20250325-2025-03-unwind-fixes-v1-1-acd774364768@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/calling.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index ea81770629eea..626a81c6015bd 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -70,6 +70,8 @@ For 32-bit we have the following conventions - kernel is built with
 	pushq	%rsi		/* pt_regs->si */
 	movq	8(%rsp), %rsi	/* temporarily store the return address in %rsi */
 	movq	%rdi, 8(%rsp)	/* pt_regs->di (overwriting original return address) */
+	/* We just clobbered the return address - use the IRET frame for unwinding: */
+	UNWIND_HINT_IRET_REGS offset=3*8
 	.else
 	pushq   %rdi		/* pt_regs->di */
 	pushq   %rsi		/* pt_regs->si */
-- 
2.39.5



