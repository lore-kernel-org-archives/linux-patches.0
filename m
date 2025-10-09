Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2418229B18;
	Thu,  9 Oct 2025 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025556; cv=none; b=ZpeUZQ5q3fsTOQ3ZUkmIgmuU9C/kOZwJPJwHLdb0owTRiX1I9ByniykLQeAhZ2WhbmeEjDDFzDuT+AghQYD/wrEGiaHmoZ28qyhuk+ilp4XL5oCMaVYewX7Xkfk/I0Dd6hbJGzx8ppC8BIL5A5FCgpGfGh4DsUweLsETnC7bPd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025556; c=relaxed/simple;
	bh=lNQnHAsxUtANRW3ozb1ZTyH7qL2Wmh9+WYA8WvvuQto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F0AZx/mBf9XlinWxTU7gc+d9q2xqnCUX6jbFOlv2czV/uVa3gAedETfzmzEOXbdXmNOW4mdbegaRu5caiMZ1NdU0FOrDUT9M6eBa2CXoQeldqoKzKhZB/x7wuA5VVAMEj2E/Ir7Hfg9qZZh1Citk1/S68LPfWcfB5SObyw5YaDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/xFlAvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/xFlAvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74F3C4CEF8;
	Thu,  9 Oct 2025 15:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025556;
	bh=lNQnHAsxUtANRW3ozb1ZTyH7qL2Wmh9+WYA8WvvuQto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/xFlAvxv2rs71Kcn1NvRM79NveaPjIFaf0OOpk0QD+hj7Zi22tV3di55P26QPxM4
	 70HCZtlD4bxCdWLkcj4aJjtW3Ggq0aKxFUTHTjXY9sAfQrS8CAADWYVH6sAFcGV/YC
	 YmJuSUa9I64Dxr4YcwydpQP+U44oLNXhO7tvG5lBen/Ie4P1slX4wZk3bElG7qDSnH
	 GY/XDCdYhmDXvEclA/GnwVO0/lgWtrlmgCMhWFXO8MTI6OvBk+emauO9iKYMwYCQBh
	 gs2EoQx5P2an42NdmCtUBzX4BmAj/mV+YpEho3GezxZWryzOFVcXnOIS7WqLf3XToH
	 IG4enfqzBk8RQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	mhiramat@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Thu,  9 Oct 2025 11:55:11 -0400
Message-ID: <20251009155752.773732-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4363264111e1297fa37aa39b0598faa19298ecca ]

If uprobe handler changes instruction pointer we still execute single
step) or emulate the original instruction and increment the (new) ip
with its length.

This makes the new instruction pointer bogus and application will
likely crash on illegal instruction execution.

If user decided to take execution elsewhere, it makes little sense
to execute the original instruction, so let's skip it.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20250916215301.664963-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Summary
- This is a small, well-scoped bug fix in the generic uprobes core that
  prevents executing or emulating the original instruction when a uprobe
  consumer handler has redirected the instruction pointer (IP). The
  previous behavior could corrupt the new IP and crash the traced
  application. The change is minimal (7 lines), does not add features,
  and aligns with expected semantics. It is suitable for stable
  backport.

What changed
- In `handle_swbp()`, after running consumer handlers, the patch adds an
  early exit if the handler changed IP away from the breakpoint address:
  - New check added: `kernel/events/uprobes.c:2772`
  - Surrounding context:
    - Handler invocation: `kernel/events/uprobes.c:2769`
    - Emulation/single-step path: `kernel/events/uprobes.c:2778` (arch
      emulation) and `kernel/events/uprobes.c:2781` (XOL single-step
      prep).
- The key addition is:
  - `kernel/events/uprobes.c:2772`: `if (instruction_pointer(regs) !=
    bp_vaddr) goto out;`

Why the bug happens
- Before this change, `handle_swbp()` always proceeded to emulate
  (`arch_uprobe_skip_sstep`) or to prepare out-of-line single-step
  (`pre_ssout`) of the original instruction even if the handler altered
  IP. On x86 and other arches, instruction emulation/step advances IP by
  the probed instruction’s length; doing that after a handler-set new IP
  advances the wrong address, making the IP bogus and often leading to
  SIGILL.
  - Where emulation executes: `kernel/events/uprobes.c:2778`
  - Where XOL single-step is prepared: `kernel/events/uprobes.c:2781`
- The patch fixes this by skipping the emulate/sstep path if IP was
  changed by the handler, which is the correct intent when a handler
  redirects control flow.

Evidence in current/mainline and in stable
- This exact fix is present in mainline commit 4363264111e12 (“uprobe:
  Do not emulate/sstep original instruction when ip is changed”) and
  adds only the early-out check in `handle_swbp()` (see
  `kernel/events/uprobes.c:2769`–`2785` in the current tree).
- Affected stable trees (e.g., 6.1/6.6/6.10/6.17) lack this check and
  will incorrectly emulate/step even after IP changes. In your 6.17
  workspace, `handle_swbp()` calls `handler_chain()` and then proceeds
  directly to emulation/step without guarding against an IP change:
  - Handler call: `kernel/events/uprobes.c:2742`
  - Emulation call: `kernel/events/uprobes.c:2744`
  - Single-step prep: `kernel/events/uprobes.c:2747`

Risk and side effects
- Scope: Single function (`handle_swbp()`), 7 insertions, no API or
  architectural change.
- Behavior change: Only when a handler changes IP; in that case, we skip
  executing the original instruction. This matches handler intent and
  prevents crashes.
- Concurrency/locking: The check reads `instruction_pointer(regs)` and
  compares to `bp_vaddr` under the same conditions as the rest of the
  function; no new locking or ordering requirements.
- Cross-arch impact: Safe and correct. All arches’
  `arch_uprobe_skip_sstep()` implementations emulate or adjust IP
  assuming execution should continue at the original site; skipping this
  when IP was redirected avoids incorrect behavior.
- No dependency on unrelated features (e.g., the
  `arch_uprobe_optimize()` call that exists in some newer trees is not
  part of this change and isn’t required for correctness).

Stable tree criteria
- Fixes a user-visible crash-causing bug in uprobes
  (tracing/instrumentation).
- Minimal, contained change with clear intent and low regression risk.
- No new features or ABI changes.
- Acked by maintainers and merged into mainline.

Conclusion
- This is a clear, low-risk bug fix preventing incorrect
  emulation/single-step after handlers redirect IP. It should be
  backported to stable kernels.

 kernel/events/uprobes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7ca1940607bd8..2b32c32bcb776 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2741,6 +2741,13 @@ static void handle_swbp(struct pt_regs *regs)
 
 	handler_chain(uprobe, regs);
 
+	/*
+	 * If user decided to take execution elsewhere, it makes little sense
+	 * to execute the original instruction, so let's skip it.
+	 */
+	if (instruction_pointer(regs) != bp_vaddr)
+		goto out;
+
 	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
 		goto out;
 
-- 
2.51.0

