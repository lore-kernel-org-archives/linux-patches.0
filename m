Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025972;
	b=D7WgdiLyUP5hlbVjisJvc/YWuqSxG9EfzrAPRJeX54829ztRPU0fKZ0JNY40CyO1qwe2
	 Hxbd9YPoqLM3r80GShIWzTWiwEyDgL3prTmnzdvtjpIgm/PS3dG8I/O+vPSeX9eHLLgU+
	 +yIAin/BMutvx+Gipew/w7Af/1RqIAAotW+fJrVoxyqxz3YUVZtyz9N2GRKlZW6zlq3Q5
	 9Hj/o80Z4ioItJv0EuFZNs3JoW/wOzJUV377Tzl6+x9IJCouAZbdBigslOq3QfaXN0D7Q
	 O5t7jL/RxizHUZRdybSW4IldJx38kpLwkriwNE1AfEoNuwNcf+Axxh05CSD86kPP4Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VeqM2nXcv2ZDC6DJwtkMT7O/xC5+J7nEdZm0OFTc//Y=;
	b=SbHoPZ7JgMYAO7BsFnzut1kFPH7Hq6Cbs+1nT6LtcFPFb2blW6G/k+T+rghK7ICSALON
	 DX1NOJbnn5RVy+FONlaZOlgDqAyhdIqJ5SBGKUxjjsbFnFuGuAnJhtDtX3MHAON08Eh4c
	 vkL99cHaElYXXi4GLX3m3rpsJHuzKbtTjhoPtA00J0WiXNxveb0EVnmT7hiH0+KaYjYDZ
	 utCgkxBPpnd0sapso2+k+PHs4gg3LBbYXo4sGXRWRI+/KltvNnlvuEVy0hb+Cgb+6zkvd
	 iiSwPbFPaTOOB6DFxUEwb6XTyhgvIS77ItmpixhuUACg3mg7TlZxuOTVol08v0lyN6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3HJDRJw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E646606A31C;
	Wed, 18 Nov 2026 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3HJDRJw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FAA1F000C4;
	Wed, 18 Nov 2026 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025972;
	bh=VeqM2nXcv2ZDC6DJwtkMT7O/xC5+J7nEdZm0OFTc//Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3HJDRJwufUB/qfIG6WNu/xwpsNskztnayeWblopXmTB7QN6XTlCj1xl/nUxJxFIn
	 nZG3BWXWRzJgoJJ4GrSFVEX9PrvClU6NFQ1fs5/0ImLcIEc+/JqdDzIAjH3m9HMY4H
	 yjaM4kqVclgKJE84LIc4Urnsi1SeDyGHssrGGIw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1269/2151] crypto: talitos - allocate channels with main struct
Date: Wed, 18 Nov 2026 15:50:04 +0100
Message-ID: <20261118150208.366793905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4b53b13f96d9f..2d69ee6086658 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3410,14 +3410,20 @@ static int talitos_probe(struct platform_device *ofdev)
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
@@ -3437,7 +3443,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	}
 
 	/* get SEC version capabilities from device tree */
-	of_property_read_u32(np, "fsl,num-channels", &priv->num_channels);
 	of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_len);
 	of_property_read_u32(np, "fsl,exec-units-mask", &priv->exec_units);
 	of_property_read_u32(np, "fsl,descriptor-types-mask",
@@ -3512,16 +3517,6 @@ static int talitos_probe(struct platform_device *ofdev)
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



