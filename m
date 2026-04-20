Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EBB3C0624;
	Mon, 20 Apr 2026 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691046; cv=none; b=Qztb+8/lAPzxh4mzw5TNU0QBNunQAVNlYy29vnUgZd5JrxeoCnuxAH5EMC7+lvW/s0eX4UvrhdwUd//2ZYsYZmmylVe9IMg7+/vhWVsC+6x2MopsXcYX6LIUgLv6CNC+d7YG1ypLXm1Pk3O8JcdN8ANjpb59VhenYiLHkhthG8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691046; c=relaxed/simple;
	bh=a5qCtqYAadx+H8N6GedWRAAhoHLaCmOXqs9zf4+AemA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwOzCg/u2hGDuFUi6GCWiqS9KoTf7Dvy5ndg5I/Al5G/n2H2hyvxD5Rg3gmnXzB+EqLcJhQIeAPGAb8eLgDQRX6np/cPN3NalWXJENLDvcc+inA8+VBktod+r1gnzf5nlTGgnqnz/XNcLodJNyJpp1WXmOHY60PwLfq4IlOMHxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dh8YuRmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dh8YuRmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF94C2BCB6;
	Mon, 20 Apr 2026 13:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691046;
	bh=a5qCtqYAadx+H8N6GedWRAAhoHLaCmOXqs9zf4+AemA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dh8YuRmEUHMbN19XaJqYUd6EVVLvZrZ7SSZVXXkf5a8OapyvI0snThgtDrpfO/SbM
	 eWrQuPCY3uuMsQDr4Qkr9vt45FaPw9U4royPbHKo956qTAhyPKVpXV6JWaBd4eXDx+
	 gt56OaHvxOLOBuIhDu31RtS/Tf5QJeCsIudwZBu8DLuTFsCi3tm/EsHz3axWQeAdXn
	 16sw0kRA1DuKRmMXQw85DNFZQTZJoGjBU5+MDeIxw120heSdE7oZkgEi6YeiT34eyz
	 IYq0iTYk8N4DD7OpYHOmot/bOwlrfwcYJdUo9+jdEuusw1MdpO+zEO9IIqGStT1qeS
	 Qoh0KCbYmISbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	andrzej.hajda@intel.com,
	neil.armstrong@linaro.org,
	rfoss@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/bridge: waveshare-dsi: Register and attach our DSI device at probe
Date: Mon, 20 Apr 2026 09:08:48 -0400
Message-ID: <20260420131539.986432-62-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit b8eb97ead862de7a321dd55a901542a372f8f1cd ]

In order to avoid any probe ordering issue, the best practice is to move
the secondary MIPI-DSI device registration and attachment to the
MIPI-DSI host at probe time.

Besides solving the probe ordering problems, this makes the bridge work
with R-Car DU. The R-Car DU will attempt to locate the DSI host bridge in
its own rcar_du_probe()->rcar_du_modeset_init()->rcar_du_encoder_init()
by calling of_drm_find_bridge() which calls of_drm_find_and_get_bridge()
and iterates over bridge_list to locate the DSI host bridge.

However, unless the WS driver calls mipi_dsi_attach() in probe(), the
DSI host bridge .attach callback rcar_mipi_dsi_host_attach() is not
called and the DSI host bridge is not added into bridge_list. Therefore
the of_drm_find_and_get_bridge() called from du_probe() will never find
the DSI host bridge and probe will indefinitelly fail with -EPROBE_DEFER.

The circular dependency here is, that if rcar_du_encoder_init() would
manage to find the DSI host bridge, it would call the WS driver .attach
callback ws_bridge_bridge_attach(), but this is too late and can never
happen. This change avoids the circular dependency.

Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://patch.msgid.link/20260206125801.78705-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - the patch applies cleanly. Now let me complete the analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `drm/bridge: waveshare-dsi:`
- **Action verb**: "Register and attach" (moving registration to probe
  time)
- **Summary**: Moves DSI device registration/attachment from bridge
  .attach callback to probe() to fix circular probe ordering dependency

Record: [drm/bridge] [register/attach] [move DSI registration to probe
to fix probe ordering deadlock]

### Step 1.2: Tags
- **Reviewed-by:** Luca Ceresoli (DRM bridge subsystem co-maintainer,
  also committer)
- **Signed-off-by:** Marek Vasut (author, well-known Renesas/DRM
  contributor)
- **Signed-off-by:** Luca Ceresoli (committer)
- **Link:** patch.msgid.link reference
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by tag

