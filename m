Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB727256D;
	Wed, 11 Feb 2026 12:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813089; cv=none; b=GFVDjsS6y1DOILCEmfDZR222NYCPMWkZci80UJHJpD3EQU2I9KXGa9YLZI86uEOLq1fMJbx2D7L43i2psQSYClFmTsos4PFzyiWRaXGlgdNgheXJZM09pogV6Ok7d4najbxU90carWMugk1nccqoftHuMuc8XYf3sm6hyenV87s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813089; c=relaxed/simple;
	bh=zBvjQ82V7lCcC9TG/0+hxmvjgV10SOGBXJUHstbacvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdIpxjw7JaPg+7FX88vPY9kcLCrWM5dtqLX72D8ipA9ZdCIxLOJBuPO1YNzxbuR8/YYewlm8RaiNj1PSu8qXrKT6km7qGFQxM5a0ILCXZRE1z3D+BrIIRiyvWD6S0k7iAv60XfK40RpBKQbm83gfAONLxCOe3AdqeKKUrkh+RAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+vwxZPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+vwxZPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4B0C19421;
	Wed, 11 Feb 2026 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813089;
	bh=zBvjQ82V7lCcC9TG/0+hxmvjgV10SOGBXJUHstbacvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+vwxZPMK4CQFi97jJPSs3UaONvvdOvD9lV+jn0Wr6IJmnl/lJ2lHmwDk2/Z5eXiE
	 A/VakkVb/2tIDSE29/jOyzk4GLxRCyNND4+AU6zHQtPR7F6m8gSH3HuqpbVjR91gHf
	 pO0rM4/kbMJBCVTL7Btpw0xZO2m2Br45XEWNPJiGce4KtjO3RVI5cmgdh7YJrpgKyQ
	 AO14XAqfHeYvTzVXuHp+zd/2gWPnlQiRHSv+oiH/arUN54rgq10B+sfcGB5yv5OBkQ
	 mg9FuNUE//+PrOTddEDYk8C58OX08SIqyXSXwZn0qgftNvpBXf+j9v6pauBnJrrswu
	 crFGtf75eDF4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakob Riemenschneider <riemenschneiderjakob@gmail.com>,
	Antheas Kapenekakis <antheas@antheas.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	superm1@kernel.org,
	soyer@irl.hu
Subject: [PATCH AUTOSEL 6.19-6.12] ACPI: x86: s2idle: Invoke Microsoft _DSM Function 9 (Turn On Display)
Date: Wed, 11 Feb 2026 07:30:18 -0500
Message-ID: <20260211123112.1330287-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
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

From: Jakob Riemenschneider <riemenschneiderjakob@gmail.com>

[ Upstream commit 229ecbaac6b31f89c554b77eb407377a5eade7d4 ]

Windows 11, version 22H2 introduced a new function index (Function 9) to
the Microsoft LPS0 _DSM, titled "Turn On Display Notification".

According to Microsoft documentation, this function signals to the system
firmware that the OS intends to turn on the display when exiting Modern
Standby. This allows the firmware to release Power Limits (PLx) earlier.

Crucially, this patch fixes a functional issue observed on the Lenovo Yoga
Slim 7i Aura (15ILL9), where system fans and keyboard backlights fail to
resume after suspend. Investigation linked shows the EC on this device
turns off these components during sleep but requires the Function 9
notification to wake them up again.

This patch defines the new function index (ACPI_MS_TURN_ON_DISPLAY) and
invokes it in acpi_s2idle_restore_early_lps0(). The execution order is
updated to match the logic of an "intent" signal:

 1. LPS0 Exit (Function 6)
 2. Turn On Display Intent (Function 9)
 3. Modern Standby Exit (Function 8)
 4. Screen On (Function 4)

Invoking Function 9 before the Modern Standby Exit ensures the firmware
has time to restore power rails and functionality (like fans) before the
software fully exits the sleep state.

