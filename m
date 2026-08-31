Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A17351C332;
	Mon, 31 Aug 2026 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183824; cv=none; b=YRE/TD4xc7AIpr13fwYYTAAOscLuDcj1F6GxcJYff47IN8/eIfss67JvN4v2G0bA4hZ+Lfk0TDIsi5/xLm5rZvN651xLtl+0IfVZKUv31XWzTh//zAfXO7Kg2ovu2CZPe9fztX9JLjlauG3nmM8XxSQWOm/xaz5NrgeeIHVQo9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183824; c=relaxed/simple;
	bh=aaEB/ngM1EH8gBogQG13NFmZoEJbsi6KVCEb8t276DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPpXzz6zjDVs8e7fDJCaX6tBca47k8x/NHTRX4aHGZ414aoBpUKk/BSau/mB6mdIl0xrZA90IQgtGXUWIFHXqC2un3mnCArEEkgOXmagNIQ1392/Jz5SthRS4vMppykQ5LBFx9hA8YvKiKoBFkREw4iKL43Q/76wnHrCq+dzm7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zx1r5P6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zx1r5P6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1311F00A3D;
	Mon, 31 Aug 2026 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183822;
	bh=J7qa3P0tM7aM6Wz+KWaE0ziDUJ4FAegbpIf/DfL6C04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zx1r5P6LciBSlxYbSZzaL2BvB+6w+CYF5xR//kLOYABgfD2LsG0FWuiAB0NOmS5QM
	 Z+WYDKkxp4rd+D0DE/jsJdUT260qBWmjkkZKMEJbC99r7nuo/jb7KSGIkoAvMPJY7R
	 b2JhsgSMwp0VmQdR+Y/dybAyz/CIdz+bQT2mGu8HePeQfGV+TrUdd+zpxupHPhvoxn
	 3GLnT8CHGrAovDnf918dR48gRixxPyYHzICdiP8Pwcv0gA92ZTobzk26WMaqGBShTj
	 Gq8zv/V2jWopcI54pkP1FEt2Qr0GEE/WNOilZ7cN/LaMBp4Gf1oGCtnv3SGaRcCPGv
	 JRv+SrDWyIxOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Agalakov Daniil <ade@amicon.ru>,
	Iskhakov Daniil <dish@amicon.ru>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] e1000e: limit endianness conversion to boundary words
Date: Mon, 31 Aug 2026 09:25:53 -0400
Message-ID: <20260831133314.4125787-325-sashal@kernel.org>
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

From: Agalakov Daniil <ade@amicon.ru>

[ Upstream commit a5ecafcfb27baf2dba766c4fd99dbb947f4e85d8 ]

[Why]
In e1000_set_eeprom(), the eeprom_buff is allocated to hold a range of
words. However, only the boundary words (the first and the last) are
populated from the EEPROM if the write request is not word-aligned.
The words in the middle of the buffer remain uninitialized because they
are intended to be completely overwritten by the new data via memcpy().

The previous implementation had a loop that performed le16_to_cpus()
on the entire buffer. This resulted in endianness conversion being
performed on uninitialized memory for all interior words.

Fix this by converting the endianness only for the boundary words
immediately after they are successfully read from the EEPROM.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Co-developed-by: Iskhakov Daniil <dish@amicon.ru>
Signed-off-by: Iskhakov Daniil <dish@amicon.ru>
Signed-off-by: Agalakov Daniil <ade@amicon.ru>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260609213559.178657-14-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[e1000e] [limit] — limit endianness conversion to boundary
words in EEPROM write path`

**Step 1.2 — Tags**

Record:
- **Fixes:** — none
- **Reported-by:** — none (found by SVACE static analysis, not a
  user/syzbot report)
- **Tested-by:** Avigail Dahan `<avigailx.dahan@intel.com>`
- **Reviewed-by:** — not in commit message (present in pull-request
  thread)
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260609213559.178657-14-
  anthony.l.nguyen@intel.com
- **Cc: stable@vger.kernel.org:** — absent (expected for manual review;
  not a negative signal)
- **Signed-off-by:** Iskhakov Daniil, Agalakov Daniil, Tony Nguyen,
  Jakub Kicinski (ignore pipeline-added SOBs)
- **Co-developed-by:** Iskhakov Daniil
- Notable: static-analysis finding (SVACE / Linux Verification Center),
  Intel Tested-by

**Step 1.3 — Body analysis**

Record:
- **Bug:** In `e1000_set_eeprom()`, `eeprom_buff` is `kmalloc()`’d
  (uninitialized). For unaligned EEPROM writes, only boundary words are
  read from hardware; interior words stay uninitialized until `memcpy()`
  fills them. The old code ran `le16_to_cpus()` over the entire word
  range, touching uninitialized interior words.
- **Symptom:** Undefined behavior / uninitialized-memory use (SVACE
  finding). No crash, oops, or corruption described in the commit
  message.
- **Root cause:** Endianness conversion loop was broader than the set of
  words actually read from EEPROM.
- **Version info:** None in message; blame shows buggy loop dates to
  driver introduction (2007).

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Although phrased as limiting conversion scope, this
fixes uninitialized-memory use (KMSAN/SVACE class) and tightens per-read
error handling (`goto out` immediately after failed `e1000_read_nvm()`).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/net/ethernet/intel/e1000e/ethtool.c` (+12 / −7, 19
  lines touched)
