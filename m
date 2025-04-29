Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEF82528EC;
	Tue, 29 Apr 2025 17:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947881; cv=none; b=F3f2ypvRCVuE/EPSaiGjG8fLlguUnCLv56tK6zxApQk/jERhnCpSw/h5AV+ESdtgs/e8261uBlQomzrBOyolfIdp+CSo2jvtSBtlX5TnWmVcKWZ/gu2G4QCDes41aijL0tZHdXppv4iVJzESfXYxDAtBuL2Ru+63pvN+RqxJVyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947881; c=relaxed/simple;
	bh=4iVPUqiQSRt2ne+u8W5jW6QOsCqohMfuZxeM4K1qiFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5wVdK14JvctC6t2LSngneZCblimEaW56VgRPEs49xliuVM6H7F3Ix5UTBjqa4U1olT9r6uO3yShNxlRDZAJdBmmRc3P2Cegyu34r27Sv9WuTkHo+eX8wCvASKQ5YQi2v9OBEbf4YsSZ4jllqKH6o4UYLikqKQqFsRP8asR/efw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7ZnjHSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7ZnjHSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F9FC4CEE3;
	Tue, 29 Apr 2025 17:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947880;
	bh=4iVPUqiQSRt2ne+u8W5jW6QOsCqohMfuZxeM4K1qiFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7ZnjHSam5M1/hIsAp8xfvdJ6aCbfL2EKLWfCBNdKwC6vtplG77IlPxNhlnM4DWPx
	 Vd5G8zrQe6cCAoUB0Sx9MneXj7qSDzZkqSpnhOyofYFST0eH6tQpFc8FJdt2U0zyMJ
	 igGVD4tfno1yPbsfsEBfcPTmDZOaMefK0ty3w5rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.12 131/280] serial: msm: Configure correct working mode before starting earlycon
Date: Tue, 29 Apr 2025 18:41:12 +0200
Message-ID: <20250429161120.487128090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 7094832b5ac861b0bd7ed8866c93cb15ef619996 upstream.

The MSM UART DM controller supports different working modes, e.g. DMA or
the "single-character mode", where all reads/writes operate on a single
character rather than 4 chars (32-bit) at once. When using earlycon,
__msm_console_write() always writes 4 characters at a time, but we don't
know which mode the bootloader was using and we don't set the mode either.

This causes garbled output if the bootloader was using the single-character
mode, because only every 4th character appears in the serial console, e.g.

  "[ 00oni pi  000xf0[ 00i s 5rm9(l)l s 1  1 SPMTA 7:C 5[ 00A ade k d[
   00ano:ameoi .Q1B[ 00ac _idaM00080oo'"

If the bootloader was using the DMA ("DM") mode, output would likely fail
entirely. Later, when the full serial driver probes, the port is
re-initialized and output works as expected.

Fix this also for earlycon by clearing the DMEN register and
reset+re-enable the transmitter to apply the change. This ensures the
transmitter is in the expected state before writing any output.

Cc: stable <stable@kernel.org>
Fixes: 0efe72963409 ("tty: serial: msm: Add earlycon support")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250408-msm-serial-earlycon-v1-1-429080127530@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/msm_serial.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1746,6 +1746,12 @@ msm_serial_early_console_setup_dm(struct
 	if (!device->port.membase)
 		return -ENODEV;
 
+	/* Disable DM / single-character modes */
+	msm_write(&device->port, 0, UARTDM_DMEN);
+	msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
+	msm_write(&device->port, MSM_UART_CR_CMD_RESET_TX, MSM_UART_CR);
+	msm_write(&device->port, MSM_UART_CR_TX_ENABLE, MSM_UART_CR);
+
 	device->con->write = msm_serial_early_write_dm;
 	return 0;
 }


