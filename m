Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDEC2DECDF;
	Tue, 21 Jul 2026 19:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661636; cv=none; b=tHAWpgQrR/qu1uWCW//ISgdY/kc3LYdO6bLDF5GJSE23ocQzmEU6aVXxKyg4TkOqaRlVvFzjM/iFyZ5YoIJKSqrC/d2EqwY2Qy0otRYWFrYVvL92u6GFNvT0rIgVniOGYNIGFNkW4e4zcTxYKvtrKtqDVylpdmbYwvGZAEUiac0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661636; c=relaxed/simple;
	bh=8uuoTeJ+qnUeFz+ZowfPxlbofdhwm43YWDQQgsHD5jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJ35GZXQ6IYcKC+VOL+1UcxThMfM7SsQuQkSEkbLaYU2eklKZAwLvm1a/MkKJwp4ieMmZIH/Bxwz3Jij2f45A/08jGkWtDkW9Puyg+6APT8hGH0YuEt3h84c3sBRnmDyU4EHMJrEIRYloVITEHxiy15QrLf/C3K8et9T5g+YbGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgOcD9rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgOcD9rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009C51F000E9;
	Tue, 21 Jul 2026 19:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661635;
	bh=syYAb7TPQ37IqL8xGRDECJq7X2XpcT2dFfSe/16BpuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgOcD9rdgDJO/pInn7NLNn4X8GfD74ZBVQiK+2wIwiG44obciXoQueTCLNEGu1CCE
	 bSpxZxY0ZJeTrXdsSROFEOiukpcpUgnlvbhpJiZ2yyKk2tQXjPB/fVzuzFuQmiGv6z
	 4JJjYb4JPSgWjLsfHb29+jFhvp4bkDcFEBuUg8ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0098/1276] crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
Date: Tue, 21 Jul 2026 17:09:01 +0200
Message-ID: <20260721152448.288924495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 3811f3805b5d88..38271526d1f8d8 100644
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



