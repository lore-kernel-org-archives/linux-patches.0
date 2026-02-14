Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1760C1D54FA;
	Sat, 14 Feb 2026 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031193; cv=none; b=rlboyNIhkux6jfe/wKqyvnTM+KVuAeHgRauA+HvcGdT+ifCvf5emmt5ZDaNaVt7GFthcBgDHy5AMuxybCEXlI++tlNNkHzSesYaZEQGwedQPNnhtvgQUwnDpF0NVMRnOJCgdh35nSgeRJojm17VvTehcc5nU2VTE/ZgYgY4k4bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031193; c=relaxed/simple;
	bh=Aif+7sXvfbUhcDPLpr9NAHy6cdQBEEc8gRYnpWu3dGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NstNlJYcNJbrVnAYp4cY4Qxbo6QhlJQZLQRS1OJGLz6Z+4QtTcmYQnb/7KAM9DDtkuPjDPPhVyMA71CpyoTXCuvhV7ZKqm1qr6Yl+49S/uTL1iX2VS7Q+XtiL168gMoy+KxIbmHUNuW1mB2I7jg6ZaRxlcDXneMjQaTAEzOJAxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWPFR8qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWPFR8qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72506C16AAE;
	Sat, 14 Feb 2026 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031193;
	bh=Aif+7sXvfbUhcDPLpr9NAHy6cdQBEEc8gRYnpWu3dGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWPFR8qx+e+h4YLVCtqWLiY5pGK+Yzk3fmHDtPgAD4UE4PmQOuit1+zJYnuutgcI+
	 zOOjpSqY+z7PTpTCIG9zH6p7HSJHCWD7N6nM8oKMiGGN3yRoiZjDfIlrn+Pdog7X9g
	 B12NlMJGFs/OeeTDfhLHVteIOqi5qr/QlYB4QHdgUxwAsk1oMXBJlTKrZ6PlezNmnh
	 y+nISqSZ9ET0nJDv/5ZkMdOGlsXn38FYJHqy91OEWrnZOY9PvsoDuVkHji36Ehros3
	 dOhrPKUS/wCT3yd9+RbBlDKAjM5p9RAe6WbcrlmyiIVIHkUbIXYNOTQGMvKzzvdi2A
	 xXVQocqlfhZ/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Swapnil Patel <swapnil.patel@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Dillon.Varone@amd.com,
	aurabindo.pillai@amd.com,
	chiahsuan.chung@amd.com,
	Ilya.Bakoulin@amd.com,
	Leo.Zeng@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	danny.wang@amd.com,
	rdunlap@infradead.org
Subject: [PATCH AUTOSEL 6.19] drm/amd/display: Fix mismatched unlock for DMUB HW lock in HWSS fast path
Date: Fri, 13 Feb 2026 19:59:35 -0500
Message-ID: <20260214010245.3671907-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit af3303970da5ce5bfe6dffdd07f38f42aad603e0 ]

[Why]
The evaluation for whether we need to use the DMUB HW lock isn't the
same as whether we need to unlock which results in a hang when the
fast path is used for ASIC without FAMS support.

[How]
Store a flag that indicates whether we should use the lock and use
that same flag to specify whether unlocking is needed.

Reviewed-by: Swapnil Patel <swapnil.patel@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Let me summarize my analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is clear and well-structured (AMD's `[Why]`/`[How]`
format):

- **[Why]:** The evaluation for whether to **acquire** the DMUB HW lock
  is different from the evaluation for whether to **release** it, which
  causes a **hang** on ASICs without FAMS support.
- **[How]:** Store the lock requirement decision in a single variable
  and reuse it for both lock and unlock.
- **Indicators:** "Fix", "hang" — these are strong backport signals.
- **Tags:** `Reviewed-by`, `Tested-by` — this has been properly reviewed
  and tested.

### 2. Code Change Analysis — The Bug Mechanism

