Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBE6154C04;
	Mon,  6 Jan 2025 15:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177116; cv=none; b=OIn8uA/19sw/mLZ1J7YDcTVapibBudxu9iULxBjJ2vmnLbCI9UVtHxbtjuFe7reDxk1DYN3exr9XbUpTT+2wW9fL5y7ir0IUx69UCrCjfhTj1LokIEt1p0I6NZ4mUhMlUuzRwaOKMf1pkeq48SImLdeeylBQf3gv7TwZGienDMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177116; c=relaxed/simple;
	bh=ujOyCc/3ir0aS0au+IVR/pYUP7g01f9kghYSTA9Vv68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJImdGH+CzgbS/qfdFQ1vsM0rR4KEpF7r28mWWysqM1yVCCuAPokSrbLazw6xe96TGlaPmkGK2YvS3VcNZxamtLCp8MQ05Y2LeKNS1WVxE22UZqkOIoNaN6zJiqPbT2tTSts51/4V3rWklj9Ihww4+SfXsH32H/sDRZo1rwYvK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSTMjVyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSTMjVyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA0C4CED2;
	Mon,  6 Jan 2025 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177116;
	bh=ujOyCc/3ir0aS0au+IVR/pYUP7g01f9kghYSTA9Vv68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSTMjVyC3R17PcJ2PJh2q/7ogDVbSfhTA4aKxISLCYrV/TztEwbRu7rcM+QdzAW/u
	 KC54ZbTW098fS5ekD0C9FNyZ0Dia5k8VuTS3WlVyqpnIsjFicQtEvB0ntMmaRoYCns
	 bXjgpstPQ0FLpzPtzdERWOMMbb2417zFtENxIMJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/222] crypto: ecdsa - Use ecc_digits_from_bytes to convert signature
Date: Mon,  6 Jan 2025 16:13:48 +0100
Message-ID: <20250106151151.517494087@linuxfoundation.org>
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

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit 546ce0bdc91afd9f5c4c67d9fc4733e0fc7086d1 ]

Since ecc_digits_from_bytes will provide zeros when an insufficient number
of bytes are passed in the input byte array, use it to convert the r and s
components of the signature to digits directly from the input byte
array. This avoids going through an intermediate byte array that has the
first few bytes filled with zeros.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 3b0565c70350 ("crypto: ecdsa - Avoid signed integer overflow on signature decoding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdsa.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index 142bed98fa97..28441311af36 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -38,7 +38,6 @@ static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
 	size_t bufsize = ndigits * sizeof(u64);
 	ssize_t diff = vlen - bufsize;
 	const char *d = value;
-	u8 rs[ECC_MAX_BYTES];
 
 	if (!value || !vlen)
 		return -EINVAL;
@@ -46,7 +45,7 @@ static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
 	/* diff = 0: 'value' has exacly the right size
 	 * diff > 0: 'value' has too many bytes; one leading zero is allowed that
 	 *           makes the value a positive integer; error on more
-	 * diff < 0: 'value' is missing leading zeros, which we add
+	 * diff < 0: 'value' is missing leading zeros
 	 */
 	if (diff > 0) {
 		/* skip over leading zeros that make 'value' a positive int */
@@ -61,14 +60,7 @@ static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
 	if (-diff >= bufsize)
 		return -EINVAL;
 
-	if (diff) {
-		/* leading zeros not given in 'value' */
-		memset(rs, 0, -diff);
-	}
-
-	memcpy(&rs[-diff], d, vlen);
-
-	ecc_swap_digits((u64 *)rs, dest, ndigits);
+	ecc_digits_from_bytes(d, vlen, dest, ndigits);
 
 	return 0;
 }
-- 
2.39.5



