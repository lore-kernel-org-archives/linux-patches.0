Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42BC250C09;
	Thu,  3 Apr 2025 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693949; cv=none; b=XA7lqK5Bhqbj8VFbN04fUIqztfGLfdWfg1GYdNvYqlXWTR47srx3m/aApJV1KqHjRmnq38aRSj8Z+ekVCQAlo41LFsLozmAkCVsPwJVgbQ56lLSQCf04N/oHCAw3LZpiPWiJo2IjpzxD8tA1NxeFzYsloiCWXntPJk0B0QZ2LoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693949; c=relaxed/simple;
	bh=WN8PyeHBBmNIcphIgo6va7S5j7p0NZyHDPq1/kQZTs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZxObOOKvZ0DLjvzUkvp3ouFXMu6A6Pl38pUjxIZBmBdhNOt6YHm9BfRx97w9JrN7Wvzg1STiKoCXJ+akZDrGq7rqDn4+CjCvHVa3b8ZExW4RHMgxC16x7RYAJ38rF+IHTKwd/DWNv6HGgVBx8TV6n6oa9466sqw2fpp7hmNqDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0Flt4Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0Flt4Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAE1C4CEE3;
	Thu,  3 Apr 2025 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693948;
	bh=WN8PyeHBBmNIcphIgo6va7S5j7p0NZyHDPq1/kQZTs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0Flt4Y8Td6sQ+HmNEvSH6yBvhiqtFp72+uwUzUG8zz3qDz6zwm11sdAmT0mcSoMQ
	 sXwVGG34t3TZLapcsY22OmsXXsdS+55N5JMkD+3hPzkzeqlhRe05Oq05j1vaitDP1Q
	 hsKXG6fA0KmIIvMuQ+4We/2tcWVEPQFcOAgtYQ/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	John Keeping <jkeeping@inmusicbrands.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.13 22/23] serial: 8250_dma: terminate correct DMA in tx_dma_flush()
Date: Thu,  3 Apr 2025 16:20:39 +0100
Message-ID: <20250403151622.924025120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


