Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36E21FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630FFC433C7;
	Tue,  1 Aug 2023 09:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883201;
	bh=l6Pcvzb0AvMm9DsHofV8Ursvkib+BQffG9sT3tfszYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3WTRPsAP6+KL7IQg7znDSWmxbSmrIgQt7ZDSJAkf1W4ZDB034sYcmzwn7u78fyt8
	 h62H83aaQSlwSnm6EjsEuUcE+8QpS8GynQHAISfnqrdB3nItkvix+zcgdfkt+o+qAx
	 kV/JlSEnCaGhrucQExNd6Gn4Rn7Zaf+wNbWJ2jnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ruihong Luo <colorsu1922@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.4 151/239] serial: 8250_dw: Preserve original value of DLF register
Date: Tue,  1 Aug 2023 11:20:15 +0200
Message-ID: <20230801091931.102302108@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruihong Luo <colorsu1922@gmail.com>

commit 748c5ea8b8796ae8ee80b8d3a3d940570b588d59 upstream.

Preserve the original value of the Divisor Latch Fraction (DLF) register.
When the DLF register is modified without preservation, it can disrupt
the baudrate settings established by firmware or bootloader, leading to
data corruption and the generation of unreadable or distorted characters.

Fixes: 701c5e73b296 ("serial: 8250_dw: add fractional divisor support")
Cc: stable <stable@kernel.org>
Signed-off-by: Ruihong Luo <colorsu1922@gmail.com>
Link: https://lore.kernel.org/stable/20230713004235.35904-1-colorsu1922%40gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230713004235.35904-1-colorsu1922@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dwlib.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_dwlib.c
+++ b/drivers/tty/serial/8250/8250_dwlib.c
@@ -244,7 +244,7 @@ void dw8250_setup_port(struct uart_port
 	struct dw8250_port_data *pd = p->private_data;
 	struct dw8250_data *data = to_dw8250_data(pd);
 	struct uart_8250_port *up = up_to_u8250p(p);
-	u32 reg;
+	u32 reg, old_dlf;
 
 	pd->hw_rs485_support = dw8250_detect_rs485_hw(p);
 	if (pd->hw_rs485_support) {
@@ -270,9 +270,11 @@ void dw8250_setup_port(struct uart_port
 	dev_dbg(p->dev, "Designware UART version %c.%c%c\n",
 		(reg >> 24) & 0xff, (reg >> 16) & 0xff, (reg >> 8) & 0xff);
 
+	/* Preserve value written by firmware or bootloader  */
+	old_dlf = dw8250_readl_ext(p, DW_UART_DLF);
 	dw8250_writel_ext(p, DW_UART_DLF, ~0U);
 	reg = dw8250_readl_ext(p, DW_UART_DLF);
-	dw8250_writel_ext(p, DW_UART_DLF, 0);
+	dw8250_writel_ext(p, DW_UART_DLF, old_dlf);
 
 	if (reg) {
 		pd->dlf_size = fls(reg);


