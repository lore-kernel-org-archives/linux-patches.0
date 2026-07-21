Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8553B52FF;
	Tue, 21 Jul 2026 22:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672977; cv=none; b=FBAoxo8CYcgHQDUZjykAL/IJSWu0iyns2hkG9467qmCRlOmzYb//uUfaJLWjjJReBwrGR2oE+I6l0tFaTzhRl5t1jN54exEXIaHseDrMQz0D67srP5KQgW93aoAQilSaG9tiO9M2C1+iho9tJZ6MtQyfwobZl6boNCJBtm7lGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672977; c=relaxed/simple;
	bh=mjqdTeJtMa7mTlHE8XuhoRT5OWpnFTGy8vwzMFKjjjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clP5XDoUWfx0i+E9STWLT+yhCG6lElpMakgPvQ2uVFuYXqJlwxUb5o01LqL2JUHdzABP5F2UGGFX/d1xV/IWnY31oFUIMouQ6CQSRyI1W53UD9rwVq8U5bb4YcvfWI/4XSHawyMBBJFAoHJUSlf1XDSuGzm44epJ+twmHz6LcoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVRecg6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVRecg6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56401F000E9;
	Tue, 21 Jul 2026 22:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672976;
	bh=BFMH8j5cx2UHci9G9IiX/FNPFuIdAk5sVZ6VoShDF7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVRecg6XAlJubIVIEoBuoQidtjKDqRyh3+CTETebmJoFG83NYgrr1rBzWTrTKLCrx
	 E4r/6C56fbWHmb6R1mObFQUuSUW5avRBIhdr4a+2YOvRwIhyqFkqFr1EruY88JfCtk
	 5QFt9T2f2/5H1+TCcjZOA17fnSbt8wXuX/ZmLWno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 829/843] crypto: qat - validate RSA CRT component lengths
Date: Tue, 21 Jul 2026 17:27:44 +0200
Message-ID: <20260721152424.726445318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit b3ac78756588059729b9195fcc9f4b37d54057a5 ]

The generic RSA key parser (rsa_helper.c) bounds each CRT component (p,
q, dp, dq, qinv) by the modulus size n_sz, but qat_rsa_setkey_crt()
allocates half-size DMA buffers (key_sz / 2) and right-aligns each
component with:

    memcpy(dst + half_key_sz - len, src, len)

When a CRT component is larger than half_key_sz the subtraction
underflows and memcpy writes past the DMA buffer, causing memory
corruption.

Add a len > half_key_sz check next to the existing !len check for each
of the five CRT components so the driver falls back to the non-CRT path
instead of writing out of bounds.

Fixes: 879f77e9071f ("crypto: qat - Add RSA CRT mode")
Cc: stable@vger.kernel.org
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Tested-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -1032,7 +1032,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->p;
 	len = rsa_key->p_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto err;
 	ctx->p = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_p, GFP_KERNEL);
 	if (!ctx->p)
@@ -1043,7 +1043,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->q;
 	len = rsa_key->q_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_p;
 	ctx->q = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_q, GFP_KERNEL);
 	if (!ctx->q)
@@ -1054,7 +1054,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->dp;
 	len = rsa_key->dp_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_q;
 	ctx->dp = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_dp,
 				     GFP_KERNEL);
@@ -1066,7 +1066,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->dq;
 	len = rsa_key->dq_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_dp;
 	ctx->dq = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_dq,
 				     GFP_KERNEL);
@@ -1078,7 +1078,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->qinv;
 	len = rsa_key->qinv_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_dq;
 	ctx->qinv = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_qinv,
 				       GFP_KERNEL);


