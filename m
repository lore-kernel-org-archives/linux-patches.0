Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B64E188A3A;
	Thu,  3 Apr 2025 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694014; cv=none; b=N7ol0mt59mXL0fKKgmq+8p0vkhS9dFzryyhGUUPu+XUPizk/8Xs7dw/OMtzzOWsTXLxP2Eke5UDy47hX10FMJoJdKGx0GPHltLOaMO9hNhFTYNspcoPNUT4TO90RHVbKc9SaaemlAxIoHlFCC5gyTYVRUaomj8zEMuK+3tde73M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694014; c=relaxed/simple;
	bh=i6PRpySOVIzM5vDfNsL/Xx1xMd4p230POdgd6yJbSD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQ691ok9rPqTV8rSo8cXSdqPvg1wdUtwEmLJ2MmPbY/lDFNLv2mdHJFuUZkjTDjmeyR7x0GMXnbXIrkvk3kRox5YRKjOei7ouiuJ/A89RcbuSffGkY3i9/t1NclFVzyvJu8D7mMHsdN5wsSYVG3oNxLUVhPyVN6lX0YDt+uXukI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSipYcq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSipYcq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D601EC4CEE3;
	Thu,  3 Apr 2025 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743694014;
	bh=i6PRpySOVIzM5vDfNsL/Xx1xMd4p230POdgd6yJbSD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSipYcq1ddVOTBFtGrmJ3rbhvDpp20eDE/LX7MyOK+8gNRCKtO+OpsKTarucNTfQT
	 +ZE+3Tob6O0ypa5l+7+joOsKOgQ5IEuwqxcWUEcnBLUSa5w2IF1jYkpdsrv5tzGtqD
	 6eDQNWYwKx9lqOu6MvWGA2Gi2r0sr0uWqxatX+o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	John Keeping <jkeeping@inmusicbrands.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 25/26] serial: 8250_dma: terminate correct DMA in tx_dma_flush()
Date: Thu,  3 Apr 2025 16:20:46 +0100
Message-ID: <20250403151623.144937099@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,7 +152,7 @@ void serial8250_tx_dma_flush(struct uart
 	 */
 	dma->tx_size = 0;
 
-	dmaengine_terminate_async(dma->rxchan);
+	dmaengine_terminate_async(dma->txchan);
 }
 
 int serial8250_rx_dma(struct uart_8250_port *p)


