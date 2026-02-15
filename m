Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5CA1367;
	Sun, 15 Feb 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167816; cv=none; b=mU9ICs/8spOR1FNjwkNVTePFVTvzYM9dCUvJjNtPo8h/2qXvuf+zuRgycodZnCN+5VAD1qq/yYMW/PBGX4JIc4gH2Tg6x/1vnzTmIc17eLaVGhC9jlvLypl0cw6Mm8emhZ2uJ4bxyXRro9wji6PwP1TBr7AYNS3A1jV2Jtcxp1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167816; c=relaxed/simple;
	bh=wVaofg3E0qedZW4L4ZDRs8qnTvcQSmBPaPzB3h+kGYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Qh5esvv8zxF/x1q75bwqqCfkFKJJd0G+8JRm/z5Ioxeq0GEGPV8ktsThx53KienL6M+BUop+UdVqBNl64gwWsRrJOB8aut/awet5od9SgYdTvTkI+IjoDXGnqM5iJO+u2HNvnchGRg1GAdOV1yNCP/cqYW1yW1VTCsl0CdYsLSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWx0CH7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWx0CH7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F713C4CEF7;
	Sun, 15 Feb 2026 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167816;
	bh=wVaofg3E0qedZW4L4ZDRs8qnTvcQSmBPaPzB3h+kGYc=;
	h=From:To:Cc:Subject:Date:From;
	b=DWx0CH7o0sEmtJRskSBMOmmzvzDqQohLC0hu4t2WNlqt08XF6S7S6ecDs1wZSh14h
	 EPS+3XqDVQYI1hIujeITSqnc/fKITevb4L97Bv2+lNfKv56kk/d5RVGcAgxdR3mvT/
	 p1ZFfNvnTvQn/OOjLP0VfMPgrB8YW6OaCTxrTGEGv7xBeNOK2bbdXbn8mMSw0Aaa/V
	 zR2qNnwh7UiBI8Pc9QXacICzXAPaIMFKDyU6MxQnWgGbGfDY3n2d1V3Js4gQYsG+EA
	 10KuPCT+Tgow/2F4pmql/Ujujs3Y9FVOz2M6q/ASs5pEyaKSU37Xbe2Eidk5p96zpX
	 mbWAM8v1GjkjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sergey Matyukevich <geomatsi@gmail.com>,
	Andy Chiu <andybnac@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	neil.armstrong@linaro.org,
	philmd@linaro.org,
	cleger@rivosinc.com,
	yelangyan@huaqin.corp-partner.google.com,
	yongxuan.wang@sifive.com,
	alexghiti@rivosinc.com,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.12] riscv: vector: init vector context with proper vlenb
Date: Sun, 15 Feb 2026 10:03:18 -0500
Message-ID: <20260215150333.2150455-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergey Matyukevich <geomatsi@gmail.com>

[ Upstream commit ef3ff40346db8476a9ef7269fc9d1837e7243c40 ]

The vstate in thread_struct is zeroed when the vector context is
initialized. That includes read-only register vlenb, which holds
the vector register length in bytes. Zeroed state persists until
mstatus.VS becomes 'dirty' and a context switch saves the actual
hardware values.

This can expose the zero vlenb value to the user-space in early
debug scenarios, e.g. when ptrace attaches to a traced process
early, before any vector instruction except the first one was
executed.

Fix this by specifying proper vlenb on vector context init.

Signed-off-by: Sergey Matyukevich <geomatsi@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Tested-by: Andy Chiu <andybnac@gmail.com>
Link: https://patch.msgid.link/20251214163537.1054292-3-geomatsi@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The calculation `riscv_v_vsize / 32` is used consistently throughout the
codebase (e.g., `arch/riscv/kvm/vcpu_vector.c:26` and
`arch/riscv/include/asm/vector.h:157`), confirming it's the correct
formula.

### Summary of Analysis

**What the bug is:**
When RISC-V vector context is first allocated (either for kernel
preemptive V use or on the first user-space vector instruction), the
`__riscv_v_ext_state` structure is zeroed, including the `vlenb` field.
The `vlenb` field represents the vector register length in bytes — a
read-only hardware property. This zero value persists until a context
switch with `mstatus.VS == dirty` causes the hardware values to be
saved.

