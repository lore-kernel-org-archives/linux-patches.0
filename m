Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E4B63139D;
	Mon, 19 Oct 2026 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418733; cv=none; b=SdAEftSRR/zkhIp0E30Tu/70UnlvWd5AM/pzEbTtGcQ48If223UEL7Tz3YXFrFwpivILzXXt7nAitag0B6pVAGjhOrjue6vX5ud0nLtSb61W//U/OgO38Q9nyYPtq+FsBebYCc8GODkudEzEEVYTnfenaW8Z+CGoExPbGSuNMdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418733; c=relaxed/simple;
	bh=MOmZKezusvd3+rl8lQj3gb0nThfx7DNqvGBVftOEahM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgMnn45byX3MLGCIgSSsUnASFe2HMuSCrwvZvod1E1+Q5EZiEYF6o4hpaEEnsmzoNEtnKwOT+DabvRKScWeEcqaFeR3Km9JY1QzT2aZpGoQ4eRBYeBKntnt7Onq4u9rwR8LXXc7U5svWVG9nSwpgC7l7xjpb52DpsiNzYajnLo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AkufR0Z5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkufR0Z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD6D1F000C7;
	Mon, 19 Oct 2026 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418729;
	bh=5rmeK0G0kCVmt28KfnVlKueuTOC+BkuMm7WRfsXUmzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkufR0Z5b4oz2hz/dGdUIbuyKwd0fC6OswogWOg9hS8AUxx7cGQBbauFVxh7cePNP
	 R8ku+RrnI8xX6v63Q5JDR+cawPc6c4AjFiv3T/Pt2DZR6/O+E4QbeB/MsSYWZkyUBT
	 OIrIhVbLah/S8bF7R8imo+sPft+l1sIiahR3w+YbBGJEGd/PxJWKzZCjRrETTg1cAf
	 cjpdfl1YgLBapQ5FnG9NhPkdQSavDxdZKIMXqW5aMb8+5gdWV55a54+yPyooTUlwWE
	 9VMti4Se7ZhzaIoU18ypRogwfGK4xNJOVqnzCe4Q1Wr/plSwVtahjH1V27hk1LNgJy
	 vSeE3pvX6Qi+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] spi: cadence-qspi: Fix status polling with octal DTR chips
Date: Mon, 19 Oct 2026 09:52:26 -0400
Message-ID: <20261019135441.1420968-455-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit fd99864b0ac936e870c7ae28354c5cd3dad5efd0 ]

Most SPI NOR chips today use 0x05 as ReaD Status Register (RDSR)
opcode. After almost every transaction, the core will wait for the said
transation to be digested by the chip by polling its status
register. This mechanism has been automated by certain chips, such as
the Cadence QSPI controller. Unfortunately, the feature has been
disabled for various (relevant) reasons. Disabling this feature has been
done by setting WRITE_COMPLETION_CTRL_REG.DISABLE_POLLING_FLD, keeping
the rest of the register intact. In this same register, there is also a
field named WRITE_COMPLETION_CTRL_REG.OPCODE_FLD, which by default also
contains 0x05, as primary RDSR opcode.

As a result, both the SPI NOR and SPI NAND cores, primary users through
spi-mem of the spi_mem_ops interface, do send their own RDSR. In this
driver, such command goes through one of the fifth possible data path
specifically crafted for short register-like commands, named STIG. In
STIG mode, the opcode of the operation is written to
OSPI_FLASH_CMD_CTRL_REG. This means that the opcode field of STIG
configuration and the opcode field of the automatic polling
configuration contain the same value.

Unfortunately, the TRM explains in two different places that this
configuration is forbidden, without explaining why it is problematic:

$12.4.2.4.11 OSPI Software-Triggered Instruction Generator (STIG)
```
OSPI_FLASH_CMD_CTRL_REG[31-24] CMD_OPCODE_FLD bits should be set
different than OSPI_DEV_INSTR_RD_CONFIG_REG[7-0] RD_OPCODE_NON_XIP_FLD
and OSPI_DEV_INSTR_WR_CONFIG_REG[7-0] WR_OPCODE_FLD.
```

and