The bug is in `hwss_build_fast_sequence()` in `dc_hw_sequencer.c`. This
function builds a sequence of hardware programming blocks that are
executed during fast display updates (page flips, cursor updates, etc.).

**The lock acquisition (line ~765-772 of buggy code):**

```765:772:drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
        if (dc->hwss.dmub_hw_control_lock_fast) {
block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.dc =
dc;
block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.lock
= true;
                block_sequence[*num_steps].params.dmub_hw_control_lock_f
ast_params.is_required =
                        dc_state_is_fams2_in_use(dc, context) ||
                        dmub_hw_lock_mgr_does_link_require_lock(dc,
stream->link);
                block_sequence[*num_steps].func =
DMUB_HW_CONTROL_LOCK_FAST;
```

**The lock release (line ~906-911 of buggy code):**

```906:911:drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
        if (dc->hwss.dmub_hw_control_lock_fast) {
block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.dc =
dc;
block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.lock
= false;
                block_sequence[*num_steps].params.dmub_hw_control_lock_f
ast_params.is_required = dc_state_is_fams2_in_use(dc, context);
                block_sequence[*num_steps].func =
DMUB_HW_CONTROL_LOCK_FAST;
                (*num_steps)++;
```

The critical mismatch:
- **Lock:** `is_required = dc_state_is_fams2_in_use(dc, context) ||
  dmub_hw_lock_mgr_does_link_require_lock(dc, stream->link)`
- **Unlock:** `is_required = dc_state_is_fams2_in_use(dc, context)` —
  **MISSING the `dmub_hw_lock_mgr_does_link_require_lock` check!**

Looking at `dcn401_dmub_hw_control_lock_fast()`, when `is_required` is
`true`, it sends a DMUB inbox0 command to acquire/release a hardware
lock. When `is_required` is `false`, it does nothing.

**The hang scenario:**
1. FAMS2 is NOT in use (`dc_state_is_fams2_in_use()` returns `false`)
2. The link requires lock due to PSR or Replay being enabled
   (`dmub_hw_lock_mgr_does_link_require_lock()` returns `true`)
3. Lock path: `is_required = false || true = true` → **lock IS
   acquired**
4. Unlock path: `is_required = false` → unlock is **NOT performed**
5. The hardware lock is now permanently held → **system hangs**

This is triggered specifically on ASICs that use PSR (Panel Self
Refresh) or Replay but do NOT have FAMS2 enabled, which is a real-world
configuration (many AMD laptops with eDP panels use PSR).

### 3. Bug Origin

