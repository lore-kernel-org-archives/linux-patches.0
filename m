Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACABF1A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAkaHs/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE017C433CA;
	Mon, 16 Oct 2023 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446205;
	bh=uHyBMS5zh5G4W+lqUJLvP6lAXCseEB8EMQIcTllExqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAkaHs/1zeRoR2ATHQQKWYtNWMunQ2U2/ZhmAxev4Vud7NlIeVKD1d1tXbKiCjJ/h
	 KHySh+97mhQ35K6lIoE4yxLXMc2LGYn4SajsA07kpOY81lEi4bFosVmlo1pWfOEjyZ
	 /ovYY8ssXvskUqKmPyKKk93CO956/e0Ui0erWktM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 093/102] arm64: factor insn read out of call_undef_hook()
Date: Mon, 16 Oct 2023 10:41:32 +0200
Message-ID: <20231016083956.176201252@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit dbfbd87efa79575491af0ba1a87bf567eaea6cae upstream.

Subsequent patches will rework EL0 UNDEF handling, removing the need for
struct undef_hook and call_undef_hook. In preparation for those changes,
this patch factors the logic for reading user instructions out of
call_undef_hook() and into a new user_insn_read() helper, matching the
style of the existing aarch64_insn_read() helper used for reading kernel
instructions.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221019144123.612388-5-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/traps.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -394,25 +394,22 @@ void unregister_undef_hook(struct undef_
 	raw_spin_unlock_irqrestore(&undef_lock, flags);
 }
 
-static int call_undef_hook(struct pt_regs *regs)
+static int user_insn_read(struct pt_regs *regs, u32 *insnp)
 {
-	struct undef_hook *hook;
-	unsigned long flags;
 	u32 instr;
-	int (*fn)(struct pt_regs *regs, u32 instr) = NULL;
 	void __user *pc = (void __user *)instruction_pointer(regs);
 
 	if (compat_thumb_mode(regs)) {
 		/* 16-bit Thumb instruction */
 		__le16 instr_le;
 		if (get_user(instr_le, (__le16 __user *)pc))
-			goto exit;
+			return -EFAULT;
 		instr = le16_to_cpu(instr_le);
 		if (aarch32_insn_is_wide(instr)) {
 			u32 instr2;
 
 			if (get_user(instr_le, (__le16 __user *)(pc + 2)))
-				goto exit;
+				return -EFAULT;
 			instr2 = le16_to_cpu(instr_le);
 			instr = (instr << 16) | instr2;
 		}
@@ -420,10 +417,20 @@ static int call_undef_hook(struct pt_reg
 		/* 32-bit ARM instruction */
 		__le32 instr_le;
 		if (get_user(instr_le, (__le32 __user *)pc))
-			goto exit;
+			return -EFAULT;
 		instr = le32_to_cpu(instr_le);
 	}
 
+	*insnp = instr;
+	return 0;
+}
+
+static int call_undef_hook(struct pt_regs *regs, u32 instr)
+{
+	struct undef_hook *hook;
+	unsigned long flags;
+	int (*fn)(struct pt_regs *regs, u32 instr) = NULL;
+
 	raw_spin_lock_irqsave(&undef_lock, flags);
 	list_for_each_entry(hook, &undef_hook, node)
 		if ((instr & hook->instr_mask) == hook->instr_val &&
@@ -431,7 +438,7 @@ static int call_undef_hook(struct pt_reg
 			fn = hook->fn;
 
 	raw_spin_unlock_irqrestore(&undef_lock, flags);
-exit:
+
 	return fn ? fn(regs, instr) : 1;
 }
 
@@ -483,13 +490,19 @@ void arm64_notify_segfault(unsigned long
 
 void do_el0_undef(struct pt_regs *regs, unsigned long esr)
 {
+	u32 insn;
+
 	/* check for AArch32 breakpoint instructions */
 	if (!aarch32_break_handler(regs))
 		return;
 
-	if (call_undef_hook(regs) == 0)
+	if (user_insn_read(regs, &insn))
+		goto out_err;
+
+	if (call_undef_hook(regs, insn) == 0)
 		return;
 
+out_err:
 	force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
 }
 


