Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FFEDF59;
	Sat, 14 Feb 2026 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030707; cv=none; b=sQhLgOKQBmOPb9PhEW0fX33pATd2o58IMy3oiJIjtXpimP3SHfoTuWIplxINX02CeErDFlB+Ns+PA4ZHPKgoJxaEyNUuOS4SSSczxWZmi+UH/SngqYysaATu2IeSi0hXMdPK/JgGDW0YR8NGb27ShMKp9rDqRDy955lWU26jbYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030707; c=relaxed/simple;
	bh=/kd1Oo5eC6W/FB1ali0jRnimMqmPzi1EFI4is2YTTHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ydst4DyhcVHw6Qani4ArtoDp8hYh+a49Ukxa67hcvbWZcbWla67a9YYOoruQvMuFAA/h7NnqmReje3+jPBRXTVkctnv+66kqWYgVUhCUCzr0fKRw71xjBnxvC+tAdscFO+UMtmyWDHtUYlw6VD7x+VDjXT2CVFje3jdGIHDho7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZiw7URf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZiw7URf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF05C116C6;
	Sat, 14 Feb 2026 00:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030707;
	bh=/kd1Oo5eC6W/FB1ali0jRnimMqmPzi1EFI4is2YTTHk=;
	h=From:To:Cc:Subject:Date:From;
	b=eZiw7URfWD0nB1Gad02PxbIKoyFjRMpfVWMZzghc/4Nbig0iatt2KI9dxDAgH8FA0
	 ENNsIvme4cPQfq2K6Z8RAcjPucIDo8/fbyylrhkjQRrdaSxqumuV9u4USMWrgko/Fj
	 +f97aCmadvKJ42vRxPciTPJ5J4CfEhkeQRd6PnVjT6DXAuSTolRXPjkr3q70IJSVMj
	 Xh1eS2iGcmUn84V0FIeIeBKs9wIyKTZK8gqmK32ZP7X7of0xa0qW8nHQcQY2zXsTY5
	 PTy8bifNhWfHf/YyT+UueQl5sxcbsRl/C1ZQfd05TmhJOio3BY6GqPvqwj7brSott1
	 Cya7pe1eYB36w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	guoren@kernel.org,
	neil.armstrong@linaro.org,
	geert@linux-m68k.org,
	brauner@kernel.org,
	yelangyan@huaqin.corp-partner.google.com,
	schuster.simon@siemens-energy.com,
	linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] parisc: Prevent interrupts during reboot
Date: Fri, 13 Feb 2026 19:58:07 -0500
Message-ID: <20260214005825.3665084-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

[ Upstream commit 35ac5a728c878594f2ea6c43b57652a16be3c968 ]

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need for a thorough analysis. Here is
my complete assessment:

---

## Detailed Analysis: "parisc: Prevent interrupts during reboot"

### 1. COMMIT MESSAGE ANALYSIS

The commit message is minimal: "parisc: Prevent interrupts during
reboot". It clearly states the problem it's fixing -- interrupts are not
properly disabled during the reboot path on PA-RISC systems. The author
is **Helge Deller**, the long-time parisc maintainer and the most
authoritative developer for this architecture. The commit has no
`Fixes:` tag or `Cc: stable` (as expected for autosel candidates).

### 2. CODE CHANGE ANALYSIS

The change is **one single effective line of code** plus a comment:

```c
/* prevent interrupts during reboot */
set_eiem(0);
```

This is inserted into `machine_restart()` in
`arch/parisc/kernel/process.c` immediately after
`pdc_chassis_send_status(PDC_CHASSIS_DIRECT_SHUTDOWN)` and before
`pdc_do_reset()`.

**What `set_eiem(0)` does:** On PA-RISC, the EIEM (External Interrupt
Enable Mask, Control Register 15) controls which external interrupts can
fire. Setting it to 0 **masks all external interrupts at the hardware
level**, preventing any interrupt from being delivered to the CPU. This
is defined as:

```82:82:arch/parisc/include/asm/special_insns.h
#define set_eiem(val)   mtctl(val, CR_EIEM)
```

**The bug:** Without this line, external interrupts remain enabled
during the entire reboot sequence. This means:

a) **Deadlock risk in `pdc_do_reset()`**: The `pdc_do_reset()` function
acquires `pdc_lock` via `spin_lock_irqsave()`:

```1236:1246:arch/parisc/kernel/firmware.c
int pdc_do_reset(void)
{
        int retval;
        unsigned long flags;

        spin_lock_irqsave(&pdc_lock, flags);
        retval = mem_pdc_call(PDC_BROADCAST_RESET, PDC_DO_RESET);
        spin_unlock_irqrestore(&pdc_lock, flags);

        return retval;
}
```