- **Function:** `e1000_set_eeprom()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow per hunk**

Record:
- **Hunk 1 (first boundary word):** Before — read NVM, advance `ptr`,
  defer all endianness work. After — on read failure, `goto out`; on
  success, `le16_to_cpus()` only on `eeprom_buff[0]`, then advance
  `ptr`.
- **Hunk 2 (last boundary word):** Before — conditional second read
  gated on `!ret_val`; shared error check later. After — unconditional
  check for odd end alignment; read, fail-fast `goto out`, then
  `le16_to_cpus()` only on the last boundary index.
- **Removed:** Full-buffer `le16_to_cpus()` loop over `last_word -
  first_word + 1` words.
- **Unchanged:** `memcpy()` of user data, full-buffer `cpu_to_le16s()`
  loop, `e1000_write_nvm()`.

**Step 2.3 — Bug mechanism**

Record: **Category (e) — initialization / memory safety.** `kmalloc()`
leaves interior buffer words uninitialized; old loop called
`le16_to_cpus()` on them before `memcpy()` overwrote them. Secondary
improvement: **error-path correctness** — fail immediately after each
NVM read instead of batching error checks.

**Step 2.4 — Fix quality**

Record: **Obviously correct and minimal.** Interior words are fully
supplied by `memcpy()` and only need `cpu_to_le16s()` before write;
boundary words that were EEPROM-read need `le16_to_cpus()` right after
read. Regression risk is very low.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy full-buffer loop introduced in `bc7f75fa9788` (Auke Kok,
2007-09-17) — original e1000e driver. Present in this tree at lines
599–601.

**Step 3.2 — Fixes: tag**

Record: **N/A** — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**

Record: Related recent commits in this tree:
- `90fb7db49c6db` — `e1000e: fix heap overflow in e1000_set_eeprom` (Cc:
  stable, already in 6.18.44)
- `7e93136459ddf` — cast cleanup in same file
- Fix commit `a5ecafcfb27ba` is on `origin/master` but **not** in
  current HEAD (`v6.18.44`)

**Step 3.4 — Author context**

Record: Agalakov Daniil also authored `e1000: check return value of
e1000_read_eeprom` (`70b85c1773446`). Tony Nguyen (Intel wired LAN
maintainer) committed this via the Intel pull request. Patch was part of
a 15-patch Intel queue, but this hunk is self-contained.

**Step 3.5 — Dependencies**

Record: **Standalone.** No prerequisite commits required; `git apply
--check` on `a5ecafcfb27ba` against current tree succeeds cleanly.
Sibling fix exists for legacy `e1000` (`4cc8566ae0d16`) but is
independent.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c a5ecafcfb27ba` → https://patch.msgid.link/20260609213559.17
  8657-14-anthony.l.nguyen@intel.com
- Earlier revisions in series v1–v3 (March–April 2026) for `e1000`
  variant; committed version is from June 2026 Intel pull request (patch
  13/15).
- Applied to netdev/net-next by Jakub Kicinski.

**Step 4.2 — Reviewers (b4 dig -w)**

Record: CC’d netdev maintainers (davem, kuba, pabeni, edumazet,
andrew+netdev). Thread contains multiple `Reviewed-by:` tags from Intel
engineers (Loktionov, Kitszel, Ruinskiy) and netdev reviewers (Joe
Damato, Paul Menzel, Simon Horman, Dan Carpenter).

**Step 4.3 — Bug report**

