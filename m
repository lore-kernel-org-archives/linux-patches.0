Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C3B1E570F;
	Mon, 21 Oct 2024 10:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506825; cv=none; b=GzTycDTAemSOPSTU7ig83KO48CUlZLBlArBMjAuQzMXHZ3VK5iU8MOS7pnqJrjBQKrF47G3yDK8RVFbIN7RjwJqUYwQTTxc4k4cylLOf2pYpJKfDkzQHnKu42g2ZushzuYyqa8awCSYjOKyUgIwL1i0DQ/HveGlXoBHUk42m7ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506825; c=relaxed/simple;
	bh=A6HOkGpDJ2XdWiiKLMPLhaJe287yHtqTlm7eAhNF4YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVMT3zK2kSd24py4wEPRK89gI4NuhdCpnl+cgtMMcj2R3VALavTa89jzvRsubFIp0Jar6cLB803hMqsClZuKRYmYMpV8w9Lib9qLZ6xNTKYQSwNebhLK+Yaiv+JLmX01VfaMLQBPBMAmInflUm8jhh3nBMNvsIIG1soAGtY4A3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRe+/HQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRe+/HQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6019DC4CEC3;
	Mon, 21 Oct 2024 10:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506824;
	bh=A6HOkGpDJ2XdWiiKLMPLhaJe287yHtqTlm7eAhNF4YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRe+/HQX8p7ueqkZ8FnoxNfqCRM2uZfG2rYzsbiltYp834OtIAQC/sn2wTa+HMRXy
	 SIyInz/aMOpHgOU1o/Tx9PROjDwvYE5q07b99NFZq0GoAc2tWZ/jkVNwjdTbhBQDWC
	 41JS30M5b8pOKshdaTMAwUJTi78wLWJcSiP8feFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.11 132/135] serial: qcom-geni: fix dma rx cancellation
Date: Mon, 21 Oct 2024 12:24:48 +0200
Message-ID: <20241021102304.513268002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 23ee4a25661c33e6381d41e848a9060ed6d72845 upstream.

Make sure to wait for the DMA transfer to complete when cancelling the
rx command on stop_rx(). This specifically prevents the DMA completion
interrupt from firing after rx has been restarted, something which can
lead to an IOMMU fault and hosed rx when the interrupt handler unmaps
the DMA buffer for the new command:

	qcom_geni_serial 988000.serial: serial engine reports 0 RX bytes in!
	arm-smmu 15000000.iommu: FSR    = 00000402 [Format=2 TF], SID=0x563
	arm-smmu 15000000.iommu: FSYNR0 = 00210013 [S1CBNDX=33 WNR PLVL=3]
	Bluetooth: hci0: command 0xfc00 tx timeout
	Bluetooth: hci0: Reading QCA version information failed (-110)

Also add the missing state machine reset which is needed in case
cancellation fails.

Fixes: 2aaa43c70778 ("tty: serial: qcom-geni-serial: add support for serial engine DMA")
Cc: stable@vger.kernel.org      # 6.3
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241009145110.16847-5-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -787,17 +787,27 @@ static void qcom_geni_serial_start_rx_fi
 static void qcom_geni_serial_stop_rx_dma(struct uart_port *uport)
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
+	bool done;
 
 	if (!qcom_geni_serial_secondary_active(uport))
 		return;
 
 	geni_se_cancel_s_cmd(&port->se);
-	qcom_geni_serial_poll_bit(uport, SE_GENI_S_IRQ_STATUS,
-				  S_CMD_CANCEL_EN, true);
-
-	if (qcom_geni_serial_secondary_active(uport))
+	done = qcom_geni_serial_poll_bit(uport, SE_DMA_RX_IRQ_STAT,
+			RX_EOT, true);
+	if (done) {
+		writel(RX_EOT | RX_DMA_DONE,
+				uport->membase + SE_DMA_RX_IRQ_CLR);
+	} else {
 		qcom_geni_serial_abort_rx(uport);
 
+		writel(1, uport->membase + SE_DMA_RX_FSM_RST);
+		qcom_geni_serial_poll_bit(uport, SE_DMA_RX_IRQ_STAT,
+				RX_RESET_DONE, true);
+		writel(RX_RESET_DONE | RX_DMA_DONE,
+				uport->membase + SE_DMA_RX_IRQ_CLR);
+	}
+
 	if (port->rx_dma_addr) {
 		geni_se_rx_dma_unprep(&port->se, port->rx_dma_addr,
 				      DMA_RX_BUF_SIZE);