Record: Reviewed by subsystem maintainer. Author is a well-known kernel
developer (Marek Vasut).

### Step 1.3: Commit Body
The commit describes a circular dependency:
1. R-Car DU's `rcar_du_encoder_init()` calls `of_drm_find_bridge()` to
   find the DSI host bridge in `bridge_list`
2. The DSI host bridge is only added to `bridge_list` via
   `drm_bridge_add()` inside `rcar_mipi_dsi_host_attach()`
3. `rcar_mipi_dsi_host_attach()` is only triggered by
   `mipi_dsi_attach()`
4. `mipi_dsi_attach()` (via `ws_bridge_attach_dsi()`) is only called
   from `ws_bridge_bridge_attach()`
5. `ws_bridge_bridge_attach()` only gets called once the pipeline is
   assembled - but the pipeline can't be assembled (step 1 fails)

Failure mode: indefinite -EPROBE_DEFER — the driver never successfully
probes with R-Car DU.

Record: Real circular dependency causing permanent probe failure. The
waveshare bridge cannot work with R-Car DU at all.

### Step 1.4: Hidden Bug Fix Detection
Despite not using "fix" in the subject, this IS a bug fix. "Register and
attach... at probe" indicates correcting the timing of a critical
operation. The body clearly describes a broken code path resulting in a
permanent, unrecoverable probe failure.

Record: Yes, this is a hidden bug fix. Moving DSI registration to probe
fixes a real circular dependency.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files**: 1 file changed: `drivers/gpu/drm/bridge/waveshare-dsi.c`
- **Lines**: +1, -6 (net -5 lines)
- **Functions modified**: `ws_bridge_bridge_attach()` (removed call),
  `ws_bridge_probe()` (added call)
- **Scope**: Single-file surgical fix

Record: Extremely small change — moves 1 function call from one location
to another.

### Step 2.2: Code Flow Change
**Hunk 1** (`ws_bridge_bridge_attach`): Removes the call to
`ws_bridge_attach_dsi(ws)` and its error check. The function now only
calls `drm_bridge_attach()`.

**Hunk 2** (`ws_bridge_probe`): Changes `return 0` to `return
ws_bridge_attach_dsi(ws)`. DSI registration now happens at probe time.

Record: Before: DSI registration in .attach callback (lazy). After: DSI
registration in .probe (eager). This breaks the circular dependency.

### Step 2.3: Bug Mechanism
This is a **probe ordering / circular dependency** fix. The bug category
is "logic/correctness fix" — the code called a function at the wrong
lifecycle point, creating a deadlock in the probe ordering chain.

Record: Circular dependency between R-Car DU encoder init and waveshare
bridge DSI registration. Permanent EPROBE_DEFER.

### Step 2.4: Fix Quality
- Obviously correct: follows the well-established pattern from
  `6ef7ee48765f` (sn65dsi83 bridge)
- Minimal: net -5 lines
- Regression risk: Very low. If the DSI host isn't ready at probe time,
  `ws_bridge_attach_dsi()` returns `-EPROBE_DEFER` and the driver will
  be re-probed later. All resources use `devm_*` management.

Record: High quality fix, minimal regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
All code in `waveshare-dsi.c` was introduced by `dbdea37add132` (Joseph
Guo, Aug 6, 2025). The buggy pattern (DSI registration in .attach
instead of .probe) has existed since the driver was first added.

Record: Bug present since driver inception (v6.18 cycle, Aug 2025).
Present in 7.0.

### Step 3.2: No Fixes: tag — expected.

### Step 3.3: File History
Only 2 commits exist in 7.0 for this file:
1. `dbdea37add132` — driver addition
2. `3e6339a19cfc9` — devm_drm_bridge_alloc bailout fix

In mainline, additional commits follow but are NOT in 7.0:
- `b8eb97ead862d` — this commit (not in 7.0)
- `fca11428425e9` — DSI lanes support (not in 7.0)
- `a469749640fbc` — signedness bug fix (not in 7.0)

Record: Standalone fix. No prerequisite commits needed. The lanes and
signedness commits are independent.

### Step 3.4: Author
Marek Vasut is a very well-known kernel contributor, particularly for
Renesas/R-Car and DRM bridge subsystems.

Record: Author is a trusted, experienced kernel contributor.

### Step 3.5: Dependencies
The patch applies cleanly to 7.0 HEAD (verified via `git apply
--check`). No dependencies on other patches.

