Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629AC44AB85;
	Thu, 30 Jul 2026 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427922; cv=none; b=m0X6SC1Qw/x+WrlsjLN32i6XfgefLEbwGeGlZ2vhNQiihtRjAMFFG7ab8DEdG7fAN+VmzC63Q+iNS07XoiBWeZI3dL87trBWxInWnoaTpZaInUB9VTiHflzi9K4g3vAUlvLR0lNaxkNT/XFCHVumWmvf3/Puc0I4LRrhT8GS3wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427922; c=relaxed/simple;
	bh=uL2DneLBfsYKYlGRXrfClY0Be4jX6F/2C3jhc8khIdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4XJcfAoNMQm8K0ocGnDzYeRL0+PyVVAF/zO0IGdzDo3obDLFJgGmAK/sadV9nKS0nd1W13W2fBfzlwVvMqiY2ydAKE/iSXtenmZztjMoK0mIl/lPoTo9ZlQzG/1kLRwBSNJs9JKXM7ACoz4VaSzeXVquHsAVSq75Z3sbhhQIFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doR0IQ+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doR0IQ+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B871F000E9;
	Thu, 30 Jul 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427920;
	bh=mvKMCPbRfvCQHbR3u91Ji6GPSAdPJ/7DhoMCr0wD1NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=doR0IQ+IKhkxVGe7vBggrUBQ02B/QD2+OrQPCVFLoBYjoN9plwnz3iqMnD7plJLcq
	 liTkeXjaEn0OqFoP+GD2rIXzpvM3kkgueZDY8/KDCE7wy0O2W3y4mzCPmAC3XuBupd
	 JjAV9dLmXG2hiSz21sXwsZRiOlwizaMQou831e6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 323/484] net: hip04: fix RX buffer leak on build_skb failure
Date: Thu, 30 Jul 2026 16:13:40 +0200
Message-ID: <20260730141430.503742224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


