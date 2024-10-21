Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72C31E1C11;
	Mon, 21 Oct 2024 10:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507186; cv=none; b=OHTgSojuoEU0TFkwcWvP8X2xAoHJbYJAD3W8rGAjHnNGi7U8h7XTU8eXxE5a4rJeHPRhO56Fi/kEfpPARQ/lGPIaHenf4Gz4fNXqMxg4YmX86Fs0IuVjZGH0axaumC4jx9LNHkxgvcZ6bIuR93gxbrXDPXe5GNShkxb1c92MKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507186; c=relaxed/simple;
	bh=4SnHs0bsSCq0sNtcovA2EAuHNnmHESBrTDttcQ89er4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP9vY5NHz0KJO7wOLuP4W5yBNLq6Y5k41s3/rL53MPPd/SgB6JWQBJewtRgCEIeQjRHR3zTzj9txb2KF67yJobkqchgeT9stcf8yas6Me+JMxAnEkhtGEu9bc3vFqTqEKh7Nm77RAtfUXxNi6mLXoZ50ojXxpr5ous5FQLmDZ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxmUTZ6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxmUTZ6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D84C4CEC3;
	Mon, 21 Oct 2024 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507186;
	bh=4SnHs0bsSCq0sNtcovA2EAuHNnmHESBrTDttcQ89er4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxmUTZ6iCH6itISpjh1J/IFg9N2OCDXkHJKtLKF4VxQPwTI2Vi19FdOe+P7PGr9I9
	 U5h3AHRja68dyH7CyNP3hy/Y1pVyTJkrRZAPRVQ8jVVYbeHxqiOrq5DwF1OQYQCzuF
	 IRRu2DUlULJeARIa+5UBNxCUqlzN4KH6Y48OWY78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.6 117/124] serial: qcom-geni: fix dma rx cancellation
Date: Mon, 21 Oct 2024 12:25:21 +0200
Message-ID: <20241021102301.242807018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -775,17 +775,27 @@ static void qcom_geni_serial_start_rx_fi
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


