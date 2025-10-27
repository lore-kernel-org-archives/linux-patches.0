Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1936D31B804;
	Mon, 27 Oct 2025 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590582; cv=none; b=cbNZP5/wSwcirLg6DnAaRmgHKI6NGnVUAUvpd+5PNQjxt6Ew7blALI7yBYuiIvkCtaMeno6TzPR9sBTxkIdFp2Nl5vL5o9DbCY4IsEsp+9exIOlUXMRgqpmqH12tAJZq9bRgYv8QdgvggWDgRA46yBVKWICK+vYJxeNflptyoWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590582; c=relaxed/simple;
	bh=D868krfLupialNXXDllh6FXu4FAkib0cHZTiAiH7ek4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3Of73/a3ZdLh63L2RvHABsBefyi/HNDsIHU0vaAu2fHxOI6tu5VBZjURskGtQRdQ7wVX7vftAWHYsYGBV94arkzPjPs0k4WderbfWNycjgYrkxx8eKlyCZSmudRSYBQV4R+IYwdva56AGM0PZ5Z6KP3pVFgefWv5XhEqC+PxKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxZm0bUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxZm0bUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1633C4CEFD;
	Mon, 27 Oct 2025 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590582;
	bh=D868krfLupialNXXDllh6FXu4FAkib0cHZTiAiH7ek4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxZm0bUlg7qpoAPtYyEB5RMFESoEO/ALKn5e5nAs6KdSKF6kRXuAthVOdlPVPntOH
	 XeHmcOC/566JXWkHa7idCWTOE8hzeDVzaRGFRwoagY2giFLhVGqF217gS2uI0piHiE
	 XNeHFSMXUEopJ7j9j3WvMIX8Z4HxhupYQ1+0GvNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/224] crypto: essiv - Check ssize for decryption and in-place encryption
Date: Mon, 27 Oct 2025 19:34:03 +0100
Message-ID: <20251027183511.587118514@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 6bb73db6948c2de23e407fe1b7ef94bf02b7529f ]

Move the ssize check to the start in essiv_aead_crypt so that
it's also checked for decryption and in-place encryption.

Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template for ESSIV generation")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/essiv.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index aa6b89e91ac80..8a74cc34ac50a 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -203,9 +203,14 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	const struct essiv_tfm_ctx *tctx = crypto_aead_ctx(tfm);
 	struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
 	struct aead_request *subreq = &rctx->aead_req;
+	int ivsize = crypto_aead_ivsize(tfm);
+	int ssize = req->assoclen - ivsize;
 	struct scatterlist *src = req->src;
 	int err;
 
+	if (ssize < 0)
+		return -EINVAL;
+
 	crypto_cipher_encrypt_one(tctx->essiv_cipher, req->iv, req->iv);
 
 	/*
@@ -215,19 +220,12 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	 */
 	rctx->assoc = NULL;
 	if (req->src == req->dst || !enc) {
-		scatterwalk_map_and_copy(req->iv, req->dst,
-					 req->assoclen - crypto_aead_ivsize(tfm),
-					 crypto_aead_ivsize(tfm), 1);
+		scatterwalk_map_and_copy(req->iv, req->dst, ssize, ivsize, 1);
 	} else {
 		u8 *iv = (u8 *)aead_request_ctx(req) + tctx->ivoffset;
-		int ivsize = crypto_aead_ivsize(tfm);
-		int ssize = req->assoclen - ivsize;
 		struct scatterlist *sg;
 		int nents;
 
-		if (ssize < 0)
-			return -EINVAL;
-
 		nents = sg_nents_for_len(req->src, ssize);
 		if (nents < 0)
 			return -EINVAL;
-- 
2.51.0



