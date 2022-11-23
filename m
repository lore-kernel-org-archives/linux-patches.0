Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BA51C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F8C433D7;
	Wed, 23 Nov 2022 09:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195542;
	bh=oAigBay/sd/7qktzjMrBHXzuJdfLRliL+a2vGIn4EJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbMIDE2Oii8Tzpnbhq4+4GurPEVNIPAbwF4sP1/znfIO/vZ1kr4koCvBlX8Rtar4N
	 WSCvB7b74iA0a3qRbfg4vraLC2N8YL1Smtc9FcJX7Xle7LfwbxmbTOSdO0gCFaXrdT
	 E96o236M3t8B0bH5psJxKrMOqq6CMM/GNWzXHhwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.10 113/149] serial: 8250: Flush DMA Rx on RLSI
Date: Wed, 23 Nov 2022 09:51:36 +0100
Message-Id: <20221123084602.013278688@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

commit 1980860e0c8299316cddaf0992dd9e1258ec9d88 upstream.

Returning true from handle_rx_dma() without flushing DMA first creates
a data ordering hazard. If DMA Rx has handled any character at the
point when RLSI occurs, the non-DMA path handles any pending characters
jumping them ahead of those characters that are pending under DMA.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1873,10 +1873,9 @@ static bool handle_rx_dma(struct uart_82
 		if (!up->dma->rx_running)
 			break;
 		fallthrough;
+	case UART_IIR_RLSI:
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
-		fallthrough;
-	case UART_IIR_RLSI:
 		return true;
 	}
 	return up->dma->rx_dma(up);


