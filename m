Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE1F4595B;
	Mon, 14 Oct 2024 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916456; cv=none; b=XJGmQRcPUcaH85x1szHDiMv8Xrkf83MqjTvP0dUjPpwl3m6zpujbj9lnkomG21WuDlqACwIdsTYw1ea5LIXGJLw6hvxPlbBEz6NC1oGPI8UWiINrivXyZvD6Plg4sQrtem3QcuPeMAXqhBecu8ivcj6Ugx7nd1eXLYLQZdGEdT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916456; c=relaxed/simple;
	bh=/zMGcg4jOxOjcZ0krdqfBHc930gicD9wCXuPs3TNA48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEkhyWxeTo9iY8OmtiDvnBBIoFC2xg3O8VJYVsbCw3YAPKYCQhZxQjeMBMs7IwayE3bdVKmS54i29QpiFaPQZLjtb8u2Ds9mHSJEogmclq9S5R/8hB8Pq+ZVZeDqFFPT6rLrXqJgtdOyJDqhEPDlB+iu7bJ/xV7yFkn0pE6ezFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIeF0aZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIeF0aZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA77C4CEC3;
	Mon, 14 Oct 2024 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916455;
	bh=/zMGcg4jOxOjcZ0krdqfBHc930gicD9wCXuPs3TNA48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIeF0aZRyU5mRiU5gB8LGUNfHnGTl9ooKCuBDpavkYI/4Vv7dLgyrjHsWdNetjnfL
	 O7IIgMw2oqxK92dvGmC8WF5OE1WOpJ0pad5HERN8g387xRUEOuHNcvfzq0S/QaBFaL
	 b9OvVsqKdWJ2cPI8Ud3GdgQAhKF7Xj2qmNmpA+7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 188/214] mmc: sdhci-of-dwcmshc: Prevent stale command interrupt handling
Date: Mon, 14 Oct 2024 16:20:51 +0200
Message-ID: <20241014141052.315236971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wilczynski <m.wilczynski@samsung.com>

commit 27e8fe0da3b75520edfba9cee0030aeb5aef1505 upstream.

While working with the T-Head 1520 LicheePi4A SoC, certain conditions
arose that allowed me to reproduce a race issue in the sdhci code.

To reproduce the bug, you need to enable the sdio1 controller in the
device tree file
`arch/riscv/boot/dts/thead/th1520-lichee-module-4a.dtsi` as follows:

&sdio1 {
	bus-width = <4>;
	max-frequency = <100000000>;
	no-sd;
	no-mmc;
	broken-cd;
	cap-sd-highspeed;
	post-power-on-delay-ms = <50>;
	status = "okay";
	wakeup-source;
	keep-power-in-suspend;
};

When resetting the SoC using the reset button, the following messages
appear in the dmesg log:

[    8.164898] mmc2: Got command interrupt 0x00000001 even though no
command operation was in progress.
[    8.174054] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
[    8.180503] mmc2: sdhci: Sys addr:  0x00000000 | Version:  0x00000005
[    8.186950] mmc2: sdhci: Blk size:  0x00000000 | Blk cnt:  0x00000000
[    8.193395] mmc2: sdhci: Argument:  0x00000000 | Trn mode: 0x00000000
[    8.199841] mmc2: sdhci: Present:   0x03da0000 | Host ctl: 0x00000000
[    8.206287] mmc2: sdhci: Power:     0x0000000f | Blk gap:  0x00000000
[    8.212733] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x0000decf
[    8.219178] mmc2: sdhci: Timeout:   0x00000000 | Int stat: 0x00000000
[    8.225622] mmc2: sdhci: Int enab:  0x00ff1003 | Sig enab: 0x00ff1003
[    8.232068] mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000000
[    8.238513] mmc2: sdhci: Caps:      0x3f69c881 | Caps_1:   0x08008177
[    8.244959] mmc2: sdhci: Cmd:       0x00000502 | Max curr: 0x00191919
[    8.254115] mmc2: sdhci: Resp[0]:   0x00001009 | Resp[1]:  0x00000000
[    8.260561] mmc2: sdhci: Resp[2]:   0x00000000 | Resp[3]:  0x00000000
[    8.267005] mmc2: sdhci: Host ctl2: 0x00001000
[    8.271453] mmc2: sdhci: ADMA Err:  0x00000000 | ADMA Ptr:
0x0000000000000000
[    8.278594] mmc2: sdhci: ============================================

