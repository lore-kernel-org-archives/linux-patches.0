Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FA0332EA7;
	Sat, 30 May 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160253; cv=none; b=VPlOtraC3TFORyCOytGEZ8yYFeZ6aMlL+JNwfB+eSUuvf+IuYrWsel64tSPl6umxLnlgS03CT4F5yyBpbP/pJ/cyg8DEEGXPpqu03+urDvPRN3Yh4tsS52A1YxKJ6kImGfQEYYU0VN3eWnLF8GMyu4zgrxqK1xC8W5BlSkhCcGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160253; c=relaxed/simple;
	bh=E4nlI91c6kjwlSq5FY0PgNsSP3JpA3uOZb/2TBr07ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdQvuy34InQ5OQg/UYs2O6pxaB3Uk3OidCzf1cdVx+2vBH/531UbF2pgIg5Z1r9c2TSygFaqcX/XesXvh/t5HehaSNz5zD/aMOxp0wbhAj++k6kBJb/4AvO2ZkIQ7AyMPCxQHsUWmLGeNo4xfzYa87lnSqEK8y7Z/v5wPnVa9ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4VelWCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4VelWCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8381F00893;
	Sat, 30 May 2026 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160252;
	bh=egG9ZJpG7kRwge7fGh6SJVS3TVXQDIvTJR4FIg8a/9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4VelWCyrCMRmgd9MSdzMg4maVW67HwfqZYbSHVHjSCfvMkJ7vx5ZPjmYC0EepXmj
	 s8RF27qFKfnbswtQlpf35+XBCLRqnOAm3WG8oEB3d9gNa/nrY6WpaJ6dylgP6b0Fo+
	 2t5F/9hLEnpW1B4xVUQUv3Uf/ZKFzvBwKCKRGkv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Yucheng Lu <kanolyc@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 270/969] crypto: authencesn - reject short ahash digests during instance creation
Date: Sat, 30 May 2026 17:56:34 +0200
Message-ID: <20260530160307.930216914@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Yucheng Lu <kanolyc@gmail.com>

commit 5db6ef9847717329f12c5ea8aba7e9f588a980c0 upstream.

authencesn requires either a zero authsize or an authsize of at least
4 bytes because the ESN encrypt/decrypt paths always move 4 bytes of
high-order sequence number data at the end of the authenticated data.

While crypto_authenc_esn_setauthsize() already rejects explicit
non-zero authsizes in the range 1..3, crypto_authenc_esn_create()
still copied auth->digestsize into inst->alg.maxauthsize without
validating it.  The AEAD core then initialized the tfm's default
authsize from that value.

As a result, selecting an ahash with digest size 1..3, such as
cbcmac(cipher_null), exposed authencesn instances whose default
authsize was invalid even though setauthsize() would have rejected the
same value.  AF_ALG could then trigger the ESN tail handling with a
too-short tag and hit an out-of-bounds access.

Reject authencesn instances whose ahash digest size is in the invalid
non-zero range 1..3 so that no tfm can inherit an unsupported default
authsize.

Fixes: f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
Cc: stable@kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Yucheng Lu <kanolyc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/authencesn.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -400,6 +400,11 @@ static int crypto_authenc_esn_create(str
 	auth = crypto_spawn_ahash_alg(&ctx->auth);
 	auth_base = &auth->base;
 
+	if (auth->digestsize > 0 && auth->digestsize < 4) {
+		err = -EINVAL;
+		goto err_free_inst;
+	}
+
 	err = crypto_grab_skcipher(&ctx->enc, aead_crypto_instance(inst),
 				   crypto_attr_alg_name(tb[2]), 0, mask);
 	if (err)


