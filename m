Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F961BC46;
	Thu, 12 Feb 2026 01:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858603; cv=none; b=YmlJdy7WfdXOrwU+y+xtiCOSqoj1o/C3/JzmYw+hcQvO5G3SvdK2lUMjDmRcHZp2Ke5kHQUjV4yCvPPkAZ4eLNVLBNAKtBuoLeqnHHNq9aUPy/9HX4aX9nGi0JPLvDCnSq0A4PglI7doF7qjNDtv6RGZ72dxDBPgrATvteiNyVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858603; c=relaxed/simple;
	bh=++XxyHqSqHofe4sF/LKqBW/7x0og8SG38kJtyNh5vdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l7m3OjYmfAof5U3xjlW+XUwcVApNAaCuA8mqSwnPbI30kN3xkbJb06cWuMe41+aeJLrPIdpz+BU6GJQIMobJc/FDkOyo0VXx/bgmdcK6SZlvzRjsvEn444+gtGk0muGy/hVMAPn83D9BGcin35skGkT/WV/jQ1pSw2DXPLuF6xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/cpq3LB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/cpq3LB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C079FC16AAE;
	Thu, 12 Feb 2026 01:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858603;
	bh=++XxyHqSqHofe4sF/LKqBW/7x0og8SG38kJtyNh5vdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/cpq3LBtfp9zsKawAmlrN3Lk0CLCSLTXa134DxONlSZoPWaNLrZHj6MExONQt2lr
	 9xUVRWUjemo/eDwQ9IqTvvULIQlhzBPZzLsbQa0sENQ/TDDemovadxrEXi2mpcnn8w
	 C0FXefl0wC/VzjD2Hc1V/OKqINILWGr0HTGxyW2Hskh+pLhJkyRbeNnOLyqNU4OOE8
	 Gay7MyQuRuOcE4GclSvxANDEUIfurNgZSaiMDjhpp4erpY5Y5czsjQ3Fj6Yn7dnxJN
	 NiQ+m+UT+xIKb+02srpgY3RVqRWVTxQVKkcpoh1hJR2+ndm0HNH5uyr13DiXNqPU2D
	 PMH9cpgX6oWuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	kpsingh@kernel.org,
	mattbobrowski@google.com,
	mhiramat@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	svens@linux.ibm.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.18] arm64/ftrace,bpf: Fix partial regs after bpf_prog_run
Date: Wed, 11 Feb 2026 20:09:26 -0500
Message-ID: <20260212010955.3480391-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 276f3b6daf6024ae2742afd161e7418a5584a660 ]

Mahe reported issue with bpf_override_return helper not working when
executed from kprobe.multi bpf program on arm.

The problem is that on arm we use alternate storage for pt_regs object
that is passed to bpf_prog_run and if any register is changed (which
is the case of bpf_override_return) it's not propagated back to actual
pt_regs object.

Fixing this by introducing and calling ftrace_partial_regs_update function
to propagate the values of changed registers (ip and stack).

Reported-by: Mahe Tardy <mahe.tardy@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/bpf/20260112121157.854473-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me provide the full analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear: `bpf_override_return` helper does not work
when executed from a **kprobe.multi** BPF program on arm64. This was
**reported by a real user** (Mahe Tardy), which indicates it's a real-
world bug affecting actual users. The fix has been **reviewed by Steven
Rostedt** (ftrace maintainer) and **acked by Will Deacon** (arm64
maintainer), two highly authoritative figures.

### 2. THE BUG MECHANISM (Detailed)

On arm64, the `ftrace_regs` structure (`struct __arch_ftrace_regs` in
`arch/arm64/include/asm/ftrace.h`) is **NOT** a wrapper around `pt_regs`
- it's a separate, smaller structure containing only x0-x8, fp, lr, sp,
pc. Arm64 defines `HAVE_ARCH_FTRACE_REGS`.

When `kprobe_multi_link_prog_run()` is called (in
`kernel/trace/bpf_trace.c`):

1. `ftrace_partial_regs(fregs, bpf_kprobe_multi_pt_regs_ptr())` copies
   data **from** `ftrace_regs` **to** a per-CPU `pt_regs` buffer. On
   arm64, this creates a **separate copy**.
2. `bpf_prog_run(link->link.prog, regs)` passes this `pt_regs` copy to
   the BPF program.
3. When `bpf_override_return` is called inside the BPF program, it
   modifies the `pt_regs` copy:
   - `regs_set_return_value(regs, rc)` - sets the return value
   - `override_function_with_return(regs)` - sets `regs->pc = regs->lr`
     (on arm64), redirecting execution to skip the probed function
4. **THE BUG**: After `bpf_prog_run()` returns, the modified `pt_regs`
   copy is simply discarded. The changes are **never propagated back**
   to the original `ftrace_regs`, so the instruction pointer override
   and return value changes are lost.

On x86_64 (and s390, powerpc, loongarch), this bug does NOT manifest
because they define `CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS`, meaning
`ftrace_partial_regs()` returns a pointer directly into the
`ftrace_regs` structure — changes to the `pt_regs` automatically update
the `ftrace_regs`.

### 3. THE FIX

The fix introduces a new function `ftrace_partial_regs_update()` with
two variants:

- **For architectures without `HAVE_ARCH_FTRACE_REGS`** (x86, etc.):
  Empty no-op, because `pt_regs` is embedded in `ftrace_regs` directly.
- **For architectures with `HAVE_ARCH_FTRACE_REGS`** (arm64, riscv):
  Copies the instruction pointer and return value back from the separate
  `pt_regs` to the `ftrace_regs`:

```c
ftrace_regs_set_instruction_pointer(fregs, instruction_pointer(regs));
ftrace_regs_set_return_value(fregs, regs_return_value(regs));
```

