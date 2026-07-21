Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A250246AA94;
	Tue, 21 Jul 2026 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647961; cv=none; b=IHI1W//vv5rw/Ir/ZIfRw/tUqupN37k0dYiym/+2folUmwEvlLZ3m5SAQ3w4OKJSu90Y9SV67cntewqIKEasqrmc8gKJJWcaCUjfJR9A7OzeU0bz+YWEQZUIiOAeGC4ElYQpwxhHvhICP2/KfnIB//C18eJzTTfoIo+wcOqQlF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647961; c=relaxed/simple;
	bh=Ha3efbUHId/ZtCohAr1BiqGLU4c8ejD0LPvw8VwGkTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDPte9cCjM0hfkmnSvu+cnZDV0bX+SJjXJHayzjlHUTTOdc0ObMqguKfEjnEdO3I7ioKhVtnOP0Il6lMrzGbMMak3weV8RGOCOSXb5duHypErpDW5rLpS6mSKM84fWLhqts86rQG1LATRfaVnY9vhPqjqQ9mcW0guvsCxvAIkas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xV9+t1Tq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xV9+t1Tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146581F000E9;
	Tue, 21 Jul 2026 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647960;
	bh=iNWgTBNfz1Q/9aGSvFhFk67FRtWv3l9LsDNaH3cdkPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xV9+t1Tq39zQ/mpYgUeg/De9tRDtEwhl758FcMJVuT0MdmPaZfz9RfxEgwZNuKepv
	 nJz4w3cmE6Ozqu03NDT8HxC3BIRt6gm2fUdV7uNrfZB8sWD8KFOlHBvDDyNOp3+Mnc
	 QRe1Voz6e/rsJwZuOu8L7sfc7sSdV8ca7lnjpjBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>,
	Moteen Shah <m-shah@ti.com>
Subject: [PATCH 7.1 0020/2077] serial: 8250_omap: clear rx_running on zero-length DMA completes
Date: Tue, 21 Jul 2026 16:54:53 +0200
Message-ID: <20260721152553.145201285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -944,11 +944,12 @@ static void __dma_rx_do_complete(struct
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


