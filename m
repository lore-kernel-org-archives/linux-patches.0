Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0D63D47BC;
	Mon, 30 Mar 2026 12:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874352; cv=none; b=ZQ96ou1St7nWOZsSujQlXQeUp2W2WQ5qhMS0k8y2EWJuIDuuwmVYk/BOyU/QI9yKfKU5LciahHQaSvALJ4QPprz01tSgyR4+oUjGbGfa/VD+pkIPT5VWbgOlNaK6fQIsMrfPEpYefY0BV/X/flb8Qcx3ydLqRynB9KjXrpxkcIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874352; c=relaxed/simple;
	bh=QIr2MPysgN6oXjXrbTTEUp1sNpZxedb6kRsTKaf1NtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5hJYbLi1sOfqolO4ymLAYqAY4g+I6hJlOlkUIsJhyoCJOrZdw+MBtCRS0J7QJJKhI3twY89Pi+n8Qk/h1eKXwKQpV1IUOAFG76j6MNFd7celmvD4XhohPGyjUzU0PedvEbJl1hbWEZ9BElM9ECFM++8QkXUAU3Jmvj6GX9eKMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+f95Fkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+f95Fkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8025C2BCB2;
	Mon, 30 Mar 2026 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874352;
	bh=QIr2MPysgN6oXjXrbTTEUp1sNpZxedb6kRsTKaf1NtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+f95FklNi/1MzvAXHcy+AFf+L+M8YNw28ElNETkrccD4N10cPuHead3xeTLO6bPd
	 xZDiJo5c6YeISH6EymjTzMgbLSQ3jFhGoGLCLniKe8O5mY8WAhdSpQzSeGnjMWEWbc
	 VekFpl7kb34GZnaT23QCKyYT2Hryr9Y5UfTTBW5X4jGdwIXekfqgkvziu+m4JvkzLD
	 9DJU3/DqafrdqclcKYWoFDeaHDd/fwfXbiVtkxmyw9HNl4snkMt+xxTFs39svlKHcf
	 imDMeDmu9y5g6UjR7LrkqRhnAXfC9VRJIjoo47P6b+VM19wDkc0LpT4p2QjtysB95X
	 PqFUizVEH6zXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	yung-chuan.liao@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	daniel.baluta@nxp.com,
	perex@perex.cz,
	tiwai@suse.com,
	sound-open-firmware@alsa-project.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Mon, 30 Mar 2026 08:38:33 -0400
Message-ID: <20260330123842.756154-20-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Transfer-Encoding: 8bit

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 215e5fe75881a7e2425df04aeeed47a903d5cd5d ]

sof_parse_token_sets() accepts array->size values that can be invalid
for a vendor tuple array header. In particular, a zero size does not
advance the parser state and can lead to non-progress parsing on
malformed topology data.

Validate array->size against the minimum header size and reject values
smaller than sizeof(*array) before parsing. This preserves behavior for
valid topologies and hardens malformed-input handling.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260319-sof-topology-array-size-fix-v1-1-f9191b16b1b7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis.

===============================================================
## PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1:** Record: [ASoC: SOF: topology] [reject] [reject invalid
vendor array size in token parser to prevent non-progress parsing]

**Step 1.2:** Record: Tags present:
- Signed-off-by: Cássio Gabriel (author)
- Acked-by: Peter Ujfalusi (confirmed listed SOF maintainer in
  MAINTAINERS)
- Link: patch.msgid.link URL
- Signed-off-by: Mark Brown (ASoC maintainer, merged the patch)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable tags (expected for
  manual review candidates)

**Step 1.3:** Record: Bug: `sof_parse_token_sets()` accepts
`array->size` values that are invalid — specifically, a zero size does
not advance parser state. Symptom: non-progress parsing (infinite loop)
on malformed topology data. Root cause: the validation only checked
`asize < 0`, which cannot catch zero or small positive values.

**Step 1.4:** Record: Yes, this is a real bug fix despite "hardens"
language. The commit fixes a concrete infinite loop scenario where
`asize == 0` causes the parser while-loop to never terminate.

===============================================================
## PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1:** Record: 1 file changed (`sound/soc/sof/topology.c`), 1
line modified. Function modified: `sof_parse_token_sets()`.
Classification: single-file, single-line surgical fix.

