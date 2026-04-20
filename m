Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E8044D686;
	Mon, 20 Apr 2026 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691821; cv=none; b=q34MKhrUm1rrxalfOg2dbg/9VtsPaEwJ3uetH8ex03/Uv18J/rUaEEWnJ4suBnSsW5aagAVLqaZ+r/oFI0fa1ZonhZ6JuAfxLUVp+2X6/IsrQCuVo9Ds4xVjxiX/Txgo5nL8OeA02GIk7iIWCqxQZqfAf/Cg7sl+c/Tyr4S4l/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691821; c=relaxed/simple;
	bh=2KKVT61x7r0VNCbNk+Z/K7EtDoMDG2szqH3H4yR+pt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZvuTYjv1IEzDfchNHPywUT+522czXGnD8AhUxAiuKyaBq6oHb7RTtPnaQLDjTZuP0DmBusnNUh7mEXjLu1lNgpEOaOKQj+66SwBdX49DpFi3QltX7zXuACEV35mLmWStcieswKbUcNHahezUSUcNzGJb/LVHRV+SxlbpWf0DdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNmb1DSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNmb1DSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB34C2BCB4;
	Mon, 20 Apr 2026 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691821;
	bh=2KKVT61x7r0VNCbNk+Z/K7EtDoMDG2szqH3H4yR+pt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNmb1DSE3oYgyQbB/QFJf/vbmnXRxGmuyj85BF3rjK3NfBS6dvrinrrsPIKQt6KYk
	 7WOqi+Hrd3oKL/wtlEnr4dA2Zqd0fGhb2R8erlr+fW2u2IUjAVj5k7Q7BqizEKjCx5
	 yP2Grz/MXB73f85Ta/NXecfzHw78Eg7iZfvuhuN759/lngK1Rb2Wyunmv1GuBkllpL
	 nhQrq0ORifgYyiA7l2+WP45IFIEhttu0HsWRJPRBZzL0m9JRi1AYBNGWEED/VTmto+
	 1m29yWUOIqqRQd79uEWyoaiFckm8nxhwB/3d4zKTdfMdxGGAPbiwOgzAqdzsfi3eQZ
	 kMkaGqIVZb5gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+d5ace703ed883df56e42@syzkaller.appspotmail.com,
	Simon Horman <horms@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] net: sched: cls_u32: Avoid memcpy() false-positive warning in u32_init_knode()
Date: Mon, 20 Apr 2026 09:20:08 -0400
Message-ID: <20260420132314.1023554-214-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 34bd3c6b0bd383a76d987c8c45c4f309b681b255 ]

Syzbot reported a warning in u32_init_knode() [1].