$12.4.2.5.2 Configuring the OSPI Controller for Optimal Use
```
When using the OSPI Controller, the opcodes in
OSPI_DEV_INSTR_RD_CONFIG_REG[7-0] RD_OPCODE_NON_XIP_FLD,
OSPI_DEV_INSTR_WR_CONFIG_REG[7-0] WR_OPCODE_FLD and
OSPI_WRITE_COMPLETION_CTRL_REG[7-0] OPCODE_FLD bit fields shall not
match the opcode in the OSPI_FLASH_CMD_CTRL_REG[31-24] CMD_OPCODE_FLD
bit field.
```

For some reasons, this is only unveiled now when testing in ODTR
mode. Plain SDR modes work flawlessly with the same chips. One possible
reason for this, is that the internal data path in ODTR mode is
very different due to the extra opcode extension/repetition which may be
interpreted differently (this is a wild guess). For sure there is an
interference, as even the TRM states that there is some magic happening:

$12.4.2.4.13 OSPI Command Translation
```
The WREN and the RDSR device instructions are the only ones that are
sent by the controller under the hood.
```

I cannot probe the bus when the problem arises, so I don't know exactly
what is sent on the bus. Practically speaking, the chip was driving the
lines low (reading all 0s), which is not the usual default state when
the chip is not driving the lines (all 1s). Other people on the mailing
list claimed successfully using ODTR chips with this controller. My take
here is that either they were using a variant of the IP without write
completion at all (there is a quirk for it), or they were using chips
slightly more flexible about their opcode sequency or maybe with
different addr/dummy requirements.

Clearing the WRITE_COMPLETION_CTRL_REG.OPCODE_FLD while disabling write
completion polling entirely seems the best compromise.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20261001-winbond-spi-next-cadence-rdsr-fix-v1-1-ec5ff594ba5d@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.18.57**. The candidate is a 3-line Cadence QSPI
programming fix: stop leaving the default RDSR opcode in
`WRITE_COMPLETION_CTRL` after auto-poll is disabled, which the TRM
forbids and which breaks octal DTR status polling.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[spi: cadence-qspi:] [Fix] [status polling fails with octal
DTR chips because WRITE_COMPLETION_CTRL.OPCODE_FLD still holds 0x05]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** https://patch.msgid.link/20261001-winbond-spi-next-cadence-
  rdsr-fix-v1-1-ec5ff594ba5d@bootlin.com
- **Cc: stable:** none (expected)
- **Signed-off-by:** Miquel Raynal (author; MTD/NAND maintainer); Mark
  Brown (SPI maintainer, applied the patch)
- Ignore: `[ Upstream commit fd99864b0ac936e870c7ae28354c5cd3dad5efd0 ]`
  and `Signed-off-by: Sasha Levin` (pipeline)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Auto-HW write-completion polling was disabled by OR-ing
  `DISABLE_POLLING_FLD` into `WRITE_COMPLETION_CTRL`, which **kept the
  reset-default OPCODE_FLD = 0x05 (RDSR)**. SPI NOR/NAND then issue
  their own RDSR via STIG (`OSPI_FLASH_CMD_CTRL_REG`), so STIG opcode
  and completion-opcode both become 0x05.
- **TRM:** Cadence OSPI TRM §12.4.2.4.11 and §12.4.2.5.2 forbid STIG
  `CMD_OPCODE_FLD` matching `WRITE_COMPLETION_CTRL.OPCODE_FLD` (and the
  read/write instruction opcodes).
- **Symptom:** In **octal DTR**, the flash drives the bus low (reads as
  all 0s). SDR with the same chips works. Status 0 means WIP=0, so
  software can treat a still-busy flash as ready.
- **Root cause (author):** controller still has “under the hood”
  WREN/RDSR translation; ODTR’s extra opcode extension/repetition likely
  makes the illegal opcode collision actually fire.
- **Versions:** none named. Introduced by the 2021 auto-poll disable,
  not by new 7.x code.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Subject and body describe a real hardware-
programming bug. Not cleanup/refactor.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/spi/spi-cadence-quadspi.c` (**+1 / −2**)
- Function: `cqspi_write_setup()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `reg = readl(WR_COMPLETION_CTRL); reg |=
  DISABLE_AUTO_POLL; writel(...)` — RMW preserves OPCODE_FLD=0x05 and
  poll-count/delay/bit fields.
- **After:** `reg = CQSPI_REG_WR_DISABLE_AUTO_POLL; writel(...)` —
  writes only BIT(14), so OPCODE_FLD becomes 0 (and other poll fields
  0).
