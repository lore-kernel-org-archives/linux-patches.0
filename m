Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BD740F8C5;
	Tue, 28 Apr 2026 10:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372960; cv=none; b=nXEGoIrjaUn7Vs+KkLlG5bhDq4vP6MWe6hLl2LPPjIuK+b5Vf8lQgTKvhPJ/K/uwhjYR72vMJw/3UGseBhh12yZv19JnipDPrmbFPPKf2U7pin46sHVpVXGSdhrcnFF+VuBR2XYBDGKK4085l6/7LmTuZb/yYXRiS57SIbeBEQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372960; c=relaxed/simple;
	bh=LRJrmMyuTktkzkaPZwISotTL2EmtTHfhnpRTWMpYmzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EWKq3fs82vQW0LmbKzaId6eCGh/fxI9HuN11tkRR9BzacmNURlBIE45TDiLhS+A8DyUvY7PJCyhfiiLyA31nwMWOe37UlGDe8pdWYFLnYb0B/BchVBr9ksP6481YLR2OPjjfURmtvRhPk7KxPHtgVYVgj7aflLiQV9JUEnBJNDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qejSsBxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qejSsBxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0128EC2BCB7;
	Tue, 28 Apr 2026 10:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372959;
	bh=LRJrmMyuTktkzkaPZwISotTL2EmtTHfhnpRTWMpYmzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qejSsBxyBYttUVX6y+7dQtb4z+sIZrfi/53kPuujRpkot7VjGEWZ/n8QDSUv1s/4q
	 N04SyD+f3RvKtJ8EGKvfVpbPGxr8Gbal5q0Fbwlc9RZUFz4TELZRsf99wAjFoGpQQZ
	 TpCvS3P1r0e4PjmYvhpF7kgAJ0D39gRrnwBqaWm56HHqeyfxtOfU4Qc1rjagPlZb7Q
	 F3VDUlAHVcneAKnd9IUAJ/iRHV8Tbiz+TL6CUM4kyrkm2xMLhzk27l7oBGjsYi/3R1
	 78kH8b/jt6IaHZ9zdkx1bGdXyEnXV2Lq0iT1BM1zYLQrTIv970k4bhrcLJPIwteKxy
	 LiV5HHh+FX5xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	johan@kernel.org,
	elder@kernel.org,
	greybus-dev@lists.linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] greybus: beagleplay: bound bootloader RX buffer copy
Date: Tue, 28 Apr 2026 06:40:58 -0400
Message-ID: <20260428104133.2858589-47-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit cbc96a916b1a3be7039b0166c0fc56ec1632ba01 ]

When `flashing_mode` is set, `gb_tty_receive()` routes incoming bytes to
`cc1352_bootloader_rx()`. That helper appends the new bytes to the shared
`rx_buffer` with `memcpy()` but does not check that the chunk fits in the
remaining space first. The normal HDLC receive path already enforces
`MAX_RX_HDLC`, so do the same here before appending bootloader data.

If a packet would overflow the receive buffer, drop it and reset the
bootloader receive state instead of copying past the end of `rx_buffer`.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260322031923.58013-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough information to write the full analysis.

# Analysis: greybus: beagleplay: bound bootloader RX buffer copy

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject parsing**
Record: subsystem=`greybus/beagleplay`, action=`bound` (i.e. add bounds
check), summary=add a bounds check to bootloader RX path before `memcpy`
into a fixed-size buffer.

**Step 1.2 - Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Link:
  https://patch.msgid.link/20260322031923.58013-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  (greybus maintainer)
- No `Fixes:`, no `Cc: stable`, no `Reported-by:`, no `Reviewed-by:`.
  Absence is expected.

**Step 1.3 - Body analysis**
Record: Bug = `cc1352_bootloader_rx()` does `memcpy(rx_buffer +
rx_buffer_len, data, count)` without verifying `count` fits the
remaining space; the HDLC sibling path already enforces `MAX_RX_HDLC`.
Failure mode = write past end of `rx_buffer` (heap buffer overflow).

**Step 1.4 - Hidden bug fix detection**
Record: Subject says "bound" rather than "fix", but body explicitly
describes a buffer-overflow gap and the fix mirrors a guard that already
exists on the parallel HDLC path. This is unambiguously a bug fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory**
Record: 1 file (`drivers/greybus/gb-beagleplay.c`), +6/-0 lines, 1 hunk,
single function `cc1352_bootloader_rx()`. Surgical single-file fix.

