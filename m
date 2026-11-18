Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016047;
	b=u0a4w8jlMHtjJ99I387y2/jdYMUu0NBOXR0ERcCpJxDC41vCwytqSp8Xp1JgyUi5mqf1
	 Rmvtiu34A58r4L2IfHMPQd6csuNpw+6S83QeRTJBS4raeGBbE+LqCYXWSSWGy8YeC1dWF
	 uy3n8IKiYoKbaSD7TMURqQ70lidRnTAvw4mDXfqiYRo5KABTVkzJQeiVyk5mOUoGAalCu
	 lOf4ifHEmRtqOLJSrORL7Y2kJtlLUXGyXY9mo3gaLaNhtrLePZ2CbBsVsadO9Fob3c57C
	 pA8qHCidJfiIj+6Hseb/1nM29CuGTPOBsIoIKOdNlBln5vCnDzYssbtqXgVWrNCurBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qluditEmf2UfdJnnBOQCTCesHWUWktoObIsSS21O3BM=;
	b=Vq5YnbExLVf3wbSaE4Q7CS8H7VlS1jITj1HIV3nzIgVMWyGhiw4rjJiT3+nQc8cHZ1KX
	 vpZhZGKGgbaT1jElf76Qw1UKz2cyTotki98g8oYbYO8tnCo9qQ9j/FwefR8ZZTKMdg91M
	 Il8QftxfVNP6nwrAre3Uk+3whn6ymTIcIIo6EfHX0PvOiY/hryeKeeA10x4vGkaqcQMtn
	 0Grdfga7hL3AWMpqrLbm0tuLNiOPz3xPPiajK7B0Cs+igTyo9SLIInFfl2pCGNicutiMK
	 OqvEU6EcdwoAz6YqOYQleRTPCAsH8KFcbF8cAT4lYQRmeudB93adddu6dXlwHobsKZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdkjLg4k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA9B606A31C;
	Wed, 18 Nov 2026 15:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdkjLg4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9B61F000C5;
	Wed, 18 Nov 2026 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016047;
	bh=qluditEmf2UfdJnnBOQCTCesHWUWktoObIsSS21O3BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdkjLg4k0GP39xAA4ElvpmomjLDNcRwL8FgnXpfjZk7Jd4vo88OwQ1s4mQJLx8b8x
	 6pC5vcU8BOR1ZOZXeItUjeoB0Uf7fHJTnEZQjus8x8uALdNJp7hTf/ElOnG3I1TRy5
	 cRYty4Nohk7MXU/7S2kQWqowvpfEa7gKA6zVjlx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0391/2651] crypto: amlogic - Fix DMA memory leak in cipher error path
Date: Wed, 18 Nov 2026 15:27:11 +0100
Message-ID: <20261118150301.914167697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

[ Upstream commit 6c2373dd818b777d0a81eb02acebc03940552dcd ]

A DMA memory leak occurs in meson_cipher() on the mapping error paths.
The driver jumps to the end of the function without unmapping the
previously mapped source scatterlist and key/IV buffer when the
destination apping fails.

Additionally, a memory leak occurs when a scatterlist mapping succeeds
but the returned count exceeds the driver's MAXDESC limit. In this case,
the driver rejects the mapping without unmapping it. The BIDIRECTIONAL
mapping branch also lacks the required 'MAXDESC -3' upper bound check.

Fix this by introducing proper error labels, error_src and error_keyiv
and unmap resources immediately inside the calidation checks to ensure
all successfully mapped resources are cleaned up before returning the
error.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 25 ++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 29048da6f50a7..d78815b0547d8 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -177,10 +177,13 @@ static int meson_cipher(struct skcipher_request *areq)
 	if (areq->src == areq->dst) {
 		nr_sgs = dma_map_sg(mc->dev, areq->src, sg_nents(areq->src),
 				    DMA_BIDIRECTIONAL);
-		if (!nr_sgs) {
-			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
+		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
+			dev_err(mc->dev, "Invalid BIDIR SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgs)
+				dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_BIDIRECTIONAL);
+			goto error_keyiv;
 		}
 		nr_sgd = nr_sgs;
 	} else {
@@ -189,14 +192,20 @@ static int meson_cipher(struct skcipher_request *areq)
 		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgs)
+				dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+			goto error_keyiv;
 		}
 		nr_sgd = dma_map_sg(mc->dev, areq->dst, sg_nents(areq->dst),
 				    DMA_FROM_DEVICE);
 		if (!nr_sgd || nr_sgd > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgd);
 			err = -EINVAL;
-			goto theend;
+
+			if (nr_sgd)
+				dma_unmap_sg(mc->dev, areq->dst, sg_nents(areq->dst), DMA_FROM_DEVICE);
+			goto error_src;
 		}
 	}
 
@@ -251,6 +260,12 @@ static int meson_cipher(struct skcipher_request *areq)
 						 ivsize, 0);
 		}
 	}
+	goto theend;
+
+error_src:
+	dma_unmap_sg(mc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+error_keyiv:
+	dma_unmap_single(mc->dev, phykeyiv, keyivlen, DMA_TO_DEVICE);
 theend:
 	kfree_sensitive(bkeyiv);
 	kfree_sensitive(backup_iv);
-- 
2.53.0