I also enabled some traces to better understand the problem:

     kworker/3:1-62      [003] .....     8.163538: mmc_request_start:
mmc2: start struct mmc_request[000000000d30cc0c]: cmd_opcode=5
cmd_arg=0x0 cmd_flags=0x2e1 cmd_retries=0 stop_opcode=0 stop_arg=0x0
stop_flags=0x0 stop_retries=0 sbc_opcode=0 sbc_arg=0x0 sbc_flags=0x0
sbc_retires=0 blocks=0 block_size=0 blk_addr=0 data_flags=0x0 tag=0
can_retune=0 doing_retune=0 retune_now=0 need_retune=0 hold_retune=1
retune_period=0
          <idle>-0       [000] d.h2.     8.164816: sdhci_cmd_irq:
hw_name=ffe70a0000.mmc quirks=0x2008008 quirks2=0x8 intmask=0x10000
intmask_p=0x18000
     irq/24-mmc2-96      [000] .....     8.164840: sdhci_thread_irq:
msg=
     irq/24-mmc2-96      [000] d.h2.     8.164896: sdhci_cmd_irq:
hw_name=ffe70a0000.mmc quirks=0x2008008 quirks2=0x8 intmask=0x1
intmask_p=0x1
     irq/24-mmc2-96      [000] .....     8.285142: mmc_request_done:
mmc2: end struct mmc_request[000000000d30cc0c]: cmd_opcode=5
cmd_err=-110 cmd_resp=0x0 0x0 0x0 0x0 cmd_retries=0 stop_opcode=0
stop_err=0 stop_resp=0x0 0x0 0x0 0x0 stop_retries=0 sbc_opcode=0
sbc_err=0 sbc_resp=0x0 0x0 0x0 0x0 sbc_retries=0 bytes_xfered=0
data_err=0 tag=0 can_retune=0 doing_retune=0 retune_now=0 need_retune=0
hold_retune=1 retune_period=0

Here's what happens: the __mmc_start_request function is called with
opcode 5. Since the power to the Wi-Fi card, which resides on this SDIO
bus, is initially off after the reset, an interrupt SDHCI_INT_TIMEOUT is
triggered. Immediately after that, a second interrupt SDHCI_INT_RESPONSE
is triggered. Depending on the exact timing, these conditions can
trigger the following race problem:

1) The sdhci_cmd_irq top half handles the command as an error. It sets
   host->cmd to NULL and host->pending_reset to true.
2) The sdhci_thread_irq bottom half is scheduled next and executes faster
   than the second interrupt handler for SDHCI_INT_RESPONSE. It clears
   host->pending_reset before the SDHCI_INT_RESPONSE handler runs.
3) The pending interrupt SDHCI_INT_RESPONSE handler gets called, triggering
   a code path that prints: "mmc2: Got command interrupt 0x00000001 even
   though no command operation was in progress."

To solve this issue, we need to clear pending interrupts when resetting
host->pending_reset. This ensures that after sdhci_threaded_irq restores
interrupts, there are no pending stale interrupts.

The behavior observed here is non-compliant with the SDHCI standard.
Place the code in the sdhci-of-dwcmshc driver to account for a
hardware-specific quirk instead of the core SDHCI code.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 43658a542ebf ("mmc: sdhci-of-dwcmshc: Add support for T-Head TH1520")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241008100327.4108895-1-m.wilczynski@samsung.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -746,6 +746,14 @@ static void th1520_sdhci_reset(struct sd
 
 	sdhci_reset(host, mask);
 
+	/* The T-Head 1520 SoC does not comply with the SDHCI specification
+	 * regarding the "Software Reset for CMD line should clear 'Command
+	 * Complete' in the Normal Interrupt Status Register." Clear the bit
+	 * here to compensate for this quirk.
+	 */
+	if (mask & SDHCI_RESET_CMD)
+		sdhci_writel(host, SDHCI_INT_RESPONSE, SDHCI_INT_STATUS);
+
 	if (priv->flags & FLAG_IO_FIXED_1V8) {
 		ctrl_2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 		if (!(ctrl_2 & SDHCI_CTRL_VDD_180)) {


