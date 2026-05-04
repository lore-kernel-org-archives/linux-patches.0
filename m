Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AFE3DFC79;
	Mon,  4 May 2026 14:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904741; cv=none; b=dU9L7PE0bk7BwTmoGpY1b6/HYE22S0edjreg1lwe2OJEEUINgDA3NvsULLNw+gnh8icOL9kJXLhStR1uLIHwnJ5lBk8f6nrBuRU9hMoJJZEWtW53UvRl9id/cQx5YDzUcZrXSStjN7PF1Sdy4b1CsmD0PAcChmgBy/XS1BEj5PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904741; c=relaxed/simple;
	bh=fp73vYaSQX22Nw8A3PiRgOhyfu6tRyHIG0hEYyKap8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmm0j9gSYjvWL2UvTBBUkphlHzWUhjHy8kMJ8doq61LEw3vNrjOHeGNKSg662E30RwHXwU40CqAxFlgxhQNeNF8gJOCGYG+fD6segSZ2v2rM3kd5Wah7rLfUmrygh0KyG/F5+d3tqsQ1hVH7j+RLGdloTSFIYv0iy7ZUpZkIioY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRBOe7Nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRBOe7Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD77C2BCB8;
	Mon,  4 May 2026 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904741;
	bh=fp73vYaSQX22Nw8A3PiRgOhyfu6tRyHIG0hEYyKap8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRBOe7NrEHZhU8HsX/w1il9HWk0LkCEZuUx6v687cZGeRiwmqFvD/4l50ymUE1NWJ
	 Qqs9VSMyBwU9KP/iDgFrPojJcCz22UX5frD7K8qlwr7a50YAoHuMZNFnAni81gZsgV
	 fB2io/hERbB6M8L2rQZcOmmws69I3N7Srxz+mr8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 156/215] crypto: atmel-ecc - Release client on allocation failure
Date: Mon,  4 May 2026 15:52:55 +0200
Message-ID: <20260504135135.876385805@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
 


