Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31766146D40;
	Mon,  6 Jan 2025 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177259; cv=none; b=OaBDxw399yG36WV087GNfbBOsQskCq5en+n7vFu/BWP9YrTEz8ADHW6SQ5qdjisU/HfXHR1G4VlGRPr+O6kZDh2K2osffMs2E7RUvJ/rGC8Cq3fyDCY4CLkdwEUfjNjoy9LkrVf0AxRWBTm+ubKmjfj7jZ3K/bdDY2OmO5c47rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177259; c=relaxed/simple;
	bh=pCVJuX2u6YyFZcngH4cil7LheQ0kS0pb5HJR081cMqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqZThrDqMoTlvkF0b6Pgk50Eq1Zm/IPByx9dsjJ9THf7C2Gx6F8EjUwa91h++U3e8wWXIkQGr3QA+9wlJ+zmfClmBS8cUR89vqQ4osYnsdoAVII3yZK56p85oYLkIn/d3us7iUnGER6ccFud7Yu/zy7iYsRWoXCpYFQazrc5hYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ormt3eG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ormt3eG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C66C4CED2;
	Mon,  6 Jan 2025 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177259;
	bh=pCVJuX2u6YyFZcngH4cil7LheQ0kS0pb5HJR081cMqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ormt3eG3Y6xzxSDVHa64FVO/M79UVgUl73Dr8FUAHqO1iDpyrovxZ0dP/jHZy2rEV
	 0uTSVk29Gn7CUWyq+RRyq/06+pMvjPVRcQtM8NZQHE4TlSntTHPUq4gURU13b3XFG2
	 uIL606DqxM5AQBkyKUqQMWVW3v46bViILG9T3GNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/222] crypto: ecc - Prevent ecc_digits_from_bytes from reading too many bytes
Date: Mon,  6 Jan 2025 16:15:09 +0100
Message-ID: <20250106151154.572580943@linuxfoundation.org>
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

[ Upstream commit c6ab5c915da460c0397960af3c308386c3f3247b ]

Prevent ecc_digits_from_bytes from reading too many bytes from the input
byte array in case an insufficient number of bytes is provided to fill the
output digit array of ndigits. Therefore, initialize the most significant
digits with 0 to avoid trying to read too many bytes later on. Convert the
function into a regular function since it is getting too big for an inline
function.

If too many bytes are provided on the input byte array the extra bytes
are ignored since the input variable 'ndigits' limits the number of digits
that will be filled.

Fixes: d67c96fb97b5 ("crypto: ecdsa - Convert byte arrays with key coordinates to digits")
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecc.c                  | 22 ++++++++++++++++++++++
 include/crypto/internal/ecc.h | 15 ++-------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index f53fb4d6af99..21504280aca2 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -66,6 +66,28 @@ const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 }
 EXPORT_SYMBOL(ecc_get_curve);
 
+void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
+			   u64 *out, unsigned int ndigits)
+{
+	int diff = ndigits - DIV_ROUND_UP(nbytes, sizeof(u64));
+	unsigned int o = nbytes & 7;
+	__be64 msd = 0;
+
+	/* diff > 0: not enough input bytes: set most significant digits to 0 */
+	if (diff > 0) {
+		ndigits -= diff;
+		memset(&out[ndigits - 1], 0, diff * sizeof(u64));
+	}
+
+	if (o) {
+		memcpy((u8 *)&msd + sizeof(msd) - o, in, o);
+		out[--ndigits] = be64_to_cpu(msd);
+		in += o;
+	}
+	ecc_swap_digits(in, out, ndigits);
+}
+EXPORT_SYMBOL(ecc_digits_from_bytes);
+
 static u64 *ecc_alloc_digits_space(unsigned int ndigits)
 {
 	size_t len = ndigits * sizeof(u64);
diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.h
index ab722a8986b7..c0b8be63cbde 100644
--- a/include/crypto/internal/ecc.h
+++ b/include/crypto/internal/ecc.h
@@ -63,19 +63,8 @@ static inline void ecc_swap_digits(const void *in, u64 *out, unsigned int ndigit
  * @out       Output digits array
  * @ndigits:  Number of digits to create from byte array
  */
-static inline void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
-					 u64 *out, unsigned int ndigits)
-{
-	unsigned int o = nbytes & 7;
-	__be64 msd = 0;
-
-	if (o) {
-		memcpy((u8 *)&msd + sizeof(msd) - o, in, o);
-		out[--ndigits] = be64_to_cpu(msd);
-		in += o;
-	}
-	ecc_swap_digits(in, out, ndigits);
-}
+void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
+			   u64 *out, unsigned int ndigits);
 
 /**
  * ecc_is_key_valid() - Validate a given ECDH private key
-- 
2.39.5



