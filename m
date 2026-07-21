Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA92F43C06B;
	Tue, 21 Jul 2026 22:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671352; cv=none; b=rFpvE/BGAVGClGxnDVVEPAe/mf9x/tXnLZgqPAFpgT9kBc3P+ZOfIbm8nhuTVq31NTs9rn+YOhU3SObwwcWeFnDCx14kd4IBeKDcdL6fca9rKxwnpHn2yjdGqmqs9881Bo7gPlFx0hZGs4gNfKbcrNlgbo6VFXY+EWRTe5ZjZ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671352; c=relaxed/simple;
	bh=q+5aVf1FFhUsrueWODUqoVFt1xBV490Gy4IU4/f6R+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UN6VuWSSl6igaY1ly6wPlhhcn0xs6iMOOYl3J4tn2ZhyVGWK2JSg1B4YumzGBO9JArIZvTUJb9Xq7fyxjHVdvdiqxJPVUkTEk9PzTDy2ff9fR5ckcEaprzHzvJY5/h4je9LiR6pgSWk9PUSeoBcv4CfZhmX3SMWGB+8lzs065Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OC945UF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OC945UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FFC1F00A3A;
	Tue, 21 Jul 2026 22:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671350;
	bh=oTyD5wOiCqmXNDRf1gsZG7IkNXBkAn2LbzJ8lHRpXLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OC945UFfCeU3mAI0nl5D+BHJXmec6XZMCxal3jyMxpV7PjWhBCqwqu0gWOav1eRY
	 Hr4vJaNHNWJ8AD4N7RNIE0Sws5vISFVp7k/3pnax8zM/MlcuvDyRag6jF2GPSc2XxJ
	 qRigmnNNmWakizAxfGw6D1osZCzc6lobkINn+UT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 5.15 211/843] serial: msm: Disable DMA for kernel console UART
Date: Tue, 21 Jul 2026 17:17:26 +0200
Message-ID: <20260721152410.765766816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1211,7 +1211,8 @@ static int msm_startup(struct uart_port
 	data |= UART_MR1_AUTO_RFR_LEVEL0 & rfr_level;
 	msm_write(port, data, UART_MR1);
 
-	if (msm_port->is_uartdm) {
+	/* Disable DMA for console to prevent PIO/DMA collisions */
+	if (msm_port->is_uartdm && !uart_console(port)) {
 		msm_request_tx_dma(msm_port, msm_port->uart.mapbase);
 		msm_request_rx_dma(msm_port, msm_port->uart.mapbase);
 	}


