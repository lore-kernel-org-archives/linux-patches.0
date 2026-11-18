Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049369;
	b=f1lUsXfNh7upXvTQlkqwCHuwFjqF5qbHNSjztlp440zynWqJGuJLeRkGJIyFBJcToUo/
	 99WuvcuVMlSGFDCvAy69qJpFqvpbBzDeL+biqBa81dqMiNZG2LN8RkXTb2Q6axrU3oiMu
	 dZkdHyBQ3g2grR7BW1p/0SfbtBCkBka3loUL3eCKbLavjzqjMG4ZGzh5rTjsGO2b+B8BK
	 D2yD5eRC7ckFMmjsllPKLw+OIBQ1UDswY+1n/iTEyv/ZkfAC8qB6gHsSjgiUnsG/6jkXu
	 6OqCb3P2tG9pQHLB2i3CUULLwgF1bd/eloTng2jukFiMkwrgnC3PYbLa8kP5MPLWztg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TouZeSY5d4AkaMlVY9nheYMbasFKOgO0qUE1EXih3EU=;
	b=3sqro1W8ezc8B8RYmHGzDgkgkwgOaDeeBQJrrEtMp2i6rkhrst/kE0fu5Jr70tygHtJl
	 MCo6yIBeHt18ruWtpkdnOnGabAZoy1bsCubxIg8s/ZpKry25SQ/9SSZ+6vllChAxhToqr
	 YaNfjvSVz/qtOIJb0L1vPqmJ/dxBD9AzWZ/Xct4EGg4t2t+PN+vJ0+UHGV2onME1svM0U
	 20DRCuj/ZTrMNAlS0nxYGw5HpOdwQbcrCbtPz8BxvMIksM+CIAFYF38ZPPEeEqkQLQayo
	 F+XFQ6zLMHCeS68pfiflvjgv+nRROpRh8ZFZhb3XoQStHWoyTnAjTnGp6U3yXMe35hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODjXBYOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8F6606A32A;
	Thu, 19 Nov 2026 00:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODjXBYOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4EB1F000C5;
	Thu, 19 Nov 2026 00:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049369;
	bh=TouZeSY5d4AkaMlVY9nheYMbasFKOgO0qUE1EXih3EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODjXBYOdrfsyDx1clI9QKDHBneYjFN9Jm67GZ7GDuiGzJtoo9BOkZmjsoVSikse0a
	 1SYqus1qnXW8R/5DmzssBovRrFhL87vuyr7aJ2Ph1z+ZTomJTMNI7ZT77rjwTNt2gq
	 Aetz7uUE59/QY8rBHVyOERP3E8DmNeC/U/Kl/GLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2328/2857] crypto: talitos - allocate channels with main struct
Date: Wed, 18 Nov 2026 15:56:02 +0100
Message-ID: <20261118150325.357962322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ec2ea6c726a74..9efe5533761c1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3421,14 +3421,20 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3448,7 +3454,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3523,16 +3528,6 @@ static int talitos_probe(struct platform_device *ofdev)
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
index 043ea7965d2b8..adc2af74ec62d 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -141,8 +141,6 @@ struct talitos_private {
 	 */
 	unsigned int fifo_len;
 
-	struct talitos_channel *chan;
-
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan ____cacheline_aligned;
 
@@ -155,6 +153,9 @@ struct talitos_private {
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



