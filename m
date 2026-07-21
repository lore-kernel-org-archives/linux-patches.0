Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91383C5523;
	Tue, 21 Jul 2026 21:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668534; cv=none; b=c8mVOwKn0BMgmu25phEO2ovGsQHMG+9Tm5SCGkMRcWVkgAv9RRb5fCHtvBs/xhn1nrPIN8Ar+b0c3efBbZHRXRm/SFE1JhpwC/Mmq1PKika6Ulx4Ebw1L26yZWRFDPIfzfTCPu7bnhcpHDxebkAeMScEsM5aBUrlttU6Waj2Luc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668534; c=relaxed/simple;
	bh=08CzL3lAb0XG1B3ZPyCWcNIFVl/rgrGAVR5TH8EYXSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBUDqKDdsO6/k2F4wdcSrDB9IGLpOq9SXOv7+QnFLDfc4mKfR3Hb6lsDk0ejGdtwP8qRwkxozbkDpxineSKeq+jcPG1b97CVSoCCch4wNfjIDUVdGbaxKBm+xrt5zfXWEEMbyI+qFl0XDCio6PIUwpvN3X29ZD9eTYAq9LBW9H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWOn8dSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWOn8dSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCD81F000E9;
	Tue, 21 Jul 2026 21:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668533;
	bh=8VtZoLpQAANMtP4UDx1f/B6UNW6ewlxOAjFHVgMePZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWOn8dSkS3gkSVNr+jXaJK8jN0IWZ7sywrMOZuGVfe2FOzgvQe4VWr5I+rKaGHGJ8
	 zL0F/WX1mSqLRKRw0loSqSqZNK8e4uZEEuO2pFgMzOj9vArEcZRTIQWU5Xzm2kgWtm
	 FFezb+fXZRnzwvoCvkf97Jsm8cDTWt392vJ72P24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 0212/1067] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Tue, 21 Jul 2026 17:13:33 +0200
Message-ID: <20260721152429.337655605@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 39a31ad9e2a5ed7e9c9c6f711dca96c8c8f5f26b upstream.

drbg_ctr_generate() sometimes returns success when it fails, leaving the
output buffer uninitialized.  Fix it.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -603,7 +603,7 @@ static int drbg_ctr_generate(struct drbg
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */


