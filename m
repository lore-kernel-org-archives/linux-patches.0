Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501B37E310;
	Tue, 21 Jul 2026 22:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673602; cv=none; b=XptZplMnM59BpTQ5+HktTBPx+sNiRx6rlaVACJak8AUc7D4kDJbLy1482p5p6Znp273objatxFbGZr19r9RqCzjbDVdoSmUvQN2Sqpbon379m30zesyF81kRQkpX743IvNBKTvACFfxdacNUXTaWyf+Radhfc599LNzYcT1L5vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673602; c=relaxed/simple;
	bh=/3+vAxEP53IiMNOLNraq0DAgAkryEt3wt1N2fsWPLC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqcAI04BqeV3nbihQ4PD4OKmHfS5Aq45TWuzOKktjYMo3JNJJBekyJ1d/rOdneNM6GBeu35dcNjdvM+OUcsfRyEsXjTyxtAQxJWYY8hmisCubUwYB379S0ZdBvPtXRhDwU0A90L74c4zsMt2bJWnuKzdLCF32maLK+hZFaCmk+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVEb+7i2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVEb+7i2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF0B1F000E9;
	Tue, 21 Jul 2026 22:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673601;
	bh=CEySsfXIxd4eJUZGclkgGlBWNKc/fdnzV1GaAx9olgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVEb+7i2RQ7ELqcGXGf3KcsE4PVhv27VYNgM64wBk/K26RVNbl+bITiUtc7GxDyAf
	 ryDr2yUjAJvflXA+LOQP1fMsGIijNbtJ3L8iufa//kspNZ6wXCGiNt9vw5lxuFKLIx
	 EiOZ0QmdK08gXsd+1ZiIqz7MgFbiV5Dbo7X43Bes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/699] crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
Date: Tue, 21 Jul 2026 17:18:59 +0200
Message-ID: <20260721152359.758153497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 2d7b2cfc59998baf5e8622a24dc28f69a5212e06 ]

The ->curve_oid check in ecrdsa_param_curve() rejects the valid enum
value 0 (OID_id_dsa_with_sha1), but look_up_OID() returns OID__NR on
lookup failure. Compare ->curve_oid with OID__NR instead to ensure that
only unknown OIDs return -EINVAL.

Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecrdsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
index 0a970261b107d9..bfb6dbfb4598f0 100644
--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -153,7 +153,7 @@ int ecrdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
 	struct ecrdsa_ctx *ctx = context;
 
 	ctx->curve_oid = look_up_OID(value, vlen);
-	if (!ctx->curve_oid)
+	if (ctx->curve_oid == OID__NR)
 		return -EINVAL;
 	ctx->curve = get_curve_by_oid(ctx->curve_oid);
 	return 0;
-- 
2.53.0



