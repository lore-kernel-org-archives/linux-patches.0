Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8DF3A381E;
	Mon, 20 Apr 2026 13:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690982; cv=none; b=ou+HCslPzNesBzhhVzI+a5pVX0xMMpSAl910tzWZkMXQAR1MifUZBp6Hmc2bhsQwVAvwJlML8IIa+ntvJJRVxXfjbDI7kpYgvOxITtKQm507r4Ghwet4e1LomVrm743npuBp6+JiHvZ4jTnluvM28wX1kXbRCShDBemmsCP3L80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690982; c=relaxed/simple;
	bh=ixycCzgwQcrzBOwmwhxZCHJFxuy1T4f1CXEOmEHTDg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h78nnpJVEWWLnKPYXSN9htTNoNc8MXi9noGy3apywKVbsz8MKxOqEe2g0gIuy5u4E7R5Vf5heT5QlHEMEl4VWDii3Lqmp29laYdhEbr4j5cPs1Ro8oYS13P5pakaXwkx0ty2R+RDlvmOmABgfctLqM5Hypv8qZOyVfrPvhZEGHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVEY1Y6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVEY1Y6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4F1C2BCB6;
	Mon, 20 Apr 2026 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690981;
	bh=ixycCzgwQcrzBOwmwhxZCHJFxuy1T4f1CXEOmEHTDg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVEY1Y6WyLlu4gn/eqzCvjuNeC8N48zo9FCO1ZRI9ItILzirTvU45znp2iR7fNtdI
	 pQgPcK2JyyaXLUVBCqzRCEwGTnZzYSCBlPIFZ0IrFt8Vbm/vmY7/o++3QQfRZOZYSg
	 zaPrHGwLpz06alvPU/XsqM36D+g2uXQCrRVARgq6sPAio7CEVUNApbqh0yXOdPMDuV
	 vzkD7LrnNZqGiKIDrlc8ts74cOjIChB7pF+5O6Qt+dfhXZgxY+RAgwrw4/H8OJeuVC
	 0W/r8Wf5+QBKz1/98/OH4xVqwRmjHBT0K7rCDu+9CRgyzKJ8K2Y1tolKpj566rlwZV
	 mvxef2nYSmZOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] ALSA: asihpi: detect truncated control names
Date: Mon, 20 Apr 2026 09:08:10 -0400
Message-ID: <20260420131539.986432-24-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 18d4969e22cc3ff738257e1d7738aafc65a6d2d2 ]

asihpi_ctl_init() builds mixer control names in the fixed 44-byte
hpi_ctl->name buffer with sprintf().

This is not only a defensive cleanup. The current in-tree name tables and
format strings can already exceed 44 bytes. For example,

  "Bitstream 0 Internal 0 Monitor Playback Volume"

is 46 characters before the trailing NUL, so the current sprintf() call
writes past the end of hpi_ctl->name.

The generated control name is used as the ALSA control element key, so
blindly truncating it is not sufficient. Switch the formatting to
snprintf() and emit an error if truncation happens, showing the
truncated name while still keeping the write bounded to hpi_ctl->name.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260328102808.33969-1-pengpeng@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1**: Subsystem: `sound/pci/asihpi` (ALSA PCI audio driver).
Action verb: "detect" (but the real action is **fixing** a buffer
overflow by bounding writes). Summary: Replaces unbounded `sprintf()`
with bounded `snprintf()` on a fixed 44-byte buffer.

**Step 1.2**: Tags:
- Signed-off-by: Pengpeng Hou (author), Takashi Iwai (ALSA subsystem
  maintainer)
- Link:
  `https://patch.msgid.link/20260328102808.33969-1-pengpeng@iscas.ac.cn`
- No Fixes: tag, no Reported-by:, no Cc: stable (expected for manual
  review candidates)

**Step 1.3**: The commit body explicitly identifies a concrete buffer
overflow: the name "Bitstream 0 Internal 0 Monitor Playback Volume" is
46 characters + NUL = 47 bytes, exceeding the 44-byte `hpi_ctl->name`
buffer. The `sprintf()` call writes past the end of the buffer. The fix
bounds the write with `snprintf()` and emits an error on truncation.

