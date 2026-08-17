Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB903E4510;
	Mon, 17 Aug 2026 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974379; cv=none; b=BM/lNPVIN2KzzklDCQ1+o6JA6lD50dXuX/S2gWQbUIMOkJXYE4VXWQKMVF7c3IvlvfF5ktSpE7wa23HMcGM0gQiYm1PSAEIPppd7DCTPtuXPsI+13RsinG7tdlKMSBi3nMf0a4hGU7ycdH76UeLgbBokPK591Z/LS7O0p6yTgtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974379; c=relaxed/simple;
	bh=w03RYCZm3BYqaKNEatxRvDuHhajNosA6rIeJjJWn7Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhXL2KK/c/oejRAOAhnXf58l4O9aRPHyexYvisclNgtDYexVpMcqPLNbSnVshNMMVIGZ3GTDVh0m8nhjoZ2+zNj9wLMHXir7U/rSU330xqZHSAmmmwvWZ2Ye80ObzCwJEbXDBils98VXM70AftUq++QvzIhcuC1hUlnmdBM/ux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=og5d/DA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="og5d/DA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C031F00A3E;
	Mon, 17 Aug 2026 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974371;
	bh=okoUyu6pMvo4NRonOEUmKJ6sbp5uw5Y2c+vqYBeTJpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=og5d/DA2h2/5vJz723U2DwkSEa4rmnxAnH9w2Hh4USsjACV8DYCEZUy4hVyxn0Fos
	 3t8+ddM3JPpEM19Pj9rEWxB4e/c5r9e0RAX+TGoHlc6j7BqEdPacTMRv3bwdFBGJw2
	 zOcLS1y8Ly0+TpUagPwR5wFUUgfSCahKaBlFx3yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 7.1 183/271] serial: amba-pl011: synchronize DMA teardown
Date: Mon, 17 Aug 2026 15:31:48 +0200
Message-ID: <20260817132544.356510775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 440915499231e9db1c361aa45bb702e8fd3b4a32 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1215,7 +1215,7 @@ static void pl011_dma_shutdown(struct ua
 
 	if (uap->using_tx_dma) {
 		/* In theory, this should already be done by pl011_dma_flush_buffer */
-		dmaengine_terminate_all(uap->dmatx.chan);
+		dmaengine_terminate_sync(uap->dmatx.chan);
 		if (uap->dmatx.queued) {
 			dma_unmap_single(uap->dmatx.chan->device->dev,
 					 uap->dmatx.dma, uap->dmatx.len,
@@ -1228,12 +1228,12 @@ static void pl011_dma_shutdown(struct ua
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
-			timer_delete_sync(&uap->dmarx.timer);
 		uap->using_rx_dma = false;
 	}
 }