- Path: **write setup** for every spi-mem data write when
  `cqspi->wr_completion` is true (default). Direct-mode writes stay
  disabled, unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** hardware workaround / logic correctness (illegal
  controller opcode collision)
- **Mechanism:** disabled auto-poll still advertised RDSR 0x05; STIG
  RDSR used the same opcode; TRM-forbidden config; ODTR status reads
  return 0
- **Fix:** clear OPCODE_FLD while keeping poll disabled, so STIG 0x05 no
  longer matches

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** minimal and aligned with the TRM. Polling was already
  disabled; remaining fields only matter when polling is on.
  `CQSPI_NO_SUPPORT_WR_COMPLETION` platforms (SoCFPGA, Mobileye) never
  write this register.
- **Regression risk:** **low**. SDR already worked with poll disabled;
  changing opcode from 0x05 to 0 while poll is off is what the TRM
  wants. Slightly broader than clearing only bits [7:0], but with
  `DISABLE_POLLING` set that is harmless.
- No API/data-structure/locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Auto-poll disable + RMW: **`9cb2ff11171264`** (“spi: cadence-quadspi:
  Disable Auto-HW polling”, Apurva Nandan, 2021-07-13) — present since
  ~v5.15
- `if (cqspi->wr_completion)` gate: **`98d948eb833104`** (2021-11)
- DTR support: **`f453f293979fb`** (2021-01-06)
- The RMW was already used for DTR-only in `f453f293979fb`;
  `9cb2ff11171264` extended it to all writes. Bug is years old in this
  tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Buggy pattern comes from `9cb2ff11171264`,
