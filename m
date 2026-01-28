Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5942586FE;
	Wed, 28 Jan 2026 15:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614435; cv=none; b=FIx83pvu1T/saBeGSxHdc2blnb1bs1e190DGwJqAk7B9MrIRvbd6cbwx7A4fN138pbw9WR+0zS+PuJc/GTU6a5nM+f4obRJTaswe/YfRhHkho9/pzPaqYYQFEPiEVdM1XZdF59EN+kz58IUnpL1KuduRoanOhar842DRViiI6hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614435; c=relaxed/simple;
	bh=r5ana6WeZMtTgQ0raDHFmP7PGprR7Ad5XkG8aXi3qzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxzvFId3DG8DYUebCvo3FhlV2UruH9+z8LedAFNOxYoDGg/V9TmN8HnhDnr//kZ7GZ9hgCSvugRUn6hxyRquW9jjo5NJrIhgV2CkkAN5IsJDZZRSwnXAZYk1zo6pWSiNXHA26UvZhyKBOe+qLOoHejUJCEGMx5YEE68/DkQGuoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OU9RwfPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OU9RwfPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63605C4CEF1;
	Wed, 28 Jan 2026 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614435;
	bh=r5ana6WeZMtTgQ0raDHFmP7PGprR7Ad5XkG8aXi3qzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU9RwfPu5Hl2NwmKr/dF02xjkg3/EdG0zZ9OxdtydZUWLEridt72Z3K6sfwgFr7fw
	 L6cDqedWECOdwu9V1dnFkDK37Lpyi++cFNTGGxRJQwkk45dnUKg8goZJnnfO3Sh9A9
	 FalXhoPfMorFYjpzXXtpKlwMcf86GxVnZMpgs9GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/254] crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec
Date: Wed, 28 Jan 2026 16:21:50 +0100
Message-ID: <20260128145349.641459151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 91424e791d5c7..29ff3a0e86c09 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -189,6 +189,9 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
 	dst = src;
@@ -281,6 +284,9 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u32 tmp[2];
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	cryptlen -= authsize;
 
 	if (req->src != dst) {
-- 
2.51.0



