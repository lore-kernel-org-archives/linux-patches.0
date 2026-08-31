Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D71A47253A;
	Mon, 31 Aug 2026 13:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183319; cv=none; b=XK1qMVX7OAlKeJINPs6w5pqMTgewjmR8ozuCHO6sy6Ueo91xMx5BAxC8vNZ5fOy0u+dUat5fTz+NBhmp6HuaF9sUtEswdNUMXcy4LqNg95E4uVrn/5nF1Y8LiE1S/hV5EfkulbXhfYimhvhHnaui+4h8RoKDuD0uPXbBvW8pwQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183319; c=relaxed/simple;
	bh=Sv4s2m5IQ3UmBW0dexl0UO3KbKPH0DmEt3HrFT6Abnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ic2JZMsA0NNfPHLdNgNObGZQd6ciSo5gvL8vlY5AyaIVIMOaNQlS9qMrjsEjOF1vZyvTyLcV5yWT5myjCIpUKeJIny/dw30EckuI89eTy4s6PmATvdXobouxO+cNhKiG2bYkZ8mjce8ijRyaT/3vApvKVKKIzejyfqTcs+QD/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijIKlTNY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijIKlTNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37551F00A3D;
	Mon, 31 Aug 2026 13:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183317;
	bh=LIvU5vRo9fbm1kgLmtunAKbZmuCfn61AqCgbJ+/8XX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijIKlTNYTprTvyTaEMmCei3c/572LELkNTFVs4fm4NidNU+w/niacTUmiV/MvOugv
	 giy8cCRDWzYtKgYW7NJFbnPi1PS5zU/00Oq1B74u7Pu+F8l3znyohDZtvO7D7mrSdo
	 hu9CtAQUCeiaJ/M8jDdgXkbxx/Zl5tkCC+cJsdIMYnuXVIX+G2h59oSBr3mT0zJwj3
	 a4M8mUXfy/fE8LeYZ5yHiTKszULf3Ybrp0AZYjYa42POgeeh6Qt3W+1AwWwV4KPgwi
	 snpGu4rdhg25xKOgkgtZa8mZvWrwIyjO29UGlbmztVryJmV9ZpBsOWmf+3AR6NhKUj
	 rtTDI4MAeRLtA==
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
Subject: [PATCH AUTOSEL 6.18] net: sfp: apply I2C adapter quirks to limit block size
Date: Mon, 31 Aug 2026 09:21:44 -0400
Message-ID: <20260831133314.4125787-76-sashal@kernel.org>
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

[ Upstream commit f2a138abfb719a3bfd370ca79f00055ec81e4f59 ]

The SFP driver assumes all I2C adapters support reading and writing the
pre-defined block size SFP_EEPROM_BLOCK_SIZE of 16 bytes. This constant
was probably chosen based on good guesses and known limitations of a
range of I2C adapters and SFP modules.

However, I2C adapters may even support less and usually need to specify
this via I2C quirks. Theoretically, such an adapter may provide full
functionality but only support a read and write length of e.g. 8 bytes.
Currently, the SFP driver doesn't account for that.

Add handling for I2C quirks in SFP I2C configuration taking the fields
max_read_len and max_write_len in struct i2c_adapter_quirks into account
to further limit the maximum block size if needed.

Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260614133418.2068201-2-jelonek.jonas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: sfp: apply I2C adapter quirks to limit
block size`

**Local tree:** `v6.18.44` (`6.18.44`, commit `2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[net: sfp]` `[apply]` — Apply I2C adapter `max_read_len` /
`max_write_len` quirks when configuring SFP EEPROM block size.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Jonas Jelonek, Jakub Kicinski (ignore pipeline SOB)
- **Reviewed-by:** Maxime Chevallier (Bootlin; authored SFP SMBus
  support in this tree)
- **Link:** https://patch.msgid.link/20260614133418.2068201-2-
  jelonek.jonas@gmail.com (patch 2 of a series)
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable, syzbot, or CVE
  tags

### Step 1.3: Body Analysis
**Record:**
- **Bug:** SFP driver hardcodes `SFP_EEPROM_BLOCK_SIZE` (16) without
  checking `i2c_adapter_quirks`.
- **Symptom:** On adapters declaring `max_read_len` or `max_write_len`
  below 16, `i2c_transfer()` is rejected by I2C core quirk checks →
  EEPROM read fails → SFP module probe fails (`failed to read EEPROM`).
- **Root cause:** `sfp_i2c_configure()` ignores
  `i2c->quirks->max_read_len` / `max_write_len`.
- **Version info:** None in message; patch is dated June 2026, not yet
  in this checkout.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite “apply” wording, this is a hardware-
compatibility bug fix: the driver issues I2C transfers larger than the
adapter allows.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/phy/sfp.c` (+8 / −2 lines)
- **Function:** `sfp_i2c_configure()` only
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `i2c_max_block_size` set directly to 16 (I2C) or 1
  (SMBus).
