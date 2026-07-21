Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA73444AB7F;
	Tue, 21 Jul 2026 21:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668759; cv=none; b=KquvPLA6qe4IEd489eEeU4jK6x9znTmTkCZeDRtnZ106WDHxqFTUfCjq3BBh48XdyOrj1+vVjj+wvrilb9AVUY1b5BD2ZtuRVvCOEmQYP1lDIXgNn2nGNpjasAXdpmeh11k4HWBV+qNXDnTh30xCb2R5/ecmVKwXiczC4R4girA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668759; c=relaxed/simple;
	bh=/CyOWq3SkxaVA41wy0daC/+QDa7oHvAQV+v8suRlMF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9e7YG6jnK39N5Pe81/HNowqGBv7IHl1aTkDB35GCJD8E4MWim7s9aMP6u2IHGaSqgrHjZXkKiX1juC9mCtJo+ovvH9FfpZT8dLyuJNuaSpWQ/CjTfPrtqi+s5/54mMiv0JqIZNBkhMfT1lWx0cD923dUBTymKC1ExbD9hDAEpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFwfWI7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFwfWI7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2CD1F000E9;
	Tue, 21 Jul 2026 21:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668757;
	bh=oLSEsr7AT3ZfCFaGXdmAdgE5lShpp1sCqvywwJ9vJzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFwfWI7zigO8ugK4r+uAWZDmw2y/B/Cz/UbcVZt+B/yb2bvN9zF3hfvbISjFk1T7O
	 /JnSJuxf0Fa0fSDAczxEWgEWZrhtg8DkVqqdXTxWmv67CpuVPuepvSjVg3I0tgvXu2
	 aMSKqWu+SoxFW1xE0h0nGeN3HiUZ+3PUG8g4xaO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lukas Wunner <lukas@wunner.de>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0298/1067] crypto: ecrdsa - fix unknown OID check in ecrdsa_param_curve
Date: Tue, 21 Jul 2026 17:14:59 +0200
Message-ID: <20260721152431.265864590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



