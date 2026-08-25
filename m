Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A0D46EF87;
	Tue, 25 Aug 2026 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666149; cv=none; b=sPcNWoK0nCF/jri8K2j3muc6PxEvr1B3YsHRRVm6UisFgguoeEX9RysN7PQu6pn/Miz+EO9fM7pRdGMqSWet4zrLF4Xh8F591ZEU6GhQMDN9qgBqs3EcCuOu2n80HGeBEwgsG9s/vu0SypAgYNG8SSmyOHIVvE8RDZTdXgEmAfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666149; c=relaxed/simple;
	bh=o/V8v3O5ppaurnDW30oIP+1VUiHdqws2CGf6Q+WtVbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMFgEscwPi3Fwh08OspoGIDVWzgsmmOCMOk8Ba/G2ZkyCLu11we9ER/JymX5s8koP73LEiCzRm6dBdvkVPjdthIu+AYazE7hMcyPb2flr38CWtKDjFTAekacnrOPxCQmwY2hoiU7hU7ad7aBYTtZ2MG28z/AIYaj6unLueCNtkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X17lrl7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X17lrl7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C541F00A3D;
	Tue, 25 Aug 2026 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666147;
	bh=3b8y6nx+RyNvDUh2ngJHBdxkbUiTi0FaLNmrgNeN7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X17lrl7nAUUpVrJ/OltdQpj90fjxwkglYGRSlVkjBzPbWg2dmZLXX4GrdPiF24Ax2
	 vibsIfzdivr+vhGV/K7L7HE6V+5HUxsd3aeMs506vAffnrqjfIiGjVspf1F9dOkU+z
	 ncSyg5Q7e8GY4YW7SAZuZnK6DO8PWi8gsGg1sLE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/76] serial: amba-pl011: synchronize DMA teardown
Date: Tue, 25 Aug 2026 15:26:13 +0200
Message-ID: <20260825132542.335890070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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
@@ -1198,7 +1198,7 @@ static void pl011_dma_shutdown(struct ua
 
 	if (uap->using_tx_dma) {
 		/* In theory, this should already be done by pl011_dma_flush_buffer */
-		dmaengine_terminate_all(uap->dmatx.chan);
+		dmaengine_terminate_sync(uap->dmatx.chan);
 		if (uap->dmatx.queued) {
 			dma_unmap_single(uap->dmatx.chan->device->dev,
 					 uap->dmatx.dma, uap->dmatx.len,
@@ -1211,12 +1211,12 @@ static void pl011_dma_shutdown(struct ua
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


