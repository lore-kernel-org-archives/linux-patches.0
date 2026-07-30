Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64CC37B012;
	Thu, 30 Jul 2026 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426435; cv=none; b=XTXU9PolLikCUZvEfxZ3hccShAeglp9IhRY0PCPrYFrXb2s5nJwjyXmUK13XKbUNWzSrRmHM4zo2axYGDRs1r9pPRgrllEZhjnjlmmOHpDXqE3S5XVXH4lENXHB9GcbOCiOP4mHn/auCwh9KtEQ5n6Kt97arloQBRWqQ0DmhsPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426435; c=relaxed/simple;
	bh=EZr2++cNNWDoO124uoK3Zo5dSv0VYQO4xNALmu9n4LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCn2WxJP97ACltCP1i7Qfb0QNNzjGS/21je4woIY2w8Q1MIjmtReH1VGLmcn6Chbj9N+2xn2z39VG/aLB9jDWQfHOIzK/tv7qOrQaMgtbiFJC42WGsGT6EF852uASc21lWiAJxTl2oFyge2nofcVwTfPHBQueD8Rm9EWf4rb5wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ty1cJZv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ty1cJZv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EACD1F000E9;
	Thu, 30 Jul 2026 15:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426433;
	bh=4SHuOoPxSe6edhO6BR/12s5nNpb263rYRo3ZrH51n/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ty1cJZv46fDY72E8gOEhT12U8q5Ufb4jWk9MRM28n16Zh4vAwopX1PzVAiHgA4leg
	 jVdmR2eIHBLD6GSBRyyoZnU+/z6zubpNECYaF5EQ7Dxw21crcI9ETTxc5ji8yOkJCr
	 0BFZ2C3c9CmEMNdhQvZDn4MQkvdKAOR1SKw2VrSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 416/602] net: hip04: fix RX buffer leak on build_skb failure
Date: Thu, 30 Jul 2026 16:13:28 +0200
Message-ID: <20260730141444.706630133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

commit 14fa65d10f5696b063a7d8d26e8291ea84a2c6ed upstream.

When build_skb() fails in hip04_rx_poll(), the driver jumps to the
refill path without releasing the current RX buffer and its DMA mapping.
Installing a replacement buffer then overwrites the slot references and
leaks both resources.

Keep the current slot intact and return budget so NAPI retries the same
buffer.  Also free a newly allocated RX fragment when dma_map_single()
fails.

This issue was found by an in-house static analysis tool.

Fixes: 701a0fd52318 ("hip04_eth: fix missing error handle for build_skb failed")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260712142729.2057636-1-fanwu01@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -594,7 +594,11 @@ static int hip04_rx_poll(struct napi_str
 		skb = build_skb(buf, priv->rx_buf_size);
 		if (unlikely(!skb)) {
 			net_dbg_ratelimited("build_skb failed\n");
-			goto refill;
+			/* Retain the slot; return budget so NAPI retries this
+			 * buffer. Refill would overwrite rx_buf[]/rx_phys[]
+			 * and leak them.
+			 */
+			return budget;
 		}
 
 		dma_unmap_single(priv->dev, priv->rx_phys[priv->rx_head],
@@ -622,14 +626,15 @@ static int hip04_rx_poll(struct napi_str
 			rx++;
 		}
 
-refill:
 		buf = netdev_alloc_frag(priv->rx_buf_size);
 		if (!buf)
 			goto done;
 		phys = dma_map_single(priv->dev, buf,
 				      RX_BUF_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(priv->dev, phys))
+		if (dma_mapping_error(priv->dev, phys)) {
+			skb_free_frag(buf);
 			goto done;
+		}
 		priv->rx_buf[priv->rx_head] = buf;
 		priv->rx_phys[priv->rx_head] = phys;
 		hip04_set_recv_desc(priv, phys);