While `spin_lock_irqsave` disables local interrupts, the PA-RISC EIEM
hardware mask is a separate mechanism. On PA-RISC, the external
interrupt delivery path goes through the EIEM -- an interrupt fires only
if the corresponding EIEM bit is set AND the EIRR (External Interrupt
Request Register) bit is set. If a hardware interrupt fires between
`pdc_chassis_send_status()` (which also uses `pdc_lock`) and
`pdc_do_reset()`, or during the firmware calls themselves, it could
interfere with the reset process.

b) **Interference with firmware reset**: `pdc_do_reset()` calls into PDC
firmware (`mem_pdc_call(PDC_BROADCAST_RESET, PDC_DO_RESET)`). Firmware
calls on PA-RISC are sensitive to the processor state. An interrupt
arriving during or between firmware calls can corrupt the reset
sequence, potentially causing the machine to **hang instead of
rebooting**.

c) **The `gsc_writel(CMD_RESET, COMMAND_GLOBAL)` fallback**: If
`pdc_do_reset()` returns (on machines that don't implement
`PDC_BROADCAST_RESET`), the code tries a hardware reset via
`gsc_writel`. Interrupts during this path are equally problematic.

### 3. ESTABLISHED PATTERN IN PARISC AND OTHER ARCHITECTURES

**PA-RISC internal precedent:**
- `parisc_terminate()` in `traps.c` uses the exact same pattern:
  `set_eiem(0)` followed by `local_irq_disable()` before critical
  shutdown operations (line 428-429)
- The SMP CPU hotplug code (`smp.c:481`) uses `set_eiem(0)` to disable
  all external interrupts when taking a CPU offline

**Other architectures ALL disable interrupts before reset:**
- ARM: `local_irq_disable()` at line 136 of `arch/arm/kernel/reboot.c`
- ARM64: `local_irq_disable()` at line 141 of
  `arch/arm64/kernel/process.c`
- x86: `local_irq_disable()` at line 100 of `arch/x86/kernel/reboot.c`
- xtensa: `local_irq_disable()` at line 524 of
  `arch/xtensa/kernel/setup.c`
- nios2: `local_irq_disable()` at line 49 of
  `arch/nios2/kernel/process.c`
- csky: `local_irq_disable()` at line 25 of `arch/csky/kernel/power.c`
- MIPS falcon: `local_irq_disable()` at line 37 of
  `arch/mips/lantiq/falcon/reset.c`

PA-RISC was the **outlier** in not disabling interrupts before reboot.
This commit fixes that deficiency.

### 4. CLASSIFICATION

This is a **bug fix** -- specifically fixing a potential hang/crash
during reboot caused by unmasked interrupts during firmware calls. It is
NOT a new feature, optimization, or cleanup.

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 3 (1 blank line, 1 comment, 1 functional line)
- **Files touched**: 1 (`arch/parisc/kernel/process.c`)
- **Subsystem**: parisc architecture, reboot path
- **Risk**: **Extremely low**. Disabling interrupts before a system
  reset is universally accepted as correct and necessary. The
  `set_eiem(0)` pattern is already used in the same codebase for similar
  critical paths.

### 6. USER IMPACT

- **Who is affected**: All PA-RISC Linux users who reboot their machines
- **What happens without the fix**: Potential hang during reboot,
  requiring a hard power cycle. This could be intermittent and timing-
  dependent, making it hard to reproduce but very real.
- **Severity if triggered**: System hang requiring manual intervention
  (power cycle)

### 7. STABILITY INDICATORS

- Author is the subsystem maintainer (highest trust level)
- Pattern is well-established across all other architectures
- The exact same `set_eiem(0)` call is used in the parisc
  `parisc_terminate()` function already
- The change is trivially small and obviously correct

### 8. DEPENDENCY CHECK

- No dependencies on other commits
- The `set_eiem()` macro has existed since the earliest parisc code
- The `machine_restart()` function is largely unchanged across all
  stable trees
- This will apply cleanly to any kernel version that has parisc support

### Summary

This is a trivially small, obviously correct fix that prevents
interrupts during the reboot sequence on PA-RISC systems. Without it, an
untimely interrupt can interfere with PDC firmware calls during reset,
potentially causing the machine to hang instead of rebooting. Every
other Linux architecture disables interrupts before reboot; parisc was
the outlier. The fix uses the same `set_eiem(0)` pattern already used in
`parisc_terminate()` and SMP CPU offline code. The risk is essentially
zero -- there is no conceivable way that disabling interrupts right
before a hardware reset could cause a regression.

**YES**

 arch/parisc/kernel/process.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index e64ab5d2a40d6..703644e5bfc4a 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -85,6 +85,9 @@ void machine_restart(char *cmd)
 #endif
 	/* set up a new led state on systems shipped with a LED State panel */
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_SHUTDOWN);
+
+	/* prevent interrupts during reboot */
+	set_eiem(0);
 	
 	/* "Normal" system reset */
 	pdc_do_reset();
-- 
2.51.0

