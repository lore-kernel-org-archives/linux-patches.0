Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CFF1DDA0C;
	Tue,  8 Apr 2025 10:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109937; cv=none; b=EQod7PQkgKst9+iY7ClAJlz35edhyUqHPzSRC2CHLnW34UxCpqV2MNrnt0GHHQ+Mfxdi9XpNzhcnYuqC4X3ohv9vIZXr6bmg3ktDeLg+uXFEVWNGYXtWBgaazg8GmTVKDwxuKUzy+Yjqiik5Y3ENZyUxULfuX0xEAC66z8rkroc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109937; c=relaxed/simple;
	bh=7soKsvDr7Co5kzMxUkX8bYO42kk04JDisKnng2raCwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYeFzmqHBawW9bX5LknCzusdVPSMJdKBZHmPLFBPupeJA3XmUHFCeDPMiqkoyYn7W1XIrspnqiwP+2yUExlZ7SOCjxwE5Ry4iMyPao8yvYWllaxQB9cRUJYy/uoKVxSPlYgMQUGRKr6Bh5wlmA44ciQIDO/7mR0WBQKYMEOTOfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWgZSEhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWgZSEhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38C6C4CEE5;
	Tue,  8 Apr 2025 10:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109937;
	bh=7soKsvDr7Co5kzMxUkX8bYO42kk04JDisKnng2raCwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWgZSEhb0ioObr1WVHK6Tw+Vgoz2PsJn8ijFaKarS10EBeGQC6kiIZM0Zj+R25gxd
	 UnzFtI+ja9cIsuhgjAUBKx64/SwcY/VgZOjvJxQ6LfP3Txz28HHeAXlES+eKJKeQdL
	 1sRzS0sfGqgpljrbn4VD4id9ucVmTVsdQpl0Y8fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	John Keeping <jkeeping@inmusicbrands.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 108/227] serial: 8250_dma: terminate correct DMA in tx_dma_flush()
Date: Tue,  8 Apr 2025 12:48:06 +0200
Message-ID: <20250408104823.593288755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -148,7 +148,7 @@ void serial8250_tx_dma_flush(struct uart
 	 */
 	dma->tx_size = 0;
 
-	dmaengine_terminate_async(dma->rxchan);
+	dmaengine_terminate_async(dma->txchan);
 }
 
 int serial8250_rx_dma(struct uart_8250_port *p)


