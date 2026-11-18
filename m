Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056029;
	b=qzpF/X1DjGe6kTog8mW4+kdNiaCg08LRRtqZZnLrNNg+ia0XdgepEILrRwtrlGmZK4q0
	 tSmr8Y+Y4+BTrBJrb7qqR9mPQ3Jype/dtCJn/48kggKR96im9bXzKnwHh+CP4KsFiNY8I
	 8x5VWKjdAqFaZ9NCFOxB2HGwyh7qwd2EVjhkE/pf3k420uZ2tcMSoJnvRvNqZQLFDqh+8
	 K+kNKFnQe8Ptnq92NYdOjzo6XYA94U/ue1xBxW6SIW2HcqC63tHYCYWZS2XJDNbSzxWAs
	 6RdtoXWGwthfNd7HvYXKftb9Rq4W/6dxkWv3p662qQDmYwZUdGAfzomU0Yau1Q/ziAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6N4bqve7Zp6s7iA70CJgoYOTvf3PORCZhfxbdyABKNU=;
	b=fuoBj+mIv1h75gIf6sLGsLFcpwlFdeefl71GKLxSu9kVQsbnZom/WJubHZTgc/40w1G7
	 YGKKvIi2rOWRFuuEUbf936gfDqxbNDesXYnvhJ5VaTZbhQyYWw5NWD0jJT2knwFGuE2Iu
	 +hIPpmbT8RFsKmpQkD7DNU4nHEbU3U+pHLD/PksPweFOqRzT/YS1+/TJoqNB7EWnfGvKY
	 BeuVhf8Ze2BiUAx+OHWVtgmJuChIDoZzIy1IJY40ROoijlPVZBq1NdPMSvy13nJIXE8zb
	 8DIGeV36RxWcVQbW4xCNpulptfmOizbxaPSy5d8+gTxsnVxnrLKpDavlE1VV9t6B1zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cC+6urVU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7B606A31C;
	Thu, 19 Nov 2026 02:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cC+6urVU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FEC1F000C4;
	Thu, 19 Nov 2026 02:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056029;
	bh=6N4bqve7Zp6s7iA70CJgoYOTvf3PORCZhfxbdyABKNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cC+6urVUBSZCWXwIQ7gwggqAjIfD4nGrxiRbJB2VIslzn0oJiy3amr/eog8UHtN3v
	 rryvpCPhWSTFs83qIpOXJ/eET89F/NLT2hHehsBn4MiqdVT+Mpe+QwRNGmXiYpr8a7
	 OQV/Gg7xKn2f4yfHrq7RSBFROQgQypJ9CR5HWSPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1815/2214] crypto: talitos - allocate channels with main struct
Date: Wed, 18 Nov 2026 15:58:11 +0100
Message-ID: <20261118150124.081537923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 24818f77603b3fcb7f3da5802b28bcc5ac7604aa ]

Use a flexible array member to combine allocations.

Add __counted_by for extra runtime analysis.

Error in case of no channels as they are required.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 666d66df2525 ("crypto: talitos - init tasklets before requesting IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 19 +++++++------------
 drivers/crypto/talitos.h |  5 +++--
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8836f8e20ee13..dcc73423eb6a0 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3342,14 +3342,20 @@ static int talitos_probe(struct platform_device *ofdev)
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv;
+	unsigned int num_channels;
 	int i, err;
 	int stride;
 	struct resource *res;
 
-	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
+	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
+		return -EINVAL;
+
+	priv = devm_kzalloc(dev, struct_size(priv, chan, num_channels), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->num_channels = num_channels;
+
 	INIT_LIST_HEAD(&priv->alg_list);
 
 	dev_set_drvdata(dev, priv);
@@ -3369,7 +3375,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3444,16 +3449,6 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 	}
 
-	priv->chan = devm_kcalloc(dev,
-				  priv->num_channels,
-				  sizeof(struct talitos_channel),
-				  GFP_KERNEL);
-	if (!priv->chan) {
-		dev_err(dev, "failed to allocate channel management space\n");
-		err = -ENOMEM;
-		goto err_out;
-	}
-
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 
 	for (i = 0; i < priv->num_channels; i++) {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 32825119e8805..3be7cc895edf1 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -139,8 +139,6 @@ struct talitos_private {
 	 */
 	unsigned int fifo_len;
 
-	struct talitos_channel *chan;
-
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan ____cacheline_aligned;
 
@@ -153,6 +151,9 @@ struct talitos_private {
 	/* hwrng device */
 	struct hwrng rng;
 	bool rng_registered;
+
+	struct talitos_channel chan[] __counted_by(num_channels);
+
 };
 
 /* .features flag */
-- 
2.53.0



