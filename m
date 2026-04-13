Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB15274B5F;
	Mon, 13 Apr 2026 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096625; cv=none; b=GSZ1SPfozyu38AJp82T6oOrQrUDOKPrakfzPPWCBXnJ7GsavgvSfVywFzbVhiBrgKbQXRZAmr8nJtfewxJD/3KjLFpOtrrk4z2XxrlSUKb00H1iPQ6lG5K86bcqX4Rau2Hkq4hQbO3PLiTylbZUiLl3RBKYuZm3Uclh2rz2S4NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096625; c=relaxed/simple;
	bh=CqPM4IoUTI2cNKIURc26ZzQ03BMmrQuf07VWCdXbhy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/vl2f+APKD4YVJMwdsmhoz9WQzCuxU5TpQcfhj2lrDLHz4Yjo3j+FnwO8G3q9qT2EPre7Vc3Tay/0PJz1kYQphQTsn11NfdmBIsmOFeFm58jGxjQEhAxeEfeuLtd27QGucQKU4sAAKegY+ltxxwGf4kG6xU+igaVZFPTpO8GrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrKFo5Gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrKFo5Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8502CC2BCAF;
	Mon, 13 Apr 2026 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096624;
	bh=CqPM4IoUTI2cNKIURc26ZzQ03BMmrQuf07VWCdXbhy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrKFo5Gzv/21FdjY1NmaEO83Fdd45NgF9/X3Rin5LI9wOJK5IwaqpZBq8lVzrqC7h
	 uNcUcIt+oFLZPyld+LeHF4k2Q0E1xlr/V6jQ5eA1wXgoSNfyeWjDvA+94IhTZJHUjC
	 3ZOz6D2inOVem/wUoxup6lqe9bduuQ5q7c90RGhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 41/83] net: altera-tse: fix skb leak on DMA mapping error in tse_start_xmit()
Date: Mon, 13 Apr 2026 18:00:09 +0200
Message-ID: <20260413155732.548569831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 6dede3967619b5944003227a5d09fdc21ed57d10 upstream.

When dma_map_single() fails in tse_start_xmit(), the function returns
NETDEV_TX_OK without freeing the skb. Since NETDEV_TX_OK tells the
stack the packet was consumed, the skb is never freed, leaking memory
on every DMA mapping failure.

Add dev_kfree_skb_any() before returning to properly free the skb.

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260401211218.279185-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/altera/altera_tse_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -572,6 +572,7 @@ static netdev_tx_t tse_start_xmit(struct
 				  DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->device, dma_addr)) {
 		netdev_err(priv->dev, "%s: DMA mapping error\n", __func__);
+		dev_kfree_skb_any(skb);
 		ret = NETDEV_TX_OK;
 		goto out;
 	}


