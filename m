Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FE46F490;
	Tue, 21 Jul 2026 20:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665567; cv=none; b=tCSqZYQgmwBVln3Dx5CUV+Li7L4aAecL+p0KJiWixD3IEwxjoFbJxsV6FX1Qp6tPSvMVXZ3k9G+7gdApu528fkMe5P/SRcUCHybn2+7nxoXCvtPn2B7avEdCXhXaEslARiE2T9I6URwcJ8TF0PfmgmE3saaec8cSlV+BwAS4g6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665567; c=relaxed/simple;
	bh=C7GSvypRx24wmRnht8xUgjFil80iO//UdkBLNiru/UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnG9RZkMyHvhCFlC9MhV/TdA3B6mcCxmGFMcUEOcqlidpgCIrH3FcChnwgdxsVoq7+snr/VaDLanu/mF6EK9Pak869pdDn/2ZTUeuf2NtVjisf04296nJRPdNjVnQ0M8bKI7rMTP98WiB1hbNPLzBWOyPKPWDsFEZvndhwhcZ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEAys5Td; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEAys5Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2401F00A3A;
	Tue, 21 Jul 2026 20:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665562;
	bh=1NgnN4OUK/HhWrsXh48Zybv2RxWyLRjaUDj+ifVPMSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEAys5Tdh8fx06EmPRyHtsTi6kl1mmKo3tiGUmbPwmNkkgQ8IB1Qwz1ZgZ5/jswbV
	 XfMRsNbmwAUUrXWKJW/wTAGjfBIG2ugH01YetyLmc0xuF4Pf7uYKCeMWpmAdRBStZF
	 th+ps7LhiBGHEQmVdiFHVsA0WCIAXKEHA17iHQjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.6 0350/1266] serial: msm: Disable DMA for kernel console UART
Date: Tue, 21 Jul 2026 17:13:07 +0200
Message-ID: <20260721152449.664451691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 22dd2777e6c180e1c945b00f6d18550979436324 upstream.

At the moment, concurrent writes from userspace and the kernel to the
console can trigger a race condition that results in an infinite loop of
the same messages printed over and over again. This is most likely to
happen during system startup or shutdown when the init system starts/stops
a large number of system services that interact with various kernel code.

When userspace writes to the TTY device, the driver initiates an
asynchronous DMA transfer and releases the port lock. At the same moment,
the kernel printk path might grab the port lock and re-configure the UART
controller for PIO, without waiting for the DMA operation to complete. It
seems like this collision results in zero progress being reported for the
DMA engine, so the same text is printed to the console over and over again.

For the kernel console, we want a reliable output path that will be
functional even during crashes etc. So rather than implementing complex
code to synchronize the kernel console write routines with the userspace
DMA write routines, simply disable DMA for the console UART instance.

Similar checks exist in many other serial drivers, e.g. 8250_port.c,
imx.c, sh-sci.c etc.

Cc: stable <stable@kernel.org>
Fixes: 3a878c430fd6 ("tty: serial: msm: Add TX DMA support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260706-serial-msm-console-dma-collision-v1-1-3179b8cb1d89@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/msm_serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1221,7 +1221,8 @@ static int msm_startup(struct uart_port
 	data |= MSM_UART_MR1_AUTO_RFR_LEVEL0 & rfr_level;
 	msm_write(port, data, MSM_UART_MR1);
 
-	if (msm_port->is_uartdm) {
+	/* Disable DMA for console to prevent PIO/DMA collisions */
+	if (msm_port->is_uartdm && !uart_console(port)) {
 		msm_request_tx_dma(msm_port, msm_port->uart.mapbase);
 		msm_request_rx_dma(msm_port, msm_port->uart.mapbase);
 	}


