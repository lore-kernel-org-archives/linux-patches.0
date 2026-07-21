Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C01C43C06B;
	Tue, 21 Jul 2026 22:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671355; cv=none; b=uFoDl2Uqoxj5p8GMHjDWM5kdvUghHYUP2CamZFtVZYyKJQRMQ1BJug5ulwXOmYtar4DPB9cZwX2e2Syi8MSHC1DTjgnCOzzTefKFKrsEFGT3C1prHw/gK8RY4ZyRdcsQWAlUga861QllILe1DrHSv3xQLJCdfh4iTZ6mMHugsyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671355; c=relaxed/simple;
	bh=ERoCIRFxOZfNJnQTFWcceBg2to9dm336SkYshSUyBDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouPboo462RFslawkn57G9dgeDtLdPvKqF736ZbFFH8JC8amjUmW3ocW5p5imloJxXsT5/BTbtH78mOAE5w/olQzbcqaJp2a0k0NwL1+X9O0spk62s2gH2pujnq3rCLzA9lpo9k1DCiRshea3Q4hFZcjZe0nfvcLtLWPDIXcNvZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ8eLVsC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ8eLVsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FE11F000E9;
	Tue, 21 Jul 2026 22:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671353;
	bh=AqYH75XCfNuxPi+uG5UY+R6eRIHVfCheJsnEWvcRoG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJ8eLVsCmaltM+tkjIaCONmKFTCPxNRtAioh1WJQpid8YO0id1EhNfLHQ6pn0uaiO
	 LZ1Zi5lICyvpaeHkbUl31FtXopStMYnlMzxbLP26NtKiVelbXuidT2wlvbBZo7f/jU
	 zORjQ2/1VUBxLzZfyzCJtmY2LwvP2Et8LQ9J+fpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Matthias Feser <mfe@KBSgmbhfr.onmicrosoft.com>,
	Moteen Shah <m-shah@ti.com>
Subject: [PATCH 5.15 212/843] serial: 8250_omap: clear rx_running on zero-length DMA completes
Date: Tue, 21 Jul 2026 17:17:27 +0200
Message-ID: <20260721152410.787827387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -878,11 +878,12 @@ static void __dma_rx_do_complete(struct
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


