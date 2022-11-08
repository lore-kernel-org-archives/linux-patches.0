Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0973D15CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1AEC433D7;
	Tue,  8 Nov 2022 13:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915459;
	bh=AAi3mNthKu1SydxaMODeLKsBYK6OFmkCj5K5ejLfbho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXnxkfAirNCI/syU1KB7rNN/72kC0EkA/p+2q29G2D7Z69IehtlSa670W+64yTahC
	 gN1uSqmHzI0A6RO1d18/l38OaGTpl4cxe7Sxb67Xy6eABIvrEQKEGaX0FwGiZmGqmk
	 D4oDdr/Ji3vvb01Nd9pD12R8vFSShyi890yajpIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Han Xu <han.xu@nxp.com>,
	=?UTF-8?q?Tomasz=20Mo=C5=84?= <tomasz.mon@camlingroup.com>,
	Richard Weinberger <richard@nod.at>,
	Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH 5.4 69/74] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times
Date: Tue,  8 Nov 2022 14:39:37 +0100
Message-Id: <20221108133336.572824033@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 0fddf9ad06fd9f439f137139861556671673e31c upstream.

06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
though: It is calculated based on the maximum page read time, but the
timeout is also used for page write and block erase operations which
require orders of magnitude bigger timeouts.

Fix this by calculating busy_timeout_cycles from the maximum of
tBERS_max and tPROG_max.

This is for now the easiest and most obvious way to fix the driver.
There's room for improvements though: The NAND_OP_WAITRDY_INSTR tells us
the desired timeout for the current operation, so we could program the
timeout dynamically for each operation instead of setting a fixed
timeout. Also we could wire up the interrupt handler to actually detect
and forward timeouts occurred when waiting for the chip being ready.

As a sidenote I verified that the change in 06781a5026350 is really
correct. I wired up the interrupt handler in my tree and measured the
time between starting the operation and the timeout interrupt handler
coming in. The time increases 41us with each step in the timeout
register which corresponds to 4096 clock cycles with the 99MHz clock
that I have.

Fixes: 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout setting")
Fixes: b1206122069aa ("mtd: rawniand: gpmi: use core timings instead of an empirical derivation")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Han Xu <han.xu@nxp.com>
Tested-by: Tomasz Moń <tomasz.mon@camlingroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -652,8 +652,9 @@ static void gpmi_nfc_compute_timings(str
 	unsigned int tRP_ps;
 	bool use_half_period;
 	int sample_delay_ps, sample_delay_factor;
-	u16 busy_timeout_cycles;
+	unsigned int busy_timeout_cycles;
 	u8 wrn_dly_sel;
+	u64 busy_timeout_ps;
 
 	if (sdr->tRC_min >= 30000) {
 		/* ONFI non-EDO modes [0-3] */
@@ -677,7 +678,8 @@ static void gpmi_nfc_compute_timings(str
 	addr_setup_cycles = TO_CYCLES(sdr->tALS_min, period_ps);
 	data_setup_cycles = TO_CYCLES(sdr->tDS_min, period_ps);
 	data_hold_cycles = TO_CYCLES(sdr->tDH_min, period_ps);
-	busy_timeout_cycles = TO_CYCLES(sdr->tWB_max + sdr->tR_max, period_ps);
+	busy_timeout_ps = max(sdr->tBERS_max, sdr->tPROG_max);
+	busy_timeout_cycles = TO_CYCLES(busy_timeout_ps, period_ps);
 
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |


