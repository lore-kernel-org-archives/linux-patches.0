Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023AC53D0C1;
	Mon, 31 Aug 2026 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184163; cv=none; b=GrRKoMnLKbKwENVLq/8XSH0lr18v1JhDMdh4TiJ7z3U1ZCNz64oOpwsr3NS5Q/Utc5IBgVxjGivuf5jLcGbfxmS3vEPQiX3ijeNZ0FcgYgam81sIj3pR72Ibnyu/OLl8PZXIM+UW3l84MWD5gsG/dwkJxLpnxNGub99H/xqRt5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184163; c=relaxed/simple;
	bh=rzWTuNNITA1RP0z2Bs1ytdcA00Pp2AsVQqSvSU1gUDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpcBC6YfGFW/QL4JGdQQzzUlGYcGoyoO80Gsoxwwkzpli4oEf4HZVSosCCDLKvbpTwpQK8Fvbc7F5CNadV8iqgeOXlzDyQuRSPYAcxH7LHHRx95mxxgTaqRCORfBlsMA6JyAw//6UKb0xadm0MtY/WfxcUhxWfIaLTZbN3rjNiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6SY8Scb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6SY8Scb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C4B1F00ADB;
	Mon, 31 Aug 2026 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184160;
	bh=Nt3ygAog5YObM4Ykz23j98wLcbCUuH7UCi3DByaXqVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6SY8ScbHnlF4tH72vQYIcnkhUolaAfiA4dPDBW3bi5xDlahyZxKzbQXw/ayJoeyN
	 WKbY0W2meTrCiSXGxAqwHSnlDGx+wzJQdYc7HGkI2I8wR7zIvmdaRJBxZq7CimIje3
	 m5LF+3Oo+Mxt9VYm8AsMp4DiW+yrrekguTLQEOwCsXJKLqwEDyrEPH3OVKOpt8D/kc
	 PqvVRfeDFlwWong7CLWTREj9IeG/n47pfeO6GOm5F4jf3pnDPk3MVFYFnrbQ8LivB8
	 l9sU5W0tWwCRcreNEvfshm5CncAooN4m8F30879QWiaFj1IexCX64xppjkR06KHSFo
	 az48HWTwYSfOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonas Jelonek <jelonek.jonas@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: sfp: extend SMBus support
Date: Mon, 31 Aug 2026 09:29:15 -0400
Message-ID: <20260831133314.4125787-527-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonas Jelonek <jelonek.jonas@gmail.com>

[ Upstream commit 58b29bdf6186a8c3f2d725619c0b17cf602ac4e0 ]

Commit 7662abf4db94 ("net: phy: sfp: Add support for SMBus module access")
added SMBus access for SFP modules, but limited it to single-byte
transfers. As a side effect, hwmon is disabled (16-bit reads cannot be
guaranteed atomic) and a warning is printed.

Many SMBus-only I2C controllers in the wild support more than just
byte access, and SFP cages are often wired to such controllers
rather than to a full-featured I2C controller -- e.g. the SMBus
controllers in the Realtek longan and mango SoCs, which advertise
word access and I2C block reads. Today, they cannot drive an SFP at
all without falling back to the byte-only path.

Extend sfp_smbus_read()/sfp_smbus_write() so that, in addition to
the existing byte access, they also use SMBus word access and SMBus
I2C block access whenever the adapter advertises them. Both
directions are handled in a single read and a single write helper
that pick the largest supported transfer per chunk and fall back as
needed.

I2C-block is preferred unconditionally when available: the protocol
carries any length 1..32, so it can serve every chunk -- including
the 1- and 2-byte tails -- without help from word or byte access.
Note that this requires I2C_FUNC_SMBUS_I2C_BLOCK, which reads a
caller-specified number of bytes. This deviates from the official
SMBus Block Read (length is supplied by the slave) but is widely
supported by Linux I2C controllers/drivers.

