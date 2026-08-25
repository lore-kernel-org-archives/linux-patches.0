Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA90F3909A4;
	Tue, 25 Aug 2026 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665527; cv=none; b=dMwD/t7hpOo1OUjFN9KI0MrdtlNst5W4sAp+xlCgyWDIPkLPL20tu8iFloBfEEVWr2KY73WFKAb0wivLjr5ZVhbQUF5d0yWF/WUPU4IkXJ5Q4gD76nleoApBYXocVhTFJq5ntwSJrdFlaEPow8ldhY6BJ7PxGqSPk7MRuW1esUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665527; c=relaxed/simple;
	bh=d3l4KRB2Z03a7BNx7XEIqEsSO+ROSpKkZS8j3qS+XSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyBCKMD2zk/Te7PKmQCt3vP01iXpqNKbIP4IYh4/jICwxBLQBsZCNM+vXD/cgHR5qadaHctbZc4Cz63wwY7AijLHpXB7sHnacjXYTHnFZfJH5ELTC1r7WICuAjDQptGq5n2HXpbYlHV7m3zAzv26IDEUxb4JAgqp0rC4+LbD3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ra1QcqZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ra1QcqZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E291E1F000E9;
	Tue, 25 Aug 2026 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665525;
	bh=OTuzUIoYRDPnyjv5lK2XXi/6Ui7YTI4/SdCa8vL6lHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ra1QcqZge059QESfuoynfUnnlOUxZ/G+v2pHnfkrt6zeifLa3HIofec92Q71E6MfO
	 Zmf1KxMg8cCC9hl5OqbrOxqsM8dHTnUKCM2AIYgRa+oBYYHFfWUEH/OO3YGETPG9eN
	 bYgSYTCyLdJwfHU51aYBcYGnJzFCelpIBk4iMq5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/77] serial: amba-pl011: synchronize DMA teardown
Date: Tue, 25 Aug 2026 15:25:38 +0200
Message-ID: <20260825132542.199314667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 440915499231e9db1c361aa45bb702e8fd3b4a32 ]

dmaengine_terminate_all() does not wait for a running callback, so the TX
callback can still touch the TX buffer after it is freed. The RX poll
timer reads the RX buffers without the port lock.

Switch to dmaengine_terminate_sync() and delete the RX timer before
freeing the buffers.

Fixes: ead76f329f77 ("ARM: 6763/1: pl011: add optional RX DMA to PL011 v2")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260731085915.326775-4-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ changed upstream's `timer_delete_sync()` deletion to match this tree's `del_timer_sync()` spelling at the old call site ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1171,7 +1171,7 @@ static void pl011_dma_shutdown(struct ua
 
 	if (uap->using_tx_dma) {
 		/* In theory, this should already be done by pl011_dma_flush_buffer */
-		dmaengine_terminate_all(uap->dmatx.chan);
+		dmaengine_terminate_sync(uap->dmatx.chan);
 		if (uap->dmatx.queued) {
 			dma_unmap_single(uap->dmatx.chan->device->dev,
 					 uap->dmatx.dma, uap->dmatx.len,
@@ -1184,12 +1184,12 @@ static void pl011_dma_shutdown(struct ua
 	}
 
 	if (uap->using_rx_dma) {
-		dmaengine_terminate_all(uap->dmarx.chan);
+		if (uap->dmarx.poll_rate)
+			timer_delete_sync(&uap->dmarx.timer);
+		dmaengine_terminate_sync(uap->dmarx.chan);
 		/* Clean up the RX DMA */
 		pl011_dmabuf_free(uap->dmarx.chan, &uap->dmarx.dbuf_a, DMA_FROM_DEVICE);
 		pl011_dmabuf_free(uap->dmarx.chan, &uap->dmarx.dbuf_b, DMA_FROM_DEVICE);
-		if (uap->dmarx.poll_rate)
-			del_timer_sync(&uap->dmarx.timer);
 		uap->using_rx_dma = false;
 	}
 }


