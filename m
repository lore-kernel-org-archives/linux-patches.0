Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7356E51C37;
	Mon, 11 Dec 2023 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPggsT3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05ADC433C8;
	Mon, 11 Dec 2023 18:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320803;
	bh=wk3tum5RsmMc/JNvAWFgZHPoX8J1hJi+1aSJM1JxIbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPggsT3DaC+DGED69Nv3CzRFagrCVBOpsOU1QZJ0gVzBxJ+nVjFb5cWg1ZiKDLaGx
	 z45mC9MW77tl0wukkP6RllPJbKywkubeW8kacmFETtOm/H3TWE07SLbDbTUGjukMHx
	 SWW6lJ0MR1UnmwLynLvfSKcLv1dvdHFj2weYXZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mack <daniel@zonque.org>,
	Maxim Popov <maxim.snafu@gmail.com>
Subject: [PATCH 6.1 174/194] serial: sc16is7xx: address RX timeout interrupt errata
Date: Mon, 11 Dec 2023 19:22:44 +0100
Message-ID: <20231211182044.430272147@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <daniel@zonque.org>

commit 08ce9a1b72e38cf44c300a44ac5858533eb3c860 upstream.

This device has a silicon bug that makes it report a timeout interrupt
but no data in the FIFO.

The datasheet states the following in the errata section 18.1.4:

  "If the host reads the receive FIFO at the same time as a
  time-out interrupt condition happens, the host might read 0xCC
  (time-out) in the Interrupt Indication Register (IIR), but bit 0
  of the Line Status Register (LSR) is not set (means there is no
  data in the receive FIFO)."

The errata description seems to indicate it concerns only polled mode of
operation when reading bit 0 of the LSR register. However, tests have
shown and NXP has confirmed that the RXLVL register also yields 0 when
the bug is triggered, and hence the IRQ driven implementation in this
driver is equally affected.

This bug has hit us on production units and when it does, sc16is7xx_irq()
would spin forever because sc16is7xx_port_irq() keeps seeing an
interrupt in the IIR register that is not cleared because the driver
does not call into sc16is7xx_handle_rx() unless the RXLVL register
reports at least one byte in the FIFO.

Fix this by always reading one byte from the FIFO when this condition
is detected in order to clear the interrupt. This approach was
confirmed to be correct by NXP through their support channels.

Tested by: Hugo Villeneuve <hvilleneuve@dimonoff.com>

Signed-off-by: Daniel Mack <daniel@zonque.org>
Co-Developed-by: Maxim Popov <maxim.snafu@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231123072818.1394539-1-daniel@zonque.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -769,6 +769,18 @@ static bool sc16is7xx_port_irq(struct sc
 		case SC16IS7XX_IIR_RTOI_SRC:
 		case SC16IS7XX_IIR_XOFFI_SRC:
 			rxlen = sc16is7xx_port_read(port, SC16IS7XX_RXLVL_REG);
+
+			/*
+			 * There is a silicon bug that makes the chip report a
+			 * time-out interrupt but no data in the FIFO. This is
+			 * described in errata section 18.1.4.
+			 *
+			 * When this happens, read one byte from the FIFO to
+			 * clear the interrupt.
+			 */
+			if (iir == SC16IS7XX_IIR_RTOI_SRC && !rxlen)
+				rxlen = 1;
+
 			if (rxlen)
 				sc16is7xx_handle_rx(port, rxlen, iir);
 			break;