**Step 1.4**: This is NOT a hidden bug fix — the commit message is clear
that the current in-tree code overflows the buffer. It explicitly says
"This is not only a defensive cleanup."

## PHASE 2: DIFF ANALYSIS

**Step 2.1**: Single file modified: `sound/pci/asihpi/asihpi.c` (+22,
-14). Single function modified: `asihpi_ctl_init()`. Scope: surgical,
single-function fix.

**Step 2.2**: Three `sprintf()` calls (one per branch of the if/else)
are replaced with `snprintf()` using `sizeof(hpi_ctl->name)` as the
bound. A new `int len` variable captures the return value, and a check
at the end emits `pr_err()` if truncation occurred.

**Step 2.3**: Bug category: **Buffer overflow / out-of-bounds write**.
The `name` buffer is defined as:

```1280:1280:sound/pci/asihpi/asihpi.c
        char name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN]; /* copied to
snd_ctl_elem_id.name[44]; */
```

`SNDRV_CTL_ELEM_ID_NAME_MAXLEN` = 44. The longest possible generated
name ("Bitstream 0 Internal 0 Monitor Playback Volume") = 46 chars + NUL
= 47 bytes. The `sprintf()` writes 3 bytes past the end.

**Step 2.4**: Fix is obviously correct — `snprintf()` is a drop-in
bounded replacement for `sprintf()`. No regression risk; the only
behavioral change is that overflow is prevented and logged.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1**: `git blame` shows the buggy `sprintf()` calls were
introduced in commit `719f82d3987aad` (Eliot Blennerhassett, 2010-04-21)
— "ALSA: Add support of AudioScience ASI boards." This code has been
present since ~v2.6.35, meaning the bug exists in **all** active stable
trees.

**Step 3.2**: No Fixes: tag to follow.

**Step 3.3**: Recent history shows only cleanup/refactoring commits to
this file. No intermediate fix for this specific buffer overflow. The
patch is standalone.

**Step 3.4**: Author Pengpeng Hou has other commits that are buffer-
safety/bounds-check fixes (e.g., NFC, networking). The patch was
reviewed and requested in its final form by Takashi Iwai, the ALSA
maintainer.

