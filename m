Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B42326D44;
	Tue, 21 Jul 2026 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655508; cv=none; b=cqvVMbewXwS8ewbmXOsCOXbCdb0nxLYKaKGPNPeDjDkCr/MJPBn0QrXsX68ycoEaAfXnNtZ++lDDbdmyuy3/5IwOHri2v7z9Q1e/rifi509IHilusTO/1DeGlsZxg8U/CWtPBuMUQQe1AUwlqalzVYb+ENE1sYxpAvMp45W5Pdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655508; c=relaxed/simple;
	bh=w+GjiPber8C1kqR2ks7bydVxoLslRp7Ux499uTfJAKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpgJFduOLZ8vvOO6MudIxzz7lo38M7xvFDiJXOqMaPRF2ezgA0LzNQh2ESSEZg6gzZ8g3xCiMHUrTDhM1zah9s61huY7bw1W6iVk4YuUpSp8X5iL3LHfAWA5T8WgA5QeC20OqBE4z9lzOt2b+U466n/YE0CnPBP8AMzNHXXTuRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hypdZpNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hypdZpNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D421E1F000E9;
	Tue, 21 Jul 2026 17:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655507;
	bh=uqsKZjfQFh+3L+wAqvS4GhKI6jkgBlPg5NOiXt0flFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hypdZpNXgpcBdbM0sa3qLdGcSN5LMinl/Dt/kq5mxr4vcwKeHvAIADI7Zl4q/FrHw
	 /MjaDVZCe8OaU8z7VWBifFf8lfpCpRWDWiEbf/FCaDGWhBBEJd5whTaeDgaPhJdvc+
	 GruuqxxMu0iDu5RcFgGgVlD+ynC5mmKwEqF+/pGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.18 0034/1611] serial: msm: Disable DMA for kernel console UART
Date: Tue, 21 Jul 2026 17:02:30 +0200
Message-ID: <20260721152515.582309716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


