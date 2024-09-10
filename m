Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B641891A1;
	Tue, 10 Sep 2024 09:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962205; cv=none; b=VrwgO8sCKlckw0GF5gsZpY426smuhMkL/vdNsiENX6EzXA1KPOhlgWdv0nRphojY8bR6NOzvgtnz48M2kSMLOP2jUtN3T7Ak3mq+2MW9ABKxOANqO1EUIzBk85VFIfW+a9NOfgTyjHMXLWHZDBkSBnczX6IWLvMYwywcVTJWl60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962205; c=relaxed/simple;
	bh=Z7LcgeHK3NTvKJ1WEEsQpAUZ4+U4G99tjxC8JdCQIFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7nrbDX9CDrijrQJqrfhP93NqKaRa1NPARsRmBv9kqhHYeY1HdVv0fAfevT51gmxACW2MyCztH1Cx2siXi6mWK56Ka7+8Lw1taBlqQB576WDzS5FueGifmloTWE2giTDCe4hpiTw64LTRp/1bZXGKYHA/RWGbd8hyffWPpEFQRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSkVew++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSkVew++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815BBC4CECD;
	Tue, 10 Sep 2024 09:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962204;
	bh=Z7LcgeHK3NTvKJ1WEEsQpAUZ4+U4G99tjxC8JdCQIFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSkVew++NCpPRXcGv5SteD0rocLPgP7rRYbU/uc0p0zjUfat1vdXIW5U/H4pw+Ia6
	 fOmfbjpSNhTrSGoGc/FAynUS5CK6bemPEBnSk/5WMolka5RrYZ+FcIx2WG2uOP3Vy1
	 OKVK3irbvE2elC/JZGj6rjMTwuwUGoKVoUKSxLOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 330/375] crypto: starfive - Fix nent assignment in rsa dec
Date: Tue, 10 Sep 2024 11:32:07 +0200
Message-ID: <20240910092633.663240187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

[ Upstream commit 8323c036789b8b4a61925fce439a89dba17b7f2f ]

Missing src scatterlist nent assignment in rsa decrypt function.
Removing all unneeded assignment and use nents value from req->src
instead.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.h | 1 -
 drivers/crypto/starfive/jh7110-rsa.c  | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 85c65c6c0327..5ed4ba5da7f9 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -218,7 +218,6 @@ struct starfive_cryp_request_ctx {
 	struct scatterlist			*out_sg;
 	struct ahash_request			ahash_fbk_req;
 	size_t					total;
-	size_t					nents;
 	unsigned int				blksize;
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index 59f5979e9360..a778c4846025 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -259,7 +259,7 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 		memset(rctx->rsa_data, 0, shift);
 	}
 
-	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
+	rctx->total = sg_copy_to_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
 					rctx->rsa_data + shift, rctx->total);
 
 	if (enc) {
@@ -309,7 +309,6 @@ static int starfive_rsa_enc(struct akcipher_request *req)
 	rctx->in_sg = req->src;
 	rctx->out_sg = req->dst;
 	rctx->total = req->src_len;
-	rctx->nents = sg_nents(rctx->in_sg);
 	ctx->rctx = rctx;
 
 	return starfive_rsa_enc_core(ctx, 1);
-- 
2.43.0