- **After:** Compute `max_block_size`, then clamp with `min()` against
  `i2c->quirks->max_read_len` and `max_write_len` if non-zero; assign to
  `sfp->i2c_max_block_size` and `sfp->i2c_block_size`.
- **Path:** Adapter configuration at probe (`sfp_i2c_get()` →
  `sfp_i2c_configure()`), before any EEPROM access.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / hardware-compatibility fix.
- **Mechanism:** `sfp_i2c_read()` chunks reads using
  `sfp->i2c_block_size`. With block size 16 on an adapter with
  `max_read_len=12`, `i2c_check_quirks()` in `i2c-core-base.c` returns
  `-EINVAL` (“msg too long”) before the transfer runs. Reducing block
  size to 12 makes chunked reads succeed.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High — same pattern as
  `drivers/usb/typec/ucsi/ucsi_ccg.c` (lines 258–260).
- **Risk:** Very low — only reduces transfer size; no API or locking
  changes.
- **Note:** `sfp_i2c_write()` does not chunk by block size, but SFP
  writes are small (1–3 bytes); reads are the critical probe path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `sfp_i2c_configure()` introduced in `7662abf4db94`
(2025-03-25, “Add support for SMBus module access” by Maxime
Chevallier), which set `i2c_max_block_size = SFP_EEPROM_BLOCK_SIZE`.
Related init fix `bef389a210e7d` (Jonas Jelonek, 2026-06-19) is already
in this tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Changes
**Record:**
- `bef389a210e7d` — initializes `i2c_block_size` in same function
  (already in tree; Greg Kroah-Hartman signed stable copy).
- `813c2dd78618f` — earlier `i2c_block_size` init at allocation.
- Patch Link suffix `-2-` indicates series with `bef389a` as patch 1.

### Step 3.4: Author Context
**Record:** Jonas Jelonek authored `bef389a` (real soft-lockup fix, Cc:
stable). Maxime Chevallier is the SFP SMBus author and reviewed this
patch.

### Step 3.5: Dependencies
**Record:** Standalone. Requires `struct i2c_adapter_quirks` (present
since long before SFP SMBus support) and `sfp_i2c_configure()` with
`bef389a` (present in this tree). No other commits needed.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Lore/patch.msgid.link blocked by bot protection (Anubis).
`b4 dig -c` did not match this commit (not merged). Could not read
thread.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 dig -w. Reviewed-by: Maxime Chevallier
confirmed in commit message.

### Step 4.3: Bug Reports
**Record:** None. No Reported-by, syzbot, or Bugzilla links.

### Step 4.4: Series Context
**Record:** Patch 2 of Jonas Jelonek series; patch 1 (`bef389a`) already
in this tree and nominated for stable.

### Step 4.5: Stable List
**Record:** UNVERIFIED — lore blocked. Patch 1 had explicit `Cc:
stable@vger.kernel.org`; this patch does not.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `sfp_i2c_configure()` (modified); `sfp_i2c_read()` (consumer
of `i2c_block_size`).

### Step 5.2: Callers
**Record:** `sfp_i2c_configure()` ← `sfp_i2c_get()` ← `sfp_probe()`.
Runs once at platform device probe.

### Step 5.3: Callees
**Record:** `i2c_check_functionality()`, reads `i2c->quirks`. Downstream
`sfp_i2c_read()` → `i2c_transfer()`.

