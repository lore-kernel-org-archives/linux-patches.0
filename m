Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC013F482E;
	Thu, 16 Jul 2026 14:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211263; cv=none; b=R1A8lTPxbf+Rrt1CD0C2O/8wRdRHgIggHsCK5748jiHRkZh6QIGRUy8mivq1czL6z6uH9SY/QCSnqlgt4G5D+QBr8flxdYMeSFs9MfNtdLkIRo1kA2cO0ehXgZbePsA1b05Qj6MTqoynuOLmHNOOpSbJBD59M6Y4VNFTN2+pLhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211263; c=relaxed/simple;
	bh=ZrY0CtFweRssdApxfaSnstWWGBSxBx6pecHslIAFfkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGz0Cwo5dFrNqJ1dZz+k7pLFaKPU1k7iU/ArfmfWidiiEil5WM1Uv7c69W2wLFXTcgvu42KWgzgDHYJuJPVfALB4cxunDl+GvRR1QLZQ/xA7miwjsnNwOZR9AHBhCcKQsLNxKVMh5h1OwAOVeyErdYQJWReZCWDyIFbwgXhJFrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT+9S8F8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT+9S8F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987081F000E9;
	Thu, 16 Jul 2026 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211262;
	bh=EPXm3njPzGtSVjKIiN4XuQWbDSwg/nAGvs1u9JyYde0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VT+9S8F8Y6tGR8uNJKtij374spsuQ8oxLY2eAxTXJV/NpgRtefmMmiwgqa7eTckSn
	 oMio5bdE4a7HLCFXpcUsjGVXQsQ0niS52RSd3t5ESVIJSA+PqMKzGuR0WzyWlp4Y+w
	 8C2M29XzgQKXFFsqCMTt1Xsvea/7Aa0f+cMFBCds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 360/480] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Thu, 16 Jul 2026 15:31:47 +0200
Message-ID: <20260716133052.591256840@linuxfoundation.org>
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
@@ -592,7 +592,7 @@ static int drbg_ctr_generate(struct drbg
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */


