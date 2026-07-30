Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92343F0A6;
	Thu, 30 Jul 2026 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423089; cv=none; b=iDH0g4dn82Qq2ocnpFLXFKP3rJKM0bQP37nX57cKrCm977wxf+BZOFcgcFXiT1/jknw/m1akzLeGRwOqJrafU//uGCWdXPR7wvVAqxpiA+A1qlhoqM8z25yIx9pPOPVE9/+tfrkvqxw/lC4XiCCPXLXJW7+7Fy1D7HRHjFEp6QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423089; c=relaxed/simple;
	bh=/HNhbv5BRvmJ9uXnkSZwXqr5UYGmtcxAIUdfwvjVd0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njCk0JUU8n4a0e3daiFoF2TVCWWP2ryUCBhsFENOQmyvaP8UNhMu0LCryT+iJbMeZ3td0e/xMw/t8Elis7RSYEQDEokaov8OImFTlHXMq297GPzV2bwzvXTKabvBcSp6oK9sHfGYa1c2glxAq4loQKPxlD6298p/mUMrOKEjNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C37WJtFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C37WJtFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC0A1F000E9;
	Thu, 30 Jul 2026 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423088;
	bh=cq0gFuzFbpcskHUdFfB4+BpQzU0M3zbaiiuwYiFxqkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C37WJtFkdWajvd40zANvh5Anlpv4FDvivhP9RhCtHdOEMphavz3GvCUyCn2Zji54P
	 v+I3tLUDuKPEjH/kOIDev8AZwPrehTxhXtH9Cv72U5/umueARdCizHthWQw+aeOtQI
	 rR9m8/TgSnHqzMUh8qVwkwwgD0EzvsBfU0g6k98Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 663/744] net: hip04: fix RX buffer leak on build_skb failure
Date: Thu, 30 Jul 2026 16:15:36 +0200
Message-ID: <20260730141458.357470104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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