Capability matrix this implementation supports:

  - BYTE only:                  works (unchanged behaviour); 1-byte
                                xfers, hwmon disabled.
  - BYTE + WORD:                word for >=2-byte chunks, byte for
                                trailing odd byte.
  - I2C_BLOCK present (with or
    without BYTE/WORD):         block as the universal transport for
                                every chunk.
  - WORD only (no BYTE/BLOCK):  accepted with WARN_ONCE. Even-length
                                transfers work; odd-length transfers
                                (e.g. the 3-byte cotsworks fixup
                                write) hit the BYTE branch which the
                                adapter does not implement, so the
                                xfer returns an error and the
                                operation is aborted. No mainline
                                I2C driver was found to advertise
                                WORD without BYTE; the warning lets
                                us learn about it if it ever shows
                                up.

Adapters with asymmetric R/W capabilities (e.g. only READ_I2C_BLOCK
but not WRITE_I2C_BLOCK) remain functionally correct -- the
per-iteration fallback uses the direction-specific bits -- but the
shared i2c_max_block_size is sized by the all-bits-set check, so a
transfer in the better-supported direction is not upgraded. None of
the mainline I2C bus drivers surveyed during review advertise such
asymmetry; promoting i2c_max_block_size to per-direction sizes can
be revisited if needed.

Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260614133418.2068201-3-jelonek.jonas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: sfp: extend SMBus support`
(58b29bdf6186a)

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[net: sfp]` `[extend]` — Extend existing SMBus SFP access
beyond single-byte transfers.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Fixes: | None |
| Reported-by: | None |
| Tested-by: | None |
| Reviewed-by: | Maxime Chevallier \<maxime.chevallier@bootlin.com\>
(original SMBus author) |
| Acked-by: | None |
| Link: | https://patch.msgid.link/20260614133418.2068201-3-
jelonek.jonas@gmail.com |
| Cc: stable | None (expected for manual review) |
| Signed-off-by: | Jonas Jelonek, Jakub Kicinski |

Notable: Reviewed by the author of commit 7662abf4db94 that introduced
SMBus support. No syzbot or user bug reports.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Commit 7662abf4db94 limited SMBus to single-byte transfers.
  Adapters advertising word or I2C-block SMBus (e.g. Realtek
  longan/mango SoCs) cannot drive SFP cages; they fail
  `sfp_i2c_configure()` or are stuck on byte-only path with hwmon
  disabled.
- **Symptom:** SFP probe/configure failure (`-EINVAL`) on I2C-block-only
  adapters; degraded operation (no hwmon, warning spam) on byte-capable
  but word/block-capable adapters.
- **Root cause:** `sfp_i2c_configure()` only accepts
  `I2C_FUNC_SMBUS_BYTE_DATA`; read/write helpers only use
  `I2C_SMBUS_BYTE_DATA`.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite “extend” wording, this completes
