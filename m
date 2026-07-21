Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537C44AB96;
	Tue, 21 Jul 2026 21:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668696; cv=none; b=FFxSJax+ALaJbL+qdrEAVTN0mIYW2A4jK+6DpkZacsFfLtbD77S2Hkatfs+fL80CwuM+pqUEiVkFiYW3bOzZrV/xCMX9q+Ks7w07sapqMrDv9SPAub48P2R8YbRMdc3+KdJ2HOQDcVby/HQdvrOsyu+yfUK8UdaIG9DDh6td3/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668696; c=relaxed/simple;
	bh=YcRjY569pO8fE3z0l2Gk2g06B/PgyeMTFk+ABKVVhQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER98x41SXxCdSBPspaTqdeFYa5vlUVxULS4KKbhrivYj3SFmHSaD9ieR8GfVSc9vkv64AUcGhPKrwj3kdEiCv1XYdKoGi/mN5YfReC3ckYNIGAkofKgjnnDJBnarDOJlIIxXL8rCgAliYPjdRKqLsUrOv75QFSJi1hVOMSEmdoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+TIHTSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+TIHTSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5720A1F00A3A;
	Tue, 21 Jul 2026 21:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668694;
	bh=mL8CZwe92dnUbNzhk2iTaDnPN7mvCRCRiIZHwKqynV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+TIHTSVE7+fyqRHo/i6iqLqx9MpRS/BUM0zQHofThME+THi1TpyVUftwnxypYHyz
	 2teaRBSBtHpxC5kp2u1JIe1aAHnq61uhPEtuOfgaSC/3vXWix8ENR236XitHLY44mq
	 qXDnhDoBlDvkNF+w0/aPMHjL3HkKogdNTFRLejkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.1 0272/1067] serial: msm: Disable DMA for kernel console UART
Date: Tue, 21 Jul 2026 17:14:33 +0200
Message-ID: <20260721152430.679168531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1225,7 +1225,8 @@ static int msm_startup(struct uart_port
 	data |= MSM_UART_MR1_AUTO_RFR_LEVEL0 & rfr_level;
 	msm_write(port, data, MSM_UART_MR1);
 
-	if (msm_port->is_uartdm) {
+	/* Disable DMA for console to prevent PIO/DMA collisions */
+	if (msm_port->is_uartdm && !uart_console(port)) {
 		msm_request_tx_dma(msm_port, msm_port->uart.mapbase);
 		msm_request_rx_dma(msm_port, msm_port->uart.mapbase);
 	}