Link: https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/modern-standby-firmware-notifications#turn-on-display-notification-function-9
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220505
Suggested-by: Antheas Kapenekakis <antheas@antheas.dev>
Signed-off-by: Jakob Riemenschneider <riemenschneiderjakob@gmail.com>
Link: https://patch.msgid.link/20260127200121.1292216-1-riemenschneiderjakob@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my complete analysis:

---

## Commit Analysis: ACPI: x86: s2idle: Invoke Microsoft _DSM Function 9
(Turn On Display)

### 1. COMMIT MESSAGE ANALYSIS

The commit adds support for invoking Microsoft _DSM Function 9 ("Turn On
Display Notification") during resume from Modern Standby (s2idle). The
commit message explicitly states it **fixes a functional issue** on the
Lenovo Yoga Slim 7i Aura (15ILL9), where fans and keyboard backlights
fail to resume after suspend. The EC (embedded controller) on this
device turns these off during sleep but requires the Function 9
notification to restore them.

Key indicators:
- **"Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220505"** -
  Links to a real bug report
- **"Crucially, this patch fixes a functional issue"** - Explicit bug
  fix language
- **Signed-off by Rafael J. Wysocki** - The ACPI/PM subsystem maintainer
  accepted it
- **Reference to Microsoft specification** - Well-documented standard
  behavior

### 2. CODE CHANGE ANALYSIS

The diff makes three minimal changes:

**a) New constant definition (1 line):**

```52:52:drivers/acpi/x86/s2idle.c
#define ACPI_MS_TURN_ON_DISPLAY 9
```

**b) Debug string mapping (2 lines):**

```358:359:drivers/acpi/x86/s2idle.c
// case ACPI_MS_TURN_ON_DISPLAY:
//   return "lps0 ms turn on display";
```

**c) New DSM call in resume path (3 lines):**
The actual fix inserts a call to
`acpi_sleep_run_lps0_dsm(ACPI_MS_TURN_ON_DISPLAY, ...)` between the LPS0
Exit and Modern Standby Exit calls, creating the sequence:
1. LPS0 Exit (Function 6)
2. Turn On Display Intent (Function 9) ← **NEW**
3. Modern Standby Exit (Function 8)
4. Screen On (Function 4)

**Safety mechanism:** The call passes through
`acpi_sleep_run_lps0_dsm()` which has a critical guard at line 380:

```380:381:drivers/acpi/x86/s2idle.c
        if (!(func_mask & (1 << func)))
                return;
```

This means Function 9 is **only invoked if the firmware advertises
support** for it via bit 9 (0x200) in the Microsoft DSM function mask.
The outer guard `lps0_dsm_func_mask_microsoft > 0` provides a second
layer of protection. Systems that don't support Function 9 are
completely unaffected.

### 3. CLASSIFICATION

This is a **hardware fix/firmware protocol compliance fix** that falls
into the "quirks and workarounds" exception category. It's analogous to:
- Adding a USB quirk for a device that doesn't work without a specific
  firmware call
- Adding a PCI quirk for a device that needs a specific initialization
  sequence

The change aligns Linux behavior with what Windows 11 22H2+ does, and
what firmware on affected devices expects. It's NOT adding a new
userspace API or feature - it's making existing suspend/resume work
correctly on hardware that requires this notification.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~8 lines of actual code across 3 locations in one
  file
- **Files touched:** 1 (`drivers/acpi/x86/s2idle.c`)
- **Complexity:** Very low - adds one more DSM call to an existing
  sequence of DSM calls
- **Risk of regression:** **Extremely low** due to the double-gating:
  1. `lps0_dsm_func_mask_microsoft > 0` - Microsoft UUID must be
     supported
  2. `func_mask & (1 << 9)` - Firmware must advertise Function 9 support
- On systems WITHOUT Function 9 support, the new code is a complete no-
  op

### 5. USER IMPACT

**Severity: HIGH** for affected users.
- Fans not working after resume is a **thermal safety issue** - the CPU
  could overheat
