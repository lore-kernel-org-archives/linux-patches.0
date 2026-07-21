Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A146AA7B;
	Tue, 21 Jul 2026 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647956; cv=none; b=NOvVKiU0mut9S8PbOyMUUY9QnnAp4BrvFYl/u1Nsn3R7CwTbbSOgasJ5zmbrm1I50ElIQLxkC97XYiimxLUNZi9bFwNO49scWecrc4iMnldgni7o+7MUiv9RkQMOHPgooF8JDfdSlkQReUI++YrEA/Lym9bmE+TIrlkajgylDRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647956; c=relaxed/simple;
	bh=CtO0RXKrwjbBnfbG8mNfsxAt4hjaq8P6mLKmFRCwxJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYnwGtjTOFaV4AWNGgu2rEWRhGVCQPmA9okAB2p4MryMBTE4bL7DPYcgaQYFbO5SPB2kcsv9GnCxNKWIzFn8EtR07UizGgv8dfbZC8WL1A9gDNhirvwWBzKl8+0w4XJlxMQNE1VDWDok0ZzN63GOLpXlhXwwB7fcDehTAXd1AqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vpp68axJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vpp68axJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37741F000E9;
	Tue, 21 Jul 2026 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647955;
	bh=pDDQhBgPKG+pvmWNZICsvc23Z7L0GJ1k4Ip+RmqFUeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vpp68axJmxyAh4BGXDvup8uNUCz4rIqjX4thKPBmdAWKy2ovbQKlJyI6Ig66+p84z
	 KmtRTjeCn1hXAZkRdxKjadyziDnxdmLxVCVmcLtens9UGk0urdzWisAMk7N9iTzJm7
	 zuEshsv+wwfV/VLqyPF3VmCFaMR36HW5BSeeZaUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 7.1 0018/2077] serial: msm: Disable DMA for kernel console UART
Date: Tue, 21 Jul 2026 16:54:51 +0200
Message-ID: <20260721152553.098180645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1228,7 +1228,8 @@ static int msm_startup(struct uart_port
 	data |= MSM_UART_MR1_AUTO_RFR_LEVEL0 & rfr_level;
 	msm_write(port, data, MSM_UART_MR1);
 
-	if (msm_port->is_uartdm) {
+	/* Disable DMA for console to prevent PIO/DMA collisions */
+	if (msm_port->is_uartdm && !uart_console(port)) {
 		msm_request_tx_dma(msm_port, msm_port->uart.mapbase);
 		msm_request_rx_dma(msm_port, msm_port->uart.mapbase);
 	}