Record: Clean apply, no dependencies.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Patch Discussion
- **b4 dig** found the original submission: v1 on Jan 12, 2026; v2
  (applied version) on Feb 6, 2026
- v1 was identical in diff but had a shorter commit message
- Luca Ceresoli (subsystem maintainer) reviewed v1 and asked for a
  better description of what goes wrong
- v2 added the detailed explanation of the R-Car DU circular dependency
- The v1 message referenced `6ef7ee48765f` ("drm/bridge: sn65dsi83:
  Register and attach our DSI device at probe") as the precedent

Record: Patch went through v1→v2 review. Applied version is v2 with
improved description. Reviewed-by from subsystem maintainer.

### Step 4.2: Recipients
Major DRM bridge maintainers were CC'd: Andrzej Hajda, Laurent Pinchart,
Neil Armstrong, Maxime Ripard, Simona Vetter, Thomas Zimmermann, plus
dri-devel and linux-renesas-soc lists.

Record: Properly reviewed by appropriate people.

### Step 4.3: Bug Report
No external bug report — author discovered the issue while working with
R-Car DU hardware.

### Step 4.4-4.5: No related series or stable discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Functions Modified
- `ws_bridge_bridge_attach()`: Called by DRM framework when attaching
  bridge to encoder pipeline
- `ws_bridge_probe()`: Called by I2C subsystem on device match

### Step 5.3-5.4: Call Chain for the Bug
Verified the circular dependency path:
1. `rcar_du_encoder_init()` → `of_drm_find_bridge()` → searches
   `bridge_list` → NOT FOUND → returns `-EPROBE_DEFER` (confirmed in
   `rcar_du_encoder.c` line 75-77)
2. R-Car DSI bridge only enters `bridge_list` via `drm_bridge_add()` at
   line 943 of `rcar_mipi_dsi.c`, which is inside
   `rcar_mipi_dsi_host_attach()`, which requires `mipi_dsi_attach()` to
   be called first
3. Without moving `ws_bridge_attach_dsi()` to probe, `mipi_dsi_attach()`
   never gets called at the right time

Record: Circular dependency fully verified through code inspection.

### Step 5.5: Similar Patterns
The exact same fix was applied to `sn65dsi83` bridge in commit
`6ef7ee48765f` (Oct 2021). This is a well-known pattern.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Exists in 7.0
The waveshare-dsi driver exists in 7.0 (added in `dbdea37add132`, which
is in 7.0). The buggy code is present.

Record: Bug exists in 7.0 stable tree.

### Step 6.2: Backport Complications
Patch applies cleanly — verified. The file in 7.0 is at the exact state
the patch expects.

Record: Clean apply confirmed.

### Step 6.3: No related fixes already in 7.0.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
DRM bridge driver — PERIPHERAL. Affects only users of waveshare DSI
panels on R-Car DU hardware.

Record: PERIPHERAL subsystem, specific hardware combination.

### Step 7.2: Activity
The waveshare-dsi driver is relatively new (Aug 2025) with active
development.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users of waveshare DSI2DPI panels connected to R-Car DU display
controllers. This is a specific embedded/industrial use case.

Record: Driver-specific, R-Car platform-specific.

### Step 8.2: Trigger Conditions
Every boot on affected hardware. The bug is deterministic — it always
triggers. The system will log endless `-EPROBE_DEFER` messages and the
display never works.

Record: 100% trigger rate on affected hardware. Deterministic.

### Step 8.3: Failure Severity
Permanent probe failure — the display hardware never initializes. The
bridge never works with R-Car DU. This is a complete functionality
failure.

Record: Severity HIGH — complete hardware failure on affected platforms.

### Step 8.4: Risk-Benefit
- **Benefit**: Makes waveshare bridge actually work on R-Car DU (from
  non-functional to functional)
- **Risk**: Very low — 1 file, net -5 lines, uses devm for cleanup,
  follows established pattern, reviewed by maintainer. Tested on R-Car
  hardware by the author.

Record: HIGH benefit for affected users, VERY LOW risk.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real, deterministic bug (circular dependency → permanent
  EPROBE_DEFER)
- Extremely small fix: 1 file, net -5 lines
- Follows a well-established pattern (same fix applied to sn65dsi83 4+
  years ago)
- Reviewed by DRM bridge subsystem maintainer (Luca Ceresoli)
- Author is a trusted senior kernel developer (Marek Vasut)
- Applies cleanly to 7.0 stable
- No dependencies on other commits
- No regression risk (devm-managed resources, EPROBE_DEFER handles
  ordering)

**AGAINST backporting:**
- Affects a narrow user base (waveshare DSI + R-Car DU)
- No Fixes: tag or Cc: stable (expected — this is why we're reviewing
  it)
- Could be seen as "enabling hardware" rather than "fixing a regression"

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — follows established pattern,
   reviewed by maintainer, tested by author on R-Car
2. Fixes a real bug? **YES** — permanent EPROBE_DEFER, display never
   works
3. Important issue? **YES** — complete hardware failure (display never
   initializes)
4. Small and contained? **YES** — 1 file, net -5 lines
5. No new features or APIs? **YES** — just moves an existing call
6. Can apply to stable? **YES** — verified clean apply

### Step 9.3: Exception Categories
Not applicable — this is a straightforward bug fix, not a quirk/device-
ID/DT case.

### Step 9.4: Decision
The fix resolves a deterministic probe ordering bug that completely
prevents the waveshare DSI bridge from working with R-Car DU. While it
affects a narrow user base, the fix is tiny, obviously correct, follows
a well-established pattern, and carries essentially zero regression
risk. It meets all stable kernel criteria.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Luca Ceresoli, Signed-off-by Marek
  Vasut, Link to patch.msgid.link
- [Phase 2] Diff analysis: -5 lines removed from
  ws_bridge_bridge_attach(), +1 line in ws_bridge_probe(), moves
  ws_bridge_attach_dsi() call
- [Phase 3] git blame: all code introduced in dbdea37add132 (Aug 2025),
  present in 7.0
- [Phase 3] git log ancestry-path: only 3e6339a19cfc9
  (devm_drm_bridge_alloc fix) between driver add and HEAD for this file
- [Phase 3] git merge-base: confirmed dbdea37add132 is in 7.0 tree
- [Phase 3] git branch --contains: b8eb97ead862d NOT in HEAD, is in
  core-next etc.
- [Phase 4] b4 dig -c b8eb97ead862d: found v2 at https://patch.msgid.lin
  k/20260206125801.78705-1-marek.vasut+renesas@mailbox.org
- [Phase 4] b4 dig -a: v1 (Jan 12, 2026) → v2 (Feb 6, 2026), v2 is
  applied version
- [Phase 4] b4 dig -w: Proper DRM bridge maintainers were CC'd
- [Phase 4] b4 dig -m: Read full thread — reviewer asked for better
  description, v2 added it
- [Phase 5] Verified circular dependency: rcar_du_encoder.c line 75-77
  returns -EPROBE_DEFER when bridge not found; rcar_mipi_dsi.c line 943
  drm_bridge_add() only called from host_attach callback
- [Phase 5] Confirmed sn65dsi83 precedent: commit 6ef7ee48765f exists
  and is identical pattern
- [Phase 6] git apply --check: patch applies cleanly to 7.0 HEAD
- [Phase 6] fca11428425e9 (lanes) and a469749640fbc (signedness) are
  independent, not dependencies
- [Phase 8] Failure mode: permanent EPROBE_DEFER on R-Car DU + waveshare
  DSI — display never works

**YES**

 drivers/gpu/drm/bridge/waveshare-dsi.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/waveshare-dsi.c b/drivers/gpu/drm/bridge/waveshare-dsi.c
index 43f4e7412d722..9254446f54958 100644
--- a/drivers/gpu/drm/bridge/waveshare-dsi.c
+++ b/drivers/gpu/drm/bridge/waveshare-dsi.c
@@ -80,11 +80,6 @@ static int ws_bridge_bridge_attach(struct drm_bridge *bridge,
 				   enum drm_bridge_attach_flags flags)
 {
 	struct ws_bridge *ws = bridge_to_ws_bridge(bridge);
-	int ret;
-
-	ret = ws_bridge_attach_dsi(ws);
-	if (ret)
-		return ret;
 
 	return drm_bridge_attach(encoder, ws->next_bridge,
 				 &ws->bridge, flags);
@@ -179,7 +174,7 @@ static int ws_bridge_probe(struct i2c_client *i2c)
 	ws->bridge.of_node = dev->of_node;
 	devm_drm_bridge_add(dev, &ws->bridge);
 
-	return 0;
+	return ws_bridge_attach_dsi(ws);
 }
 
 static const struct of_device_id ws_bridge_of_ids[] = {
-- 
2.53.0

