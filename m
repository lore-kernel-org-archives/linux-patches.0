Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C381492E33;
	Wed,  9 Sep 2026 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961788; cv=none; b=jmyAUKaEr/aB8kNVbmp2SKAt4UIudmdj0Rxo0IxuaL9AvjdsSSJ7IB7AA8E9U6WKExwOC8AY6TjcUxIjCcztuG7+XVF9nXqXfIKmfOhLDsw17Cm/yMucAgwFx/Wwrfam6/0YzYzqUO4b61mOGNIiiMWMzoE79oa1gdRzlm2nJuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961788; c=relaxed/simple;
	bh=ZLcCDwqFYCu4i39pZTDkRtcLkfcJR7u/nU46jvG/i1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udBUNJdopbTW3nLR0+QqBs9WhZbykKEobhnexhEOkZY5Umv+8psoRiEKzSIi2JvEVpJPITeExDRefEqw/Pak/AEJJ63zqXs4oLQFGmmAMd1/oK4LiAkrCzB0PuJt82NgzF7yYLBLaWJ6OEj23HhhtkMuF2t0/Pw/fQCJSCW9SNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2rFKZyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2rFKZyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943A41F00A3D;
	Wed,  9 Sep 2026 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961787;
	bh=1xwX4LcLbthFxGAunT//57KJDfQf6EptPTDvb+vgekw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2rFKZyv0CyZ7ZW52veBnbyp8xvkTVHDcv80jYMoElfAD8m3AIF7bvx5EwXnoylt7
	 laqikN12EmyOs3K9Oa9IhGlZ2gxpzfLReZs57OanQ28BSOcZDzU9/t/bhAq1DBJQjq
	 YYuhxlXryPf0CP86mPt8Cr7zJ7fthxJToaMaKBGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honghui Jiang <jiang_hh2019@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 066/556] spi: Fix DMA mapping ownership on partial map failure
Date: Wed,  9 Sep 2026 15:35:46 +0200
Message-ID: <20260909134232.785626871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honghui Jiang <jiang_hh2019@163.com>

commit 367cea239fc93094e5c16a72724800e0358f5c46 upstream.

If RX mapping fails after TX mapping succeeds, __spi_map_msg() unmaps
TX but leaves tx_sg_mapped set. If TX mapping fails on a later
transfer, mappings created for earlier transfers remain active.

In both cases, cur_{tx,rx}_dma_dev have not yet been updated because they
are assigned only after every transfer has been mapped. The subsequent
spi_unmap_msg() may therefore unmap the TX mapping again or release
earlier mappings using a NULL or stale device. Using a NULL device can
trigger an oops. An empty SG table does not prevent the NULL dereference
because dma_unmap_sg_attrs() accesses the device before checking the
entry count.

Publish both mapping devices before mapping starts and unwind all
failures through __spi_unmap_msg(). This clears the mapping flags and
releases each mapping once with the device that created it.

Publishing the devices before the loop also refreshes them when no
transfer needs mapping. No mapping flag is set in that case, so current
users do not use the pointers as mapping owners.

Fixes: e289df82344f ("spi: Rework per message DMA mapped flag to be per transfer")
Cc: stable@vger.kernel.org
Signed-off-by: Honghui Jiang <jiang_hh2019@163.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260814031419.43378-2-jiang_hh2019@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1231,6 +1231,8 @@ void spi_unmap_buf(struct spi_controller
 	spi_unmap_buf_attrs(ctlr, dev, sgt, dir, 0);
 }
 
+static int __spi_unmap_msg(struct spi_controller *ctlr, struct spi_message *msg);
+
 static int __spi_map_msg(struct spi_controller *ctlr, struct spi_message *msg)
 {
 	struct device *tx_dev, *rx_dev;
@@ -1254,7 +1256,13 @@ static int __spi_map_msg(struct spi_cont
 	else
 		rx_dev = ctlr->dev.parent;
 
-	ret = -ENOMSG;
+	/*
+	 * Store the devices before mapping so partial failures can be unwound
+	 * with the device that created each mapping.
+	 */
+	ctlr->cur_tx_dma_dev = tx_dev;
+	ctlr->cur_rx_dma_dev = rx_dev;
+
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		/* The sync is done before each transfer. */
 		unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
@@ -1267,8 +1275,8 @@ static int __spi_map_msg(struct spi_cont
 						(void *)xfer->tx_buf,
 						xfer->len, DMA_TO_DEVICE,
 						attrs);
-			if (ret != 0)
-				return ret;
+			if (ret)
+				goto unwind;
 
 			xfer->tx_sg_mapped = true;
 		}
@@ -1277,25 +1285,19 @@ static int __spi_map_msg(struct spi_cont
 			ret = spi_map_buf_attrs(ctlr, rx_dev, &xfer->rx_sg,
 						xfer->rx_buf, xfer->len,
 						DMA_FROM_DEVICE, attrs);
-			if (ret != 0) {
-				spi_unmap_buf_attrs(ctlr, tx_dev,
-						&xfer->tx_sg, DMA_TO_DEVICE,
-						attrs);
-
-				return ret;
-			}
+			if (ret)
+				goto unwind;
 
 			xfer->rx_sg_mapped = true;
 		}
 	}
-	/* No transfer has been mapped, bail out with success */
-	if (ret)
-		return 0;
-
-	ctlr->cur_rx_dma_dev = rx_dev;
-	ctlr->cur_tx_dma_dev = tx_dev;
 
 	return 0;
+
+unwind:
+	__spi_unmap_msg(ctlr, msg);
+
+	return ret;
 }
 
 static int __spi_unmap_msg(struct spi_controller *ctlr, struct spi_message *msg)


