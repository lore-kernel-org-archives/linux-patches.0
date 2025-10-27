Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DAF32C93F;
	Mon, 27 Oct 2025 18:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590909; cv=none; b=cXAyNw19Qn4b2tnz53Y1Zp0UBuBXGF3XEyhfGZAI0SbbDpNTbEtk8FNSdNrhpEp6JQUS4qu3inlKOiTv88d4if3TOPlHC3GZXUDcLW3ERh/7exLQb9Ha/7JxJmBa6DuMENZ1m6s8mG/HNg/LHHiPJcvPItCovO75be8/Dm61FGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590909; c=relaxed/simple;
	bh=BgP+DohvgyjLJm5hI3lmFKqB2H62H8yXPorp9uw6Nng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM8KzU+H9nXz5xYhJF0xqsNoD9iWOc1VH9VcAXuF9KONUvRL/a8+acPy1+2ND+u8AogNOg3rvGuaDs6zlsh19Jg/+hAJTpkgFwegMbwdqw93AXToEU44mI06Y93CZoMriue73Jhit1qNqjE9dlVSiLb/JudFKqvDRcjdxMvv/Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kY5D1jwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kY5D1jwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8230FC113D0;
	Mon, 27 Oct 2025 18:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590908;
	bh=BgP+DohvgyjLJm5hI3lmFKqB2H62H8yXPorp9uw6Nng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kY5D1jwJQegp9b3JLvRiz5w8i9H5ARpV9I0dblXTDEQdq1wkjOBF7MPxWCXUmjmC2
	 U66Llrx+CJ7YHLnnRJvLsio9vMrXhy+1DGUgoHivG9vRr0f3ZN6upJA+LY5r0SHoaU
	 QGNn9E+oNzziX2kPEKkufcz0VSD7YmWF6QhtwpA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 219/224] KEYS: trusted_tpm1: Compare HMAC values in constant time
Date: Mon, 27 Oct 2025 19:36:05 +0100
Message-ID: <20251027183514.596862739@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit eed0e3d305530066b4fc5370107cff8ef1a0d229 ]

To prevent timing attacks, HMAC value comparison needs to be constant
time.  Replace the memcmp() with the correct function, crypto_memneq().

[For the Fixes commit I used the commit that introduced the memcmp().
It predates the introduction of crypto_memneq(), but it was still a bug
at the time even though a helper function didn't exist yet.]

Fixes: d00a1c72f7f4 ("keys: add new trusted key-type")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
[ changed include from crypto/utils.h to crypto/algapi.h ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/hash_info.h>
+#include <crypto/algapi.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -248,7 +249,7 @@ int TSS_checkhmac1(unsigned char *buffer
 	if (ret < 0)
 		goto out;
 
-	if (memcmp(testhmac, authdata, SHA1_DIGEST_SIZE))
+	if (crypto_memneq(testhmac, authdata, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
 	kzfree(sdesc);
@@ -341,7 +342,7 @@ static int TSS_checkhmac2(unsigned char
 			  TPM_NONCE_SIZE, ononce, 1, continueflag1, 0, 0);
 	if (ret < 0)
 		goto out;
-	if (memcmp(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
+	if (crypto_memneq(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -350,7 +351,7 @@ static int TSS_checkhmac2(unsigned char
 			  TPM_NONCE_SIZE, ononce, 1, continueflag2, 0, 0);
 	if (ret < 0)
 		goto out;
-	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
+	if (crypto_memneq(testhmac2, authdata2, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
 	kzfree(sdesc);


