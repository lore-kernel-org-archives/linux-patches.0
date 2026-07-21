Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E6B46AA71;
	Tue, 21 Jul 2026 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648354; cv=none; b=TAw1b/2Xi6dDDUyK8NLJ8Ri6o9y/KPC2ojMgU7Y0qjzPPaxausocZr5twUkPyOtQGsUApYhEQgfe1CZAg32pRdx6s0RwToaOUJ+tQ+an5IyMXcXVVITbLPAqWcMG2sTSGD186YIlZEcLl6SOUk7rmWkpz0BI3/sIVeu+UfRLU2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648354; c=relaxed/simple;
	bh=zZprf8wybGZ1KzOBSllQNEQ7ljexqdfQ3Ncv1W5U3H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeLYLd7iRmqEi0kxSCXKjgxTo/Ba410N88F29rH/4NASRrugkhRysoFgbOBNw5jfILYvmjgWtWS30xRhSZluh5yQURvW1BnTHj0khE+Mn2KMJs9Lv7FuVev6d3kip1nto/Rn0tXivl5bmkMEprx4bPdbww2PSFYE4kl4OkTRMb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1w2NRBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1w2NRBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D861F000E9;
	Tue, 21 Jul 2026 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648352;
	bh=QNmsTTBGdlANzAx6zJoc7UAiRng6VUzlVzbhrZwWrA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1w2NRBV7sVB4GKWlXAUfBePEhcuM6uEkgb51iZDEXbigbhNNN3wLaXeo2XeDPbyr
	 ZX5p1Cs0pRa2J2VoSWW46sgfX2dW4Vh9lKWEJ4OrVXx5RPGvsB3e8odB3clmCse6As
	 eIH01RzgnD4mPoDenBH90quIAYllri5P65d+i558=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0166/2077] crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
Date: Tue, 21 Jul 2026 16:57:19 +0200
Message-ID: <20260721152556.607396460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2c0602f0cd406f..0cd7eb3676041f 100644
--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -145,7 +145,7 @@ int ecrdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
 	struct ecrdsa_ctx *ctx = context;
 
 	ctx->curve_oid = look_up_OID(value, vlen);
-	if (!ctx->curve_oid)
+	if (ctx->curve_oid == OID__NR)
 		return -EINVAL;
 	ctx->curve = get_curve_by_oid(ctx->curve_oid);
 	return 0;
-- 
2.53.0



