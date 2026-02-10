Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C932DC76F;
	Tue, 10 Feb 2026 23:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766300; cv=none; b=aVYyVb0+NRKMjs3jkEHpW+9vToLZiSL58kgQmGRfyozzRWUsJgjEE36mmfqeuOa5C60f5R4qWqOUTFljIVGJlNndj6J97TRy9oZ8WqOQ5bOMaqlsrkGIkQi/DduBxAo4Y9R6qq1kcXufGRW1AedpmoePE3nQVcDK7XAPuPdQqQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766300; c=relaxed/simple;
	bh=gXAIr8R9kFpOfQYI10rltP9pZc3pIVGIUCWQASzjMlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwK+I9JZZG7jJgYTKXNpoJ/+cwoA3n7TW6z9nI3uoItPY7nhMzguarzWKHbw7eJooHxn3MFLkYYE0HsUVKOmSSphyLPvGxDKiF5Vtlp75Q/4mfRKcpq98FFyNqnk9vag4X1ijjEQPMXgZdbmv7q2JDX3cJ8Rs9ETs38YKOS4VNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inCeZF7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inCeZF7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7335FC116C6;
	Tue, 10 Feb 2026 23:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766300;
	bh=gXAIr8R9kFpOfQYI10rltP9pZc3pIVGIUCWQASzjMlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inCeZF7pLJM626S/gvnK1yIsq4+cy4lB1Bl9ZXMll38sijvckyyC6Wdq4Mr9wy408
	 1Wm/ZzFaQkr3PAmFD4Qsh4IVi1ESUrlAOjfsVu124AS2KXfu7Rt7zV9s0RJjCqRQV9
	 Ler5qt1JrujVmPEsDxA7OR/t2pEFsFij9wrvw0aZi0pVveKjs5IHfkob4Z6BBwa1xU
	 RSMb859mdw3kSZSjfR7rX3H8Hgzq5ls8YXwIOLCLx7OPdlhgD0jpoHJl3bzST4lyT7
	 JEgTBGfk9o9CSEC3tQz8wyUG/o4n40rjriLI6gMZ7SoMwZQHR6c06XQfOgCiG3teq2
	 gBevRHvilBxmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	jarkko.nikula@linux.intel.com
Subject: [PATCH AUTOSEL 6.19-6.12] i3c: mipi-i3c-hci-pci: Add System Suspend support
Date: Tue, 10 Feb 2026 18:30:54 -0500
Message-ID: <20260210233123.2905307-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 4280197d154cae1d1d5acb54484da26da04eac32 ]

Assign the driver PM operations pointer, which is necessary for the PCI
subsystem to put the device into a low power state.  Refer to
pci_pm_suspend_noirq() which bails out if the pointer is NULL, before
it has the opportunity to call pci_prepare_to_sleep().

No other actions are necessary as the mipi-i3c-hci driver takes care of
controller state.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260123063325.8210-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile my detailed analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit subject "Add System Suspend support" makes this sound like a
new feature, but the body reveals the real story: it's fixing a bug
where the PCI subsystem **cannot put the device into a low power state**
during system suspend. The commit message specifically references
`pci_pm_suspend_noirq()` which "bails out if the pointer is NULL, before
it has the opportunity to call `pci_prepare_to_sleep()`."

### 2. CODE CHANGE ANALYSIS

The change is extremely minimal:
1. Adds an **empty** `struct dev_pm_ops` (no callbacks):
  ```c
  static const struct dev_pm_ops mipi_i3c_hci_pci_pm_ops = {
  };
  ```
2. Assigns it to the PCI driver structure:
  ```c
  .driver = {
  .pm = pm_ptr(&mipi_i3c_hci_pci_pm_ops)
  },
  ```

### 3. THE BUG MECHANISM

The critical code path is in `pci_pm_suspend_noirq()`:

```863:866:drivers/pci/pci-driver.c
        if (!pm) {
                pci_save_state(pci_dev);
                goto Fixup;
        }
```

When `dev->driver->pm` is NULL (as in the current driver),
`pci_pm_suspend_noirq()` takes the early exit at line 863-866: it saves
PCI state but jumps to `Fixup`, **completely skipping** the call to
`pci_prepare_to_sleep()` at line 895:

```886:896:drivers/pci/pci-driver.c
        if (!pci_dev->state_saved) {
                pci_save_state(pci_dev);

                /*
   - If the device is a bridge with a child in D0 below it,
   - it needs to stay in D0, so check skip_bus_pm to avoid
   - putting it into a low-power state in that case.
                 */
                if (!pci_dev->skip_bus_pm &&
pci_power_manageable(pci_dev))
                        pci_prepare_to_sleep(pci_dev);
        }
```