Record: No syzbot/bugzilla link. Found by **Linux Verification Center /
SVACE** static analysis — same defect class as KMSAN uninitialized-
memory reports, but no runtime reproducer cited.

**Step 4.4 — Series context**

Record: One patch in a larger Intel driver update series; this change
does not depend on other patches in that series.

**Step 4.5 — Stable list history**

Record: No `Cc: stable` in patch or thread grep results. Contrast: the
related heap-overflow fix (`90fb7db`) explicitly requested stable.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `e1000_set_eeprom()` (modified); registered via
`ethtool_ops.set_eeprom` at line 2340.

**Step 5.2 — Callers**

Record:
- `net/ethtool/ioctl.c:ethtool_set_eeprom()` → `ops->set_eeprom()`
- Invoked from `ETHTOOL_SEEPROM` ioctl case (line 3364)
- Requires `CAP_NET_ADMIN` (default branch at line 3299)

**Step 5.3 — Callees**

Record: `kmalloc()`, `e1000_read_nvm()`, `le16_to_cpus()`, `memcpy()`,
`cpu_to_le16s()`, `e1000_write_nvm()`, `e1000e_update_nvm_checksum()`,
`kfree()`.

**Step 5.4 — Reachability**

Record: Reachable from userspace via `ethtool` EEPROM write ioctl, but
only by **privileged** (`CAP_NET_ADMIN`) users on interfaces using
`CONFIG_E1000E`. Uncommon path (manual EEPROM/NVM programming), but real
and intentional.

**Step 5.5 — Similar patterns**

Record: Same bug/fix pattern exists in legacy `e1000` driver
(`4cc8566ae0d16`). Prior e1000e fixes for uninitialized data exist
(`61114910a5f6a`, `24ad2a9209a0b`) showing maintainer attention to this
class of issue in the driver.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Current tree at
`drivers/net/ethernet/intel/e1000e/ethtool.c:599-601` still has the
full-buffer `le16_to_cpus()` loop. Bug present since 2007 in this
driver.

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** Verified with `git show a5ecafcfb27ba
| git apply --check` — success. Local tree already has `90fb7db` bounds
checking (`check_add_overflow`); patch context still matches.

**Step 6.3 — Related fixes already present?**

Record: Heap overflow fix `90fb7db49c6db` is already in 6.18.44. The
endianness/uninitialized-memory fix `a5ecafcfb27ba` is **not** present
(`git merge-base --is-ancestor` confirms).

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**

Record: **IMPORTANT** — `e1000e` Intel onboard Ethernet driver, widely
deployed on laptops/desktops/servers. Not core kernel, but common
hardware.

**Step 7.2 — Subsystem activity**

Record: Actively maintained — recent commits include PTP cleanup, DMA
leak fix, power-gating fix, EEPROM overflow fix (Aug–2025+).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of `CONFIG_E1000E` who perform ethtool EEPROM writes
(admin tooling, manufacturing, lab setups). Not universal, but real
hardware population.

**Step 8.2 — Trigger conditions**

Record: Unaligned EEPROM write spanning more than one word via
`ETHTOOL_SEEPROM`. Requires `CAP_NET_ADMIN`. Not everyday traffic, but
deliberately triggerable by root.

**Step 8.3 — Failure mode severity**

Record:
- **UB / uninitialized read:** le16_to_cpus on garbage interior words —
  **MEDIUM** as defect class (sanitizer/UB), but on the success path
  those words are fully overwritten by `memcpy()` before NVM write, so
  **no demonstrated EEPROM corruption**.
- **No crash, deadlock, or info leak to userspace** identified.
- Error-path behavior unchanged in outcome (still aborts on read
  failure).

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** Eliminates longstanding UB; aligns code with actual data
  flow; very low-risk correctness fix; Intel-tested.
- **Risk:** Very low — 12 lines of localized logic, no API changes.
- **Ratio:** Moderate benefit (correctness/sanitizer hygiene, not user-
  visible failure) vs very low risk.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real bug (uninitialized memory access) present since 2007
- Small, surgical, Intel-tested, multi-reviewer
- Applies cleanly to 6.18.44
- Same function as heap-overflow fix already in stable
- Uninitialized-memory defects are explicitly high-priority in stable
  guidance
- Improves fail-fast error handling after NVM reads