### Step 5.4: Reachability
**Record:** Triggered on every SFP cage probe with `i2c-bus` DT
property. EEPROM reads happen on module insert (`sfp_sm_mod_probe()`
reads `sizeof(id.base)` ≈ 128 bytes in chunks) and via `ethtool -m`
(`sfp_module_eeprom()`).

### Step 5.5: Similar Patterns
**Record:** `ucsi_ccg.c`, `vgxy61.c`, `i2c-core-base.c` quirk
enforcement. SFP comment at lines 217–219 already notes I2C drivers may
not tolerate reads > 16 bytes.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current `sfp_i2c_configure()` at lines 806–824 sets
`i2c_max_block_size = SFP_EEPROM_BLOCK_SIZE` (16) without checking
quirks. Bug present since `7662abf4db94` (March 2025), which is in this
tree.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — patch modifies the same function
where `bef389a` already added `i2c_block_size` init. No structural
conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** `bef389a210e7d` (i2c_block_size init) is present. This
quirks-handling fix is **not** present (grep shows no `max_read_len`
usage in `sfp.c`).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/phy/sfp.c` — network / SFP cage driver.
**Criticality: IMPORTANT** (affects SFP networking on embedded/router
platforms).

### Step 7.2: Activity
**Record:** Active — multiple SFP quirk/fix commits in 2025–2026 in this
tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_SFP` and an I2C adapter that sets
`max_read_len` or `max_write_len` < 16. In this tree, only `i2c-qcom-
cci` (12/10) and `i2c-nvidia-gpu` (4) have `max_read_len` < 16; neither
is a typical SFP bus, but any future or platform-specific adapter with
such quirks would be affected.

### Step 8.2: Trigger Conditions
**Record:** SFP probe + module insertion + I2C adapter with quirks
limiting transfer length below 16. Not userspace-triggerable for
security; hardware/configuration dependent.

### Step 8.3: Failure Mode
**Record:** I2C transfer rejected → EEPROM read fails → SFP module not
recognized, port dead. **Severity: HIGH** for affected hardware (total
loss of SFP function); **MEDIUM** overall (narrow adapter set today).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores SFP on limited I2C adapters; aligns with kernel
  I2C quirk model.
- **Risk:** Very low — 8-line clamp using established `min()` pattern.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR:**
- Provably broken code path when adapter quirks limit transfer size
  (verified in `i2c-core-base.c`)
- Complete SFP failure on affected hardware
- Small, surgical, reviewed by SFP SMBus author
- Matches established kernel pattern (`ucsi_ccg.c`)
- Driver comment acknowledges I2C length limitations
- Companion to `bef389a` (already in stable pipeline for this tree)
- Zero regression risk on adapters without quirks or with limits ≥ 16

**AGAINST:**
- No user reports, syzbot, or crash/corruption
- Commit message uses “Theoretically”
- No in-tree adapter with `max_read_len` < 16 is commonly used for SFP
  today
- `sfp_i2c_write()` does not chunk (mitigated by small write sizes in
  practice)

**UNRESOLVED:**
- Mailing list discussion (lore blocked)
- Whether reviewers nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard pattern; Reviewed-
   by present; no Tested-by
2. Fixes a real bug? **PASS** — I2C core rejects oversize transfers on
   quirky adapters
3. Important issue? **PASS** — complete SFP port failure on affected
   hardware (HIGH per-platform)
4. Small and contained? **PASS** — 8 lines, one function
5. No new features/APIs? **PASS** — uses existing `i2c_adapter_quirks`
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround category — respects adapter-
declared I2C transfer limits.

### Step 9.4: Problem and Decision

**What it solves:** The SFP driver assumes all I2C adapters accept
16-byte EEPROM read chunks. Adapters that declare lower limits via
`i2c_adapter_quirks` cause `i2c_transfer()` to fail at the I2C core,
breaking module probe and rendering the SFP cage unusable.

**Why it matters for 6.18.y:** The buggy code (`7662abf4db94`) is in
this tree. The fix is tiny, follows kernel conventions, and was reviewed
by the SFP SMBus author. While no common SFP platform hits this today,
the failure is total for any platform that does, and the driver’s own
comments acknowledge I2C length constraints.

