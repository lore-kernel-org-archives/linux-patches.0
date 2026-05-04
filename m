Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6F12E2F0E;
	Mon,  4 May 2026 14:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903593; cv=none; b=WisLiQJQ08bbEjYAH1A7WQJBIk3kwdVhqnbKPCJY+3fu/ydEyt8fc2jyTd2fbo7L/nYkFGnGkLvP4v/3Juh9Yjk9rE0LIxYvP16AA5S+V1hvQa76aDiYLqrMLF9NNDTtSNek/nA87RWP3lHQ28KTHU8yc41GSY+J1mEqi+fGgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903593; c=relaxed/simple;
	bh=PDn4ipzc536yI4HPIi5cwkhLIw6muVnzdjczB9UswXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcMeNG84Yg40nF6DBEiPqeuk4wBqcgBo1FOt5Lq08Ivl3n4l+eEG86cSlODNVf19i2tOUtHigBuvFMISWclXgpsqltVTTX3rUz2nZXwCg6VmhAOb4XgUBb502fJ7xNkGx8dy8MmogvYv2i39wIGxJfDnUV02roNlfQNGvbXmIro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/jziJzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/jziJzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B79C2BCB8;
	Mon,  4 May 2026 14:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903593;
	bh=PDn4ipzc536yI4HPIi5cwkhLIw6muVnzdjczB9UswXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/jziJzi6Irz71f3lYV4at2X0PlnH0GahBuzKlIwKdsfpaXhvDZBr2TlEx1ZkT11i
	 LAWAVNfpRgNf8Eb1RjE8mZjYktDaMJ6jzKFbXnQNF2qQk0oYTmuxTf2s+nlCD8N9l0
	 S8klLnb6A2j1gckbRThUg5WdYe9Nyu5vXBFh4GO8=
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
Subject: [PATCH 7.0 294/307] crypto: authencesn - reject short ahash digests during instance creation
Date: Mon,  4 May 2026 15:52:59 +0200
Message-ID: <20260504135153.849674956@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


