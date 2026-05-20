Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7C836A376;
	Wed, 20 May 2026 17:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298053; cv=none; b=Vcg+2s36EdiHSZzIAR53PjIfXHWCYDuBwISThoqi5RXJ6Epoh/urhm9znHacsdraStuyCxgFoEpq2ll1iO0KEBB7G3t3bTEDN70U1PFIzLhD4ttwTW0k4+/UwYTyK7r017S8CdJkH30P7e561tNvYVzhFePv51XX9qyiYiptt+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298053; c=relaxed/simple;
	bh=9xyVdKrmb2JDH+JN/x7mA68a3knPt0h3vPsGw+Hv8bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5tSkSB40I4gFQmZODWCz/9B6B4lVD8+Y+1ytVXtKZcSg2/cJT+0v6N6mG8iC1T/30biG576AXxipoGDRZqrm8TnZHVlILfD14GyHTCOaZLHkmEEzfAsHUwSclLfiLxxLgRQYXF81RMjnAqrq1OcMBpYBS5ppGmyAlJHRUet6Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fi3g/P00; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fi3g/P00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D20E1F00896;
	Wed, 20 May 2026 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298051;
	bh=YAp+HwmXg4yTSmpGzY+UgbZxDqZOkA6BUVp3Fv7M99w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fi3g/P00vAfrvW+c5e/GSTXh/rIHRYlV6QFMlfx96TjlvfGlyxO3FUAvQnHJSma++
	 0M8akcVzvG1UWIODp3pzDochUr+zUTgG3ZHo6gRVf0rmO+9uz7grAA0LROmRww/Hxd
	 MtEMLI0a8W0kozHEDwULaE2L6SNK9BSDQ5bhhUtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/957] crypto: inside-secure/eip93 - register hash before authenc algorithms
Date: Wed, 20 May 2026 18:11:45 +0200
Message-ID: <20260520162139.357224307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 5377032914b29b4643adece0ff1dfc67e36700f4 ]

Register hash before hmac and authenc algorithms. This will ensure
selftests pass at startup. Previously, selftests failed on the
crypto_alloc_ahash() function since the associated algorithm was
not yet registered.

Fixes following error:
...
[   18.375811] alg: self-tests for authenc(hmac(sha1),cbc(aes)) using authenc(hmac(sha1-eip93),cbc(aes-eip93)) failed (rc=-2)
[   18.382140] alg: self-tests for authenc(hmac(sha224),rfc3686(ctr(aes))) using authenc(hmac(sha224-eip93),rfc3686(ctr(aes-eip93))) failed (rc=-2)
[   18.395029] alg: aead: authenc(hmac(sha256-eip93),cbc(des-eip93)) setkey failed on test vector 0; expected_error=0, actual_error=-2, flags=0x1
[   18.409734] alg: aead: authenc(hmac(md5-eip93),cbc(des3_ede-eip93)) setkey failed on test vector 0; expected_error=0, actual_error=-2, flags=0x1
...

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index b7fd9795062d4..76858bb4fcc22 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -36,6 +36,14 @@ static struct eip93_alg_template *eip93_algs[] = {
 	&eip93_alg_cbc_aes,
 	&eip93_alg_ctr_aes,
 	&eip93_alg_rfc3686_aes,
+	&eip93_alg_md5,
+	&eip93_alg_sha1,
+	&eip93_alg_sha224,
+	&eip93_alg_sha256,
+	&eip93_alg_hmac_md5,
+	&eip93_alg_hmac_sha1,
+	&eip93_alg_hmac_sha224,
+	&eip93_alg_hmac_sha256,
 	&eip93_alg_authenc_hmac_md5_cbc_des,
 	&eip93_alg_authenc_hmac_sha1_cbc_des,
 	&eip93_alg_authenc_hmac_sha224_cbc_des,
@@ -52,14 +60,6 @@ static struct eip93_alg_template *eip93_algs[] = {
 	&eip93_alg_authenc_hmac_sha1_rfc3686_aes,
 	&eip93_alg_authenc_hmac_sha224_rfc3686_aes,
 	&eip93_alg_authenc_hmac_sha256_rfc3686_aes,
-	&eip93_alg_md5,
-	&eip93_alg_sha1,
-	&eip93_alg_sha224,
-	&eip93_alg_sha256,
-	&eip93_alg_hmac_md5,
-	&eip93_alg_hmac_sha1,
-	&eip93_alg_hmac_sha224,
-	&eip93_alg_hmac_sha256,
 };
 
 inline void eip93_irq_disable(struct eip93_device *eip93, u32 mask)
-- 
2.53.0



