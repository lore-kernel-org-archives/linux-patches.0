Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54BC143895;
	Thu, 13 Jun 2024 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279348; cv=none; b=KkXZ9Wwpr2MWqSYlzC9/qPkpZ8TUAg4hztVsNFUPeyHrbXZMDDPnr0MKxcHva1IaVpU41b0YbYHUEBIPASvbj3ga1f3J7gZZoxlX9yh/niRqnXEBNhd6GPcAVX8JvpEJdvGi6N+CsLz24m0VHgizRnOXdO0vRtZ+uQJaGsypCDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279348; c=relaxed/simple;
	bh=LjrrmZzi9+6bORYvxd/CJ94CII6rWwvOgL0rYvFEdFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdBaIyRySjEPtqZDsNEUSKlr1S2wErUrVYfft0g4xIa6yHsnNYejPhtr9O0EWs8DMNhvTJiuCaPrGy0myfX08OLMBX6KeDqzSjT0RGedWqXMv6ik56HdrCWrwlB3m1ORQzoF4qN0os0O8BQInxynl8jYcFflAuD1yhBTP1ObIsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCHALCRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCHALCRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E769C2BBFC;
	Thu, 13 Jun 2024 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279348;
	bh=LjrrmZzi9+6bORYvxd/CJ94CII6rWwvOgL0rYvFEdFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCHALCRS/rcSnhcHoPfUoI2DNrSERAXehvazA540jNNI2ww4NgrjJBY/jU26Yx9O+
	 yvuGyNdsdsD7Vg95IdL8Zg4hBDT2BcdtD6h1BWmmdqMIh3365pvNEBRvIY3fM3u0/B
	 U63BYbpWLM76n5LlDSyCndGkT7V9Rmu78fJMqFCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 045/157] mmc: sdhci: Add support for "Tuning Error" interrupts
Date: Thu, 13 Jun 2024 13:32:50 +0200
Message-ID: <20240613113229.169243141@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit b3855668d98cf9c6aec2db999dd27d872f8ba878 upstream.

Most Bay Trail devices do not enable UHS modes for the external sdcard slot
the Lenovo Yoga Tablet 2 830 / 1050 and Lenovo Yoga Tablet 2 Pro 1380 (8",
10" and 13") models however do enable this.

Using a UHS cards in these tablets results in errors like this one:

[  225.272001] mmc2: Unexpected interrupt 0x04000000.
[  225.272024] mmc2: sdhci: ============ SDHCI REGISTER DUMP ===========
[  225.272034] mmc2: sdhci: Sys addr:  0x0712c400 | Version:  0x0000b502
[  225.272044] mmc2: sdhci: Blk size:  0x00007200 | Blk cnt:  0x00000007
[  225.272054] mmc2: sdhci: Argument:  0x00000000 | Trn mode: 0x00000023
[  225.272064] mmc2: sdhci: Present:   0x01e20002 | Host ctl: 0x00000016
[  225.272073] mmc2: sdhci: Power:     0x0000000f | Blk gap:  0x00000000
[  225.272082] mmc2: sdhci: Wake-up:   0x00000000 | Clock:    0x00000107
[  225.272092] mmc2: sdhci: Timeout:   0x0000000e | Int stat: 0x00000001
[  225.272101] mmc2: sdhci: Int enab:  0x03ff000b | Sig enab: 0x03ff000b
[  225.272110] mmc2: sdhci: ACmd stat: 0x00000000 | Slot int: 0x00000001
[  225.272119] mmc2: sdhci: Caps:      0x076864b2 | Caps_1:   0x00000004
[  225.272129] mmc2: sdhci: Cmd:       0x00000c1b | Max curr: 0x00000000
[  225.272138] mmc2: sdhci: Resp[0]:   0x00000c00 | Resp[1]:  0x00000000
[  225.272147] mmc2: sdhci: Resp[2]:   0x00000000 | Resp[3]:  0x00000900
[  225.272155] mmc2: sdhci: Host ctl2: 0x0000000c
[  225.272164] mmc2: sdhci: ADMA Err:  0x00000003 | ADMA Ptr: 0x0712c200
[  225.272172] mmc2: sdhci: ============================================

which results in IO errors leading to issues accessing the sdcard.

0x04000000 is a so-called "Tuning Error" which sofar the SDHCI driver
does not support / enable. Modify the IRQ handler to process these.

This fixes UHS microsd cards not working with these tablets.

Link: https://lore.kernel.org/r/199bb4aa-c6b5-453e-be37-58bbf468800c@intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410191639.526324-3-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   10 ++++++++--
 drivers/mmc/host/sdhci.h |    3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3439,12 +3439,18 @@ static void sdhci_data_irq(struct sdhci_
 		host->data->error = -EILSEQ;
 		if (!mmc_op_tuning(SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND))))
 			sdhci_err_stats_inc(host, DAT_CRC);
-	} else if ((intmask & SDHCI_INT_DATA_CRC) &&
+	} else if ((intmask & (SDHCI_INT_DATA_CRC | SDHCI_INT_TUNING_ERROR)) &&
 		SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND))
 			!= MMC_BUS_TEST_R) {
 		host->data->error = -EILSEQ;
 		if (!mmc_op_tuning(SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND))))
 			sdhci_err_stats_inc(host, DAT_CRC);
+		if (intmask & SDHCI_INT_TUNING_ERROR) {
+			u16 ctrl2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);
+
+			ctrl2 &= ~SDHCI_CTRL_TUNED_CLK;
+			sdhci_writew(host, ctrl2, SDHCI_HOST_CONTROL2);
+		}
 	} else if (intmask & SDHCI_INT_ADMA_ERROR) {
 		pr_err("%s: ADMA error: 0x%08x\n", mmc_hostname(host->mmc),
 		       intmask);
@@ -3979,7 +3985,7 @@ bool sdhci_cqe_irq(struct sdhci_host *ho
 	} else
 		*cmd_error = 0;
 
-	if (intmask & (SDHCI_INT_DATA_END_BIT | SDHCI_INT_DATA_CRC)) {
+	if (intmask & (SDHCI_INT_DATA_END_BIT | SDHCI_INT_DATA_CRC | SDHCI_INT_TUNING_ERROR)) {
 		*data_error = -EILSEQ;
 		if (!mmc_op_tuning(SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND))))
 			sdhci_err_stats_inc(host, DAT_CRC);
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -158,6 +158,7 @@
 #define  SDHCI_INT_BUS_POWER	0x00800000
 #define  SDHCI_INT_AUTO_CMD_ERR	0x01000000
 #define  SDHCI_INT_ADMA_ERROR	0x02000000
+#define  SDHCI_INT_TUNING_ERROR	0x04000000
 
 #define  SDHCI_INT_NORMAL_MASK	0x00007FFF
 #define  SDHCI_INT_ERROR_MASK	0xFFFF8000
@@ -169,7 +170,7 @@
 		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL | \
 		SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_DATA_CRC | \
 		SDHCI_INT_DATA_END_BIT | SDHCI_INT_ADMA_ERROR | \
-		SDHCI_INT_BLK_GAP)
+		SDHCI_INT_BLK_GAP | SDHCI_INT_TUNING_ERROR)
 #define SDHCI_INT_ALL_MASK	((unsigned int)-1)
 
 #define SDHCI_CQE_INT_ERR_MASK ( \


