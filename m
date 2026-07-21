Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256863368B8;
	Tue, 21 Jul 2026 17:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655740; cv=none; b=bpr58DF0PKzHA88PS2W0l+mGi+QE8iSnNrHOSMRC33ubDGSV1DuNqW/MDtD50MQOwsqf+jLbsPFJYQexLQ7R2loxL5+Okt/RgN5Ao7kEF2cnt0Wnw0m8wpGzcdrjKftgbkfvJQrtr2b41GquK3ON6NDVKvEUVsxo7KZTWjHQlu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655740; c=relaxed/simple;
	bh=cPmLov+l+LVRaTzKL5xAbH5CUtpkV1XZxOAZT9qqnyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzX7Fv3AObQWBldi2xaztN1Z+KwgGI1RxgsuvlCTyRyMQD6Upyu7f/FWIoRJ8jXm0jQS50KFyTqU9Emkcp9VHBEU5nEA89wDEFn2Aee5hbnSKwbknE4Xk+Zy1y1tLMvBsiqPWMrlFZX0uldjQyWin0ZWXyjSJ4qZ0vLbiQOlQzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wl+3LC/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wl+3LC/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5671F000E9;
	Tue, 21 Jul 2026 17:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655739;
	bh=TyWNSu2H0fiOkL7jOJfqoZiQ/xzZmH/FX7O+qRE3WYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wl+3LC/xthWlgrQupvBI4gjZF4ti6Ybq2jUjPkboy12pAIKP03SIij9AqUUynABMA
	 OBaytYwVVHA6dQVRxtybXV4K9R0cYxg455FCRtLi9/Z5d/W8jmZlbmhq/rM/ra8Brx
	 wd6vwJWRcCHElxcF09s3MHoxffqmCphqlgGU1QJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0123/1611] crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
Date: Tue, 21 Jul 2026 17:03:59 +0200
Message-ID: <20260721152517.626795403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