Similar to commit 7cba18332e36 ("net: sched: cls_u32: Avoid memcpy()
false-positive warning") which addressed the same issue in u32_change(),
use unsafe_memcpy() in u32_init_knode() to work around the compiler's
inability to see into composite flexible array structs.

This silences the false-positive reported by syzbot:

  memcpy: detected field-spanning write (size 32) of single field
  "&new->sel" at net/sched/cls_u32.c:855 (size 16)

Since the memory is correctly allocated with kzalloc_flex() using
s->nkeys, this is purely a false positive and does not need a Fixes tag.

[1] https://syzkaller.appspot.com/bug?extid=d5ace703ed883df56e42

Reported-by: syzbot+d5ace703ed883df56e42@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69a811b9.a70a0220.b118c.0019.GAE@google.com/T/
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260309123917.402183-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `net: sched: cls_u32`
- Action verb: "Avoid" (suggesting a workaround, not a direct bug fix)
- Summary: Avoids a false-positive memcpy warning in `u32_init_knode()`

**Step 1.2: Tags**
- Reported-by: `syzbot+d5ace703ed883df56e42@syzkaller.appspotmail.com`
  (syzbot-reported)
- Closes: `https://lore.kernel.org/all/69a811b9.a70a0220.b118c.0019.GAE@
  google.com/T/`
- Reviewed-by: Simon Horman `<horms@kernel.org>` (netdev
  maintainer/reviewer)
- Acked-by: Gustavo A. R. Silva `<gustavoars@kernel.org>`
  (FORTIFY_SOURCE / flexible array expert)
- Signed-off-by: Jakub Kicinski `<kuba@kernel.org>` (net maintainer)
- No Fixes: tag, no Cc: stable (expected)
- Author explicitly states: "does not need a Fixes tag"

**Step 1.3: Commit Body**
- References prior commit 7cba18332e36 that fixed the **identical**
  issue in `u32_change()`
- The warning: `memcpy: detected field-spanning write (size 32) of
  single field "&new->sel" at net/sched/cls_u32.c:855 (size 16)`
- Root cause: FORTIFY_SOURCE's `memcpy` hardening can't see that the
  flexible array struct was correctly allocated to hold the extra keys.
- Author explicitly says: "this is purely a false positive"

**Step 1.4: Hidden Bug Fix?**
This is NOT a hidden bug fix. It is genuinely a false-positive warning
suppression. The `memcpy` operation is correct; the compiler's bounds
checking is overly conservative for composite flexible array structures.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `net/sched/cls_u32.c`
- 1 line removed, 4 lines added (net +3 lines)
- Function modified: `u32_init_knode()`
- Scope: single-file, surgical fix

**Step 2.2: Code Flow Change**
- Before: `memcpy(&new->sel, s, struct_size(s, keys, s->nkeys));`
- After: `unsafe_memcpy(&new->sel, s, struct_size(s, keys, s->nkeys), /*
  justification comment */);`
- `unsafe_memcpy` is defined in `include/linux/fortify-string.h` as
  `__underlying_memcpy(dst, src, bytes)` — it simply bypasses the
  FORTIFY_SOURCE field-spanning write check. The actual memory operation
  is identical.

**Step 2.3: Bug Mechanism**
- Category: Warning suppression / false positive from FORTIFY_SOURCE
- No actual memory safety bug. The `new` structure is allocated with
  `kzalloc_flex(*new, sel.keys, s->nkeys)` which correctly sizes the
  allocation for the flexible array.

**Step 2.4: Fix Quality**
- Obviously correct — same pattern as existing fix at line 1122 in the
  same file
- Zero regression risk — `unsafe_memcpy` produces identical machine code
  to `memcpy`, just without the compile-time/runtime bounds check
- Minimal change

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The `memcpy` line was introduced by commit `e512fcf0280ae` (Gustavo A.
  R. Silva, 2019, v5.2) which converted it from open-coded `sizeof()` to
  `struct_size()`.
- The underlying memcpy in `u32_init_knode()` predates that and goes
  back to the function's original creation.

**Step 3.2: Prior Fix (7cba18332e36)**
- Commit 7cba18332e36 (Kees Cook, Sep 2022) fixed the identical false-
  positive in `u32_change()`.
- First appeared in v6.1. Present in all stable trees from v6.1 onward.
- This commit is the direct analog for `u32_init_knode()`.

**Step 3.3: File History**
- Recent changes to cls_u32.c are mostly treewide allocation API changes
  (kzalloc_flex, kmalloc_obj).
- This patch is standalone — no dependencies on other patches.

**Step 3.4: Author**
- Jiayuan Chen is a contributor with multiple net subsystem fixes (UAF,
  NULL deref, memory leaks).
- Not the subsystem maintainer, but the patch was accepted by Jakub
  Kicinski (netdev maintainer).

**Step 3.5: Dependencies**
- The `unsafe_memcpy` macro was introduced by commit `43213daed6d6cb`
  (Kees Cook, May 2022), present since v5.19.
- In stable trees, the allocation function is different (not
  `kzalloc_flex`), but the `memcpy` line with `struct_size` exists since
  v5.2.
- This can apply standalone. Minor context differences in stable trees
  won't affect the single-line change.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Patch Discussion**
- b4 dig found the submission: `https://patch.msgid.link/20260309123917.
  402183-1-jiayuan.chen@linux.dev`
- Two versions: v1 and v2 (v2 dropped unnecessary commit message content
  per reviewer feedback)
- No NAKs. Reviewed-by from Simon Horman, Acked-by from Gustavo A. R.
  Silva.

**Step 4.2: Reviewers**
- Simon Horman (netdev reviewer) — Reviewed-by
- Gustavo A. R. Silva (flexible array / FORTIFY expert, he wrote the
  original struct_size conversion) — Acked-by
- Jakub Kicinski (netdev maintainer) — committed the patch

**Step 4.3: Bug Report**
- Syzbot page at
  `https://syzkaller.appspot.com/bug?extid=d5ace703ed883df56e42`
  confirms:
  - WARNING fires at runtime in `u32_init_knode()` at cls_u32.c:855
  - Reproducible with C reproducer
  - Similar bugs exist on linux-6.1 and linux-6.6 (0 of 2 and 0 of 3
    patched, respectively)
  - Crash type: WARNING (FORTIFY_SOURCE field-spanning write detection)
  - Triggerable via syscall path: `sendmmsg → tc_new_tfilter →
    u32_change → u32_init_knode`

**Step 4.4/4.5: No explicit stable nomination in any discussion.**

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Function Modified**
- `u32_init_knode()` — creates a new knode by cloning an existing one
  during u32 filter update

**Step 5.2: Callers**
- `u32_init_knode()` is called from `u32_change()` (line ~921), which is
  the TC filter update path
- `u32_change()` is called via `tc_new_tfilter()` → rtnetlink → netlink
  syscall path
- This is reachable from unprivileged userspace (with appropriate
  network namespace capabilities)

**Step 5.4: Call Chain**
- `sendmmsg` → `netlink_sendmsg` → `rtnetlink_rcv_msg` →
  `tc_new_tfilter` → `u32_change` → `u32_init_knode` → WARNING

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable Trees**
- The `memcpy(&new->sel, s, struct_size(s, keys, s->nkeys))` line exists
  since v5.2 (commit e512fcf0280ae).
- Present in all active stable trees (5.15.y, 6.1.y, 6.6.y, 6.12.y).
- `unsafe_memcpy` is available since v5.19 (commit 43213daed6d6cb).
- So this fix is applicable to 6.1.y and later.
- Syzbot confirms the warning fires on 6.1 and 6.6 stable trees.

**Step 6.2: Backport Complications**
- The single-line change (`memcpy` → `unsafe_memcpy`) should apply
  cleanly or with trivial context adjustment.
- The comment references `kzalloc_flex()` which doesn't exist in stable
  trees (it's a 7.0 API), but that's just a comment in the
  `unsafe_memcpy` justification parameter — functionally irrelevant.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- `net/sched` — Traffic Control (TC) classifier, specifically cls_u32
- Criticality: IMPORTANT — TC is widely used in networking, QoS,
  container networking

**Step 7.2: Activity**
- Active subsystem with regular fixes and updates.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
- Any user with `CONFIG_FORTIFY_SOURCE=y` (default on most distros)
  using TC u32 classifier
- The WARNING fires during filter updates via netlink

**Step 8.2: Trigger Conditions**
- Triggered when updating a u32 TC filter with >0 keys (common
  operation)
- Reachable from userspace via netlink/rtnetlink
- Reliably reproducible (syzbot has C reproducer)

**Step 8.3: Failure Mode**
- Primary: WARN at runtime — log noise, `panic_on_warn` configurations
  would crash
- No data corruption, no memory safety issue (the memcpy is correct)
- Severity: MEDIUM (WARNING only, no functional impact unless
  `panic_on_warn=1`)

**Step 8.4: Risk-Benefit**
- BENEFIT: Silences a false-positive WARNING on stable trees, eliminates
  syzbot CI noise, prevents crashes with `panic_on_warn=1`
- RISK: Essentially zero — `unsafe_memcpy` produces identical code to
  `memcpy` minus the check
- Ratio: Favorable (small benefit, near-zero risk)

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
1. The WARNING actively fires on stable trees (6.1, 6.6) — confirmed by
   syzbot
2. The fix is trivially correct (1 functional line changed), zero
   regression risk
3. Same exact pattern as commit 7cba18332e36 already in stable since
   v6.1
4. Reviewed by Simon Horman, Acked by Gustavo A. R. Silva (the FORTIFY
   expert), committed by Jakub Kicinski
5. With `panic_on_warn=1` (common in security-hardened deployments),
   this is a crash
6. Reachable from userspace via standard TC netlink operations

**Evidence AGAINST backporting:**
1. Author explicitly says "this is purely a false positive and does not
   need a Fixes tag"
2. Not a real memory safety bug — the memcpy operation is correct
3. Without `panic_on_warn`, only produces log noise
4. Comment in the fix references `kzalloc_flex()` which doesn't exist in
   stable trees (cosmetic issue only)

**Stable Rules Checklist:**
1. Obviously correct and tested? **YES** — identical pattern to existing
   fix in same file
2. Fixes a real bug? **BORDERLINE** — it's a false-positive warning, but
   it does fire at runtime and causes problems with `panic_on_warn`
3. Important issue? **MEDIUM** — WARNING severity, but crash with
   `panic_on_warn=1`
4. Small and contained? **YES** — 1 file, +4/-1 lines
5. No new features? **YES**
6. Applies to stable? **YES** — with minor context differences

The decisive factor: syzbot confirms this WARNING actively fires on 6.1
and 6.6 stable trees, the fix follows a proven pattern already in
stable, and the risk is essentially zero. While the author says it's a
false positive (and it is), the runtime WARNING is a real issue for
production systems, especially those with `panic_on_warn=1`.

## Verification

- [Phase 1] Parsed tags: Reported-by syzbot, Reviewed-by Simon Horman,
  Acked-by Gustavo A. R. Silva, committed by Jakub Kicinski
- [Phase 2] Diff analysis: single line `memcpy` → `unsafe_memcpy` with
  justification comment in `u32_init_knode()`
- [Phase 3] git blame: memcpy line introduced by e512fcf0280ae (v5.2,
  2019), present in all stable trees
- [Phase 3] git show 7cba18332e36: confirmed identical prior fix for
  u32_change(), present since v6.1
- [Phase 3] git tag --contains 43213daed6d6cb: `unsafe_memcpy` available
  since v5.19
- [Phase 4] b4 dig -c 34bd3c6b0bd3: found submission at lore, v1→v2, no
  NAKs
- [Phase 4] b4 dig -w: netdev maintainers and linux-hardening list were
  CC'd
- [Phase 4] syzbot page: confirmed WARNING fires on 6.1 and 6.6 stable,
  reproducible with C repro
- [Phase 5] Call chain: sendmmsg → netlink → tc_new_tfilter → u32_change
  → u32_init_knode (userspace reachable)
- [Phase 6] Code exists in all active stable trees; unsafe_memcpy
  available in 6.1+
- [Phase 8] Failure mode: WARN at runtime, MEDIUM severity (crash with
  panic_on_warn)

**YES**

 net/sched/cls_u32.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 9241c025aa741..8f30cc82181d9 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -852,7 +852,10 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	/* Similarly success statistics must be moved as pointers */
 	new->pcpu_success = n->pcpu_success;
 #endif
-	memcpy(&new->sel, s, struct_size(s, keys, s->nkeys));
+	unsafe_memcpy(&new->sel, s, struct_size(s, keys, s->nkeys),
+		      /* A composite flex-array structure destination,
+		       * which was correctly sized with kzalloc_flex(),
+		       * above. */);
 
 	if (tcf_exts_init(&new->exts, net, TCA_U32_ACT, TCA_U32_POLICE)) {
 		kfree(new);
-- 
2.53.0

