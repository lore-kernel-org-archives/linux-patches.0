Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C8015252D;
	Mon,  6 Jan 2025 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177119; cv=none; b=HdxDTRpLnfF+R9nif3gvrU/aXVXG8xrxFZ9obP/sRcCsqUXOUopiIskY/n8cFcwfz66cmvrSU+9PXgCaQBfAs2rANITfOsy7qsEZSZVs9OVgXGck+D1ZEj2zj6raBfnjlo4oycRMXrBOyXfhLyIt2E8JGGJOFYyHJIjKk833i+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177119; c=relaxed/simple;
	bh=03EjnzBpAtXmTACzUaPA0qMe5Uf/ZpN5tnS/0X4efDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=img16S96wojypeo9ETKVY4B4puqNbaBOx6F5Mi/mBHr7hfXYGOtIesnoXqplpHOsVhAT3MJwVwLxBUk3DCkUqQcdolihmRNNaAVhHM0QqhZ7pC3bWEkH7qbiAKMlLw6gLIqggCy0KCzAKUzr4slV+IIPoNMcfFMM5BSw9AFqnYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOOm/kta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOOm/kta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C412CC4CED2;
	Mon,  6 Jan 2025 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177119;
	bh=03EjnzBpAtXmTACzUaPA0qMe5Uf/ZpN5tnS/0X4efDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOOm/ktaLCqRcby99beBvTon2mdoR4mW4ehrk0oMmHaXY4FNClDdYRb1HKOD1auLP
	 edDyZMEd+HRLJ2qZXfx9E2gTSDbVgh3aSWXU41Wq2HkvWwbzq8zFaelFF+LnsbpoYv
	 tJwwsZA/oE92XSNmGVIalavDnqdJB/xqpFeenBD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/222] crypto: ecdsa - Avoid signed integer overflow on signature decoding
Date: Mon,  6 Jan 2025 16:13:49 +0100
Message-ID: <20250106151151.554572243@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3b0565c703503f832d6cd7ba805aafa3b330cb9d ]

When extracting a signature component r or s from an ASN.1-encoded
integer, ecdsa_get_signature_rs() subtracts the expected length
"bufsize" from the ASN.1 length "vlen" (both of unsigned type size_t)
and stores the result in "diff" (of signed type ssize_t).

This results in a signed integer overflow if vlen > SSIZE_MAX + bufsize.

The kernel is compiled with -fno-strict-overflow, which implies -fwrapv,
meaning signed integer overflow is not undefined behavior.  And the
function does check for overflow:

       if (-diff >= bufsize)
               return -EINVAL;

So the code is fine in principle but not very obvious.  In the future it
might trigger a false-positive with CONFIG_UBSAN_SIGNED_WRAP=y.

Avoid by comparing the two unsigned variables directly and erroring out
if "vlen" is too large.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdsa.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index 28441311af36..da04df3c8ecf 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -36,29 +36,24 @@ static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
 				  const void *value, size_t vlen, unsigned int ndigits)
 {
 	size_t bufsize = ndigits * sizeof(u64);
-	ssize_t diff = vlen - bufsize;
 	const char *d = value;
 
-	if (!value || !vlen)
+	if (!value || !vlen || vlen > bufsize + 1)
 		return -EINVAL;
 
-	/* diff = 0: 'value' has exacly the right size
-	 * diff > 0: 'value' has too many bytes; one leading zero is allowed that
-	 *           makes the value a positive integer; error on more
-	 * diff < 0: 'value' is missing leading zeros
+	/*
+	 * vlen may be 1 byte larger than bufsize due to a leading zero byte
+	 * (necessary if the most significant bit of the integer is set).
 	 */
-	if (diff > 0) {
+	if (vlen > bufsize) {
 		/* skip over leading zeros that make 'value' a positive int */
 		if (*d == 0) {
 			vlen -= 1;
-			diff--;
 			d++;
-		}
-		if (diff)
+		} else {
 			return -EINVAL;
+		}
 	}
-	if (-diff >= bufsize)
-		return -EINVAL;
 
 	ecc_digits_from_bytes(d, vlen, dest, ndigits);
 
-- 
2.39.5



