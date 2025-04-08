Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF1264A76;
	Tue,  8 Apr 2025 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112700; cv=none; b=TZA5u3mwHlipvRVAdlnt1WEg4eiyATLiRFpE19Hcq4U+++AG9wq1Hw2Jlm6s4GLVsZpB7ex56D7bf3pbQanMJ+mVgvFBKuQtfR5IZpb0MR1dM2a9+azz7dOeTRKKqIscGTD+UMwZLL+SDsJI5qhz2A1Z+Qszfe+InGFY20f+w/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112700; c=relaxed/simple;
	bh=5OgzpZW2QAlXKHgmzkK/dUNpxNkzafxGhEpGTL8j7H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwEen9JjypNq+5bmEMWQs2yln+ZmrjkNctKjsb8w+kEGbidMTds9GJRMqhnRtC5z3fJJG8B7iWXhRsbMfQ8vOoJ1B3qHsLrHIrHzpe+H2BzebnktelWULhxMYMfBaJMHl7cZosOUKJuQ2V4VAxE62ffia+OmgUyPEnbApFcv5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8UP0rTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8UP0rTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D635C4CEE5;
	Tue,  8 Apr 2025 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112699;
	bh=5OgzpZW2QAlXKHgmzkK/dUNpxNkzafxGhEpGTL8j7H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8UP0rTLJKL/pfbPOCtFk1ntffjW7daOHmA7+y9htRuQOZLIvk6OnH2az9OITyoN3
	 fqpsxDZEQe+6NqkoR9LqzbiyalprBpZFe2BErMEdanOdD6IkLgpPXe5g2ANz38dVUV
	 45sAS5XXnzQKBHn/uQ/WDMczTmkSdZ4+qYGuY2I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	John Keeping <jkeeping@inmusicbrands.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 126/279] serial: 8250_dma: terminate correct DMA in tx_dma_flush()
Date: Tue,  8 Apr 2025 12:48:29 +0200
Message-ID: <20250408104829.745541314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,7 +150,7 @@ void serial8250_tx_dma_flush(struct uart
 	 */
 	dma->tx_size = 0;
 
-	dmaengine_terminate_async(dma->rxchan);
+	dmaengine_terminate_async(dma->txchan);
 }
 
 int serial8250_rx_dma(struct uart_8250_port *p)


