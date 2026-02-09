Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F004723B604;
	Mon,  9 Feb 2026 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647440; cv=none; b=qviMLAcVh8gxU8BOj9tvOqVuxAQtPyzj7Ak//lPU+C/fJ1fwjTioyNh5ZVOKUX7Gj99uaAvolNngoktF95Hghd1boedyCF3f9pf+pNGc1FrIrG19WQe5HwRcwv5dE2UGmJo7TAkLlNWicSpzsEzemH7xYTM4+uC6SgomUqBT01E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647440; c=relaxed/simple;
	bh=HOfTNb44as9xUM+fBNMFpZaEWK5N+vjmeMY0r+Zxx54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI1kucwCxnOs/TCs7aBrcnJ93g0UkzNHiWx5SJPvJ1ILaf+zMOv1GjCYjRVy37RoZFBEMhfB9OrUyi5of1aVIL5MoabTJSMhAVDUAbKn3dS8eI4aIznvhdglYdI3B/RZiIrJFnRD2uE+TnuCM006DFrqvOIEvM0yBK4NWLBAQv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIK4wXUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIK4wXUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53117C116C6;
	Mon,  9 Feb 2026 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647439;
	bh=HOfTNb44as9xUM+fBNMFpZaEWK5N+vjmeMY0r+Zxx54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIK4wXUoxEJePbceWRkXNCqH3KlqZCT1KuI9ZJOc/V8BJLwfB0WiYOpUbFixDJAkG
	 02xW6vvUl2ryDgKXcgWdC2ayyfmOXeTPNRZ7sjLgLGeiZhOrx/RT2fcaynWwnANdXp
	 yXQWsMqacW8BNQko1CB9A1nUGFxYbkISosruPkcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/175] riscv: Use 64-bit variable for output in __get_user_asm
Date: Mon,  9 Feb 2026 15:22:54 +0100
Message-ID: <20260209142324.052847419@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit bdce162f2e57a969803e5e9375999a3e0546905f ]

After commit f6bff7827a48 ("riscv: uaccess: use 'asm_goto_output' for
get_user()"), which was the first commit that started using asm goto
with outputs on RISC-V, builds of clang built with assertions enabled
start crashing in certain files that use get_user() with:

  clang: llvm/lib/CodeGen/SelectionDAG/SelectionDAGBuilder.cpp:12743: Register FollowCopyChain(MachineRegisterInfo &, Register): Assertion `MI->getOpcode() == TargetOpcode::COPY && "start of copy chain MUST be COPY"' failed.

Internally, LLVM generates an addiw instruction when the output of the
inline asm (which may be any scalar type) needs to be sign extended for
ABI reasons, such as a later function call, so that basic block does not
have to do it.

Use a temporary 64-bit variable as the output of the inline assembly in
__get_user_asm() and explicitly cast it to truncate it if necessary,
avoiding the addiw that triggers the assertion.

Link: https://github.com/ClangBuiltLinux/linux/issues/2092
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260116-riscv-wa-llvm-asm-goto-outputs-assertion-failure-v3-1-55b5775f989b@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/uaccess.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index f5f4f7f85543f..1029c31026dcf 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -97,13 +97,23 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm, unsigne
  */
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+/*
+ * Use a temporary variable for the output of the asm goto to avoid a
+ * triggering an LLVM assertion due to sign extending the output when
+ * it is used in later function calls:
+ * https://github.com/llvm/llvm-project/issues/143795
+ */
 #define __get_user_asm(insn, x, ptr, label)			\
+do {								\
+	u64 __tmp;						\
 	asm_goto_output(					\
 		"1:\n"						\
 		"	" insn " %0, %1\n"			\
 		_ASM_EXTABLE_UACCESS_ERR(1b, %l2, %0)		\
-		: "=&r" (x)					\
-		: "m" (*(ptr)) : : label)
+		: "=&r" (__tmp)					\
+		: "m" (*(ptr)) : : label);			\
+	(x) = (__typeof__(x))__tmp;				\
+} while (0)
 #else /* !CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
 #define __get_user_asm(insn, x, ptr, label)			\
 do {								\
-- 
2.51.0



