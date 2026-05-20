Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB753D8137;
	Wed, 20 May 2026 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297963; cv=none; b=KYZUZt9bE4nfKhEIfTI+IiymANgYDNKN91cUDre4pvF8t13RHyCqfmllD7jHxLdDdRWy7upYyTDaHVsTWn7T0LkW8XfzLJ1zOPzETalhMWiV/Y8KTM1Y1agknor37LZx1wnJ/ENPaYkKJpF0StjORXFokAvaZpDUurY+G1XzqsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297963; c=relaxed/simple;
	bh=Hif1o5xqqkN0t23rQ2U/XUHG8vWCIIpQInOJY3av9qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDtwLk5oXdUIpqJYgRSNzfOUud1Ae1V4g3LDDNKjASN3JsrNP3lF5GsvcUHnKXPHqZZA+MRVn45U8TkgXbC5MNXMCsdV49DGXMLH0piUqZBd9zRQ23A1sh+X+Wz/baKhQfW+I9TE1X26FA3zMqxBRJxAHT+Ias+3cKwdkNHiN+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06rzaxOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06rzaxOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CC61F000E9;
	Wed, 20 May 2026 17:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297962;
	bh=kLZg56v2/aVjiQn2C5/y6ZA/UtIgYE1oGVoHay9NwWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06rzaxOeFLipmWY6gfcQaFiMrJmZs2XYrzW7cFtt1ygumHtCl/PbYHO+skcZfRdj9
	 4wVJf3t9uX6PI4RFlVnycOB/uu08B4rx6i6bx63iVuQqP0SdzuuUtclUGFkrc/1OTG
	 dq15+gfslaaNKGmTNcLUjgGdy0Ie2DpNdHwB4Gy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/957] crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs
Date: Wed, 20 May 2026 18:11:54 +0200
Message-ID: <20260520162139.549209585@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 57a13941c0bb06ae24e3b34672d7b6f2172b253f ]

Ensure the device supports XTS and GCM with 'has_xts' and 'has_gcm'
before unregistering algorithms when XTS or authenc registration fails,
which would trigger a WARN in crypto_unregister_alg().

Currently, with the capabilities defined in atmel_aes_get_cap(), this
bug cannot happen because all devices that support XTS and authenc also
support GCM, but the error handling should still be correct regardless
of hardware capabilities.

Fixes: d52db5188a87 ("crypto: atmel-aes - add support to the XTS mode")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9b0cb97055dc5..b393689400b4c 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2270,10 +2270,12 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	crypto_unregister_aeads(aes_authenc_algs, i);
-	crypto_unregister_skcipher(&aes_xts_alg);
+	if (dd->caps.has_xts)
+		crypto_unregister_skcipher(&aes_xts_alg);
 #endif
 err_aes_xts_alg:
-	crypto_unregister_aead(&aes_gcm_alg);
+	if (dd->caps.has_gcm)
+		crypto_unregister_aead(&aes_gcm_alg);
 err_aes_gcm_alg:
 	i = ARRAY_SIZE(aes_algs);
 err_aes_algs:
-- 
2.53.0



