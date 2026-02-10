Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F5A2DC76F;
	Tue, 10 Feb 2026 23:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766294; cv=none; b=BPNam+6C3kABXrLzQo70Nanmk6e9Ct+OKcTHgantSyMcMJxeY1rtBNquJkdmccHbkpg6v7GaQDTnNW38mwCuuMran39klNoBS8h7cPoCl0/HsNNVw4DrOj20O9QwqaX7uC4Ir8wY0fFDyjWqXTXCRUPdYHkdwN8cccI1vCCdT+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766294; c=relaxed/simple;
	bh=g0rIbgAbeYMMUxIF53N6m1pCP8B5aMhZ6y0RYE6CQO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3CnCulL6JJjze4BqQc/HZATMK4JJ2RJ4jqOZPnt6rBiRINS6hq0GWWS0UNiNTWpnww273ze9U9K9cYc907Rya5gxxjeMAd7YLBK2CSAIXP8KkpCLjDKf2/tHJtLdiIOmWXVA0BIPr7poPCoRUYDUYcds6yW/20aEvONBcgNPN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pdULQm7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pdULQm7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF45C116C6;
	Tue, 10 Feb 2026 23:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766294;
	bh=g0rIbgAbeYMMUxIF53N6m1pCP8B5aMhZ6y0RYE6CQO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdULQm7YlxxLaAMhmj7ja1FCPoby0q0ML59kqr9ZOTWm/h+Px73qf//a23noUAaev
	 Y/If1Lh2Igjc3IPguQ5wATxR6jYirJLfYezWtPlMC614mC0r0HykkDCZZvgELruHIh
	 0JRm8Sfbp9je0VLyewOycPLYsVfDlHiF17pfyU9FjOdWBwqe3/ulJIKnnMYaM/TBo8
	 z++iMj1u1RnhltMtUsJkS0v4lpXDjQJv0qjoyTGXBgX5UyqSGN39tpcDXyGRKGePqQ
	 J03sbGj03zj0x49vpu4IkP3mwxZGOYL6GMOhBuGfq9dnEV+llOZjw1pOkt8F+P3hTO
	 CJpldCdMau3bQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	jarkko.nikula@linux.intel.com,
	billy_tsai@aspeedtech.com,
	quic_msavaliy@quicinc.com,
	wsa+renesas@sang-engineering.com
Subject: [PATCH AUTOSEL 6.19-6.12] i3c: mipi-i3c-hci: Ensure proper bus clean-up
Date: Tue, 10 Feb 2026 18:30:50 -0500
Message-ID: <20260210233123.2905307-5-sashal@kernel.org>
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

[ Upstream commit 8bb96575883d3b201ce37046b3903ea1d2d50bbc ]

Wait for the bus to fully disable before proceeding, ensuring that no
operations are still in progress.  Synchronize the IRQ handler only after
interrupt signals have been disabled.  This approach also handles cases
where bus disable might fail, preventing race conditions and ensuring a
consistent shutdown sequence.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. `readx_poll_timeout` has been used in this file since its
introduction. The new `i3c_hci_bus_disable()` function uses the same
pattern. No compatibility issue.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly states the intent: "ensuring that no
operations are still in progress", "Synchronize the IRQ handler only
after interrupt signals have been disabled", "preventing race conditions
and ensuring a consistent shutdown sequence." This is unambiguously a
race condition and shutdown ordering fix.

**Author**: Adrian Hunter (Intel), a prolific and trusted kernel
developer.
**Reviewer**: Frank Li (NXP), an I3C subsystem reviewer.
**Maintainer**: Merged by Alexandre Belloni, the I3C subsystem
maintainer.

### 2. CODE CHANGE ANALYSIS - The Race Conditions

**Bug 1: Bus not fully disabled before cleanup**

The OLD `i3c_hci_bus_cleanup()` does:

```155:165:/home/sasha/linux-
autosel/drivers/i3c/master/mipi-i3c-hci/core.c
static void i3c_hci_bus_cleanup(struct i3c_master_controller *m)
{
        struct i3c_hci *hci = to_i3c_hci(m);
        struct platform_device *pdev =
to_platform_device(m->dev.parent);

        reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE);
        synchronize_irq(platform_get_irq(pdev, 0));
        hci->io->cleanup(hci);
        if (hci->cmd == &mipi_i3c_hci_cmd_v1)
                mipi_i3c_hci_dat_v1.cleanup(hci);
}
```

`reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE)` merely writes to the
register. The hardware may still be mid-operation. Without waiting for
hardware acknowledgment, the subsequent cleanup proceeds on a bus that
is still active, which can cause undefined hardware behavior.

The new `i3c_hci_bus_disable()` uses `readx_poll_timeout()` with a
generous 500ms timeout to wait until the `HC_CONTROL_BUS_ENABLE` bit is
confirmed cleared by the hardware, ensuring the bus has truly stopped.

**Bug 2: Use-after-free race in DMA cleanup path**

This is the critical bug. The old flow is:

1. `reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE)` - request bus disable
2. `synchronize_irq()` - waits for any currently-running IRQ handler to
   finish
3. `hci_dma_cleanup()` starts - iterates rings, disabling per-ring
   interrupt signals and freeing DMA buffers in the **same loop**

The race: `synchronize_irq()` only guarantees the *currently running*
handler has finished. It does **not** prevent new interrupts from
arriving. Since the top-level `INTR_SIGNAL_ENABLE` register is still
armed (it's only cleared inside `io->cleanup()`), the hardware can
deliver a new interrupt *after* `synchronize_irq()` returns.

If that happens, `i3c_hci_irq_handler()` runs, calls
`hci_dma_irq_handler()`, which accesses `rings->headers[i]` (including
`rh->ibi_status`, `rh->resp`, `rh->xfer`) - DMA memory that
`hci_dma_cleanup()` may be concurrently freeing with
`dma_free_coherent()`. This is a **use-after-free**.

The fix splits the DMA cleanup loop: first loop disables all ring
interrupt signals and ring control, then calls
`i3c_hci_sync_irq_inactive()` (which disables top-level interrupt
signals AND synchronize_irq), and only then the second loop frees DMA
resources.

**Bug 3: Same race in PIO cleanup path**

The `hci_pio_irq_handler()` accesses `pio->lock`, `pio->enabled_irqs`,
and other `hci_pio_data` fields. If an interrupt fires after
`synchronize_irq()` but before `hci_pio_cleanup()` disables PIO signals
and frees `pio`, the handler will access freed memory.

The fix inserts `i3c_hci_sync_irq_inactive()` after disabling PIO
interrupt signals and before freeing the `pio` structure.

### 3. CLASSIFICATION

This is a **race condition fix** preventing **use-after-free** during
driver cleanup/shutdown. It falls squarely in the category of fixes that
should be backported to stable.

### 4. SCOPE AND RISK ASSESSMENT

- **Files changed**: 4 files, all within the same driver
- **Lines added**: ~40 lines of new code (two helper functions + loop
  restructuring)
- **Lines removed**: ~5 lines
- **Complexity**: Moderate but well-contained
- **Risk**: LOW - changes only affect the cleanup/shutdown path, using
  established kernel patterns (`readx_poll_timeout`, `synchronize_irq`)
- **Subsystem**: I3C bus driver used by Intel and AMD hardware (active,
  maintained)

### 5. USER IMPACT

- Affects users with MIPI I3C HCI hardware (Intel, AMD platforms via
  ACPI)
- The bug could trigger during driver removal (module unload), system
  shutdown, or suspend/resume cycles
- Consequence if triggered: kernel crash, memory corruption, or
  undefined behavior from use-after-free
- The AMD ACPI entry `AMDI5017` shows this driver is used on real
  production hardware

### 6. STABILITY INDICATORS

- **Reviewed-by**: Frank Li (NXP) - I3C expert
- **Merged by**: Alexandre Belloni - I3C maintainer
- Already in mainline (v6.19)

### 7. DEPENDENCY CHECK

The commit is **self-contained**:
- New functions `i3c_hci_bus_disable()` and
  `i3c_hci_sync_irq_inactive()` are introduced and used only within this
  commit
- Uses `readx_poll_timeout()` and `synchronize_irq()` which exist in all
  stable kernels
- `<linux/iopoll.h>` is already included in `core.c`
- No dependency on other patches from the series (the other patches in
  the series appear to be PCI-related, not core driver changes)

### 8. BACKPORT CONSIDERATIONS

For older stable trees that lack `9e23897bca622` ("Use physical device
pointer with DMA API"), the `dma_free_coherent` calls in
`hci_dma_cleanup` use `&hci->master.dev` instead of `rings->sysdev`.
However, this is in the *unchanged* part of the code (the second loop),
so it should apply cleanly or with minimal context adjustment.

### Final Assessment

This commit fixes a real race condition that can cause use-after-free
during driver shutdown/cleanup in the MIPI I3C HCI driver. The bug
mechanism is clear: interrupt handlers can fire after
`synchronize_irq()` returns because interrupt signal enable registers
weren't disabled first, leading to concurrent access of memory being
freed. The fix is well-structured, properly orders the shutdown sequence
(disable signals -> synchronize IRQ -> free resources), and is self-
contained with low regression risk.

**YES**

 drivers/i3c/master/mipi-i3c-hci/core.c | 32 +++++++++++++++++++++++---
 drivers/i3c/master/mipi-i3c-hci/dma.c  |  7 ++++++
 drivers/i3c/master/mipi-i3c-hci/hci.h  |  1 +
 drivers/i3c/master/mipi-i3c-hci/pio.c  |  2 ++
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 607d77ab0e546..0a4d8c9968c9b 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -152,13 +152,39 @@ static int i3c_hci_bus_init(struct i3c_master_controller *m)
 	return 0;
 }
 
+/* Bus disable should never fail, so be generous with the timeout */
+#define BUS_DISABLE_TIMEOUT_US (500 * USEC_PER_MSEC)
+
+static int i3c_hci_bus_disable(struct i3c_hci *hci)
+{
+	u32 regval;
+	int ret;
+
+	reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE);
+
+	/* Ensure controller is disabled */
+	ret = readx_poll_timeout(reg_read, HC_CONTROL, regval,
+				 !(regval & HC_CONTROL_BUS_ENABLE), 0, BUS_DISABLE_TIMEOUT_US);
+	if (ret)
+		dev_err(&hci->master.dev, "%s: Failed to disable bus\n", __func__);
+
+	return ret;
+}
+
+void i3c_hci_sync_irq_inactive(struct i3c_hci *hci)
+{
+	struct platform_device *pdev = to_platform_device(hci->master.dev.parent);
+	int irq = platform_get_irq(pdev, 0);
+
+	reg_write(INTR_SIGNAL_ENABLE, 0x0);
+	synchronize_irq(irq);
+}
+
 static void i3c_hci_bus_cleanup(struct i3c_master_controller *m)
 {
 	struct i3c_hci *hci = to_i3c_hci(m);
-	struct platform_device *pdev = to_platform_device(m->dev.parent);
 
-	reg_clear(HC_CONTROL, HC_CONTROL_BUS_ENABLE);
-	synchronize_irq(platform_get_irq(pdev, 0));
+	i3c_hci_bus_disable(hci);
 	hci->io->cleanup(hci);
 	if (hci->cmd == &mipi_i3c_hci_cmd_v1)
 		mipi_i3c_hci_dat_v1.cleanup(hci);
diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 951abfea5a6fd..7061c44243424 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -162,6 +162,13 @@ static void hci_dma_cleanup(struct i3c_hci *hci)
 
 		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
 		rh_reg_write(RING_CONTROL, 0);
+	}
+
+	i3c_hci_sync_irq_inactive(hci);
+
+	for (i = 0; i < rings->total; i++) {
+		rh = &rings->headers[i];
+
 		rh_reg_write(CR_SETUP, 0);
 		rh_reg_write(IBI_SETUP, 0);
 
diff --git a/drivers/i3c/master/mipi-i3c-hci/hci.h b/drivers/i3c/master/mipi-i3c-hci/hci.h
index 249ccb13c9092..5add9c68434bf 100644
--- a/drivers/i3c/master/mipi-i3c-hci/hci.h
+++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
@@ -147,5 +147,6 @@ void mipi_i3c_hci_pio_reset(struct i3c_hci *hci);
 void mipi_i3c_hci_dct_index_reset(struct i3c_hci *hci);
 void amd_set_od_pp_timing(struct i3c_hci *hci);
 void amd_set_resp_buf_thld(struct i3c_hci *hci);
+void i3c_hci_sync_irq_inactive(struct i3c_hci *hci);
 
 #endif
diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index 710faa46a00fa..9bf6c3ba6bce9 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -212,6 +212,8 @@ static void hci_pio_cleanup(struct i3c_hci *hci)
 
 	pio_reg_write(INTR_SIGNAL_ENABLE, 0x0);
 
+	i3c_hci_sync_irq_inactive(hci);
+
 	if (pio) {
 		dev_dbg(&hci->master.dev, "status = %#x/%#x",
 			pio_reg_read(INTR_STATUS), pio_reg_read(INTR_SIGNAL_ENABLE));
-- 
2.51.0

