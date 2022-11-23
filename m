Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BAF1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5964C433D6;
	Wed, 23 Nov 2022 09:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196176;
	bh=UyLaojOULzpRt/kL6TcbCknduzXuAjXyN9bB22h18Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZ3qXkedyLmHwNjs26sysxvVs7TdFgwFCNNPl4b2fvafg6aJ9qOJIVl7ZKyi2BN0n
	 jX/KbuKwMdkLNk5glK7Hg7awNk1C4B6T0RWRA9kyWbX/MxJIruD3dfzopIo2genFGS
	 qDsN/wD9g7J6qe83vt2tWmRPiNlMCNlNC4dVFomU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikanth Thokala <srikanth.thokala@intel.com>,
	Aman Kumar <aman.kumar@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.15 141/181] serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs
Date: Wed, 23 Nov 2022 09:51:44 +0100
Message-Id: <20221123084608.428172565@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit a931237cbea256aff13bb403da13a97b2d1605d9 upstream.

DW UART sometimes triggers IIR_RDI during DMA Rx when IIR_RX_TIMEOUT
should have been triggered instead. Since IIR_RDI has higher priority
than IIR_RX_TIMEOUT, this causes the Rx to hang into interrupt loop.
The problem seems to occur at least with some combinations of
small-sized transfers (I've reproduced the problem on Elkhart Lake PSE
UARTs).

If there's already an on-going Rx DMA and IIR_RDI triggers, fall
graciously back to non-DMA Rx. That is, behave as if IIR_RX_TIMEOUT had
occurred.

8250_omap already considers IIR_RDI similar to this change so its
nothing unheard of.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Co-developed-by: Srikanth Thokala <srikanth.thokala@intel.com>
Signed-off-by: Srikanth Thokala <srikanth.thokala@intel.com>
Co-developed-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1885,6 +1885,10 @@ EXPORT_SYMBOL_GPL(serial8250_modem_statu
 static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 {
 	switch (iir & 0x3f) {
+	case UART_IIR_RDI:
+		if (!up->dma->rx_running)
+			break;
+		fallthrough;
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
 		fallthrough;


