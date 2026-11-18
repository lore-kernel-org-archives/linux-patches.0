Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061408;
	b=MTGGYk42SmzHwh0nYdGz6ZWpccVTEv5K1qp3bNG/dNMMnJoI+KFd/UL4FSA+oHabrzds
	 rb9VjoADH5mK7JfFvQ7K0ycMmgiC55O04/VPNBmDB1eEBVp24irnpFTeAeILN4VZ3lkxP
	 zzww64qqf2W0om1EVp+gAz/bcq/cNG6SGkVcZQIPErl0Yhd3dS3qdl9al/IG0IeqdcfRR
	 ovlW58LN5YAX7K8dbvy/nZFbaXGz5C2aD5+SGzTDgT4YulNw11IkL/7x9xLyNFP6Bbmyj
	 O+wYJ7Mz7XOEtdQLLqR4ReNDMQa3JTma9dkoO+8rUUHfp5/vAl1OLE7eYFgLPbNi9vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0Um5hV/BWE4R2GCZHtRUGEh2cEto9KGpv7ETEkg6Ko=;
	b=d1AToTsGrYMEorVsy4iKiB9HAX0zE1hqEgG6d76c4Ver3GcahOo10dEteRuDgUI4Ur3N
	 LooB0MTq8qhdbKNxk+ceNXA+xQOqU4ypFgMfIWsYfAM8ycTbuZVGXxpCVsVmDjk4YuE3S
	 d2FSRZapviSUA+7lHW6VfW+MxX1I5+mTJHXv4WPl003qDynXbqff2znMMzYfynQzAzTEU
	 gLgffVTn4FsQtAausJM6Qo37RJ2Pnj0rvo8efYFZ9iGdDu+QS+6wT9HInSAhES4BA1gWG
	 VcBJnk2iiwYoCEmLZbaUGZqc2AikRaMF7UtzFyjys3ir1ABTDUw9ndDv45DXAai3UaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFct+jwZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B701606A332;
	Thu, 19 Nov 2026 04:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFct+jwZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C551F000C4;
	Thu, 19 Nov 2026 04:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061408;
	bh=B0Um5hV/BWE4R2GCZHtRUGEh2cEto9KGpv7ETEkg6Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFct+jwZrT2qlYjZZfYChGHCs5iER5dodhMTygHbRyA2THUijJFuLgZSP5pwvurnV
	 NGqcOip2eEcsXfgrApkcHA0TXsA9kIWTi4NGw7na7J/beb6vNCtyFUdA2qgVnd4LaQ
	 k3HcuoNso6hDGu+JrIvAHXNi02qkQ8QiYJuHWaQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1541/1848] crypto: talitos - allocate channels with main struct
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118150024.021700584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 98b8f7f55febe..6d4184d8c46b4 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3341,14 +3341,20 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3368,7 +3374,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3443,16 +3448,6 @@ static int talitos_probe(struct platform_device *ofdev)
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



