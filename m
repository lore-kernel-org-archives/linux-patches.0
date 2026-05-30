Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DAA3C277F;
	Sat, 30 May 2026 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165836; cv=none; b=pLzPx8WUg6UPx9TTIIFZ6x3h6p5Kpcju0u1b3Ljtkj8ddKg3FckNQLB2qrFL19eDREyiVQnMpyo2vd1CjDoCdOj4iX5976QFtanXmwXp2GuZf+VZrjDIispS3U73kW8/LL/I1IK5wR2Z3OhP9TLSoDITeLjh7f+9us5/9VoUudM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165836; c=relaxed/simple;
	bh=BO5GS9185n20hO+/L81CSaqh1dStgvYFKEkKhPOSf5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhpT+rK3RGVBTzKvDOuyBr73qE1mrpNvHYesv+JvfbPW2zU4X0RXRaIXzfyq4P0CO4fjPfaN6DYvZOLZCWR0+M9BdjLMggJWxvCMTJZZXWpmNfHf37aVB1LhdSHN8bhvUFgUmPXXuxRUnVfjHACZdvJyPGzfDJ8lpOi0ryoHWew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unKdG0nq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unKdG0nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A5E1F00893;
	Sat, 30 May 2026 18:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165835;
	bh=UGYD8tiHPKMGN8xMYcZVhhHx8zJ96yknijdnU1mc3wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unKdG0nqr2oNdjhECeUkBn/eanU6FLjDY4phHJHaa8zXgia6EzQVrJjY3acfL7cZX
	 8/3Ra0cElUGkvHY5YYNTbNzGxvEfQ9jy4K+4ncw1FpZ2wCD3duhiC3whKE0EkGwaXr
	 fwQFrFGm5h4CrT9je/ALw5raw1fzYsc5mS2BX3/o=
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
Subject: [PATCH 5.10 196/589] crypto: authencesn - reject short ahash digests during instance creation
Date: Sat, 30 May 2026 18:01:17 +0200
Message-ID: <20260530160230.059316202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


