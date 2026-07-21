Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390E0409E0A;
	Tue, 21 Jul 2026 21:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670713; cv=none; b=M5ztPLPxHEq/OPsX08eF8AdSrs12Q/Vg6YGfcEQe8xJahQVfl7Vr4ev+jIadXKYglLKgCCyXs1HOScP2WW4BbCremP/ljpWLPlSs2t/MYUPUGAd+EW1UKZPbeS0RWpn66GBbUYe42bu9PRM+w+rbrnhIMF6yrcZWqlBprCe04EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670713; c=relaxed/simple;
	bh=rI8d37wPn2czsvYNTw4+40RzcxPf1IWxPvuQ9sfgG3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gES5aup7xcBOqfrTOepMelG0iwOuywjWRYB46mxwG5Z5J/DY1N3tkLJ0QnHXKBx+v/guFlbI/E+HxuBfmqWTRoCqJwoe6Z9ZdEyOb2W8ZttKcHZIBKtE359FisztaO1Fy+IG9O12atVbghD1LtOLhbLg/4FU+K1oj5eoLaLRkIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqIQ8Zr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqIQ8Zr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CEE1F000E9;
	Tue, 21 Jul 2026 21:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670712;
	bh=acMKaC9FMUIIfF6vfV7Yan6WZOcNugMqjRd4+KDLVFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqIQ8Zr/egzxLssU0ixKqxkmQhBqzRmq3OThj2kizNHEY1PRFsOJcxIeJ4/x+htPw
	 7ZdY5HO0axU+q0nfcWrYBpGtDD6awk+AhDRxeTD4abvjrS1wO3TkIJ4pU3x2pWr3B3
	 OmdkNxFuyGO23HpaTf8/mfrJByDhMWsWlfnHE1dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1037/1067] crypto: qat - validate RSA CRT component lengths
Date: Tue, 21 Jul 2026 17:27:18 +0200
Message-ID: <20260721152447.785178058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