broken/incomplete SMBus support introduced by 7662abf4db94. Adapters
with `I2C_FUNC_SMBUS_I2C_BLOCK` but no `BYTE_DATA` currently get
`-EINVAL` and the SFP driver fails probe entirely.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/phy/sfp.c` (+111 / -28 on mainline; +120 / -29
  with quirks prerequisite)
- **Functions:** `sfp_smbus_byte_read` → `sfp_smbus_read`,
  `sfp_smbus_byte_write` → `sfp_smbus_write`, `sfp_i2c_configure`
- **Scope:** Single-file, moderate surgical change

### Step 2.2: Code Flow Changes
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| Read helper | Byte-only loop | Per-chunk: I2C-block → word (≥2 bytes)
→ byte fallback |
| Write helper | Byte-only loop | Per-chunk: I2C-block → word (≥2 bytes)
→ byte fallback |
| `sfp_i2c_configure` | Requires `BYTE_DATA` only; `max_block_size = 1`
| Accepts `BYTE_DATA` OR `I2C_BLOCK`; sets block size 16/2/1; word-only
path with `WARN_ONCE` |

### Step 2.3: Bug Mechanism
**Record:** **Logic / hardware correctness fix (category g/h).**
Incomplete protocol selection left certain SMBus-only adapters unusable
and forced `i2c_max_block_size = 1`, which disables hwmon
(`sfp_hwmon_probe()` requires `i2c_block_size >= 2`).

### Step 2.4: Fix Quality
**Record:** Well-structured capability matrix in commit message; BYTE-
only path preserved unchanged. Low regression risk for existing byte-
only setups. `i2c_get_functionality()` called once per read/write call
(minor inefficiency, not a stability concern). Reviewed by subsystem
expert.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy byte-only SMBus code introduced in **7662abf4db94**
(2025-03-25, Maxime Chevallier). Present in this 6.18.44 tree. Related
fix **bef389a210e7d** (i2c_block_size init, infinite-loop fix) already
backported to stable by Greg K-H.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Referenced commit 7662abf4db94 is an
ancestor of HEAD.

### Step 3.3: Related Commits
**Record:** Part of v11 series (2 patches):
1. **f2a138abfb719** — `net: sfp: apply I2C adapter quirks to limit
   block size` (prerequisite on mainline)
2. **58b29bdf6186a** — this commit

`bef389a210e7d` (i2c_block_size init) already in 6.18.44. Neither quirks
nor extend SMBus are in 6.18.44 yet.

### Step 3.4: Author Context
**Record:** Jonas Jelonek authored `bef389a210e7d` (already in stable
6.18.y). Same SFP SMBus series.

### Step 3.5: Dependencies
**Record:** On mainline, extend SMBus builds atop quirks patch
(refactors `sfp_i2c_configure` to use local `max_block_size`).
**f2a138abfb719 applies cleanly to 6.18.44**; **both patches apply
cleanly in sequence**. Extend SMBus alone conflicts (verified via
cherry-pick).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 58b29bdf6186a` → https://patch.msgid.link/2026061
4133418.2068201-3-jelonek.jonas@gmail.com (v11 2/2). Series evolved
v5→v11 since 2026-01-16.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd Russell King, Andrew Lunn, netdev
maintainers, Maxime Chevallier.

### Step 4.3: Bug Reports
**Record:** No external bug report links. Hardware impact described for
Realtek longan/mango SoCs in commit message only.

### Step 4.4: Series Context
**Record:** Standalone functional value, but clean backport to 6.18.44
needs **f2a138abfb719** first.

### Step 4.5: Stable List
**Record:** Could not fetch lore thread (bot protection). Related
**bef389a210e7d** had `Cc: stable@vger.kernel.org` and was backported;
this commit does not carry that tag.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `sfp_smbus_read`, `sfp_smbus_write`, `sfp_i2c_configure`

### Step 5.2: Callers
**Record:** `sfp_i2c_configure()` ← `sfp_i2c_get()` ← `sfp_probe()`.
SMBus read/write used via `sfp->read`/`sfp->write` function pointers
through `sfp_read()`/`sfp_write()` for EEPROM access, module detection,
hwmon, ethtool `-m`, quirks/fixups.

### Step 5.3: Callees
**Record:** `i2c_get_functionality()`, `i2c_smbus_xfer()`,
`i2c_check_functionality()`, unaligned accessors.

### Step 5.4: Reachability
**Record:** Triggered at platform device probe when SFP cage uses SMBus-
only I2C adapter. Affects all SFP operations on that hardware — module
insert, link bring-up, diagnostics.

### Step 5.5: Similar Patterns
**Record:** Original SMBus byte support (7662abf4db94) is the incomplete
pattern this fixes.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current tree has byte-only
`sfp_smbus_byte_read`/`write` and `sfp_i2c_configure()` requiring
`I2C_FUNC_SMBUS_BYTE_DATA` only (lines 757–824). SMBus support commit
7662abf4db94 is an ancestor.

### Step 6.2: Backport Complications
**Record:** Extend SMBus alone → merge conflict in `sfp_i2c_configure`.
**f2a138abfb719 + 58b29bdf6186a apply cleanly in sequence** (verified).
Minor adaptation possible without quirks, but quirks patch is small and
should accompany this.

