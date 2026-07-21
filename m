Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A31369D71;
	Tue, 21 Jul 2026 17:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653392; cv=none; b=i/C50xgyA4Hr+tsDduZtciqpMXFzpgPDEOiycmovC92inNZnNWnyc56/D8xhDVdI+Dd41rj+ib+4UBLDUNvK+bjGZ2dQ/aw//7kimOwULgGEoKRgb6aXZ3nfzAZj2BEX7ZVUjk5H+/WlDywuLu716sbRO4fa00uL3uO5HE3n9Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653392; c=relaxed/simple;
	bh=yyRkeSU/pm7A1VS3bugFuymxw4qJOpOqoDgoktPyCLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpYgvDR7Q0DeDTZmyWm+VWkWYHkcjQzqHfUVH/V88bz9GooW+PHL9xn26j6KZKBfitCQ64s2q/v2dJLZh4h+A7+9NRWTYuvcTnkMWRv+cTvl9i89rV9GnDZ6l5NYoE4pCA8i3XPzme0mTRzRAv3DIix4CT4yuQn1NChh/NMVIhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szg15jB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szg15jB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451A81F000E9;
	Tue, 21 Jul 2026 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653390;
	bh=JeV1ONzj/S97cuS8mYWLFDbn89XYZviw69cDYm49q2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szg15jB9+cIYsY8pUtNO64/LOwsVm9S3+w8ZGb/F5t8Mazsa4TKV7sUZh5CYE3z1X
	 Q7A32cuKGHW73Is8qWj/TeKv5PvuikIc1QEN/Vfxg07O6Lh2qbzaMUiLWXNbMkvXb+
	 n6FbGkPUU3HA4Z0Dj0g1zp1dLDYJ9BOSwfqU4/uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Matthew Bystrin <dev.mbstr@gmail.com>,
	Rui Qi <qirui.001@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1309/2077] riscv: Fix 32-bit call_on_irq_stack() frame pointer ABI
Date: Tue, 21 Jul 2026 17:16:22 +0200
Message-ID: <20260721152623.694845081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit c4c7756a81b5baef286bf9be1ea404f3e4dd7a3c ]

call_on_irq_stack() uses struct member offsets to set up its link in the
frame record list. On riscv32, struct stackframe is the wrong size to
maintain stack pointer alignment, so STACKFRAME_SIZE_ON_STACK includes
padding. However, the ABI requires the frame record to be placed
immediately below the address stored in s0, so the padding must come
before the struct members.

Fix the layout by making STACKFRAME_FP and STACKFRAME_RA the negative
offsets from s0, instead of the positive offsets from sp.

Fixes: 82982fdd5133 ("riscv: Deduplicate IRQ stack switching")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Matthew Bystrin <dev.mbstr@gmail.com>
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Link: https://lore.kernel.org/all/20240530001733.1407654-2-samuel.holland@sifive.com/
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/20260624113148.3723541-1-qirui.001@bytedance.com
[pjw@kernel.org: cleaned up the patch tags and added Matthew's Reviewed-by]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/asm-offsets.c | 4 ++--
 arch/riscv/kernel/entry.S       | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index af827448a609e6..a75f0cfea1e9fa 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -501,8 +501,8 @@ void asm_offsets(void)
 	OFFSET(SBI_HART_BOOT_STACK_PTR_OFFSET, sbi_hart_boot_data, stack_ptr);
 
 	DEFINE(STACKFRAME_SIZE_ON_STACK, ALIGN(sizeof(struct stackframe), STACK_ALIGN));
-	OFFSET(STACKFRAME_FP, stackframe, fp);
-	OFFSET(STACKFRAME_RA, stackframe, ra);
+	DEFINE(STACKFRAME_FP, offsetof(struct stackframe, fp) - sizeof(struct stackframe));
+	DEFINE(STACKFRAME_RA, offsetof(struct stackframe, ra) - sizeof(struct stackframe));
 #ifdef CONFIG_FUNCTION_TRACER
 	DEFINE(FTRACE_OPS_FUNC,		offsetof(struct ftrace_ops, func));
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index e189c477c0e23a..9a06ed983bb061 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -386,8 +386,8 @@ SYM_CODE_END(ret_from_fork_user_asm)
 SYM_FUNC_START(call_on_irq_stack)
 	/* Create a frame record to save ra and s0 (fp) */
 	addi	sp, sp, -STACKFRAME_SIZE_ON_STACK
-	REG_S	ra, STACKFRAME_RA(sp)
-	REG_S	s0, STACKFRAME_FP(sp)
+	REG_S	ra, (STACKFRAME_SIZE_ON_STACK + STACKFRAME_RA)(sp)
+	REG_S	s0, (STACKFRAME_SIZE_ON_STACK + STACKFRAME_FP)(sp)
 	addi	s0, sp, STACKFRAME_SIZE_ON_STACK
 
 	/* Switch to the per-CPU shadow call stack */
@@ -405,8 +405,8 @@ SYM_FUNC_START(call_on_irq_stack)
 
 	/* Switch back to the thread stack and restore ra and s0 */
 	addi	sp, s0, -STACKFRAME_SIZE_ON_STACK
-	REG_L	ra, STACKFRAME_RA(sp)
-	REG_L	s0, STACKFRAME_FP(sp)
+	REG_L	ra, (STACKFRAME_SIZE_ON_STACK + STACKFRAME_RA)(sp)
+	REG_L	s0, (STACKFRAME_SIZE_ON_STACK + STACKFRAME_FP)(sp)
 	addi	sp, sp, STACKFRAME_SIZE_ON_STACK
 
 	ret
-- 
2.53.0



