Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039418;
	b=WqsAbsSGC5oed0+JG+2kvccZo5U2F0aapuCIpna23pQgycUMvGuJcGkgR8vET0ubUngd
	 YkHh3PUDYwH+KIYj1MCsffMEkc4BNvWeiZey936lKgyyo9amO3MK+K7cFP/d2fCoi4lqa
	 8GkPFO357Ft4ISkhnbRwSl/R5W+KG4/IMQSvkkDmWioZdF9AYivWVF+IG1LK8Y2UnMEl3
	 gC/5EhDXR8/S6oDTvseJKhpgeijx+9ZHXNV73tTyyxKkSnBli23rOV4eqXLUbx9Q4vcgM
	 Pl9+KAxlIfur8j+pZwca9mI+5RBhyu12Lpp5XvonqtcCu1nDgufvwureE+rMPoRafkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gBk27G6Ws9TFzlrnEMoOpl9xzucAwoAGO1toPgQX5y4=;
	b=DNx+xUe1twUi7nFRWkbctotbBMK1ZFOvlwfNPxRpgX5+yjLyoNLNOLeMtHq4A6w0jhoB
	 aQHeoLTfhTa/ggs8XQonhD+szMBMQyk1EqiDglUY1E09iaX0TTM+f5DZiE7ZzSDNA5z9y
	 0YhJWNg9RjOC20NmIO2gwTNiStDj3rzTOvgM25am69FJk10SL07yZDGV9JjujaF7PHNDt
	 X1ymQ+IyrBr92s0gB4IyOrbbnxhMfJKK8b1Y1ynLapE3+HnDeYJtYcsz/Uv6GZasTFIU5
	 iecXMW4YjgCAyv+DakcJrhNuiubMS7xiWAvQJZ82yTv71AE2HRx2M5XQ3GnxF/MNHHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJI5MO9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3A4606A320;
	Wed, 18 Nov 2026 22:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJI5MO9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAC81F000C4;
	Wed, 18 Nov 2026 22:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039418;
	bh=gBk27G6Ws9TFzlrnEMoOpl9xzucAwoAGO1toPgQX5y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJI5MO9ic06RmvCWal83cI1renopv+NdmOZ0aOmufnuPwBauX1ugy8wXhmReZvYsq
	 2XR3gjpWZ8PJj4vGXe1Yt9Lsgj3xo3ehcPkDDNrS03q/XhhbulBYqXnvSdZ5idh/Ei
	 /g6B/oJISCoEQuZbVNyWtURKjeOm+Hwg/Pu5F8LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2091/3318] dmaengine: at_hdmac: Fix use-after-free by proper tasklet cleanup
Date: Wed, 18 Nov 2026 15:45:13 +0100
Message-ID: <20261118150424.829636154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 13f2d32a09609d083ace2d589fbdc68e970ae34c ]

Current cleanup paths have a use-after-free vulnerability:
- vchan_init() creates tasklets that access at_dma_chan memory
- free_irq() only waits for IRQ handler, NOT tasklets
- atdma is devm-managed and freed after probe/remove
- Running tasklets accessing freed memory → Use-After-Free!

The fix requires careful ordering:
- free_irq() FIRST to synchronize with running IRQ handlers and prevent
  them from scheduling new tasklets
- Then kill tasklets to wait for already-scheduled ones to complete
- Only then free other resources

Fixes: ac803b56860f ("dmaengine: at_hdmac: Convert driver to use virt-dma")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260604073945.54B311F00898@smtp.kernel.org/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Suggested-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260727061705.45169-1-zenghongling@kylinos.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/at_hdmac.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index ce9b707e8ac1c..3258d2b14eb14 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1930,6 +1930,20 @@ static void at_dma_off(struct at_dma *atdma)
 		cpu_relax();
 }
 
+static void at_dma_cleanup_channels(struct at_dma *atdma)
+{
+	struct dma_chan *chan, *_chan;
+	int i = 0;
+
+	list_for_each_entry_safe(chan, _chan, &atdma->dma_device.channels,
+			device_node) {
+		/* Disable interrupts */
+		atc_disable_chan_irq(atdma, i++);
+		tasklet_kill(&to_at_dma_chan(chan)->vc.task);
+		list_del(&chan->device_node);
+	}
+}
+
 static int __init at_dma_probe(struct platform_device *pdev)
 {
 	struct at_dma		*atdma;
@@ -2095,6 +2109,8 @@ static int __init at_dma_probe(struct platform_device *pdev)
 err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_device);
 err_dma_async_device_register:
+	disable_irq(platform_get_irq(pdev, 0));
+	at_dma_cleanup_channels(atdma);
 	dma_pool_destroy(atdma->memset_pool);
 err_memset_pool_create:
 	dma_pool_destroy(atdma->lli_pool);
@@ -2108,23 +2124,17 @@ static int __init at_dma_probe(struct platform_device *pdev)
 static int at_dma_remove(struct platform_device *pdev)
 {
 	struct at_dma		*atdma = platform_get_drvdata(pdev);
-	struct dma_chan		*chan, *_chan;
 
 	at_dma_off(atdma);
 	if (pdev->dev.of_node)
 		of_dma_controller_free(pdev->dev.of_node);
 	dma_async_device_unregister(&atdma->dma_device);
 
-	dma_pool_destroy(atdma->memset_pool);
-	dma_pool_destroy(atdma->lli_pool);
 	free_irq(platform_get_irq(pdev, 0), atdma);
 
-	list_for_each_entry_safe(chan, _chan, &atdma->dma_device.channels,
-			device_node) {
-		/* Disable interrupts */
-		atc_disable_chan_irq(atdma, chan->chan_id);
-		list_del(&chan->device_node);
-	}
+	at_dma_cleanup_channels(atdma);
+	dma_pool_destroy(atdma->memset_pool);
+	dma_pool_destroy(atdma->lli_pool);
 
 	clk_disable_unprepare(atdma->clk);
 
-- 
2.53.0