- Keyboard backlight not working is a significant usability issue
- The Lenovo Yoga Slim 7i Aura is a current, shipping laptop
- More devices will likely require Function 9 as firmware designers
  align with Windows 11 22H2+ behavior

### 6. DEPENDENCY CHECK

**For 6.12.y stable:**
- Commit `073237281a508` ("Enable Low-Power S0 Idle MSFT UUID for non-
  AMD systems", v6.9) is present - this is crucial because the affected
  laptop is Intel-based
- Commit `f198478cfdc81` ("Adjust Microsoft LPS0 _DSM handling
  sequence", v6.5) is present - provides the correct DSM ordering
- The function was renamed from `acpi_s2idle_restore_early` to
  `acpi_s2idle_restore_early_lps0` in `bfc09902debd0` (v6.19-rc1), so a
  minor name adaptation is needed for 6.12.y
- The internal code structure is identical, so the patch logic applies
  cleanly

**For 6.6.y stable:**
- In v6.6, `lps0_dsm_func_mask_microsoft = -EINVAL` is explicitly set
  for non-AMD (Intel) systems. The Microsoft UUID is disabled on Intel
  platforms. The specific Lenovo Intel laptop from the bug report would
  NOT benefit in 6.6.y without also backporting `073237281a508`
- AMD systems in 6.6.y could potentially benefit if their firmware
  advertises Function 9

**For 6.1.y and older:** Code structure differs significantly; limited
applicability.

### 7. STABILITY INDICATORS

- Accepted by Rafael J. Wysocki (ACPI/PM subsystem maintainer)
- References official Microsoft documentation
- Follows the established pattern of previous DSM function additions
  (Functions 7/8 were added the same way)
- The Microsoft specification has been stable since Windows 11 22H2
  (2022)

### 8. OVERALL ASSESSMENT

**Pros:**
- Fixes a real, documented hardware bug (bugzilla 220505)
- Very small and surgical change (8 lines)
- Zero risk of regression on unaffected hardware (firmware opt-in via
  capability mask)
- Follows well-established patterns in this subsystem
- Fans not resuming is a potential thermal safety issue
- Accepted by subsystem maintainer
- Aligns with documented firmware specification

**Cons:**
- Could be viewed as adding "new feature" (new DSM function call)
- Most relevant for 6.12.y; older stable trees have reduced
  applicability
- Specific to newer hardware, though more devices will need this over
  time

The fix is very similar in nature to hardware quirks - it makes specific
hardware work correctly by calling a documented firmware interface that
the hardware expects. The safety guarantees are excellent, the change is
minimal, and it fixes a real bug that impacts basic laptop functionality
(fans, keyboard backlights) after suspend/resume.

**YES**

 drivers/acpi/x86/s2idle.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index cc3c83e4cc23b..2189330ffc6d3 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -49,6 +49,7 @@ static const struct acpi_device_id lps0_device_ids[] = {
 #define ACPI_LPS0_EXIT		6
 #define ACPI_LPS0_MS_ENTRY      7
 #define ACPI_LPS0_MS_EXIT       8
+#define ACPI_MS_TURN_ON_DISPLAY 9
 
 /* AMD */
 #define ACPI_LPS0_DSM_UUID_AMD      "e3f32452-febc-43ce-9039-932122d37721"
@@ -356,6 +357,8 @@ static const char *acpi_sleep_dsm_state_to_str(unsigned int state)
 			return "lps0 ms entry";
 		case ACPI_LPS0_MS_EXIT:
 			return "lps0 ms exit";
+		case ACPI_MS_TURN_ON_DISPLAY:
+			return "lps0 ms turn on display";
 		}
 	} else {
 		switch (state) {
@@ -617,6 +620,9 @@ static void acpi_s2idle_restore_early_lps0(void)
 	if (lps0_dsm_func_mask_microsoft > 0) {
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
+		/* Intent to turn on display */
+		acpi_sleep_run_lps0_dsm(ACPI_MS_TURN_ON_DISPLAY,
+				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
 		/* Modern Standby exit */
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_EXIT,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
-- 
2.51.0

