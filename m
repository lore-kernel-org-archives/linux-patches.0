Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB27C471421;
	Tue, 21 Jul 2026 20:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665570; cv=none; b=bhiNehxaaX6npaUSwIRspqZvQemK8LudIQ1brYxK7vVyEgpore3x29UivAM8H2++XMAI9TLqyq8qURMrOmPNh1N2nBxtEOQCkJEOnwFa3s21b4VcxNrl/5vchgdA2AbUubnDyPGmJjd93P9ZaQHheesTs/Rcj2Hq5U29HD5kHZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665570; c=relaxed/simple;
	bh=C+htPyK+FI0YHymC7NTJJ/aMVn6sMYUJie+cx0UOHSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdrqVLNYhgKNWdqQETEleACuE0Xv8LcAyTNblcTwFyZS4j3lK8weh9HeHhkIoMpB0BuvnmHEOlu2+GsNt0k6IEAAWvHhfEthRzmIrYbNKQM75YKjescj6fdyGDUsu0voXtiU06HVy1QF/onU+0uelVBe6dCbix6cPye0a1h9bcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+UYjShZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+UYjShZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A397F1F000E9;
	Tue, 21 Jul 2026 20:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665565;
	bh=FldvJ0NyyJlpIF2DNz7VW1o96DTBegtUAH8uNzNGlBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+UYjShZpH8bHiYur1uiFhaefMGkfGH7uX1whCMxf3yacMg7+WC0b3uMfE6a9IxoO
	 eroRObsfPhbCpclfQ+L0XCW+BzjXjWHLidPI2Xz+eViIXNG5QhLz8w5nxyy8hzU+R7
	 Tka1xot9936HtR1hFJJZgRpO7QLJVw092WVSh9Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>,
	Moteen Shah <m-shah@ti.com>
Subject: [PATCH 6.6 0351/1266] serial: 8250_omap: clear rx_running on zero-length DMA completes
Date: Tue, 21 Jul 2026 17:13:08 +0200
Message-ID: <20260721152449.687589126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -953,11 +953,12 @@ static void __dma_rx_do_complete(struct
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


