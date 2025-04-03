Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398082512E3;
	Thu,  3 Apr 2025 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693907; cv=none; b=hVLupZEo01VNsLPhoRoYPPrRf5P39SE87CL5PRuMZOmnHkVXNIsNyQAt20gA5TZu6okP2EH9gxanGYQW24qYLr/ApRzHIDuiQ82lln4PiNntf3XPAgboA71NWkiXQvz+lT/kNOLLNOIvuMWpFvTGLFeOkZkyfo4vzq5gXLOba7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693907; c=relaxed/simple;
	bh=XMQ8JwzuQxkUV4bf1qvC3Tc9zmQPNLOZnJrAy588n9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+XvY11VldbzTn6A1LlBh6bJUZ1xgZu5vy+lL8v1Sz9W1zHS6oWqRXOvbORpEatNW8JzhxkkMIuetH3QSzYYoKFfJAIPcx4M8sggYJOhRRrgW+A2Sqr8n9bZ5gWAwyOBGs7QBjRd958ypmpQb4errxaSGR3jy3W9QMazCN/ITZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9YYVrYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9YYVrYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A52C4CEE8;
	Thu,  3 Apr 2025 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693907;
	bh=XMQ8JwzuQxkUV4bf1qvC3Tc9zmQPNLOZnJrAy588n9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9YYVrYXPfnyeGufxgA8Hr3wwy5UGck0l4DrBRML1GNjgiG5c/l4N3ADMiPkyp+LD
	 O14dQ4st5wvPPcHyPzO0A0yXCavjeAJQVdlQYBA+3snpST4rP4KZOZ83XMiSTzhTej
	 Va4uLe896PiHbGqISpWHu9PCNImR/c1ouIY09j2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	John Keeping <jkeeping@inmusicbrands.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 21/22] serial: 8250_dma: terminate correct DMA in tx_dma_flush()
Date: Thu,  3 Apr 2025 16:20:31 +0100
Message-ID: <20250403151622.652694492@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

commit a26503092c75abba70a0be2aa01145ecf90c2a22 upstream.

When flushing transmit side DMA, it is the transmit channel that should
be terminated, not the receive channel.

Fixes: 9e512eaaf8f40 ("serial: 8250: Fix fifo underflow on flush")
Cc: stable <stable@kernel.org>
Reported-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250224121831.1429323-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -162,7 +162,7 @@ void serial8250_tx_dma_flush(struct uart
 	 */
 	dma->tx_size = 0;
 
-	dmaengine_terminate_async(dma->rxchan);
+	dmaengine_terminate_async(dma->txchan);
 }
 
 int serial8250_rx_dma(struct uart_8250_port *p)


