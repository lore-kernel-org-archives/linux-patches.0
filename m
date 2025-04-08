Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45DD26773A;
	Tue,  8 Apr 2025 12:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113943; cv=none; b=nQ6/VZKaHkpViO2jAupf9zVpKt5YLn7yLPr7lLwxn6snMH8RQDDE8BMKF4Hw0axB/WOM/KzR+ZVQhDGdEf8ToipBGWz9op6Q+9J9A+QkZHzXALOxSkjzOGO8WseYdm1NqP7pyIWczUQLKbLEZLY8gjrz/59vJMSRraixGzOjgUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113943; c=relaxed/simple;
	bh=Ycxe/qxOJdE1B3EalQjl4UO9bPPNWS7fACmnwj1QmW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CdOPOJxb+ng3GoZPNdZexBsYYU5aEFKZAxh/tiPvRWukVny8WIEs1HtORdgUYVBtF4feoTb6lXuS6KzlVxYg6vPIWdmQx6tGvTufppfMGT3+PPRyjG7/l3pLlNkgk4w0u/Nke/Hyes3Cy8OYjNZ/MjrarRFlS7Ryqkfz4PyYnuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byF0zgi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byF0zgi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741E4C4CEE5;
	Tue,  8 Apr 2025 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113942;
	bh=Ycxe/qxOJdE1B3EalQjl4UO9bPPNWS7fACmnwj1QmW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byF0zgi+lBFyXNkyHUipsQhQpwbzxiYx/YvUiZ9DVoXvbastWPNF14w86LmW09DSo
	 0J+24m3x8JJTWMrs7bimb56IkcvnjxVXi1aSra+V1HNsu0b7fuQ/Jon7c+6pm1sMIK
	 XNaf6tsIz9Ho3+wkck+fLFYJiRdU6tqJcnzLxEKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	John Keeping <jkeeping@inmusicbrands.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.4 079/154] serial: 8250_dma: terminate correct DMA in tx_dma_flush()
Date: Tue,  8 Apr 2025 12:50:20 +0200
Message-ID: <20250408104817.843546318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -139,7 +139,7 @@ void serial8250_tx_dma_flush(struct uart
 	 */
 	dma->tx_size = 0;
 
-	dmaengine_terminate_async(dma->rxchan);
+	dmaengine_terminate_async(dma->txchan);
 }
 
 int serial8250_rx_dma(struct uart_8250_port *p)