which **is** in this tree (`git merge-base --is-ancestor` succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent cadence-qspi work is clocks, PM, DMA, DT parse —
unrelated. Independent of later ODTR opcode-filter commit `bee085476d27`
and its revert (neither is in this tree). **Standalone.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Miquel Raynal maintains MTD/NAND/SPI-NAND and contributes
regularly to spi-mem/cadence-qspi. Nearby work is DTR/spi-mem, not a
hidden multi-patch dependency. This submission is **[1/1]**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses only `CQSPI_REG_WR_DISABLE_AUTO_POLL`,
`cqspi->wr_completion`, and `cqspi_write_setup()` — all present at
**v6.18.57**. `git diff v6.18.57 a1536ec7381c3^ -- drivers/spi/spi-
cadence-quadspi.c` is **empty**: the hunk applies cleanly to this
series.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c fd99864b0ac9`: https://patch.msgid.link/20261001-winbond-
  spi-next-cadence-rdsr-fix-v1-1-ec5ff594ba5d@bootlin.com
- `b4 dig -a`: **v1 only**, single patch `[PATCH]` / Mark Brown `[1/1]`
- Thread: author cover + Mark Brown “Applied to spi.git **for-7.3**”
- **No NAK, no review objections, no reviewer Cc: stable**
- Cover note: issue is subtle; explanation is long on purpose

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Mark Brown (applied), Thomas Petazzoni, Santhosh
Kumar K / Vignesh Raghavendra (TI, cadence-qspi), Steam Lin (Winbond),
linux-spi. Maintainer-applied; no extra Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author reproduced on real ODTR hardware (bus
stuck low / reads 0). Winbond engineer CC’d. Others on-list said ODTR
worked — author attributes that to IP without write-completion (quirk)
or more tolerant chips.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series name `winbond-spi-next-cadence-rdsr-fix` is **one
patch**. Not 2/3 of a stack. Later opcode-filter revert is a different
bug and not required here.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: WebSearch of lore.kernel.org/stable for this subject found
**no** stable discussion (and no documented reason to skip it).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP is **not available**; used grep/read.

**Step 5.1: KEY FUNCTIONS**
Record: **`cqspi_write_setup()`** only.

**Step 5.2: TRACE CALLERS**
Record:
- `cqspi_write_setup` ← `cqspi_write` ← `cqspi_mem_process` ←
  `cqspi_exec_mem_op` (`spi_controller_mem_ops.exec_op`)
- After a data write, spi-nor/spi-nand poll RDSR via
  **`cqspi_command_read()` (STIG)** when the op has no address or is a
  small register read (`nbytes <= STIG max`).
- Context: process context, MTD/spi-mem, not IRQ.

**Step 5.3: TRACE CALLEES**
Record: `cqspi_enable_dtr`, `writel` of WR/RD_INSTR and
WR_COMPLETION_CTRL, then size register. No alloc/locks.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace/MTD write/erase → spi-nor `spi_nor_octal_dtr_write` /
page program → exec_op write → `cqspi_write_setup` programs
WR_COMPLETION_CTRL → `spi_nor_read_sr()` issues RDSR (0x05; in 8-8-8 DTR
also dummy/addr and 2 data bytes) → STIG. **Reachable on every flash
write** on Cadence OSPI with wr_completion. Not a syscall UAF, but
boot/rootfs-on-OSPI is a common embedded path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `WR_COMPLETION_CTRL` is only written here. Platforms with
`CQSPI_NO_SUPPORT_WR_COMPLETION` skip it (SoCFPGA, Mobileye EyeQ5).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** At **v6.18.57** `cqspi_write_setup()` still does the
RMW. Tree: `git describe HEAD` = **v6.18.57-155-gcdf239ca885b2**, `make
kernelversion` = **6.18.57**. DTR (`cqspi_mem_caps.dtr = true`,
`cqspi_enable_dtr`) and octal (`CQSPI_SUPPORTS_OCTAL` on TI AM654 and
Versal) are here. spi-nor has `SNOR_PROTO_8_8_8_DTR` and
`spi_nor_read_sr()` DTR RDSR.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** to v6.18.57. Surrounding function matches the
hunk exactly.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other commit in this tree fixes OPCODE_FLD vs STIG. This
candidate is the first.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drivers/spi** Cadence Quad SPI (`CONFIG_SPI_CADENCE_QUADSPI`).
**IMPORTANT** for embedded: TI K3 OSPI (`ti,am654-ospi`), AMD/Xilinx
Versal OSPI, plus JH7110, Intel LGM, etc. Often **boot/root filesystem
flash**. Not core mm/VFS, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (PM, clocks, DMA) but this programming
sequence has been stable since 2021.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific**, especially **octal DTR** on controllers
that **have** write-completion (TI AM654/K3 OSPI, Versal OSPI).
SoCFPGA/Mobileye skip the register. SDR of the same chips is reported
working.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Flash write/erase then software RDSR poll in **8-8-8 DTR**.
Needs octal-capable controller + ODTR NOR/NAND. Not unprivileged-attack
surface; typically MTD from kernel/root. Timing-independent once ODTR is
on — author reproduced it.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- **Failure:** RDSR returns 0 (lines held low). WIP=0 can look like “not
  busy” while a program/erase is still running → **failed writes or
  flash corruption**. Or ops just fail.
- **Severity: HIGH** (flash integrity on OSPI-boot systems). Not a KASAN
  crash, but real storage failure.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: high** for ODTR-on-Cadence-QSPI users (TI K3, Versal, …)
- **Risk: very low** (1–3 lines, poll already off, quirk skips broken
  IP)
- **Ratio: strongly favors backport**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, reproduced bug: ODTR status poll returns all 0s
- TRM forbids this opcode collision
- Possible **write-completion mis-detect / flash corruption**
- 3-line, obviously correct, no new API
- Code has been wrong in this tree since 2021; DTR/octal already exist
- Applies cleanly to v6.18.57
- Author is MTD maintainer; SPI maintainer applied it
- Hardware-programming workaround (stable exception class)

**AGAINST:**
- No Fixes:/Cc: stable (not a negative per rules)
- No extra reviewers; applied to **for-7.3** not as an -rc hotfix
- Author is not 100% sure of the internal ODTR datapath (“wild guess”)
- Hits ODTR more than SDR; fewer machines than a core-mm bug
- Writes the whole register, not only OPCODE_FLD (still safe with poll
  disabled)

**UNRESOLVED:** Exact on-wire ODTR sequence (author could not probe). No
stable-list thread. Unverified whether every Cypress Semper setup
already failed the same way (Winbond exposed it; TRM still applies).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — TRM + reproduced ODTR
   failure; maintainer applied
2. Fixes a real bug that affects users? **PASS** — OSPI flash status
   poll broken in ODTR
3. Important issue? **PASS** — HIGH: failed program/erase or false
   “ready” (corruption risk)
4. Small and contained? **PASS** — +1/−2, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — v6.18.57 has the RMW; empty
   diff vs parent file

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware workaround** for Cadence OSPI write-completion vs
STIG RDSR. Not a new driver/API.

**Step 9.4: MAKE YOUR DECISION**
This belongs on 6.18.y: the buggy RMW is in this tree, octal DTR is
supported, the fix is tiny, and the failure is flash status polling — a
data-integrity problem on platforms that boot from OSPI.

---

### Problem and why it matters here
`cqspi_write_setup()` disables controller auto-poll but left
`WRITE_COMPLETION_CTRL.OPCODE_FLD` at the reset default **0x05**.
Software RDSR also uses 0x05 in STIG. The Cadence TRM forbids that
match. In octal DTR, status reads come back 0, so WIP can look clear
while the chip is still busy. On TI AM654/K3 and Versal OSPI that is
boot/storage flash, not a niche sysfs knob.

### Stable rules / risk
Surgical, no new ABI, applies to **this** 6.18.57 tree without
prerequisites. Benefit (correct ODTR status, avoid bad write completion)
dwarfs the risk of writing BIT(14) instead of RMW.

### Verification
- **[Phase 1]** Tags: Link to msgid `20261001-winbond-spi-next-cadence-
  rdsr-fix-v1-1-…`; SOB Miquel Raynal + Mark Brown; no Fixes/Reported-
  by/Cc: stable
- **[Phase 2]** Diff: `cqspi_write_setup()` RMW → `reg =
  CQSPI_REG_WR_DISABLE_AUTO_POLL` (+1/−2)
- **[Phase 3]** blame: RMW from `9cb2ff11171264` (2021); wr_completion
  gate `98d948eb833104`; DTR `f453f293979fb`; all ancestors of HEAD
- **[Phase 3]** `git merge-base --is-ancestor 9cb2ff11171264 HEAD` → yes
- **[Phase 3]** `git diff v6.18.57 a1536ec7381c3^ -- drivers/spi/spi-
  cadence-quadspi.c` → 0 lines (clean apply)
- **[Phase 4]** `b4 dig -c fd99864b0ac9`: lore/patch.msgid.link match;
  `-a` v1 only; `-w` Broonie/TI/Winbond/linux-spi; mbox: Applied
  **for-7.3**, no NAK
- **[Phase 4]** lore.kernel.org WebFetch → 403; recovered via `b4 -m` +
  patchew
- **[Phase 4]** stable lore search: no hits
- **[Phase 5]** callers: `cqspi_write` → `cqspi_mem_process` →
  `cqspi_exec_mem_op`; RDSR via `cqspi_command_read` STIG;
  `spi_nor_read_sr()` DTR path in `drivers/mtd/spi-nor/core.c`
- **[Phase 6]** `git describe HEAD` = v6.18.57-155-gcdf239ca885b2; `make
  kernelversion` = 6.18.57; v6.18.57 still has the RMW
- **[Phase 6]** octal platdata: `am654_ospi`, `versal_ospi`,
  `versal2_ospi` have `CQSPI_SUPPORTS_OCTAL` and wr_completion;
  SoCFPGA/Mobileye set `CQSPI_NO_SUPPORT_WR_COMPLETION`
- **[Phase 7]** `CONFIG_SPI_CADENCE_QUADSPI`; compatibles include
  `ti,am654-ospi`, `xlnx,versal-ospi-1.0`
- **[Phase 8]** Failure: ODTR RDSR all 0s → false ready / failed flash
  ops; severity HIGH
- **UNVERIFIED:** on-wire ODTR collision (author could not probe);
  whether every Cypress Semper board already failed identically
- **semcode:** namespace not available

The patch is a small, correct hardware programming fix for a real flash-
status bug that exists in this 6.18.y tree.

**YES**

 drivers/spi/spi-cadence-quadspi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 0a32e28eefd51..441426bc232ef 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1058,8 +1058,7 @@ static int cqspi_write_setup(struct cqspi_flash_pdata *f_pdata,
 	 * care of polling the status register.
 	 */
 	if (cqspi->wr_completion) {
-		reg = readl(reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
-		reg |= CQSPI_REG_WR_DISABLE_AUTO_POLL;
+		reg = CQSPI_REG_WR_DISABLE_AUTO_POLL;
 		writel(reg, reg_base + CQSPI_REG_WR_COMPLETION_CTRL);
 		/*
 		 * DAC mode require auto polling as flash needs to be polled
-- 
2.53.0

