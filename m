Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041112;
	b=VEeoYDDFELrUohdKvahINsepb8NcUmo5Y0MHddtog3payaRkr1r+SMRcswxbvXCprOeL
	 ylX5vgwiH5sub2StgtNvfpDrKLGb9yFhczBxktYS/SCPYa7NxLjJ4AR234EbnIRheTnNh
	 4JzfembA7k5QlCLc3S4lsc7PWniizJF1lZQXiElTT54T+NTfnm7Wkb49EZLauzO4Yp1U5
	 edmABU4xNDgUHrLN8JISxPm47aq+rvkoECs1OcEHp8NWNKB0pUx+vAJSMjhwA4hMiBwA3
	 hgFlF310sEb2/s+ResOalbmtp84NYDu4LEIN8stN2BVLuH7A8P3OhonT+uriOjNejbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIjHPUaaMZ4WelN6qz99X+CUZ6TUjhcShlDHkOCNGM0=;
	b=lhi4IFZNmpQnsvWzcRe2uJq8RkSZZwCBGNHs8FSuevqjfL/pWFQluGKJB1WGbyhxEoA3
	 rUFEOM/SUmDwL7OOn1KF0RoPpjLeycUwdAJZ6LVEIiRlk+eYY/Tt9XGSUjE5Iimsbe7wK
	 AmvETbdMo6XXIoHq4xg5tR7lP2vY95Id/2cULDICsith8whrjXcCQSxDU4JaPSQsgF4t2
	 0f3W+jcbrS/RBtz3m7zt0caPTKSh3MomhA+XP43trSx6tXVkmAuPml1RBcj9nsVINaXLe
	 6WCKFPQRn2lAPyfTZSyZwNuJ+I0IhtzXa47KxMmD/JY7ruumYPmsKbF/251Mbnt0iTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kExW9goW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00F5606A32C;
	Wed, 18 Nov 2026 22:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kExW9goW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFD81F000C5;
	Wed, 18 Nov 2026 22:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041111;
	bh=zIjHPUaaMZ4WelN6qz99X+CUZ6TUjhcShlDHkOCNGM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kExW9goWprhwAPGw103+/dWLMQZwTNFb6BeSRv4G+SKBNIvKERgAmjRhcyUNn3X3I
	 ZUtcMu3no+9Y1EH9E3c8JWQnv+Oiyg7eI8w74eW/WRnyFtE2Nrg/y6FGEHxv/VTLJs
	 ho4uD2aZ8wPEcdl4RfuZeR7WNCLdInTkubrOBMxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2697/3318] crypto: talitos - allocate channels with main struct
Date: Wed, 18 Nov 2026 15:55:19 +0100
Message-ID: <20261118150441.837807516@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fc414306d7b60..44909ca47d378 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3412,14 +3412,20 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3439,7 +3445,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3514,16 +3519,6 @@ static int talitos_probe(struct platform_device *ofdev)
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
index 11f0eb6a41db6..d4ff8d589f461 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -151,8 +151,6 @@ struct talitos_private {
 	 */
 	unsigned int fifo_len;
 
-	struct talitos_channel *chan;
-
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan ____cacheline_aligned;
 
@@ -165,6 +163,9 @@ struct talitos_private {
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



