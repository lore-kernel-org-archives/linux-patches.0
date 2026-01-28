Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1224E2FB085;
	Wed, 28 Jan 2026 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614979; cv=none; b=Ku320oEPcIhli7A/hwwiDWfKC0A2gKhsgltQ8/vLnG+kvSidWGQlLs3oR+V2Xtkv0FitndIToFaz32hSqsu5AwUeGWH4lLB89kBN1p08t3JyQwSquul1iyqvsxoO1XSbtWcV/mwUZFIdWLpVuS2E8YJnDM9wtOVCwYUmdYIcz+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614979; c=relaxed/simple;
	bh=jjZUC70QU86d6CEzf1xuStGO6g3E12kufabXDEwSsnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDrnlPVZCW+vwJWsBREtUSOKgFsyAlV/WqquLkWf+EDVM0+Lik7+Dzj6NpeHGx5GDmf0dk0owlYQ5ZRhgVrwIX4MLnOgs1UBhmgMpA2tI5hsKB6pemALuMB32sOFAjcI/l0ChjhzLNT3F7a2jTjSqfKQ+aWq8VGR34KrIqmobyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGR4acbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGR4acbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B2BC4CEF1;
	Wed, 28 Jan 2026 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614978;
	bh=jjZUC70QU86d6CEzf1xuStGO6g3E12kufabXDEwSsnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGR4acbbw+bgGSz7cCoHGb21HiCSpPr1RLTy2ymXFvsonnv3mPc03bqJSI0j80Umb
	 bLEHEmRUQsAm3UDRoj7ACAKhrnC9bX1GM8qvP2Knu+qbLNQRfjku9FHTIYYnPoNlD0
	 0tvA4ft0Uh0u3w4aOBg/HEcpi+Q2tiWbgk/s8WFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/169] crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec
Date: Wed, 28 Jan 2026 16:22:04 +0100
Message-ID: <20260128145335.499200752@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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
index 2cc933e2f7901..e08032e80f188 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -185,6 +185,9 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, assoclen);
 	dst = src;
@@ -275,6 +278,9 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	u32 tmp[2];
 	int err;
 
+	if (assoclen < 8)
+		return -EINVAL;
+
 	cryptlen -= authsize;
 
 	if (req->src != dst) {
-- 
2.51.0



