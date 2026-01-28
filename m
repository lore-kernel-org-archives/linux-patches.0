Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CFE270ED7;
	Wed, 28 Jan 2026 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615568; cv=none; b=kUsAhZ8hrzioltQDxFKvVfCXuryJeXrvh6uzy6424v6cqlWENECbU7fEiAG95X4bnnb9iUBbziTs9D/3ywQIbyNNdZmGujCiFr0Fpn9HzWrWtAlUHRirvXvhE5l8YSW+0UeqX3JJuqv3/Q+H0AC0lKqAlmrCg9DLctwNnoF8uqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615568; c=relaxed/simple;
	bh=03iYZY3TMTZPVudXVpXNpUUnApEiMZjZFFdBGcqyU20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAVDwVREN8NdDqEqXL8eMGHYzDfxfhBwd7zbjnhn7DGecaxCZOV1myU/+lPYPJ2gQMnnehevn0QNNaTJOjJ3iAFEEYGzevdCmaNXASIz6CeQRhd8S43KXga61/gzwfrXPQkVnsLxpeiz6qPbAo5YDNMbaSEGNMFd/CHGZnB4rhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gA5qwUQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gA5qwUQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CC0C4CEF1;
	Wed, 28 Jan 2026 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615568;
	bh=03iYZY3TMTZPVudXVpXNpUUnApEiMZjZFFdBGcqyU20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gA5qwUQmJlGRZDsf8+lk6A6BH4xhpQe6CocRg6AytwMbetbAOFKXXrFPguP2dK68Y
	 jTQF4wxhInIpJ0ksfTML+P9rSodHPkckcxgY+zAMoCsYt5bgDEWUprKpkaGxmKIrFj
	 Di1WOY6quPQAE68lQkw418f4SCFeGrukPzunMqCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/227] crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec
Date: Wed, 28 Jan 2026 16:21:32 +0100
Message-ID: <20260128145346.036884243@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Taeyang Lee <0wn@theori.io>

[ Upstream commit 2397e9264676be7794f8f7f1e9763d90bd3c7335 ]

authencesn assumes an ESP/ESN-formatted AAD. When assoclen is shorter than
the minimum expected length, crypto_authenc_esn_decrypt() can advance past
the end of the destination scatterlist and trigger a NULL pointer dereference
in scatterwalk_map_and_copy(), leading to a kernel panic (DoS).

Add a minimum AAD length check to fail fast on invalid inputs.

Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD interface")
Reported-By: Taeyang Lee <0wn@theori.io>
Signed-off-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/authencesn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index d1bf0fda3f2ef..542a978663b9e 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -169,6 +169,9 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
 	dst = src;
@@ -256,6 +259,9 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u32 tmp[2];
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	cryptlen -= authsize;
 
 	if (req->src != dst)
-- 
2.51.0



