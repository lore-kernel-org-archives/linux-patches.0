Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054995;
	b=LMcIP3iswNs4ihv34xunJwF6F+2zvmlQ88PTpgK+10VZuwjaph+7nSh2vzO0j1zTJVja
	 a6BAS76A1KNW9FJOBbZwKHxA7UJiSET6Z31i8aYndPzNpS+EtW4H6GSlQKqikcE6JeO+w
	 3xSOU00j4ri92vT1eBsALcRR/XdnTNEtj8tKfZW+k6swKs9fD7WOaRAB1EjqKizwilnKM
	 /BVDKNzjq/A8ndsGlti8bbQmzdJq3HkTDG2m+x5LJAmCdYRfXC+I/SU3L7Pyfm/lkDbMf
	 OH6ZSAmHWHqX75dcKFSh53k2ZWrzJ2Za4MdnA5Zrf+Rvmo4IzI/Cs79IRRshph3oQAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HXch1IQ7WCWfpJ8n7AwzJYynQnhN+G3FvoKi/BElSL4=;
	b=dJoHJhlhfb0LEveRmH64BZLkfEK7KF0dMAIot2MVJPMXdCHUyx9M4/cKt98cHuH5r/tE
	 fW9UepiHtYCO11i91ucoGtILlSqmjx2hbUv3E2K2edHU/DMFPklKhceHZvmJ7eccW4KXj
	 9X4AJHENUefAIciEgKEBsWoBPP+qJUCbkKE/IxS0g8sS5BduR+Jz12l/nK6NG1GV5E+GN
	 QVZdJY3qi91kkGrPKj+DEXEfo8zu+OK+M5IuG8Cqnpo7mMcmEEfV35L7Nqvzg53oF/2ej
	 n6Bpf6OHHBdP+WoD7as128pS9DZ8kADbzQsXL28t6MHAtJ6s/XS48oNuJXYN5+bgCYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h29Ifj2R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C66A606A335;
	Thu, 19 Nov 2026 02:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h29Ifj2R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF22A1F000CE;
	Thu, 19 Nov 2026 02:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054995;
	bh=HXch1IQ7WCWfpJ8n7AwzJYynQnhN+G3FvoKi/BElSL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h29Ifj2RFgFSvA57OIXRIlb4dhNALR4YvDMpp5rKQt8xtlKsh7RUC11FiFV5lCZne
	 WKs7PfNzMBsYNJuuNTY4eClqcUvL114o5QYlARQVr62nLioVnZMVWIKD4y77ZxFwuf
	 q6n2Ov2GCgkrIB1KZtRi6RqlU8K2/uNfl+lXD1Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1474/2214] crypto: amlogic - Fix DMA memory leak in cipher error path
Date: Wed, 18 Nov 2026 15:52:30 +0100
Message-ID: <20261118150110.137470677@linuxfoundation.org>
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
index af017a087ebf0..c9eb7c5586322 100644
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



