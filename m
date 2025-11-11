Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD3B4C97;
	Tue, 11 Nov 2025 00:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822356; cv=none; b=fVuqFMlzv+evBkhJBFsxDTTfdCPCd7zCCxbDJX0vr3sVCJFYy0X7XyRNyZyIXFPOXzJoKx3w1/nUtSPObtsFHMc/J1bQnO4GlT1NY4i4lmwjMI5e/C0hMdQh3O+jMEVLfJQipzr6xiV95i8wE+7RCEDQg8tLB5rckCmp6SLGwnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822356; c=relaxed/simple;
	bh=hZPD9rOS9XjTayKErqOxWiSo2h5/dw8/U40deVKKjwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqfPZ+RD6zoOf0/NTa3FbWLP2JnUWwJ2BYTmWIVLstr7CWEWNgqaJQ55fyIBrtmVsCBqDHWst4YqYdFGCAz3yidAxYE3wpK+xEWzBbir3BdjBRex2JZ4ZAEnMHz1uiJ/fby7EBnnXrGU9aqZWsDA/79Y7OFgUk5bvQ1y6xCwZ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK3O24A6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK3O24A6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9F8C19422;
	Tue, 11 Nov 2025 00:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822355;
	bh=hZPD9rOS9XjTayKErqOxWiSo2h5/dw8/U40deVKKjwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xK3O24A6Epx7YIFVb2MTXcDENSGUo18TZozq25oaGkvY/LRX2duDR5EKy2DPhA2mm
	 Ufx+aadqtVMVQGw50CVQSegF0J/Jg7yw7i2u9FGFhwtWG7TkRlnSZVdrDTmnpUeLN6
	 Ol1dnTwbB0pPdTLWzXPHMVjoJa52cjTERA8LR6x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/565] bpf, x86: Avoid repeated usage of bpf_prog->aux->stack_depth
Date: Tue, 11 Nov 2025 09:38:09 +0900
Message-ID: <20251111004527.629016359@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit f4b21ed0b9d6c9fe155451a1fb3531fb44b0afa8 ]

Refactor the code to avoid repeated usage of bpf_prog->aux->stack_depth
in do_jit() func. If the private stack is used, the stack_depth will be
0 for that prog. Refactoring make it easy to adjust stack_depth.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20241112163917.2224189-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 881a9c9cb785 ("bpf: Do not audit capability check in do_jit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index ccb2f7703c33c..9a861ac77f8eb 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1472,14 +1472,17 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image, u8 *rw_image
 	int i, excnt = 0;
 	int ilen, proglen = 0;
 	u8 *prog = temp;
+	u32 stack_depth;
 	int err;
 
+	stack_depth = bpf_prog->aux->stack_depth;
+
 	arena_vm_start = bpf_arena_get_kern_vm_start(bpf_prog->aux->arena);
 	user_vm_start = bpf_arena_get_user_vm_start(bpf_prog->aux->arena);
 
 	detect_reg_usage(insn, insn_cnt, callee_regs_used);
 
-	emit_prologue(&prog, bpf_prog->aux->stack_depth,
+	emit_prologue(&prog, stack_depth,
 		      bpf_prog_was_classic(bpf_prog), tail_call_reachable,
 		      bpf_is_subprog(bpf_prog), bpf_prog->aux->exception_cb);
 	/* Exception callback will clobber callee regs for its own use, and
@@ -2175,7 +2178,7 @@ st:			if (is_imm8(insn->off))
 
 			func = (u8 *) __bpf_call_base + imm32;
 			if (tail_call_reachable) {
-				LOAD_TAIL_CALL_CNT_PTR(bpf_prog->aux->stack_depth);
+				LOAD_TAIL_CALL_CNT_PTR(stack_depth);
 				ip += 7;
 			}
 			if (!imm32)
@@ -2192,13 +2195,13 @@ st:			if (is_imm8(insn->off))
 							  &bpf_prog->aux->poke_tab[imm32 - 1],
 							  &prog, image + addrs[i - 1],
 							  callee_regs_used,
-							  bpf_prog->aux->stack_depth,
+							  stack_depth,
 							  ctx);
 			else
 				emit_bpf_tail_call_indirect(bpf_prog,
 							    &prog,
 							    callee_regs_used,
-							    bpf_prog->aux->stack_depth,
+							    stack_depth,
 							    image + addrs[i - 1],
 							    ctx);
 			break;
-- 
2.51.0