**Risk vs benefit:** Near-zero risk; meaningful benefit for affected
embedded/network hardware; completes the i2c_block_size work started by
`bef389a`.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Read current `sfp_i2c_configure()`, `sfp_i2c_read()`,
  `sfp_i2c_write()` in `drivers/net/phy/sfp.c`
- **[Phase 2]** Verified `i2c_check_quirks()` rejects oversize messages
  in `drivers/i2c/i2c-core-base.c:2216-2224`
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- **[Phase 3]** `git blame -L 806,825 drivers/net/phy/sfp.c` → function
  from `7662abf4db94`
- **[Phase 3]** `git show 7662abf4db94` → introduced hardcoded block
  size
- **[Phase 3]** `git show bef389a210e7d` → prerequisite already in tree;
  `merge-base --is-ancestor` confirmed
- **[Phase 3]** `git log --oneline -20 -- drivers/net/phy/sfp.c` →
  recent SFP activity
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked by Anubis bot
  protection
- **[Phase 4]** `b4 dig -c` → no match (commit not merged)
- **[Phase 5]** Traced `sfp_i2c_configure()` ← `sfp_i2c_get()` ←
  `sfp_probe()`; `sfp_i2c_read()` uses `i2c_block_size`
- **[Phase 5]** Read `ucsi_ccg.c:258-260` for precedent pattern
- **[Phase 6]** Grep `sfp.c` — no quirks handling present; buggy code at
  lines 813/817
- **[Phase 6]** Grep `struct i2c_adapter_quirks` in
  `include/linux/i2c.h` — present
- **[Phase 6]** Grep all `max_read_len` / `max_write_len` in
  `drivers/i2c/` — only qcom-cci (12) and nvidia-gpu (4) < 16
- **[Phase 6]** Verified `i2c-rtl9300.c` has `max_read_len = 16` (at
  boundary, works today)
- **[Phase 8]** Confirmed probe reads `sizeof(id.base)` via chunked
  `sfp_i2c_read()` at line 2328
- **UNVERIFIED:** Mailing list reviewer feedback and stable nominations
- **UNVERIFIED:** Real-world SFP platform using adapter with quirks < 16

**YES**The background `git log` search finished: there’s no match for
“I2C adapter quirks” in this tree, and “limit block size” only turned up
unrelated DRM commits — so this SFP patch isn’t merged here yet.

That matches the earlier review of `6.18.44`: the buggy code is present
in `sfp_i2c_configure()`, and the fix should apply cleanly after
`bef389a210e7d`.

**YES** — still the right call for stable backport on this tree.

 drivers/net/phy/sfp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 1c4340b3777f6..68aa8e6dd55c2 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -825,21 +825,29 @@ static int sfp_smbus_byte_write(struct sfp *sfp, bool a2, u8 dev_addr,
 
 static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
 {
+	size_t max_block_size;
+
 	sfp->i2c = i2c;
 
 	if (i2c_check_functionality(i2c, I2C_FUNC_I2C)) {
 		sfp->read = sfp_i2c_read;
 		sfp->write = sfp_i2c_write;
-		sfp->i2c_max_block_size = SFP_EEPROM_BLOCK_SIZE;
+		max_block_size = SFP_EEPROM_BLOCK_SIZE;
 	} else if (i2c_check_functionality(i2c, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		sfp->read = sfp_smbus_byte_read;
 		sfp->write = sfp_smbus_byte_write;
-		sfp->i2c_max_block_size = 1;
+		max_block_size = 1;
 	} else {
 		sfp->i2c = NULL;
 		return -EINVAL;
 	}
 
+	if (i2c->quirks && i2c->quirks->max_read_len)
+		max_block_size = min(max_block_size, i2c->quirks->max_read_len);
+	if (i2c->quirks && i2c->quirks->max_write_len)
+		max_block_size = min(max_block_size, i2c->quirks->max_write_len);
+
+	sfp->i2c_max_block_size = max_block_size;
 	sfp->i2c_block_size = sfp->i2c_max_block_size;
 	return 0;
 }
-- 
2.53.0

