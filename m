Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71754221F17;
	Wed,  4 Feb 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216450; cv=none; b=sG85tG17X75GZ2OCHHjThVPh3ynrhQym7q81zkla/SsHK3Gbk2GeNAa6/lT8r4veP6S2WbuwmrPnzFA2bOd1foO4FIbvZGmUgbZFK5zzA5Rrel5cxPzoYLZQe1mi6liHRTYoOjcpgokiQB5JQRma9EPdZ6Rj6UaUYVOyneGsyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216450; c=relaxed/simple;
	bh=ubQbNfenF+7WltOzB5ZtlocwFsGhSTpktGuFeDdgEhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5HEM5fT6h+mr5bFe/iejH/8sbV/WdyNcdVDU6Tai3wlz1+OaL02QZU8kRlsEi0gfVpOQT+E7ZDmufHIzRQEri/tGxpW9l2wNZUTTay4NbgwcPtIthZ9yiLjOscQjCewM6ujNP3Ks8iK0vEn+P5Stw52jWBIOCOxbcXJ9F1ZCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afnbd1Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afnbd1Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD94FC4CEF7;
	Wed,  4 Feb 2026 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216450;
	bh=ubQbNfenF+7WltOzB5ZtlocwFsGhSTpktGuFeDdgEhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afnbd1UllwCycNYtPPIblK9qzY3MZA6CgvZbqeXhRpFFLx0ydlU9HqCjXl6KXBgOF
	 ZhxpgeymYGKC6PPBLFALlMOrRGMODqGl8N36lauu/jOt9eVS/gg8vvbtpVgVyNy7pw
	 1vhmhJgIESYCJKjGGAcKNx/L5qSi3gLTMWYZd9RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/161] crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec
Date: Wed,  4 Feb 2026 15:38:47 +0100
Message-ID: <20260204143854.061220241@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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



