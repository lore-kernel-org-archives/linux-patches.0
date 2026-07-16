Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A400325701;
	Thu, 16 Jul 2026 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211423; cv=none; b=MIUv+9759v39yqwGbicBXXas8o5ediQWM57DugnlqXvF0v8i8b/sdDZUiE4Hp+Tn0Z9/gcFGHBmVwiiP81orgVsLByWK400ihxHCCEQDDWHgC8tYWPOmopfR8giqSDmuQND19xDdpeK8RFVKlA8HS8W4hcbvA5Mag33skbkDafA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211423; c=relaxed/simple;
	bh=9eNvRHpRDfy9PgLG7mWJ2LUhw3U8fU3Dpp+3YAr1y0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoAuOMHCeF4u76aKwCr5+q2XHiYKyIDiwZIYQCZyE2n1Lwn0kpzf38KpqEKioKeHeCUA66d36YrDeOkiWrhL7KbHGCBhbZhIdQvFzdRzhqTD9coqnq1os1qdZRC2ZM1ptTc2RbMPg5xJ/QHdR6ABzdS9Zd1jRCW5M6FnrB9KWWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9TTo18Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9TTo18Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00F21F000E9;
	Thu, 16 Jul 2026 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211422;
	bh=wDdKbCKKMMq7cUrCSzwFu+JNYDfgnff8UVeP2vY3aLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9TTo18Yfqo7lk9JanhNWhkgEVZFdf2YDnNYNLRW24s+qfJ97uLwEnzyDbiKux1zg
	 qYILs1l9aldnLctHwD5bPbNHnIixK3+SbfKZCD1z7LxwCt70A8ZS8gG4JeEQS8zcuq
	 n/P3Rg0HTUelnjwPQSuuhpYLsWYwa2G/7pzubaqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 369/480] crypto: qat - validate RSA CRT component lengths
Date: Thu, 16 Jul 2026 15:31:56 +0200
Message-ID: <20260716133052.788100430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit b3ac78756588059729b9195fcc9f4b37d54057a5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -1085,7 +1085,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->p;
 	len = rsa_key->p_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto err;
 	ctx->p = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_p, GFP_KERNEL);
 	if (!ctx->p)
@@ -1096,7 +1096,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->q;
 	len = rsa_key->q_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_p;
 	ctx->q = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_q, GFP_KERNEL);
 	if (!ctx->q)
@@ -1107,7 +1107,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->dp;
 	len = rsa_key->dp_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_q;
 	ctx->dp = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_dp,
 				     GFP_KERNEL);
@@ -1119,7 +1119,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->dq;
 	len = rsa_key->dq_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_dp;
 	ctx->dq = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_dq,
 				     GFP_KERNEL);
@@ -1131,7 +1131,7 @@ static void qat_rsa_setkey_crt(struct qa
 	ptr = rsa_key->qinv;
 	len = rsa_key->qinv_sz;
 	qat_rsa_drop_leading_zeros(&ptr, &len);
-	if (!len)
+	if (!len || len > half_key_sz)
 		goto free_dq;
 	ctx->qinv = dma_alloc_coherent(dev, half_key_sz, &ctx->dma_qinv,
 				       GFP_KERNEL);


