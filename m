Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE12C3DF01A;
	Mon,  4 May 2026 14:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904205; cv=none; b=cFu3SqKU0KKsVZzT1NoDH05ZyGuY5ZktnZc9N+aFmZI2LkQhI1CKI+sn5spGytyO77kCKsnxC+KLdpV92G3ONcHNfi2IFp41glnmqELDXWHZwe8KXcLCUYAE7o4hq8RfuGB1UvGFQFoj4wUHM999KAvqRWr3RppQxsseSQwqFPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904205; c=relaxed/simple;
	bh=IhTXsJl7EKdhxDhiP1aP253jFxy4WK5HfHbVWIyCnec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueCL12uHNXydZwRrW1ZLhf7UCtOi/2qUXVjrdEPO1fzrGItoGc8Xe9ma5F7uksJP+EoRPOZ8EW5JtqZBjkxXcIz7KbZfp3incWmUL6icdiSEHFT1G79krJjGgZD+rNtjUx5Xne+4T1q+YC5/vTVgy+jS1/GdZX0rb9zFs202k2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nh25jxX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nh25jxX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A22C2BCF5;
	Mon,  4 May 2026 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904205;
	bh=IhTXsJl7EKdhxDhiP1aP253jFxy4WK5HfHbVWIyCnec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nh25jxX+sJIKAmUAdjtCp+bb/tomDHIIAQmXs/Ccu7DbrrvKEqsq4TXFcZmeNF38L
	 F5v6gJlAFdryCSvEzRifu/FnZmhoCkRn/acKjsXZ87Y6m3q1dO9fEVWYNLGAQgZPtT
	 sIIGGOMHzpLRP774eDStsZ2q4IBnQ6aBmGCrwr78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 223/275] crypto: atmel-ecc - Release client on allocation failure
Date: Mon,  4 May 2026 15:52:43 +0200
Message-ID: <20260504135151.351583301@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -261,6 +261,7 @@ static int atmel_ecdh_init_tfm(struct cr
 	if (IS_ERR(fallback)) {
 		dev_err(&ctx->client->dev, "Failed to allocate transformation for '%s': %ld\n",
 			alg, PTR_ERR(fallback));
+		atmel_ecc_i2c_client_free(ctx->client);
 		return PTR_ERR(fallback);
 	}
 


