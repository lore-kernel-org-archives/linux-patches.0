Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA7E32D42B;
	Sat, 30 May 2026 16:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160148; cv=none; b=Mkflv0rgpiuS9ySoaNb/3aqiVnNDbJYUTWhZ5seIfWy7nVH2U5RMihne6LQINkGMISUy5ldgVi0IpDsAPDYBSFXWBQer5Or9qNf3rE7jRXE2gScCUFdpfv3TWQgT+56jp/RN3+C9+5Tsr4DVxT668tk/N02AnmV/fcm1evgRo/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160148; c=relaxed/simple;
	bh=Kk++5qoGTbhJl2bYfaQNnqCGNUU5WkVI73zqFMa9l7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEvFDNttRijXOETC69rwQb+n7qF3XQffj/+mOgP/KQnwQ2WWaSpwAPoreHu+kvsNgZpxP1QId8dK+4fXc4Q8yB1voSyYSGWbvKjmJDG3FAoADmd9EV7AtNDcyNh4qDkrIu6csQSr5LoZmxqPqluPONOhvUBOiI4ebxPPCW8CB68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqZ8YbFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqZ8YbFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F29C1F00893;
	Sat, 30 May 2026 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160147;
	bh=6REIgIrxThNCCbVhfNyPdzLlQj6C+RH8hCCiKV5QTj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqZ8YbFp5f20W3sk40Uu28Wg6wOvHJm/ipYLAE7ZMgQ+o+FP5jQ2NVrNRTiCM48hB
	 /9+2+MWCx2X0wTIeSNhWTXoBbjQ3jnnM6s0vFFAxyJFTk2L6cM1sPmnZG+OOdj8/iv
	 QZnBjK3mItzOhy85CNt440KAQ9ra/EDqPaVuV15Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 257/969] crypto: atmel-ecc - Release client on allocation failure
Date: Sat, 30 May 2026 17:56:21 +0200
Message-ID: <20260530160307.577812663@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
 