**Step 2.2 - Code flow change**
Record: Before — copy unconditionally into `bg->rx_buffer +
bg->rx_buffer_len`. After — if `count > sizeof(rx_buffer) -
rx_buffer_len`, log a rate-limited error, reset `rx_buffer_len`, return
`count` (consume the chunk). Otherwise the original path runs.

**Step 2.3 - Bug mechanism**
Record: Category = memory-safety / out-of-bounds write. Mechanism:
`rx_buffer` is `u8 rx_buffer[MAX_RX_HDLC]` (1 + 256 + 2 = 259 bytes)
embedded in `struct gb_beagleplay`. Without the check, an inbound serdev
chunk plus stale `rx_buffer_len` could write past 259 bytes into heap
memory adjacent to subsequent fields (`fwl`, `flashing_mode`,
completions, etc.).

**Step 2.4 - Fix quality**
Record: 5 lines, mirrors the existing `MAX_RX_HDLC` guard in
`hdlc_rx()`. Resetting `rx_buffer_len` on overflow drops staged data,
which is acceptable here because the fix path is being exercised under
fault conditions; bootloader sync/transfers will retry. No new
regression vectors. Returning `count` correctly tells the serdev core
that the bytes were consumed.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame**
Record: `git log -S "cc1352_bootloader_rx" -- drivers/greybus/gb-
beagleplay.c` shows the function (and bug) was introduced by
`0cf7befa3ea2e` ("greybus: gb-beagleplay: Add firmware upload API").

**Step 3.2 - Fixes target**
Record: No explicit `Fixes:` tag here, but the introducing commit
`0cf7befa3ea2e` is in `v6.12-rc1` (`git describe --contains` =
`v6.12-rc1~39^2`), so the bug exists in v6.12 and later.

