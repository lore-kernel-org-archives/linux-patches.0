Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860A3DFC60;
	Mon,  4 May 2026 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904886; cv=none; b=OqqlA/pyw8gn355tp09tOdMU2v0z8N7T9jjVLBwmpxgnSY+cuBKfK6BqgJrZlcj9UmfhTHPZmzLwQ6ebe7QThtuu74XFJxwwTIypmRYqlMI17QyO2/maxEk9078RH/cpj6CK43cJ6C8eSfrg5SQwiUgYcxcVU9K7W2ly8uZwKw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904886; c=relaxed/simple;
	bh=BTgiTMAZVY4WlHLKjElpxV2XoSpNzWIXIDypAoDBUjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcolD6B8IWEw/nHv71Ma1QaDIMEOCM9FlJ23+lj9v4iTLw8SXbpN7h00XxgWXgHIlA4dExuN69y8CHjMZByxyfxZjmB93zxPnXAaLErE4a+xXjxT7lMO1dSOEGCMFociFvf40NUc8S7gT3oOzJeIpg0azmseuckViHaJTiLP4aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdT/6NUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdT/6NUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E33CC2BCB8;
	Mon,  4 May 2026 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904886;
	bh=BTgiTMAZVY4WlHLKjElpxV2XoSpNzWIXIDypAoDBUjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdT/6NUeARdS6sYqLfXu9r/eiEbc9/CZityfPr1vz/OrBR2UU4+n+2kRXZrXDAHcv
	 P2g5Fuulb+DlIURpdWG7f2mmAcSkVn5GObSc+RBPBI66+/puLhPtfzKExQkUvdEXBz
	 GDswmBpHB+bjPNJViiYPxvIPTLFSllw4UoJPYQqY=
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
Subject: [PATCH 6.12 205/215] crypto: authencesn - reject short ahash digests during instance creation
Date: Mon,  4 May 2026 15:53:44 +0200
Message-ID: <20260504135138.290874350@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -390,6 +390,11 @@ static int crypto_authenc_esn_create(str
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


