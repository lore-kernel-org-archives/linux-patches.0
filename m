Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A7422E1D;
	Thu, 16 Jul 2026 13:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209937; cv=none; b=iQh7RsP03y8EvcZmVNmWini/B1hIBs/NitMrZaNHSH1phzblDjRLnd8xHCkIaHj6p/gPA6slVTYI3Ab6osz4u/nTFiXMUGzrL/w6+ZXkJGgJJvO97aIdNAWCzfACN2lixuhztW0EyI+uxGhbYQqN3iTLtum5qydY/szhgOcLfDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209937; c=relaxed/simple;
	bh=9VYOwPXaLWYPR7e74fcwGqrvdBY/DhAYDS+xYaK5R/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoTQtd3l9bBVvh25X7DJk6PDulc3liiIUyFyvLEtpGD9w2GbVlbQXT0Gddi3Go+8PUbIYWV+rsbiNK+AbuvkzcdhSPqq8/ifTc1baS92Kjk30I6/QFtkmpNJcz6Rk0gBx1f2gUGLJV0a42c5QxVMXq/V8yUH/fXiAity3tRvchw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uskzw4N9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uskzw4N9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914AE1F000E9;
	Thu, 16 Jul 2026 13:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209936;
	bh=v5ufA3XVDx6l2e4r6l1uwXGth/A5AvZetdjjik/gQ40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uskzw4N9G2qKm5VWfu2ihlPkScWKGg89mpu5jy2xM6pBarpf14oGJrmMf1kOs3Okv
	 /sGsFhuvHltIUDW9zWBFaPIfYTGCF1S92ekjCsbtpY5bGIHpwDAf4/YHTBH9kIq2Xf
	 lz3OhrXJL7I30hg5QZRqLkJII4kbmYi4x6Dn6laU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 375/518] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Thu, 16 Jul 2026 15:30:43 +0200
Message-ID: <20260716133056.032745144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -377,7 +377,7 @@ static int drbg_ctr_generate(struct drbg
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */


