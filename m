Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1C44160C;
	Mon, 17 Aug 2026 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975869; cv=none; b=GUSRg4vcJEok63liHbmTtI4ctpR4MMbENwtK9FjfyziWhvN0MiHAfe0Tj6Y3vktyY9PuZARdiNRE1IYRiUsjK2KXxppy+iBjGZypWs4c2P9y+QAftM5K7Cu+kO98/8NBgp15m3gONA1VxC4HCC7XV/Ba/BzmkMtz0Qd1YK/UFrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975869; c=relaxed/simple;
	bh=HJp/Eu9pEOM3IVBbVRD9L9YBMF8qHa6HMnIaQ+IgEWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrM47L2lGHycmUQE88dJWboFsGUEvJi+9MaqzANQjmFUZccl2alyQypWyFvIiVjhb5CLM1wRgr8pcM03a2G34Q4rZ2X+ymyCjJQ1bj12iy+PFE3SKn/k8bis33elcWVoSClpMSIb55vQaIvVGkLIWDyLCP2wChzfD74p4JMj7oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY0r3fTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY0r3fTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EDA1F000E9;
	Mon, 17 Aug 2026 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975867;
	bh=wbPQTllRDgkibmbVR8oz2wv186wHXYnR1oPZzMUUic4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gY0r3fTVRmyUtNhwAFr/fpdwnLJsNqTu3OTEZBMG5oTRVwGjsb2IhVBWhjycsSNER
	 tkqBzT7WhZ5IfFPFQ422p+/sO5zvOOULPU4L9Z7+0hA/rJTQx2dkIzP5V6+R3BmoD9
	 PXppQAsRN3xwqux8PfrPO4lB/ShV2wlG0XT92wkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 176/389] net: hip04: fix RX buffer leak on build_skb failure
Date: Mon, 17 Aug 2026 15:30:15 +0200
Message-ID: <20260817132546.045873344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