**Step 3.3 - File history & related changes**
Record: A near-identical follow-up patch `1214bf28965ce` ("greybus: gb-
beagleplay: bound bootloader receive buffering") by the same author,
dated 2026-04-02, was applied later to the same function with explicit
`Fixes: 0cf7befa3ea2` and `Cc: stable@kernel.org`. It adds a second,
redundant copy of the same bound check; in current `origin/master` both
checks exist back-to-back. The second commit confirms the
maintainer/author both view this as a real, stable-worthy bug.

**Step 3.4 - Author**
Record: Pengpeng Hou — submitter, not subsystem maintainer. Patch was
applied directly by Greg KH (greybus maintainer). The same author
followed up with a stable-tagged version when the first lacked tags.

**Step 3.5 - Dependencies**
Record: Self-contained. Does not depend on any other unmerged work. The
function and `rx_buffer` field have been unchanged since `0cf7befa3ea2e`
was merged in v6.12.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - Lore discussion**
Record: `b4 dig -c cbc96a916b1a3` matched by patch-id, returned `https:/
/lore.kernel.org/all/20260322031923.58013-1-pengpeng@iscas.ac.cn/`. `b4
dig -a` shows v1 only — no other revisions.

**Step 4.2 - Reviewers**
Record: Cc list (per the mbox): Ayush Singh (driver author), Johan
Hovold, Alex Elder, Greg KH, plus greybus-dev. No replies in the thread;
Greg merged it as v1.

**Step 4.3 - Bug report**
Record: No `Reported-by:` or external bug-tracker link. Bug found by
code inspection. No syzbot or sanitizer reference.

**Step 4.4 - Related patches**
Record: The same author submitted a duplicate fix
`20260402054016.38587-1-pengpeng@iscas.ac.cn` ("greybus: gb-beagleplay:
bound bootloader receive buffering") containing `Fixes: 0cf7befa3ea2`
and `Cc: stable@vger.kernel.org`. That confirms the author's intent that
the fix go to stable.

**Step 4.5 - Stable list**
Record: Not applicable — checked recent file history, the explicit
stable nomination is in the duplicate follow-up rather than this commit.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Modified function**
Record: `cc1352_bootloader_rx()`.

**Step 5.2 - Callers**
Record: Single caller — `gb_tty_receive()`, which is the `.receive_buf`
member of `gb_beagleplay_ops` registered with the serdev framework
(`drivers/greybus/gb-beagleplay.c:556-578`). The serdev core invokes it
whenever the underlying UART (cc1352p7) hands up received bytes. The
branch into `cc1352_bootloader_rx` triggers when `bg->flashing_mode` is
true.

**Step 5.3 - Callees**
Record: `memcpy`, `memmove`, and `cc1352_bootloader_pkt_rx()`. The buggy
line is the `memcpy` — pre-fix, the destination pointer can advance past
the 259-byte array.

**Step 5.4 - Reachability**
Record: `flashing_mode` is set in `cc1352_prepare()`
(`drivers/greybus/gb-beagleplay.c:882`), invoked through the kernel
firmware-upload framework (sysfs `/sys/class/firmware/...`). A
privileged user-space firmware update on a BeaglePlay board makes the
buggy path reachable. The attacker/triggerer is therefore root-
equivalent, but the consequence (heap corruption from data the cc1352
sends back, batched by the UART driver into chunks > 259 bytes) is
severe.

**Step 5.5 - Similar patterns**
Record: The HDLC receive path (`hdlc_rx()` at line 399) already guards
with `bg->rx_buffer_len < MAX_RX_HDLC`. The patch makes the bootloader
path consistent with this established sibling.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1 - Buggy code in stable**
Record: Verified via `git merge-base --is-ancestor 0cf7befa3ea2e
<stable-branch>`:
- 5.10.y / 5.15.y / 6.1.y / 6.6.y → bug NOT present (driver predates
  `cc1352_bootloader_rx`).
- 6.12.y / 6.17.y / 6.18.y / 6.19.y → bug PRESENT.

**Step 6.2 - Backport difficulty**
Record: The hunk lands in `cc1352_bootloader_rx()` whose body has been
unchanged since v6.12. Patch should apply cleanly to all affected stable
trees. (The duplicate follow-up `1214bf28965ce` was generated against
the same parent, confirming this.)

**Step 6.3 - Related fixes already in stable**
Record: Verified via `git show <branch>:drivers/greybus/gb-beagleplay.c
| rg "count > sizeof|overflow|oversized"` — neither the current commit
nor the duplicate is present in any stable branch yet. No prior fix
exists for this bug in stable.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 - Subsystem & criticality**
Record: `drivers/greybus` — niche subsystem, but this driver supports a
real shipped product (BeaglePlay). PERIPHERAL criticality (only affects
users of that specific board).

**Step 7.2 - Subsystem activity**
Record: Low churn — `git log` on the file shows ~10 changes since 2024.
The function being fixed has been unchanged since its introduction in
v6.12.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected population**
Record: Users of the BeaglePlay board running v6.12+ kernels who
exercise the cc1352p7 firmware-update path.

**Step 8.2 - Trigger conditions**
Record: Requires `flashing_mode` true (firmware upload in progress;
needs root) AND `count` (size of a single serdev receive chunk plus
already-staged bytes) exceeding 259 bytes. UART subsystems can batch
incoming bytes, so this is realistic during a firmware flash, not just
under attacker control.

**Step 8.3 - Failure mode severity**
Record: Heap out-of-bounds write inside `struct gb_beagleplay`. Likely
outcomes: kernel oops/panic, slab corruption, KASAN splat, potential
local privilege/info leak. Severity = HIGH.

**Step 8.4 - Risk-benefit**
Record: Benefit = closes a kernel heap OOB write reachable during a
normal product workflow. Risk = very low — 5 lines, mirror of existing
guard, only consequence is dropping a malformed/oversized chunk during
firmware flash (already an error condition). Strong net positive.

## PHASE 9: SYNTHESIS

**Step 9.1 - Evidence**
For:
- Real out-of-bounds write in `cc1352_bootloader_rx()` confirmed by
  reading current code.
- Buggy code present in v6.12.y, v6.17.y, v6.18.y, v6.19.y.
- Tiny, surgical fix (5 lines), mirrors an existing guard.
- Same author submitted a follow-up explicitly tagged `Fixes:` + `Cc:
  stable@vger.kernel.org` for the same bug — strong confirmation of
  stable-worthiness.
- Applies cleanly to affected stable trees.

Against:
- Niche driver (limited user population).
- No `Reported-by:` / `Cc: stable` on this specific commit (expected per
  instructions).
- Trigger requires root (firmware upload).
- Cosmetic concern: if both this and `1214bf28965ce` reach stable, you
  get a duplicate bound check (still functionally correct).

**Step 9.2 - Stable rules checklist**
1. Obviously correct & tested? Yes — minimal logic, mirrors existing
   pattern; merged to mainline.
2. Real bug? Yes — reachable kernel-heap OOB write.
3. Important? Yes — heap corruption.
4. Small & contained? Yes — 6 lines, one file, one function.
5. No new features/APIs? Correct.
6. Applies to stable? Yes — file unchanged since the bug was introduced.

**Step 9.3 - Exception category**
Memory safety / OOB write fix.

**Step 9.4 - Decision**
Backport.

## Verification
- [Phase 1] Read full commit message; tags inventoried — no
  `Fixes:`/`Cc: stable` (expected).
- [Phase 2] Read current `cc1352_bootloader_rx()` (lines 532–554) and
  confirmed `rx_buffer` is `u8[MAX_RX_HDLC]=259`.
- [Phase 2] Confirmed sibling `hdlc_rx()` already enforces `MAX_RX_HDLC`
  (line 399).
- [Phase 3] `git log -S "cc1352_bootloader_rx" -- drivers/greybus/gb-
  beagleplay.c` → introduced by `0cf7befa3ea2e`.
- [Phase 3] `git describe --contains 0cf7befa3ea2e` → `v6.12-rc1~39^2`.
- [Phase 3] `git log origin/master --oneline -- drivers/greybus/gb-
  beagleplay.c` revealed duplicate follow-up `1214bf28965ce` with
  `Fixes:` + `Cc: stable`.
- [Phase 3] `git show origin/master:drivers/greybus/gb-beagleplay.c`
  shows two consecutive bound-check blocks at lines 620 and 626 in
  master (cosmetic duplication after both commits).
- [Phase 4] `b4 dig -c cbc96a916b1a3` returned the lore thread (v1 only,
  no replies).
- [Phase 4] `b4 dig -c 1214bf28965ce -m` confirmed the follow-up patch
  carries `Fixes: 0cf7befa3ea2` and `Cc: stable@vger.kernel.org`.
- [Phase 5] Read `gb_tty_receive` and `gb_beagleplay_ops` to confirm the
  call path: serdev `.receive_buf` → `gb_tty_receive` →
  `cc1352_bootloader_rx` when `flashing_mode` is set.
- [Phase 5] Read `cc1352_prepare()` (lines 860–929) to confirm
  `flashing_mode` is set during user-initiated firmware upload via the
  fw_upload framework.
- [Phase 6] `git merge-base --is-ancestor 0cf7befa3ea2e` against each
  stable-push branch — bug present in 6.12.y, 6.17.y, 6.18.y, 6.19.y;
  absent in 6.6.y and earlier.
- [Phase 6] Searched stable branches for the bound-check string — not
  present anywhere yet.
- [Phase 8] `rx_buffer` size = `1 + 256 + 2 = 259` (`MAX_RX_HDLC`);
  confirmed by reading the macro definitions at lines 23–25.
- UNVERIFIED: I did not measure how often a real BeaglePlay UART chunk
  exceeds 259 bytes during firmware flash; treating this as a defense-
  in-depth fix even if the trigger is rare. Doesn't change the YES
  decision because the OOB write itself is real.

This commit is a small, contained memory-safety fix for a real kernel-
heap OOB write that exists in 6.12.y/6.17.y/6.18.y/6.19.y. The same
author already submitted a duplicate version explicitly tagged `Cc:
stable`, which directly corroborates that the bug is stable-material. It
applies cleanly and meets every stable-kernel rule.

**YES**

 drivers/greybus/gb-beagleplay.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/greybus/gb-beagleplay.c b/drivers/greybus/gb-beagleplay.c
index 87186f891a6ac..bca3132adacde 100644
--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -535,6 +535,12 @@ static size_t cc1352_bootloader_rx(struct gb_beagleplay *bg, const u8 *data,
 	int ret;
 	size_t off = 0;
 
+	if (count > sizeof(bg->rx_buffer) - bg->rx_buffer_len) {
+		dev_err_ratelimited(&bg->sd->dev, "Bootloader RX buffer overflow");
+		bg->rx_buffer_len = 0;
+		return count;
+	}
+
 	memcpy(bg->rx_buffer + bg->rx_buffer_len, data, count);
 	bg->rx_buffer_len += count;
 
-- 
2.53.0