**AGAINST backport:**
- No runtime crash, corruption, or security exploit demonstrated
- Static analysis only (SVACE), not syzbot/KMSAN runtime report
- Privileged, rare ethtool EEPROM path
- Interior words are overwritten by `memcpy()` before NVM write —
  functional outcome appears correct even with the bug
- Author did not Cc: stable (unlike the related overflow fix)

**Unresolved:** No runtime reproducer or user report confirming
observable misbehavior on production kernels.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** (Intel Tested-by; logic
   verified)
2. Fixes a real bug? **PASS** (UB on uninitialized heap memory)
3. Important issue? **PASS (borderline)** — uninitialized-memory defect
   class, but no crash/corruption/security impact demonstrated
4. Small and contained? **PASS** (1 file, ~19 lines)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** (clean apply verified)

**Step 9.3 — Exception category**

Record: Not a device ID, quirk, DT, build, or docs fix. Standard bug-fix
category.

**Step 9.4 — Decision rationale for 6.18.44**

The buggy code is present in this tree, the fix is minimal and verified,
and it removes undefined behavior in a reachable (though privileged)
userspace-triggered path. While there is no demonstrated user-visible
failure on the success path—interior words are overwritten before the
NVM write—the defect is genuine, longstanding, and in the same critical
function as a prior stable-nominated overflow fix. The backport risk is
negligible and the correctness improvement is clear.

---

## Verification

- **[Phase 1]** Parsed commit `a5ecafcfb27ba` message and tags via `git
  show`
- **[Phase 2]** Analyzed diff via `git show a5ecafcfb27ba` and read
  current `ethtool.c:547-626`
- **[Phase 3]** `git blame -L 599,601` → `bc7f75fa9788` (2007)
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/ethernet/intel/e1000e/ethtool.c`
- **[Phase 3]** `git merge-base --is-ancestor a5ecafcfb27ba HEAD` → NOT
  in HEAD
- **[Phase 3]** `git apply --check` on patch → clean apply
- **[Phase 4]** `b4 dig -c a5ecafcfb27ba -a -w` → lore URL and reviewer
  CC list
- **[Phase 4]** `b4 dig -m /tmp/e1000e_endian.mbox`; grep for
  stable/Reviewed-by
- **[Phase 4]** WebFetch of lore URL blocked by bot protection (Anubis)
- **[Phase 5]** `grep e1000_set_eeprom` → ethtool ops registration at
  line 2340
- **[Phase 5]** Read `net/ethtool/ioctl.c:2037-2078, 3299-3364` for call
  chain and CAP_NET_ADMIN
- **[Phase 6]** `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; `make
  kernelversion` → `6.18.44`
- **[Phase 6]** Confirmed buggy loop at lines 599-601 in current tree
- **[Phase 7]** `git log --oneline -20 --
  drivers/net/ethernet/intel/e1000e/`
- **[Phase 8]** Traced data flow: interior words uninitialized → old
  `le16_to_cpus` → `memcpy` overwrite → `cpu_to_le16s` → NVM write

**YES**

 drivers/net/ethernet/intel/e1000e/ethtool.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 8e40bb50a01e1..77f3e7991e75c 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -585,20 +585,25 @@ static int e1000_set_eeprom(struct net_device *netdev,
 		/* need read/modify/write of first changed EEPROM word */
 		/* only the second byte of the word is being modified */
 		ret_val = e1000_read_nvm(hw, first_word, 1, &eeprom_buff[0]);
+		if (ret_val)
+			goto out;
+
+		/* Device's eeprom is always little-endian, word addressable */
+		le16_to_cpus(&eeprom_buff[0]);
+
 		ptr++;
 	}
-	if (((eeprom->offset + eeprom->len) & 1) && (!ret_val))
+	if ((eeprom->offset + eeprom->len) & 1) {
 		/* need read/modify/write of last changed EEPROM word */
 		/* only the first byte of the word is being modified */
 		ret_val = e1000_read_nvm(hw, last_word, 1,
 					 &eeprom_buff[last_word - first_word]);
+		if (ret_val)
+			goto out;
 
-	if (ret_val)
-		goto out;
-
-	/* Device's eeprom is always little-endian, word addressable */
-	for (i = 0; i < last_word - first_word + 1; i++)
-		le16_to_cpus(&eeprom_buff[i]);
+		/* Device's eeprom is always little-endian, word addressable */
+		le16_to_cpus(&eeprom_buff[last_word - first_word]);
+	}
 
 	memcpy(ptr, bytes, eeprom->len);
 
-- 
2.53.0

