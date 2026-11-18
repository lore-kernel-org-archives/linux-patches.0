Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052241;
	b=johVESh6ZQLNbrtres8c3CBgbSeHeedSDQ2QJADz9rhtePKrw3cUocxLEhyEawU03UWq
	 UIxwS5rcG2y9vmPLHObesP7XW+JNaKwMSFM0YvHdmuGY4XseDvr4SpEA7BM+FD75lD44Q
	 oCkwFqWpLT8AT/DhFQHGZS6RTYxSttoOT1zLbFV8EPeE5JZS7Ma/ylptAVRepGwfmk/Vo
	 CzSCcvm09QOzgUaek1DRRcouKp62GOKf4163/VGIib1qzIQVS5gWbUTQ6MNmUQcCJRGfi
	 jtmH+IakbscZfIHpkSNawY8Lc9GBM+57vsOjHXPZigaTuvpe5/vzaLlaZa8iUU+40PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OqsqzvWHcmHGiRrRMNZNpv7K0f3YrZAtD3ML+dBWVVQ=;
	b=eKQRZmURIvn3ILL79rusX5l6UxKIgepBkVkgP0NmFPXXEWGe3QTOfx+lSThLaf6VckQT
	 I5sokJh4ijtksS5z6bXwpGAV5ZK7Ty+UHLXjcmEvIMgxIlauGxegdIlx976bXV3LCPH34
	 cv1v+apFTZobJaayaud3nmVy6j+cqFOAbJpS902zgJd8TNRC0Crm3+t53WPcwxhqkuh2k
	 xLVc+D2DBzlSYTY2NC2+s/wrvArYi9K0Dn1Dqmdc4smTkkX2Xav/HX0uV8gkNV1GPR3tX
	 f+foKugGBTmEuEETFrNe+aexBolovDkn78XeVIH8pqRx+QbeocG+FK2eyLzcFyv1m1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KIlmFv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E0E606A320;
	Thu, 19 Nov 2026 01:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KIlmFv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1F01F000C4;
	Thu, 19 Nov 2026 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052240;
	bh=OqsqzvWHcmHGiRrRMNZNpv7K0f3YrZAtD3ML+dBWVVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KIlmFv5K6JTZR0nRO6cYthKpxLNg4ziQRLLSerJ/ayyPW6XuO/rXqsTEk8R2q3cH
	 71S+KNke1l98X1Z9VbMa9CxWF+e252kqGUuTYKtlP2jYrZaqQe+ynTky0rTytqqOu4
	 gqnRj6cyZo8XaiFg5dKDlGMekD807u3ZNfZlBoR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0493/2214] crypto: atmel-tdes - sync output bounce buffer before DMA
Date: Wed, 18 Nov 2026 15:36:09 +0100
Message-ID: <20261118150030.899773016@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a38fdcb9c944525ca71e6aaf35e708586d0ae87d ]

The slow path maps its output bounce buffer once at probe time with
dma_map_single() and DMA_FROM_DEVICE, then reuses the mapping for every
request.  After the CPU copies a result from the buffer,
dma_sync_single_for_device() must hand the buffer back to the device before
the next DMA transfer.  The driver omits this call, so cache lines from the
previous result can remain valid while the device writes the next one.

This bug was masked by the completion paths calling
dma_sync_single_for_device() immediately before the CPU copied the output,
where dma_sync_single_for_cpu() was required.  For DMA_FROM_DEVICE on
ARM926, dma_sync_single_for_device() invokes arm926_dma_map_area(), which
invalidates the cache lines.  The misplaced call therefore discarded the
stale lines before every copy-out.

Commit c8a9a647532f ("crypto: atmel-tdes - fix DMA sync direction")
correctly changed the completion paths to call dma_sync_single_for_cpu().
On ARM926, that function invokes arm926_dma_unmap_area(), which is a no-op.
The missing pre-DMA dma_sync_single_for_device() was therefore exposed on
ARM926-based SAM9X60 and SAM9X7 SoCs.

With CONFIG_CRYPTO_SELFTESTS=y all four DES/TDES algorithms fail on
SAM9X75:

  alg: skcipher: atmel-ecb-tdes encryption test failed (wrong result) on
  test vector 2, cfg="unaligned buffer, offset=1"

Call dma_sync_single_for_device() for the output buffer before starting DMA
in both atmel_tdes_crypt_pdc() and atmel_tdes_crypt_dma().

Fixes: c8a9a647532f ("crypto: atmel-tdes - fix DMA sync direction")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 3bd5703bcfbfb..6388fc2603450 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -384,6 +384,8 @@ static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
@@ -429,6 +431,8 @@ static int atmel_tdes_crypt_dma(struct atmel_tdes_dev *dd,
 	if (!(dd->flags & TDES_FLAGS_FAST)) {
 		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
 					   DMA_TO_DEVICE);
+		dma_sync_single_for_device(dd->dev, dma_addr_out, length,
+					   DMA_FROM_DEVICE);
 	}
 
 	switch (rctx->mode & TDES_FLAGS_OPMODE_MASK) {
-- 
2.53.0



