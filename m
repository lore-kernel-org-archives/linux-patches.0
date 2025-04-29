Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ACD40C03;
	Tue, 29 Apr 2025 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950498; cv=none; b=AF8EwARu1x4nnfflHmvi7HA230hVu6+Pj0FyGpvC2d8IR88mL2ag9y9MneCp4h+XFJWGjTrVHpBuFu1fCrHUfV8wQdA4a+t/ibtV48kbOSDE1bvBCx2T4l6QVvL2ddITO6tG1uPdx2yPAVQ+HLvoR6meo2+xcFce7a/TtUCB+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950498; c=relaxed/simple;
	bh=llpKlTk8qKJ697HB6dtHaWw65IC7skUjncQRnMfK7hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZ5Fe9M3oLxyNvjQAt5NqFcopJqUlLqCdIuYNQtH3hWlYcwMkv9Z5hUp0kRdgHAoCnXO6vUcPYHqv5D8kP1iSVYGG8fFdj+6WxrnwMFk3JRBdAGNWOm56dokDNc4BM/FWRVC+zPOH/o04+v9OdvNE20WTza4xfVQA6oy7boeoUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGxjKCI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGxjKCI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F43C4CEE3;
	Tue, 29 Apr 2025 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950497;
	bh=llpKlTk8qKJ697HB6dtHaWw65IC7skUjncQRnMfK7hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGxjKCI0ovSzK7fQ9ckH3DO2dEti8v9SF6iUR/c+QdRkK6JmP+q5FIYuU7AqR3Pcm
	 QzJQ8yOvuCTUefnArYGPmnHOnjAf8+1n5jRMSwTt+cH8zEreCoQTswPrmmR2xmyJD5
	 slajasu7dADFtwpgHZcKojI/o9GcXNByPOGpkXBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 097/204] serial: msm: Configure correct working mode before starting earlycon
Date: Tue, 29 Apr 2025 18:43:05 +0200
Message-ID: <20250429161103.404751023@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1741,6 +1741,12 @@ msm_serial_early_console_setup_dm(struct
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