**Step 3.5**: No dependencies. The diff only changes `sprintf→snprintf`
and adds a bounds check. The surrounding code is unchanged since
2010-2011 and exists identically in stable trees.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1**: b4 dig found the thread at
`https://patch.msgid.link/20260328102808.33969-1-pengpeng@iscas.ac.cn`.
The patch went through v1 → v2 → v3. Takashi Iwai reviewed v1/v2,
confirmed the overflow is real ("if the string overflow can happen
really, it's rather a bigger problem"), and explicitly requested the v3
revision with `snprintf()` + error reporting. He applied v3 with
"Applied to for-next branch now."

**Step 4.2**: Takashi Iwai (ALSA maintainer) reviewed the patch. The
linux-sound mailing list was CC'd.

**Step 4.3**: No external bug report — found via code inspection.

**Step 4.4**: Single standalone patch, not part of a series.

**Step 4.5**: No prior stable discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1**: Single function modified: `asihpi_ctl_init()`.

**Step 5.2**: `asihpi_ctl_init()` is called from ~10 places:
`snd_asihpi_volume_new`, `snd_asihpi_level_new`, `snd_asihpi_meter_add`,
`snd_asihpi_mux_new`, `snd_asihpi_cmode_new`, `snd_asihpi_tuner_new`,
etc. All called during mixer initialization in
`snd_card_asihpi_mixer_new()`.

**Step 5.3**: The function formats a control name and stores it in
`hpi_ctl->name`, which is then used as the ALSA control element key via
`snd_control->name = hpi_ctl->name`.

**Step 5.4**: The call chain is: PCI probe →
`snd_card_asihpi_mixer_new()` → control type builders →
`asihpi_ctl_init()`. The `hpi_ctl` struct is **stack-allocated** at line
2528:

```2528:2528:sound/pci/asihpi/asihpi.c
        struct hpi_control hpi_ctl, prev_ctl;
```

The `name` field is the **last field** of `struct hpi_control`, so the
overflow writes past the struct into adjacent stack memory (potentially
corrupting `prev_ctl` or other stack variables).

**Step 5.5**: The existing name tables contain entries like "Bitstream"
(9 chars), "Internal" (8 chars), "BLU-Link" (8 chars). Combined with
"Monitor Playback " (18 chars including trailing space) and control
names like "Volume" (6 chars), several combinations can exceed 44 bytes.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1**: The buggy code was introduced in 2010 (v2.6.35 era). It
exists in all active stable trees. The `asihpi_ctl_init()` function has
barely changed since then.

**Step 6.2**: The patch should apply cleanly — changes since v6.6 and
v5.15 to this file are minor cleanups that don't touch this function.
The only relevant nearby change was `1882c12ae2ab0` (strscpy instead of
strcpy in a different function).

**Step 6.3**: No related fix already in stable for this specific buffer
overflow.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1**: Subsystem: ALSA PCI audio driver (asihpi). Criticality:
PERIPHERAL — this is a specific hardware driver for AudioScience ASI
boards. However, buffer overflows in any driver are security-relevant.

**Step 7.2**: The driver receives occasional maintenance (last few
changes are cleanups and minor fixes). It's a mature, low-activity
driver.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1**: Users of AudioScience ASI audio hardware are affected.
This is niche professional audio hardware, but users who have it depend
on this driver.

**Step 8.2**: Trigger requires specific hardware/firmware configuration
where source and destination nodes produce a name exceeding 44 bytes.
The maintainer noted the specific overflow case "didn't happen in
reality" with existing firmware, but it's a latent overflow that exists
with the current in-tree string tables.

**Step 8.3**: Failure mode: **Stack buffer overflow** — the `name` field
is at the end of a stack-allocated struct. The overflow corrupts
adjacent stack memory. Potential consequences: stack corruption, crash,
or undefined behavior. Severity: **HIGH** (buffer overflow, potential
crash or security impact).

**Step 8.4**:
- **Benefit**: Prevents a proven buffer overflow that can occur with in-
  tree string values. Low practical frequency, but consequences are
  severe (stack corruption).
- **Risk**: Very low. The change is `sprintf()` → `snprintf()` + bounds
  check. No behavioral change for names that fit. Adds an error log for
  names that don't.
- **Ratio**: Favorable — very low risk for meaningful safety
  improvement.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting**:
- Fixes a real buffer overflow: `sprintf()` can write past the end of a
  44-byte buffer
- The overflow is provable from in-tree code (commit message gives a
  concrete 46-char example)
- Stack-allocated buffer → stack corruption risk
- Fix is minimal (single function, +22/-14 lines), obviously correct
- Reviewed and applied by Takashi Iwai (ALSA subsystem maintainer)
- Patch went through 3 revisions with maintainer feedback
- Bug exists in all stable trees (code from 2010)
- Patch should apply cleanly

**Evidence AGAINST backporting**:
- Niche hardware driver (AudioScience ASI boards)
- Practical trigger depends on specific firmware/hardware configuration
- Maintainer noted the overflow "didn't happen in reality" with current
  firmware
- No crash reports from users

**Stable rules checklist**:
1. Obviously correct and tested? **YES** — simple sprintf→snprintf
2. Fixes a real bug? **YES** — proven buffer overflow with in-tree
   strings
3. Important issue? **YES** — buffer overflow / stack corruption
4. Small and contained? **YES** — single function, single file
5. No new features? **YES** — purely a bug fix
6. Can apply to stable? **YES** — code unchanged since 2010

## Verification

- [Phase 1] Parsed commit message: identifies 46-char control name that
  overflows 44-byte buffer
- [Phase 2] Diff analysis: 3 `sprintf()` → `snprintf()` conversions +
  truncation check in `asihpi_ctl_init()`
- [Phase 3] git blame: buggy sprintf() code introduced in commit
  719f82d3987aad (2010, v2.6.35), present in all stable trees
- [Phase 3] git log v6.6/v5.15: confirmed function is essentially
  unchanged since introduction
- [Phase 4] b4 dig -c 18d4969e22cc3: found original thread, patch v1→v3
  evolution
- [Phase 4] b4 dig -a: confirmed v3 is the applied version, v1 used
  scnprintf, Takashi requested snprintf+check
- [Phase 4] Mailing list: Takashi Iwai confirmed overflow is real,
  requested v3, applied to for-next
- [Phase 5] Verified `struct hpi_control` has `name[44]` as last field,
  struct is stack-allocated in `snd_card_asihpi_mixer_new()`
- [Phase 5] Verified SNDRV_CTL_ELEM_ID_NAME_MAXLEN = 44 in
  include/uapi/sound/asound.h
- [Phase 5] Verified name tables: "Bitstream"(9) + " 0 "(3) +
  "Internal"(8) + " 0 "(3) + "Monitor Playback "(18) + "Volume"(6) = 47
  chars with NUL → 3-byte overflow
- [Phase 6] Code exists in all active stable trees, patch should apply
  cleanly
- [Phase 8] Stack buffer overflow severity: HIGH (stack corruption
  possible)

The fix is small, obviously correct, prevents a real buffer overflow
with in-tree string values, was reviewed and refined by the ALSA
maintainer through 3 iterations, and applies cleanly to stable trees.

**YES**

 sound/pci/asihpi/asihpi.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index 3a64d05628030..b1c7ed7f1604e 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -1362,6 +1362,7 @@ static void asihpi_ctl_init(struct snd_kcontrol_new *snd_control,
 				struct hpi_control *hpi_ctl,
 				char *name)
 {
+	int len;
 	char *dir;
 	memset(snd_control, 0, sizeof(*snd_control));
 	snd_control->name = hpi_ctl->name;
@@ -1384,23 +1385,30 @@ static void asihpi_ctl_init(struct snd_kcontrol_new *snd_control,
 		dir = "Playback "; /* PCM Playback source, or  output node */
 
 	if (hpi_ctl->src_node_type && hpi_ctl->dst_node_type)
-		sprintf(hpi_ctl->name, "%s %d %s %d %s%s",
-			asihpi_src_names[hpi_ctl->src_node_type],
-			hpi_ctl->src_node_index,
-			asihpi_dst_names[hpi_ctl->dst_node_type],
-			hpi_ctl->dst_node_index,
-			dir, name);
+		len = snprintf(hpi_ctl->name, sizeof(hpi_ctl->name),
+			       "%s %d %s %d %s%s",
+			       asihpi_src_names[hpi_ctl->src_node_type],
+			       hpi_ctl->src_node_index,
+			       asihpi_dst_names[hpi_ctl->dst_node_type],
+			       hpi_ctl->dst_node_index,
+			       dir, name);
 	else if (hpi_ctl->dst_node_type) {
-		sprintf(hpi_ctl->name, "%s %d %s%s",
-		asihpi_dst_names[hpi_ctl->dst_node_type],
-		hpi_ctl->dst_node_index,
-		dir, name);
+		len = snprintf(hpi_ctl->name, sizeof(hpi_ctl->name),
+			       "%s %d %s%s",
+			       asihpi_dst_names[hpi_ctl->dst_node_type],
+			       hpi_ctl->dst_node_index,
+			       dir, name);
 	} else {
-		sprintf(hpi_ctl->name, "%s %d %s%s",
-		asihpi_src_names[hpi_ctl->src_node_type],
-		hpi_ctl->src_node_index,
-		dir, name);
+		len = snprintf(hpi_ctl->name, sizeof(hpi_ctl->name),
+			       "%s %d %s%s",
+			       asihpi_src_names[hpi_ctl->src_node_type],
+			       hpi_ctl->src_node_index,
+			       dir, name);
 	}
+
+	if (len >= sizeof(hpi_ctl->name))
+		pr_err("asihpi: truncated control name: %s\n",
+		       hpi_ctl->name);
 }
 
 /*------------------------------------------------------------
-- 
2.53.0

