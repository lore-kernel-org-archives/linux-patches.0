Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DDE2512E7;
	Thu,  3 Apr 2025 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693767; cv=none; b=H7crD8qJ+PqqiQVHap6GMZiivartUJ/HvR8eWp9eYli8rC8paDxqa/QsUlBPwYKKsCOU9SR7NaYtW1FvmNPjlpz9XUMeYZkYqw6fbKzWjiQDoEKGkHCNDX8aC8bF4mMWPnoyv5MqWLL4E/r2ZTgaGhvorXwG9CU9QI1Pw1BKpfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693767; c=relaxed/simple;
	bh=2ELRtG6kO9x/L3ZRItKRoiBNhONiE6r0w1DWquGaveg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=maj0I6Cn2CHyDChAcR1fjHfofGlsMFDiIyKEt5+IYP8u9irN+q6eOVuIaI+dekZ1FsvNgmDdI75TDQ23iwuy12Y+50QtqMtw4yFOmt1Hdfpbc7tFZ7PnQIS3Y+/4VJtWgkTx72VfDaBEPZqZk4wwadVcamVWsc6gjcau4b9BvII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+seGw6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+seGw6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129EBC4CEED;
	Thu,  3 Apr 2025 15:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693766;
	bh=2ELRtG6kO9x/L3ZRItKRoiBNhONiE6r0w1DWquGaveg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+seGw6BRS85RBi8xCOcFp90GQQkrOQ4NANJlc4Lu3j9L75zahTWEM2o1ZzoacEtV
	 T4T5+n0RzYfbZNlc3fK75oaJG29jvZYBUdhAs1ixbjClIf87wamHa8OEDfUtwZl3iL
	 3w2rvzbDVV/sSBhsdBiOOlK/Gk1xfi7sIbTuc1M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	John Keeping <jkeeping@inmusicbrands.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 18/22] serial: 8250_dma: terminate correct DMA in tx_dma_flush()
Date: Thu,  3 Apr 2025 16:20:13 +0100
Message-ID: <20250403151621.453796199@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -146,7 +146,7 @@ void serial8250_tx_dma_flush(struct uart
 	 */
 	dma->tx_size = 0;
 
-	dmaengine_terminate_async(dma->rxchan);
+	dmaengine_terminate_async(dma->txchan);
 }
 
 int serial8250_rx_dma(struct uart_8250_port *p)