**Step 2.2:** Record: Before: `if (asize < 0)` — only rejects negative
values. After: `if (asize < sizeof(*array))` — rejects any value smaller
than the vendor array header size. The FIXME comment ("A zero-size array
makes no sense") was already documenting this known deficiency.

**Step 2.3:** Record: Bug category: logic/infinite loop. The while loop
at line 735 uses `array_size -= asize` (line 746) and advances the
pointer via `array = (u8*)array + asize` (line 784). When `asize == 0`:
1. `array_size -= 0` — no change, stays positive
2. `array = array + 0` — pointer doesn't advance
3. The while condition `array_size > 0 && total < count *
   token_instance_num` remains true
4. Result: **infinite loop / soft lockup**

**Step 2.4:** Record: The fix is obviously correct. `struct
snd_soc_tplg_vendor_array` has three `__le32` header fields (`size`,
`type`, `num_elems`) = 12 bytes minimum, plus a flex array union. Any
valid array must be at least `sizeof(*array)` bytes. Note on type
promotion: `asize` is `int`, `sizeof(*)` is `size_t`. A negative `asize`
promotes to a very large unsigned value, so `asize < sizeof(*)` would be
false — but negative `asize` is still caught by the subsequent
`array_size -= asize; if (array_size < 0)` check at line 747, so no
regression.

===============================================================
## PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1:** Record: `git blame` confirms the buggy `if (asize < 0)`
check was introduced in commit `311ce4fe7637d9` ("ASoC: SOF: Add support
for loading topologies") by Liam Girdwood, 2019-04-12. `git describe
--contains` shows this is `v5.2-rc1`. The bug has been present since
**v5.2** — all active stable trees contain it.

**Step 3.2:** Record: No Fixes: tag present. The buggy commit is
`311ce4fe7637d9`.

**Step 3.3:** Record: `git log --oneline -20` shows active development
but no related prerequisite or duplicate fix for this specific issue.

**Step 3.4:** Record: Peter Ujfalusi (Acked-by) is a listed maintainer
for SOF in MAINTAINERS. Mark Brown signed off as ASoC subsystem
maintainer. Strong maintainer endorsement.

**Step 3.5:** Record: No dependencies. The fix changes one condition in
an existing function with no new types, helpers, or APIs needed.

===============================================================
## PHASE 4: MAILING LIST RESEARCH
===============================================================

Record: The patch.msgid.link and lore.kernel.org URLs are blocked by
Anubis bot protection in this environment. However, the patch was Acked
by a listed SOF maintainer (Peter Ujfalusi) and merged by the ASoC
maintainer (Mark Brown), providing strong review signal.

===============================================================
## PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1:** Record: Modified function: `sof_parse_token_sets()`

**Step 5.2:** Record: `sof_parse_token_sets()` is called from:
1. `sof_parse_tokens()` — a wrapper called from ~9 locations throughout
   topology.c (control load, widget parsing, DAI load, link load,
   DSPless widget paths)
2. `sof_parse_pin_binding()` — direct call for pin binding token parsing

This is a heavily-used core parsing function in the SOF topology loader.

**Step 5.3-5.4:** Record: The call chain is: `sof_pcm_probe()` →
`snd_sof_load_topology()` → `snd_soc_tplg_component_load()` → SOF
callbacks (widget_ready, dai_load, link_load, control_load) →
`sof_parse_tokens()` → `sof_parse_token_sets()`. This is triggered
during SOF audio component probe when topology firmware blobs are
loaded.

**Step 5.5:** Record: The **same weak check** (`if (asize < 0)`) exists
in `sof_copy_tuples()` at line 544, with identical loop structure and
pointer advancement at line 610. This sibling function has the same
vulnerability but is NOT fixed by this commit. This means the patch is
not a complete fix across all SOF topology parsing paths, but it does
fix the specific path through `sof_parse_token_sets()`.

===============================================================
## PHASE 6: STABLE TREE ANALYSIS
===============================================================

**Step 6.1:** Record: The buggy code was introduced in v5.2. All active
stable trees (5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y) contain this
vulnerable code.

**Step 6.2:** Record: Expected clean or trivial backport — the `if
(asize < 0)` line with the FIXME comment hasn't changed since
introduction.

**Step 6.3:** Record: No duplicate or alternative fix found for this
exact issue in git history.

===============================================================
## PHASE 7: SUBSYSTEM CONTEXT
===============================================================

**Step 7.1:** Record: Subsystem: sound/soc/sof (Sound Open Firmware).
Criticality: IMPORTANT — SOF is used on most modern Intel laptops for
audio hardware.

**Step 7.2:** Record: Active subsystem with regular commits.

===============================================================
## PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1:** Record: Affected users: SOF audio hardware users (very
common on Intel-based laptops/desktops).

**Step 8.2:** Record: Trigger: malformed/corrupt SOF topology blob with
`array->size == 0` (or < header size). Topology files are loaded from
firmware path during driver probe. Trigger requires corrupt or
maliciously crafted topology data — uncommon in normal operation but
possible from disk corruption or adversarial input.

**Step 8.3:** Record: Failure mode: infinite loop in kernel context →
soft lockup → system hang during audio driver probe. Severity: HIGH
(system hang, unavailability).

**Step 8.4:** Record:
- **Benefit:** Prevents a real infinite loop / system hang. The FIXME
  comment proves the developer knew this was broken. Low-medium benefit
  (real hang, but only on malformed input).
- **Risk:** Very low. Single condition change; valid topologies always
  have `asize >= sizeof(*array)`. No regression for valid data. Acked by
  subsystem maintainer.
- **Ratio:** Favorable — high confidence in correctness, near-zero
  regression risk, fixes real hang.

===============================================================
## PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: Evidence compilation**

FOR backporting:
- Fixes a concrete infinite loop (system hang) — the FIXME comment
  proves this was a known deficiency
- Single-line, obviously correct fix
- Acked by listed SOF subsystem maintainer (Peter Ujfalusi)
- Merged by ASoC maintainer (Mark Brown)
- Bug present since v5.2 — exists in all active stable trees
- Near-zero regression risk for valid topologies
- `sof_parse_token_sets()` is called from ~10 locations — well-used code
  path

AGAINST backporting:
- Trigger requires malformed topology data (not normal operation)
- No user/syzbot crash report — found by code inspection
- The parallel `sof_copy_tuples()` function retains the same weak check
  (incomplete coverage)
- SOF is important but not core kernel — affects hardware-specific users

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? **YES** — maintainer acked, trivially
   verifiable from code
2. Fixes a real bug? **YES** — infinite loop on malformed input
   (acknowledged by FIXME comment)
3. Important issue? **YES** — system hang (soft lockup), HIGH severity
4. Small and contained? **YES** — 1 line changed, 1 function, 1 file
5. No new features or APIs? **YES**
6. Can apply to stable trees? **YES** — identical code in all stable
   trees

**Step 9.3:** Record: No exception category — standard bug fix.

**Step 9.4: Decision**

This commit fixes a real, documented infinite loop bug (the original
code even had a FIXME acknowledging the problem). The fix is a single-
line minimum-size validation, acked by the subsystem maintainer, with
near-zero regression risk. While the trigger requires malformed topology
data, a system hang is a serious failure mode — stable kernels should
handle invalid input gracefully without hanging. The incomplete coverage
of the sibling function `sof_copy_tuples()` does not diminish the value
of fixing this specific path. The fix meets all stable kernel criteria.

## Verification

- [Phase 1] Parsed all tags from supplied commit message: Acked-by Peter
  Ujfalusi, Signed-off-by Mark Brown, Link to patch.msgid.link
- [Phase 1] Verified Peter Ujfalusi is listed as maintainer in
  MAINTAINERS under "SOUND - SOUND OPEN FIRMWARE (SOF) DRIVERS"
- [Phase 2] Read `sof_parse_token_sets()` (lines 724-793): confirmed
  while loop at line 735, `array_size -= asize` at line 746, pointer
  advance `(u8*)array + asize` at line 784 — `asize == 0` causes
  infinite loop
- [Phase 2] Verified `struct snd_soc_tplg_vendor_array` in
  `include/uapi/sound/asoc.h` (line 220): three `__le32` fields (`size`,
  `type`, `num_elems`) + flex array union — `sizeof(*array)` is the
  correct minimum header size
- [Phase 2] Verified type safety: `int asize` compared against `size_t
  sizeof(*)` — negative values promote to large unsigned (caught by
  subsequent `array_size < 0` check at line 747)
- [Phase 3] git blame: buggy `if (asize < 0)` line attributed to commit
  `311ce4fe7637d9` (Liam Girdwood, 2019-04-12)
- [Phase 3] git describe: `311ce4fe7637d9` first appeared in `v5.2-rc1`
  — bug present in all active stable trees
- [Phase 3] git log -20: no prerequisites or duplicate fixes found
- [Phase 5] grep callers: `sof_parse_token_sets()` called from
  `sof_parse_tokens()` (~9 call sites) and `sof_parse_pin_binding()` (1
  call site)
- [Phase 5] grep: found same weak `if (asize < 0)` check in sibling
  `sof_copy_tuples()` at line 544, with identical loop/advance pattern
  at line 610 — NOT fixed by this commit
- [Phase 6] Buggy code unchanged since v5.2 — clean backport expected to
  all active stable trees
- [Phase 8] Failure mode: infinite loop in kernel context → soft
  lockup/system hang during topology load. Severity: HIGH
- UNVERIFIED: Lore discussion content (blocked by Anubis protection)
- UNVERIFIED: Whether unprivileged users can trigger topology loading on
  specific distributions
- UNVERIFIED: Exact runtime `sizeof(struct snd_soc_tplg_vendor_array)`
  (struct is `__packed` with flex array — compile-time verification not
  performed)

**YES**

 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 9bf8ab610a7ea..8880ac5d8d6ff 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -736,7 +736,7 @@ static int sof_parse_token_sets(struct snd_soc_component *scomp,
 		asize = le32_to_cpu(array->size);
 
 		/* validate asize */
-		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
+		if (asize < sizeof(*array)) {
 			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
 				asize);
 			return -EINVAL;
-- 
2.53.0