And in `bpf_trace.c`, the fix calls this function after
`bpf_prog_run()`:
```c
ftrace_partial_regs_update(fregs, bpf_kprobe_multi_pt_regs_ptr());
```

### 4. SCOPE AND RISK ASSESSMENT

- **Files changed**: 2 files
- **Lines added**: ~25 (mostly documentation)
- **Lines removed**: 0
- **Actual code changes**: ~5 lines of actual logic
- **Risk**: Very LOW. The no-op version for non-arm64 architectures
  means zero impact on x86. The arm64 version just copies two values
  back.

### 5. DEPENDENCY CHECK - CRITICAL ISSUE

This is where the analysis gets complex. The affected code —
`kprobe_multi_link_prog_run()` using `ftrace_regs` and
`ftrace_partial_regs()` — was introduced as part of a massive fprobe
rewrite in the **v6.14 merge window**:

- `b9b55c8912ce1` (v6.14): `tracing: Add ftrace_partial_regs() for
  converting ftrace_regs to pt_regs`
- `46bc082388560` (v6.14): `fprobe: Use ftrace_regs in fprobe entry
  handler`
- `8e2759da9378` (v6.14): `bpf: Enable kprobe_multi feature if
  CONFIG_FPROBE is enabled`
- `4346ba1604093` (v6.14): `fprobe: Rewrite fprobe on function-graph
  tracer`

In **v6.13 and earlier** (6.12 LTS, 6.6 LTS, 6.1 LTS, 5.15 LTS),
`kprobe_multi_link_prog_run()` takes `struct pt_regs *regs` directly —
there is no `ftrace_regs` / `ftrace_partial_regs()` indirection. **The
bug simply does not exist in those older stable trees.**

The bug exists in: **v6.14, v6.15, v6.18** stable trees (all currently
maintained).

### 6. BACKPORT FEASIBILITY

The patch should apply cleanly to:
- **v6.14.y**: The code at `bpf_trace.c` is very similar (just needs
  adjustment for `migrate_disable/enable` which was still present in
  v6.14)
- **v6.15.y**: Very similar to HEAD
- **v6.18.y**: Identical to HEAD (`include/linux/ftrace_regs.h`
  unchanged since v6.14)

The `include/linux/ftrace_regs.h` change should apply cleanly to all
three. The `bpf_trace.c` change might need minor adjustment for v6.14
(which still has `migrate_disable()` calls), but the relevant line is
the same.

### 7. USER IMPACT

This bug makes `bpf_override_return` completely non-functional on arm64
when used from kprobe.multi programs. This is a significant feature
regression:
- `bpf_override_return` is used by BPF-based error injection frameworks
- arm64 is a major platform (server, embedded, Android)
- The bug was reported by an actual user

### 8. CLASSIFICATION

This is a **clear bug fix** for a **functional regression** introduced
in v6.14. It:
- Fixes a real, user-reported bug
- Is small and surgical (~5 lines of actual logic)
- Has been reviewed by the ftrace maintainer (Rostedt) and arm64
  maintainer (Will Deacon)
- Has clear scope and low regression risk
- Only affects arm64 and riscv (no impact on x86)

The fix meets all stable kernel criteria:
1. Obviously correct and tested (reviewed/acked by subsystem
   maintainers)
2. Fixes a real bug (user-reported, bpf_override_return completely
   broken on arm64)
3. Important issue (complete feature breakage on a major architecture)
4. Small and contained (2 files, ~5 lines of logic)
5. Does not introduce new features (just propagates existing register
   values back)

**YES**

 include/linux/ftrace_regs.h | 25 +++++++++++++++++++++++++
 kernel/trace/bpf_trace.c    |  1 +
 2 files changed, 26 insertions(+)

diff --git a/include/linux/ftrace_regs.h b/include/linux/ftrace_regs.h
index 15627ceea9bcc..386fa48c4a957 100644
--- a/include/linux/ftrace_regs.h
+++ b/include/linux/ftrace_regs.h
@@ -33,6 +33,31 @@ struct ftrace_regs;
 #define ftrace_regs_get_frame_pointer(fregs) \
 	frame_pointer(&arch_ftrace_regs(fregs)->regs)
 
+static __always_inline void
+ftrace_partial_regs_update(struct ftrace_regs *fregs, struct pt_regs *regs) { }
+
+#else
+
+/*
+ * ftrace_partial_regs_update - update the original ftrace_regs from regs
+ * @fregs: The ftrace_regs to update from @regs
+ * @regs: The partial regs from ftrace_partial_regs() that was updated
+ *
+ * Some architectures have the partial regs living in the ftrace_regs
+ * structure, whereas other architectures need to make a different copy
+ * of the @regs. If a partial @regs is retrieved by ftrace_partial_regs() and
+ * if the code using @regs updates a field (like the instruction pointer or
+ * stack pointer) it may need to propagate that change to the original @fregs
+ * it retrieved the partial @regs from. Use this function to guarantee that
+ * update happens.
+ */
+static __always_inline void
+ftrace_partial_regs_update(struct ftrace_regs *fregs, struct pt_regs *regs)
+{
+	ftrace_regs_set_instruction_pointer(fregs, instruction_pointer(regs));
+	ftrace_regs_set_return_value(fregs, regs_return_value(regs));
+}
+
 #endif /* HAVE_ARCH_FTRACE_REGS */
 
 /* This can be overridden by the architectures */
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index fe28d86f7c357..2a5dabda8b5c2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2564,6 +2564,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.session_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
+	ftrace_partial_regs_update(fregs, bpf_kprobe_multi_pt_regs_ptr());
 	rcu_read_unlock();
 
  out:
-- 
2.51.0