**User impact:**
When ptrace (debuggers like GDB/LLDB) attaches to a process early —
before any vector instruction has been executed or before a context
switch has saved hardware values — ptrace reads `vlenb` as 0 instead of
the actual hardware value. This is incorrect data being exposed to
userspace, which can cause debuggers and tracing tools to malfunction.

**Fix characteristics:**
- **Small and surgical**: The core fix is a single line addition:
  `ctx->vlenb = riscv_v_vsize / 32;`
- **Function rename**: `riscv_v_thread_zalloc` →
  `riscv_v_thread_ctx_alloc` (reflects that it now does more than
  zalloc)
- **Obviously correct**: Uses the same formula as everywhere else in the
  kernel (`riscv_v_vsize / 32`)
- **Well-tested**: Has `Reviewed-by` and `Tested-by` from Andy Chiu, the
  RISC-V vector subsystem author
- **No new features**: Fixes incorrect initialization of existing state
- **Low risk**: Only affects RISC-V vector state initialization; the
  value being set is identical to what hardware would provide

**Stable criteria check:**
1. Obviously correct and tested — YES (reviewed + tested by maintainer,
   formula used elsewhere)
2. Fixes a real bug — YES (incorrect data exposed to userspace via
   ptrace)
3. Important issue — YES (debugging tools get wrong hardware info;
   incorrect userspace-visible state)
4. Small and contained — YES (one functional line change + rename)
5. No new features — YES (fixes existing behavior)

**Dependencies:**
The code structure with `riscv_v_thread_zalloc` exists in stable trees
(it was introduced with RISC-V V extension support). The fix is self-
contained and should apply cleanly or with minimal adjustment.

**Risk assessment:**
Very low risk. The fix adds a single assignment of a value that would
eventually be set by hardware anyway. The formula `riscv_v_vsize / 32`
is well-established and used identically in multiple other places. The
worst case if this were somehow wrong would be an incorrect vlenb value
— but since it's using exactly the same calculation as the rest of the
kernel, this is essentially zero risk.

**YES**

 arch/riscv/kernel/vector.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 3ed071dab9d83..b112166d51e9f 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -111,8 +111,8 @@ bool insn_is_vector(u32 insn_buf)
 	return false;
 }
 
-static int riscv_v_thread_zalloc(struct kmem_cache *cache,
-				 struct __riscv_v_ext_state *ctx)
+static int riscv_v_thread_ctx_alloc(struct kmem_cache *cache,
+				    struct __riscv_v_ext_state *ctx)
 {
 	void *datap;
 
@@ -122,13 +122,15 @@ static int riscv_v_thread_zalloc(struct kmem_cache *cache,
 
 	ctx->datap = datap;
 	memset(ctx, 0, offsetof(struct __riscv_v_ext_state, datap));
+	ctx->vlenb = riscv_v_vsize / 32;
+
 	return 0;
 }
 
 void riscv_v_thread_alloc(struct task_struct *tsk)
 {
 #ifdef CONFIG_RISCV_ISA_V_PREEMPTIVE
-	riscv_v_thread_zalloc(riscv_v_kernel_cachep, &tsk->thread.kernel_vstate);
+	riscv_v_thread_ctx_alloc(riscv_v_kernel_cachep, &tsk->thread.kernel_vstate);
 #endif
 }
 
@@ -214,12 +216,14 @@ bool riscv_v_first_use_handler(struct pt_regs *regs)
 	 * context where VS has been off. So, try to allocate the user's V
 	 * context and resume execution.
 	 */
-	if (riscv_v_thread_zalloc(riscv_v_user_cachep, &current->thread.vstate)) {
+	if (riscv_v_thread_ctx_alloc(riscv_v_user_cachep, &current->thread.vstate)) {
 		force_sig(SIGBUS);
 		return true;
 	}
+
 	riscv_v_vstate_on(regs);
 	riscv_v_vstate_set_restore(current, regs);
+
 	return true;
 }
 
-- 
2.51.0

