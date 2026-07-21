Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F73439322;
	Tue, 21 Jul 2026 22:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671391; cv=none; b=oHqrzIv0HQyekuNPJPDeAC+J5WP8QW1mO9j3r181aMz3MYALDV8uECMK4wdTuXMH3bVkVsN1ZkdF5wS351ZRF/XpIHCzHxcjGZmRD3cBJBZ437djwPjhapXGoxrSxEt6QNFXu4SjUlzOnflOpN+0K6+VdMAwspJB5eotUdlGO7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671391; c=relaxed/simple;
	bh=XtRxtY5ItoC1plcgmEvV2OeNcj9LV72Xa+hyaOAzb5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Czga17m5W6iGk1wmRlDrc6ocDDXFc35KjQJnbLUe8HO1MGQnVj/Ny3tW7MCDmuAJmKX09RTo1GxBVZVGxom9Fm0mV7UV78Kfj+ZjCeEKlZkP/QFGFiLNxA77OihHVh5bRrMRV53gd9v/N4ulCys48EXf1HvvqZrJD7K5bnJee58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+A8dUGg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+A8dUGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63D51F000E9;
	Tue, 21 Jul 2026 22:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671390;
	bh=JJUsu5y5MgcG26fVFh/44LloApEFrtiYckMC4uWsX4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+A8dUGgG1inTSnqlVYnVXb8/AudJ91xAh8HLr3vM03IojL9AsnTIW3Msm3HYgyt1
	 8TAZHiD5qdUV4WL4Pjjg9oq1CY6DmTP3iWXoMx/Ojirf2odZXu0dm2HZ13WUGyV0E2
	 xUsxEvdi0/abPgKx463q8gEQDQhtkgcYy8ezgarg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/843] crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
Date: Tue, 21 Jul 2026 17:17:44 +0200
Message-ID: <20260721152411.169123351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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