### Step 6.3: Related Fixes Already Present?
**Record:** `bef389a210e7d` (i2c_block_size init / ethtool spin fix)
present. Quirks and extend SMBus **not** present.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/phy/sfp.c` — network SFP cage driver.
**IMPORTANT** for networking/embedded platforms with SFP ports.

### Step 7.2: Activity
**Record:** Active — multiple SFP quirk/fix commits in recent history on
this tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** Platform-specific — systems with SFP cages on SMBus-only I2C
controllers that advertise word or I2C-block (documented: Realtek
longan/mango). Not universal, but total failure for affected hardware.

### Step 8.2: Trigger Conditions
**Record:** SFP platform probe with non-I2C SMBus adapter lacking
`I2C_FUNC_I2C` and/or `I2C_FUNC_SMBUS_BYTE_DATA`. Deterministic at boot
— not a race.

### Step 8.3: Failure Mode Severity
**Record:**
- I2C-block-only, no byte: **probe failure** (`-EINVAL`) → SFP cage
  completely non-functional — **HIGH**
- Byte-only capable: works but hwmon disabled, warning printed,
  potentially unreliable — **MEDIUM**

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected embedded/networking platforms; MEDIUM
  overall (niche hardware)
- **Risk:** LOW — byte-only behavior unchanged; new paths gated on
  adapter capabilities; reviewed; applies cleanly with quirks
  prerequisite
- **Ratio:** Favorable for 6.18.y where incomplete SMBus support
  (7662abf4db94) is already present

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR:**
- Fixes complete SFP failure on SMBus I2C-block adapters (probe
  `-EINVAL`)
- Completes incomplete SMBus support already in 6.18.44 (7662abf4db94)
- Restores hwmon on word/block-capable SMBus adapters
- Reviewed by original SMBus author
- Same author's related fix (bef389a) already in stable 6.18.y
- Applies cleanly with small quirks prerequisite
- BYTE-only path unchanged — low regression risk
- Fits hardware workaround / enablement stable exception

**AGAINST:**
- Not a crash, corruption, deadlock, or security issue
- Platform-specific (Realtek SoCs cited)
- Arguably “feature completion” rather than regression fix
- Requires 2-patch series for clean backport
- No syzbot/fuzzer or explicit user bug report

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — reviewed, clear
capability matrix, preserves byte-only behavior |
| 2. Fixes real bug affecting users? | **PASS** — SFP probe failure /
non-functional hardware on specific platforms |
| 3. Important issue? | **PASS** — complete hardware failure on affected
platforms (HIGH for them) |
| 4. Small and contained? | **PASS** — ~120 lines, one file (with quirks
prerequisite) |
| 5. No new features/APIs? | **PASS** — extends existing SMBus path; no
userspace API changes |
| 6. Can apply to local tree? | **PASS** — applies cleanly with
f2a138abfb719 first |

### Step 9.3: Exception Category
**Record:** Hardware workaround / enablement — enables SFP on SMBus
controllers that the current byte-only implementation cannot use.

### Step 9.4: Decision Rationale
6.18.44 already carries incomplete SMBus SFP support from 7662abf4db94.
On adapters advertising I2C-block SMBus without byte access,
`sfp_i2c_configure()` returns `-EINVAL` and the SFP cage fails probe
entirely. This commit fixes that real hardware failure with a contained,
reviewed change. Backport **f2a138abfb719** (I2C quirks) alongside it
for a clean apply.

---

## Verification

- [Phase 1] `git show 58b29bdf6186a --format=fuller`: parsed subject,
  tags, body
- [Phase 2] `git show 58b29bdf6186a`: full diff analyzed; 111 lines
  changed on mainline
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9 /
  kernelversion 6.18.44
- [Phase 3] `git merge-base --is-ancestor 7662abf4db94 HEAD`: SMBus
  commit confirmed in tree
- [Phase 3] `git blame -L 806,825 drivers/net/phy/sfp.c`: byte-only code
  from 7662abf4db94
- [Phase 3] `git log HEAD --grep="extend SMBus"`: not in 6.18.44
- [Phase 3] `git log HEAD --grep="apply I2C adapter quirks"`: quirks not
  in 6.18.44
- [Phase 3] `git show bef389a210e7d`: related stable backport already
  present
- [Phase 4] `b4 dig -c 58b29bdf6186a`: lore URL found
- [Phase 4] `b4 dig -c 58b29bdf6186a -a`: v5–v11 series revisions listed
- [Phase 4] `b4 dig -c 58b29bdf6186a -w`: maintainers CC list retrieved
- [Phase 4] WebFetch lore URL: **FAILED** (bot protection)
- [Phase 5] `grep sfp_i2c_configure/sfp_read` in sfp.c: probe and EEPROM
  paths traced
- [Phase 5] Read `sfp_hwmon_probe()` lines 1711–1723: hwmon requires
  `i2c_block_size >= 2`
- [Phase 5] Read probe warning lines 3239–3246: SMBus byte-only warning
  path
- [Phase 6] Read current `sfp_smbus_byte_read/write` and
  `sfp_i2c_configure`: buggy code confirmed present
- [Phase 6] `git cherry-pick --no-commit 58b29bdf6186a`: **CONFLICT**
- [Phase 6] `git cherry-pick --no-commit f2a138abfb719`: **clean apply**
- [Phase 6] Both patches in sequence: **clean apply**, +120/-29 lines
- [Phase 6] `grep i2c->quirks` in sfp.c: no quirks handling in current
  tree
- [Phase 8] `sfp_i2c_get()` error path: configure failure prevents SFP
  probe

**Recommendation:** Backport **f2a138abfb719** first, then
**58b29bdf6186a**.

**YES**

 drivers/net/phy/sfp.c | 139 +++++++++++++++++++++++++++++++++---------
 1 file changed, 111 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 68aa8e6dd55c2..d13e100e64ec0 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <linux/unaligned.h>
 #include <linux/workqueue.h>
 
 #include "sfp.h"
@@ -774,50 +775,113 @@ static int sfp_i2c_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
 	return ret == ARRAY_SIZE(msgs) ? len : 0;
 }
 
-static int sfp_smbus_byte_read(struct sfp *sfp, bool a2, u8 dev_addr,
-			       void *buf, size_t len)
+static int sfp_smbus_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
+			  size_t len)
 {
-	union i2c_smbus_data smbus_data;
+	union i2c_smbus_data smbus_data = {0};
 	u8 bus_addr = a2 ? 0x51 : 0x50;
+	size_t this_len, transferred;
+	u32 functionality;
 	u8 *data = buf;
 	int ret;
 
-	while (len) {
-		ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
-				     I2C_SMBUS_READ, dev_addr,
-				     I2C_SMBUS_BYTE_DATA, &smbus_data);
-		if (ret < 0)
-			return ret;
+	functionality = i2c_get_functionality(sfp->i2c);
 
-		*data = smbus_data.byte;
+	while (len) {
+		this_len = min(len, sfp->i2c_block_size);
+
+		if (functionality & I2C_FUNC_SMBUS_READ_I2C_BLOCK) {
+			smbus_data.block[0] = this_len;
+			ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
+					     I2C_SMBUS_READ, dev_addr,
+					     I2C_SMBUS_I2C_BLOCK_DATA, &smbus_data);
+			if (ret < 0)
+				return ret;
+
+			transferred = min_t(size_t, smbus_data.block[0], this_len);
+			if (!transferred)
+				return -EIO;
+
+			memcpy(data, &smbus_data.block[1], transferred);
+		} else if (this_len >= 2 &&
+			   (functionality & I2C_FUNC_SMBUS_READ_WORD_DATA)) {
+			ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
+					     I2C_SMBUS_READ, dev_addr,
+					     I2C_SMBUS_WORD_DATA, &smbus_data);
+			if (ret < 0)
+				return ret;
+
+			put_unaligned_le16(smbus_data.word, data);
+			transferred = 2;
+		} else {
+			ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
+					     I2C_SMBUS_READ, dev_addr,
+					     I2C_SMBUS_BYTE_DATA, &smbus_data);
+			if (ret < 0)
+				return ret;
+
+			*data = smbus_data.byte;
+			transferred = 1;
+		}
 
-		len--;
-		data++;
-		dev_addr++;
+		data += transferred;
+		len -= transferred;
+		dev_addr += transferred;
 	}
 
 	return data - (u8 *)buf;
 }
 
-static int sfp_smbus_byte_write(struct sfp *sfp, bool a2, u8 dev_addr,
-				void *buf, size_t len)
+static int sfp_smbus_write(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
+			   size_t len)
 {
 	union i2c_smbus_data smbus_data;
 	u8 bus_addr = a2 ? 0x51 : 0x50;
+	size_t this_len, transferred;
+	u32 functionality;
 	u8 *data = buf;
 	int ret;
 
+	functionality = i2c_get_functionality(sfp->i2c);
+
 	while (len) {
-		smbus_data.byte = *data;
-		ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
-				     I2C_SMBUS_WRITE, dev_addr,
-				     I2C_SMBUS_BYTE_DATA, &smbus_data);
-		if (ret)
-			return ret;
+		this_len = min(len, sfp->i2c_block_size);
+
+		if (functionality & I2C_FUNC_SMBUS_WRITE_I2C_BLOCK) {
+			smbus_data.block[0] = this_len;
+			memcpy(&smbus_data.block[1], data, this_len);
+
+			ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
+					     I2C_SMBUS_WRITE, dev_addr,
+					     I2C_SMBUS_I2C_BLOCK_DATA, &smbus_data);
+			if (ret < 0)
+				return ret;
+
+			transferred = this_len;
+		} else if (this_len >= 2 &&
+			   (functionality & I2C_FUNC_SMBUS_WRITE_WORD_DATA)) {
+			smbus_data.word = get_unaligned_le16(data);
+			ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
+					     I2C_SMBUS_WRITE, dev_addr,
+					     I2C_SMBUS_WORD_DATA, &smbus_data);
+			if (ret < 0)
+				return ret;
+
+			transferred = 2;
+		} else {
+			smbus_data.byte = *data;
+			ret = i2c_smbus_xfer(sfp->i2c, bus_addr, 0,
+					     I2C_SMBUS_WRITE, dev_addr,
+					     I2C_SMBUS_BYTE_DATA, &smbus_data);
+			if (ret < 0)
+				return ret;
+
+			transferred = 1;
+		}
 
-		len--;
-		data++;
-		dev_addr++;
+		data += transferred;
+		len -= transferred;
+		dev_addr += transferred;
 	}
 
 	return data - (u8 *)buf;
@@ -833,10 +897,29 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 		sfp->read = sfp_i2c_read;
 		sfp->write = sfp_i2c_write;
 		max_block_size = SFP_EEPROM_BLOCK_SIZE;
-	} else if (i2c_check_functionality(i2c, I2C_FUNC_SMBUS_BYTE_DATA)) {
-		sfp->read = sfp_smbus_byte_read;
-		sfp->write = sfp_smbus_byte_write;
-		max_block_size = 1;
+	} else if (i2c_check_functionality(i2c, I2C_FUNC_SMBUS_BYTE_DATA) ||
+		   i2c_check_functionality(i2c, I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		/* Either protocol alone covers any length: I2C-block carries
+		 * 1..32 bytes per xfer, byte iterates one byte at a time.
+		 */
+		sfp->read = sfp_smbus_read;
+		sfp->write = sfp_smbus_write;
+
+		if (i2c_check_functionality(i2c, I2C_FUNC_SMBUS_I2C_BLOCK))
+			max_block_size = SFP_EEPROM_BLOCK_SIZE;
+		else if (i2c_check_functionality(i2c, I2C_FUNC_SMBUS_WORD_DATA))
+			max_block_size = 2;
+		else
+			max_block_size = 1;
+	} else if (WARN_ONCE(i2c_check_functionality(i2c, I2C_FUNC_SMBUS_WORD_DATA),
+			     "SMBus word-only adapter; odd-length transfers will fail\n")) {
+		/* Word-only: even-length xfers work; odd-length xfers fall
+		 * to BYTE, which the adapter does not advertise and will
+		 * likely fail.
+		 */
+		sfp->read = sfp_smbus_read;
+		sfp->write = sfp_smbus_write;
+		max_block_size = 2;
 	} else {
 		sfp->i2c = NULL;
 		return -EINVAL;
-- 
2.53.0

