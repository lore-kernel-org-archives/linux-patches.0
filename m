Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DDEC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EACC433C7;
	Mon,  4 Sep 2023 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852503;
	bh=N5gBKegULs+Kc4qF01v8ke2QsxlHdd0t3Y3hXFGJZho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5EKMqJcBmLQmkvdG/vbqQCPpYsb1t/DSqyj1Mxp/2zh/wdKofGQ15ZP2475lsNlE
	 LaD+/3Jii20Z4UIBu77byeYClecKWrJCsMXSZ8dVBjnvSAwcA5E9P5rcurYgzmwK/f
	 J0Undk1sFcJiplKgAYYooRs19OFjXjZksA1nAKXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lech Perczak <lech.perczak@camlingroup.com>
Subject: [PATCH 6.1 22/31] serial: sc16is7xx: fix broken port 0 uart init
Date: Mon,  4 Sep 2023 19:30:30 +0100
Message-ID: <20230904182948.095271875@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 2861ed4d6e6d1a2c9de9bf5b0abd996c2dc673d0 upstream.

The sc16is7xx_config_rs485() function is called only for the second
port (index 1, channel B), causing initialization problems for the
first port.

For the sc16is7xx driver, port->membase and port->mapbase are not set,
and their default values are 0. And we set port->iobase to the device
index. This means that when the first device is registered using the
uart_add_one_port() function, the following values will be in the port
structure:
    port->membase = 0
    port->mapbase = 0
    port->iobase  = 0

Therefore, the function uart_configure_port() in serial_core.c will
exit early because of the following check:
	/*
	 * If there isn't a port here, don't do anything further.
	 */
	if (!port->iobase && !port->mapbase && !port->membase)
		return;

Typically, I2C and SPI drivers do not set port->membase and
port->mapbase.

The max310x driver sets port->membase to ~0 (all ones). By
implementing the same change in this driver, uart_configure_port() is
now correctly executed for all ports.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Lech Perczak <lech.perczak@camlingroup.com>
Tested-by: Lech Perczak <lech.perczak@camlingroup.com>
Link: https://lore.kernel.org/r/20230807214556.540627-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1439,6 +1439,12 @@ static int sc16is7xx_probe(struct device
 		s->p[i].port.fifosize	= SC16IS7XX_FIFO_SIZE;
 		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY;
 		s->p[i].port.iobase	= i;
+		/*
+		 * Use all ones as membase to make sure uart_configure_port() in
+		 * serial_core.c does not abort for SPI/I2C devices where the
+		 * membase address is not applicable.
+		 */
+		s->p[i].port.membase	= (void __iomem *)~0;
 		s->p[i].port.iotype	= UPIO_PORT;
 		s->p[i].port.uartclk	= freq;
 		s->p[i].port.rs485_config = sc16is7xx_config_rs485;


