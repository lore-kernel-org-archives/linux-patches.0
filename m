Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03AA3C76BC;
	Sat, 30 May 2026 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165815; cv=none; b=cvB6j4AdXP9PbXmlz1kCDTwkgk50a4n9RUiRu7CWroz/SOBzBXJSrFcpQaeQ5VT7Z2Q1S7zo1f9pruweAXYp2KOYBRgMcByaqMEsaGmC74mVssvRtxelLMlJWvepYoY1G9v4HaKtnFh4ExhK4FQRkHCMTh/rzz510VDcGN6lj8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165815; c=relaxed/simple;
	bh=RBZvS461HT5LhHgzRgofa8OSsBYXBERZDYdw7ZzJ/pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTmGh8nfOA8i1uDLhdQjnVuSJL0UDAfhxnYfzpOKeyrXWGZm2KwCcv8TN+XoPkh4TIBickK9e/+PIizlzDVVMZPR8J+aOmB4Zh0gZqhihnjm5bVreACUMpg53YNJa6S/AMbj/kONjYU66GXdTRMTCytWDtrLnZKcbYnse9P4HW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1w0ir/CM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1w0ir/CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E597E1F00893;
	Sat, 30 May 2026 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165812;
	bh=zalla1K4KWXLLcxw36k9PfdqikV9foPMROOa+w3ykKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1w0ir/CMbiZ9vD5ufL6T2DbXGuNSbQvQaDMPleYaNVFZ16OTKKX82VG/9sT6bhkw+
	 /p45ZeiyF59XN2KIBozYR7IAVydadsFxKAWO4HRKnNf4gtCkMeFrf/E1w+m/xFjfAi
	 gGEnEedLaeY0UfEkyOcAgnZjJ+rYJUM4+5cMIfjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 190/589] crypto: atmel-ecc - Release client on allocation failure
Date: Sat, 30 May 2026 18:01:11 +0200
Message-ID: <20260530160229.895117104@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

commit 095d50008d55d13f8fcf1bbeb7c6eba51779bc85 upstream.

Call atmel_ecc_i2c_client_free() to release the I2C client reserved by
atmel_ecc_i2c_client_alloc() when crypto_alloc_kpp() fails. Otherwise
->tfm_count will be out of sync.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-ecc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -273,6 +273,7 @@ static int atmel_ecdh_init_tfm(struct cr
 	if (IS_ERR(fallback)) {
 		dev_err(&ctx->client->dev, "Failed to allocate transformation for '%s': %ld\n",
 			alg, PTR_ERR(fallback));
+		atmel_ecc_i2c_client_free(ctx->client);
 		return PTR_ERR(fallback);
 	}
 