With the fix (non-NULL but empty `pm` ops), the code:
- Skips the NULL-pm early exit
- Skips the `pm->suspend_noirq` block (callback is NULL)
- Falls through to `pci_save_state()` AND `pci_prepare_to_sleep()`,
  which transitions the device to D3hot/D3cold

### 4. USER IMPACT

Without this fix, the Intel I3C HCI PCI controller stays in **D0 (full
power)** during system suspend. This has real consequences:
- **Higher power consumption during suspend** - device draws power when
  it shouldn't
- **May prevent platform from reaching deeper sleep states** (S0ix/S3)
  on Intel platforms
- Affects Intel Panther Lake, Wildcat Lake, and Nova Lake platforms

This is a known pattern - other PCI drivers like `surface_dtx` and
`aggregator/core.c` use the same empty `dev_pm_ops` trick for exactly
this reason.

### 5. DRIVER EXISTENCE IN STABLE TREES

- **v6.14**: Driver first added (148 lines). No `.driver.pm` pointer.
- **v6.15, v6.16**: No changes to this file.
- **v6.17**: 1 commit (Wildcat Lake-U device IDs). Still no PM.
- **v6.18**: No changes.
- **v6.19**: 13 commits (major refactoring). Still no PM.

The bug exists in **ALL versions** of this driver. However, the diff
from the analyzed commit targets a codebase significantly different from
any released version (references `intel_mi_1_info`, `intel_si_2_info`,
`mfd_remove_devices`, `mipi_i3c_hci_pci_rpm_forbid` - none of which
exist in v6.14-v6.19). This means:
- The exact diff **will NOT apply cleanly** to any stable tree
- A manual adaptation would be needed, but it's **trivially simple**
  (just add the empty struct and pointer to the existing `pci_driver`
  struct)

### 6. CLASSIFICATION

This is a **bug fix**, not a new feature. System suspend is expected to
work correctly for any PCI device. The driver was missing a required
piece (`dev_pm_ops` pointer) that the PCI subsystem needs to properly
power-manage the device. The comment in the code even says "PM ops must
exist for PCI to put a device to a low power state."

### 7. RISK ASSESSMENT

- **Risk: Essentially zero.** The `dev_pm_ops` structure is completely
  empty - no callbacks are defined. Its sole purpose is to not be NULL,
  so the PCI core doesn't take the early-exit path.
- **Lines changed**: ~7 lines added
- **Files changed**: 1
- **Reviewed-by**: Frank Li (NXP)

### 8. CONCERNS

- **Dependency**: The exact diff won't apply cleanly to stable trees
  (context mismatch). A trivial manual adaptation is needed.
- **Hardware newness**: The supported platforms (Panther Lake, etc.) are
  new Intel hardware with potentially limited user base.
- **Not a crash/security bug**: This is a power management regression,
  not a crash or data corruption.

### 9. VERDICT

The fix resolves a real power management bug that affects every user
with Intel I3C HCI hardware doing system suspend. The change is
trivially small, zero-risk, and follows an established pattern used by
other PCI drivers. While the hardware is new and the issue isn't a
crash, broken system suspend is a significant user-visible issue - users
with these platforms will see higher battery drain during suspend, and
the platform may not reach its desired sleep state.

The fix meets stable criteria: it's obviously correct, fixes a real bug,
is small and contained, and doesn't introduce new features. The empty PM
ops structure adds no new behavior - it simply allows the existing PCI
power management infrastructure to work as designed.

**YES**

 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
index dc8ede0f8ad8d..f8ac1ae371cc9 100644
--- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
+++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
@@ -265,6 +265,10 @@ static void mipi_i3c_hci_pci_remove(struct pci_dev *pci)
 	ida_free(&mipi_i3c_hci_pci_ida, dev_id);
 }
 
+/* PM ops must exist for PCI to put a device to a low power state */
+static const struct dev_pm_ops mipi_i3c_hci_pci_pm_ops = {
+};
+
 static const struct pci_device_id mipi_i3c_hci_pci_devices[] = {
 	/* Wildcat Lake-U */
 	{ PCI_VDEVICE(INTEL, 0x4d7c), (kernel_ulong_t)&intel_info},
@@ -287,6 +291,9 @@ static struct pci_driver mipi_i3c_hci_pci_driver = {
 	.id_table = mipi_i3c_hci_pci_devices,
 	.probe = mipi_i3c_hci_pci_probe,
 	.remove = mipi_i3c_hci_pci_remove,
+	.driver = {
+		.pm = pm_ptr(&mipi_i3c_hci_pci_pm_ops)
+	},
 };
 
 module_pci_driver(mipi_i3c_hci_pci_driver);
-- 
2.51.0

