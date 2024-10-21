Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9981E5735;
	Mon, 21 Oct 2024 10:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507133; cv=none; b=W5dKiytbkgvfx3IRzqY0DagJAXZQii2eVnFB9z9/KOrXo6DQhlhYlR4cqxRcekVa1T8i+E+EH0QpYuNs7aSC7Bb+4tTPGptdeYt01U9wVqPiW6yE4qr0dzUfOWSnhti20Fis4FMme0LcIJ2PXjZzhdK8rZqW1nevObSARVbWYfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507133; c=relaxed/simple;
	bh=bpU4gt8YJH5W/XWeK2sC7lNosuCvtmaRfIHTbZ6wwV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toqieSV2SopTjcGFWU3BLncsObGygkKqsSPe9mHqcZOy7aZu1z1LHkN5nPLpLAjwpGi+3bLEVfb1bK2blXpwF8HQ7S1yaBCKN0l7wX71y1kPzEyaA50P7b0R85KUXyQc8VjyiPNJnTptFyK2rH8xGA1giCnZJiXDpuHmASSkSfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE9WNXbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE9WNXbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570DCC4CEC3;
	Mon, 21 Oct 2024 10:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507132;
	bh=bpU4gt8YJH5W/XWeK2sC7lNosuCvtmaRfIHTbZ6wwV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE9WNXbeRLkP6oLGKf9VmdxPj+RKn8voD/kftPP99wdMP9d6a3X1mwbOnjEFFwMxE
	 3YyDswnPgUyjLND/SDdGt4wo6ebdUJ9eJwuriaU3OZIv7XjVdpjB/bvklKHFR2yolL
	 5JkUC7t4oCem3ATS3tH+Rs2HQzar+10X5MLXX4zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Esben Haabendal <esben@geanix.com>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH 6.6 101/124] serial: imx: Update mctrl old_status on RTSD interrupt
Date: Mon, 21 Oct 2024 12:25:05 +0200
Message-ID: <20241021102300.629146592@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

commit 40d7903386df4d18f04d90510ba90eedee260085 upstream.

When sending data using DMA at high baudrate (4 Mbdps in local test case) to
a device with small RX buffer which keeps asserting RTS after every received
byte, it is possible that the iMX UART driver would not recognize the falling
edge of RTS input signal and get stuck, unable to transmit any more data.

This condition happens when the following sequence of events occur:
- imx_uart_mctrl_check() is called at some point and takes a snapshot of UART
  control signal status into sport->old_status using imx_uart_get_hwmctrl().
  The RTSS/TIOCM_CTS bit is of interest here (*).
- DMA transfer occurs, the remote device asserts RTS signal after each byte.
  The i.MX UART driver recognizes each such RTS signal change, raises an
  interrupt with USR1 register RTSD bit set, which leads to invocation of
  __imx_uart_rtsint(), which calls uart_handle_cts_change().
  - If the RTS signal is deasserted, uart_handle_cts_change() clears
    port->hw_stopped and unblocks the port for further data transfers.
  - If the RTS is asserted, uart_handle_cts_change() sets port->hw_stopped
    and blocks the port for further data transfers. This may occur as the
    last interrupt of a transfer, which means port->hw_stopped remains set
    and the port remains blocked (**).
- Any further data transfer attempts will trigger imx_uart_mctrl_check(),
  which will read current status of UART control signals by calling
  imx_uart_get_hwmctrl() (***) and compare it with sport->old_status .
  - If current status differs from sport->old_status for RTS signal,
    uart_handle_cts_change() is called and possibly unblocks the port
    by clearing port->hw_stopped .
  - If current status does not differ from sport->old_status for RTS
    signal, no action occurs. This may occur in case prior snapshot (*)
    was taken before any transfer so the RTS is deasserted, current
    snapshot (***) was taken after a transfer and therefore RTS is
    deasserted again, which means current status and sport->old_status
    are identical. In case (**) triggered when RTS got asserted, and
    made port->hw_stopped set, the port->hw_stopped will remain set
    because no change on RTS line is recognized by this driver and
    uart_handle_cts_change() is not called from here to unblock the
    port->hw_stopped.

Update sport->old_status in __imx_uart_rtsint() accordingly to make
imx_uart_mctrl_check() detect such RTS change. Note that TIOCM_CAR
and TIOCM_RI bits in sport->old_status do not suffer from this problem.

Fixes: ceca629e0b48 ("[ARM] 2971/1: i.MX uart handle rts irq")
Cc: stable <stable@kernel.org>
Reviewed-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20241002184133.19427-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -771,6 +771,21 @@ static irqreturn_t __imx_uart_rtsint(int
 
 	imx_uart_writel(sport, USR1_RTSD, USR1);
 	usr1 = imx_uart_readl(sport, USR1) & USR1_RTSS;
+	/*
+	 * Update sport->old_status here, so any follow-up calls to
+	 * imx_uart_mctrl_check() will be able to recognize that RTS
+	 * state changed since last imx_uart_mctrl_check() call.
+	 *
+	 * In case RTS has been detected as asserted here and later on
+	 * deasserted by the time imx_uart_mctrl_check() was called,
+	 * imx_uart_mctrl_check() can detect the RTS state change and
+	 * trigger uart_handle_cts_change() to unblock the port for
+	 * further TX transfers.
+	 */
+	if (usr1 & USR1_RTSS)
+		sport->old_status |= TIOCM_CTS;
+	else
+		sport->old_status &= ~TIOCM_CTS;
 	uart_handle_cts_change(&sport->port, usr1);
 	wake_up_interruptible(&sport->port.state->port.delta_msr_wait);
 


