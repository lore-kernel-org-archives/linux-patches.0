Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013114218B5;
	Wed,  4 Feb 2026 14:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216954; cv=none; b=gYgkaE3IOhJ32sk1zCUBWgxLF8/JRZb8f2eCbsgj2afZ9SxnbkGAvzFGQi/DrE3xjdUpiWla1YSG3uGOR7m83XyEI/IKDtgFx4kiNxsL98Ni8UyZRa6/BUfygaGuT3KWaOA+8gJNtsnHVayRDvGB2nzGa1oG+qC12iBULK9IthE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216954; c=relaxed/simple;
	bh=jf53L96F0o03nFGy9WOcg1lIwFt3C5TzeTFrbuokgiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElB0VYJMdPgbusEzwxIOHAHEKoMeBwsZYyaPg4/iANmb7K1hjXTEX1Wi4zDtzTp3RXTwBPecuG51V6pRqM/5V/qac3cRXWwIJYTz2hxqgyB7fgWNeXe6ddcY+3b09cgKOC3fc6AHP5HxmzLGKZwOrRtd03n+S1cIM9pNVGBAaAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8EAliTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8EAliTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1B4C4CEF7;
	Wed,  4 Feb 2026 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216953;
	bh=jf53L96F0o03nFGy9WOcg1lIwFt3C5TzeTFrbuokgiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8EAliTWRc8L+nMt40QUrKi1H7XoN9G4d1c9mjPUhy1sOWdUIJWssRNlnrZ3jB5Go
	 y8kvWEMt59YsF19+RouH1IIFdnb2NfSNvga6w39eN98UQfKI5Pe42Df85VLFAlqxDt
	 1fEa5nCijEgIKfDe85lE7nJunB9RM0Ue7kDkPCHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/206] crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec
Date: Wed,  4 Feb 2026 15:38:32 +0100
Message-ID: <20260204143901.127628736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b60e61b1904cb..6487b35851d54 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -191,6 +191,9 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
 	dst = src;
@@ -284,6 +287,9 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u32 tmp[2];
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	cryptlen -= authsize;
 
 	if (req->src != dst) {
-- 
2.51.0