The bug was introduced by commit `7d041982fe11` ("drm/amd/display:
Extend inbox0 lock to run Replay/PSR"), which added the
`dmub_hw_lock_mgr_does_link_require_lock()` call to the **lock** path
but forgot to update the **unlock** path. That commit first appeared in
`v6.19-rc1`.

### 4. The Fix

The fix is minimal and surgical — it introduces a local boolean variable
`is_dmub_lock_required` that stores the lock decision once, then reuses
it for both lock and unlock:

```c
bool is_dmub_lock_required = false;
// ...
if (dc->hwss.dmub_hw_control_lock_fast) {
    is_dmub_lock_required = dc_state_is_fams2_in_use(dc, context) ||
                            dmub_hw_lock_mgr_does_link_require_lock(dc,
stream->link);
    // ... lock with is_dmub_lock_required ...
}
// ... later ...
if (dc->hwss.dmub_hw_control_lock_fast) {
    // ... unlock with is_dmub_lock_required (same value!) ...
}
```

This guarantees the lock and unlock always use the same `is_required`
value.

### 5. Scope and Risk Assessment

- **Files changed:** 1 file (`dc_hw_sequencer.c`)
- **Lines changed:** ~6 lines net (variable declaration + 3 modified
  lines)
- **Risk:** Extremely low — the fix is purely ensuring consistent
  behavior between lock/unlock. No new logic, no behavioral changes for
  correctly-working paths.
- **Subsystem:** AMD display driver (amdgpu/dc), which is widely used on
  AMD GPUs

### 6. User Impact

- **Severity:** **System hang** — this is a hard hang when the DMUB
  hardware lock is held permanently. The GPU display hardware becomes
  unresponsive, likely requiring a reboot.
- **Who is affected:** Users with AMD GPUs using PSR or Replay (eDP
  laptop panels) on ASICs without FAMS2 support. This is a common laptop
  configuration.
- **Trigger:** Normal display fast-path updates (page flips) — this is a
  hot path exercised during normal display operation.

### 7. Stability Indicators

- `Reviewed-by: Swapnil Patel` — peer reviewed
- `Tested-by: Daniel Wheeler` — tested by AMD's QA
- The author (Nicholas Kazlauskas) is a key AMD display developer
- The fix is obviously correct by inspection — lock/unlock must use the
  same condition

### 8. Dependencies

The fix depends on commit `7d041982fe11` ("Extend inbox0 lock to run
Replay/PSR") being present. That commit introduced the bug and is in
`v6.19-rc1` and later. The fix only needs to go to stable trees that
contain the buggy commit. The `hwss_build_fast_sequence` function itself
has existed since v6.10 (commit `5324e2b205a2`), but the specific bug
was only introduced by the inbox0 extension in 6.19-rc1.

Since the buggy commit went into `v6.19-rc1`, the fix would primarily
target the 6.19.y stable tree. If the buggy commit was also backported
to earlier stable trees, the fix should follow it.

### 9. Classification

This is a clear **bug fix** for a **system hang** caused by **mismatched
lock/unlock logic**. It:
- Fixes a real bug (hardware lock never released → hang)
- Is obviously correct (use the same condition for lock and unlock)
- Is small and surgical (6 lines changed in 1 file)
- Does not introduce any new features or APIs
- Has been reviewed and tested
- Fixes a severe user-visible issue (system hang)

**YES** — this commit should be backported to stable kernel trees.

**YES**

 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index e2763b60482a0..052d573408c3e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -741,6 +741,7 @@ void hwss_build_fast_sequence(struct dc *dc,
 	struct dce_hwseq *hws = dc->hwseq;
 	struct pipe_ctx *current_pipe = NULL;
 	struct pipe_ctx *current_mpc_pipe = NULL;
+	bool is_dmub_lock_required = false;
 	unsigned int i = 0;
 
 	*num_steps = 0; // Initialize to 0
@@ -763,11 +764,12 @@ void hwss_build_fast_sequence(struct dc *dc,
 		(*num_steps)++;
 	}
 	if (dc->hwss.dmub_hw_control_lock_fast) {
+		is_dmub_lock_required = dc_state_is_fams2_in_use(dc, context) ||
+					dmub_hw_lock_mgr_does_link_require_lock(dc, stream->link);
+
 		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.dc = dc;
 		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.lock = true;
-		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.is_required =
-			dc_state_is_fams2_in_use(dc, context) ||
-			dmub_hw_lock_mgr_does_link_require_lock(dc, stream->link);
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.is_required = is_dmub_lock_required;
 		block_sequence[*num_steps].func = DMUB_HW_CONTROL_LOCK_FAST;
 		(*num_steps)++;
 	}
@@ -906,7 +908,7 @@ void hwss_build_fast_sequence(struct dc *dc,
 	if (dc->hwss.dmub_hw_control_lock_fast) {
 		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.dc = dc;
 		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.lock = false;
-		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.is_required = dc_state_is_fams2_in_use(dc, context);
+		block_sequence[*num_steps].params.dmub_hw_control_lock_fast_params.is_required = is_dmub_lock_required;
 		block_sequence[*num_steps].func = DMUB_HW_CONTROL_LOCK_FAST;
 		(*num_steps)++;
 	}
-- 
2.51.0

