Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B9241F5D8;
	Tue, 21 Jul 2026 19:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661514; cv=none; b=bnTBeDXubk0zR3e2jTfeYdsH5jkiDQgVcJk484oEIy0fciK+n+4tWur4r/4zfvx+DD9jrewj+6nsjhYYC0vUXcJfDwmUM9MKFRB49hgmncZ0nTqr7I8S3a9YboWZyJutg+BRqx5PTlcIhOhg+Rlla1YON3hTQNJ9vD8BZJ/HIVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661514; c=relaxed/simple;
	bh=j8nrQ5AL6n8v6XpS2/OTgFJMV74A7fHALQjfTTJghko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G29qlLxJ+KImhHFLJd94B/y7LrT9D3kTUX6HklHtZjTPdl7MtkQ69RUW4WsnKLadWjNBjHtxnmteo4zyj9GJzkqw9LMjN2QrWbYY4zoH4pkw6LGARNBLbzxpaKF/opgLcMQ/O0qUONmlxLKzgti0BIkxCSuFRIYrTA0QH3qP1oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms3k3/34; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms3k3/34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1A91F00A3A;
	Tue, 21 Jul 2026 19:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661513;
	bh=mpN/926ffrlbJXlFZp1XexKZhC6w9vGUzN+ydImNJMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ms3k3/34GFBrvP+iRrcjIJDCS7ZutYMcHhL1HVgBZgBrCLRtwlBJJS1PyFL0IJypM
	 RnQHOyc9j6s+1PeaDn8304flzIqnRmoaeWfhGTRfJm+YihILbhnA64a/1H8A+kwL0X
	 eXoMj65KZ/ePIHofqh9uwAa63P3n55ZoFP/a3X1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>,
	Moteen Shah <m-shah@ti.com>
Subject: [PATCH 6.12 0051/1276] serial: 8250_omap: clear rx_running on zero-length DMA completes
Date: Tue, 21 Jul 2026 17:08:14 +0200
Message-ID: <20260721152447.227999344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>

commit 061b627ba534230a18ec4d7251562af12325d06a upstream.

On AM33xx RX DMA only triggers when the FIFO reaches the
configured threshold (typically 48 bytes). For smaller bursts
no DMA request is issued and the FIFO is drained by RX timeout.

In this case __dma_rx_do_complete() can legitimately see count == 0.

The current code exits early in this case and does not clear
dma->rx_running, leaving the DMA state inconsistent. This can
prevent RX DMA from restarting and may cause
omap_8250_rx_dma_flush() to fail, marking DMA as broken.

Fix this by clearing dma->rx_running once the DMA transfer has
completed or been terminated, even if no data was transferred.

Fixes: a5fd8945a478 ("serial: 8250: 8250_omap.c: Clear DMA RX running status only after DMA termination is done")
Cc: stable <stable@kernel.org>
Signed-off-by: Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/BE3P281MB55155F2F5795E411F5A65282EE0B2@BE3P281MB5515.DEUP281.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -965,11 +965,12 @@ static void __dma_rx_do_complete(struct
 				dev_err(p->port.dev, "teardown incomplete\n");
 		}
 	}
+
+	dma->rx_running = 0;
 	if (!count)
 		goto out;
 	ret = tty_insert_flip_string(tty_port, dma->rx_buf, count);
 
-	dma->rx_running = 0;
 	p->port.icount.rx += ret;
 	p->port.icount.buf_overrun += count - ret;
 out:


