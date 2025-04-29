Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2265140C03;
	Tue, 29 Apr 2025 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949856; cv=none; b=Rou/BlawKoQPP6iwn0gNxkQEpAs893tCjB7CH6vHfw7Ndu+Ugj2sc8S5ANmZYMeOtS9RJWr20fy86NyNr3y++fxue7ne9Mq9oI7Wb52l8TaU7jt/XAdajWXRWNhKmrCM9La09F8aiflhiWsb6cZSl5nGK1KF4QcmrevS7kcgDcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949856; c=relaxed/simple;
	bh=Vmxr6UXotwFP6465Q052XHoi939DDh7Jiq0LdYadMnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAgoBxgHn7xXmEwHSc1qlJkhV1kkOsXGeP4PKRkgjzpi5SVpxnSeubQOxpPozH32LsG4szMzlxrm9MZBfmlI6Cjh37JruB21CQrj4/uLk3AIFpeUzTMzGthavRz50jFlCmsN+dDfE0ZBLwoW9acG7F3WsqG98uXGwWd/gytqkDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQZc7LQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQZc7LQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ABBC4CEE3;
	Tue, 29 Apr 2025 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949856;
	bh=Vmxr6UXotwFP6465Q052XHoi939DDh7Jiq0LdYadMnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQZc7LQchtD11Umn2ASrDAf9UvOsxxFhCcNWWvQMmYTiTt2AaIfeyTNb0p67pXt4P
	 K6lflcW63LqNHIKTJ3trnWNR7qMkCh89as+XCgvl4y8QHGShw2IuAzFy6VURkBtu+s
	 U6flFODATSFn6fYAuQO9sGTp1rTAF8DVH5zhOJec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 078/167] serial: msm: Configure correct working mode before starting earlycon
Date: Tue, 29 Apr 2025 18:43:06 +0200
Message-ID: <20250429161054.920265308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1745,6 +1745,12 @@ msm_serial_early_console_setup_dm(struct
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


