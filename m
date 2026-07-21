Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0B91D7E5C;
	Tue, 21 Jul 2026 20:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665661; cv=none; b=exFAzIAJaMqMnk3kPAH5BHnMxJ6y1ndNEOomaAITBjHq8VMnd74uEzCVdtFrFCKpSPHX42ixTu3z87JI23i/zoa9CWhOV7pseWEEiwAm/bHqIdjARYSeS2f5Nv5K4XYl4Xgx00UrTrAHMoeawu4Z7klSQCKLbEfEUCBOzDaDM88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665661; c=relaxed/simple;
	bh=zkZfQ/UJiFqUSULjxq1HDU3udGOd8X18vCE14qco3C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqpfZ1dQIqjnSyA4YwZngxPz+K7CJ4cTgfhL+VfC85UMAdeBw10dgpeXvekgJ/8HRuka/ewUWhnsmiFkyJhctXG6KipIcFx5EuhOHQVZlHG73v/7bdRYQsDUJl0B8bi7PO1N3X2sOumYQIFdHU6c5bUcZTKYRsWrxoPu7h8cwhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9mn/qC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9mn/qC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1201F000E9;
	Tue, 21 Jul 2026 20:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665660;
	bh=Z7MoseVtt7lwm84Jiz9Dc1SoA/xlJrt5blC82cCQwLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9mn/qC7nieh/4n8K7MpGwnIUzFF8OUKjLgMXvOZdxDTY7K3M1KOk3Jgn3OL5PoUF
	 yNxguU0xwDhh9vrSuHpBRefGRbPtnEM2x2zY4EocS7ZKYiVISSz/MNUwHX1DlDzyZE
	 3WuhxLUtTOWY1BIdSjDf4F8RSGG3KQpALTY391cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0388/1266] crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
Date: Tue, 21 Jul 2026 17:13:45 +0200
Message-ID: <20260721152450.507054574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



