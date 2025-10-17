Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06CA32C946;
	Fri, 17 Oct 2025 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715507; cv=none; b=Gp8wDvZDjh5I7uxGpC0+DeLhl9yZdKoIkN+CMYKVuaEnCkMEemcVYIqDd3C1rmdFNktwLhdAHHxpCwx9etmE6b0lulayRsV+k9tQOzdnmGLr5jxCb8zbiS2ZlQYAnfaZSx9O8rTuRuc7LuQFptCLUB9Gck+7NNOfXR9sQE9ozUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715507; c=relaxed/simple;
	bh=OuQ4+1FCCUBVSz1eROIkM+eRG+gwF2zPRzO6f/uGHf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2NsrcfCYSbittoapDg255IM6pBvH/RlaOKV0G8WK+bFrpsUNlilFMl2DCCar7KSOXNueohfnGhkh+snvzuYIbEwPI0+ixcemK9byEfnLnUXJPsACJ3re8cZ8LqiA/qCBiQVgTrcIhDco6SDpMLd24UT0ZiWoMGQ7RqPNRafgD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETZPqQdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETZPqQdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0647CC4CEE7;
	Fri, 17 Oct 2025 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715507;
	bh=OuQ4+1FCCUBVSz1eROIkM+eRG+gwF2zPRzO6f/uGHf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETZPqQddl/XCkLntsNtV+tJyMnekqY8n00yMdSS+fR5CjKoap2Vr0QSHQzz7eJ7dK
	 H5C10TVJcZwlYTaHHTA9hx2ft/Cdje7u1pwhJLGATUh30hGv1n8F0ibcuX3CFsR5Yf
	 OFeCDcqhS06+OKWid2tzPZ3HUiQ2AqHsGzztihZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.17 233/371] KEYS: trusted_tpm1: Compare HMAC values in constant time
Date: Fri, 17 Oct 2025 16:53:28 +0200
Message-ID: <20251017145210.513772383@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit eed0e3d305530066b4fc5370107cff8ef1a0d229 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -7,6 +7,7 @@
  */
 
 #include <crypto/hash_info.h>
+#include <crypto/utils.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/parser.h>
@@ -241,7 +242,7 @@ int TSS_checkhmac1(unsigned char *buffer
 	if (ret < 0)
 		goto out;
 
-	if (memcmp(testhmac, authdata, SHA1_DIGEST_SIZE))
+	if (crypto_memneq(testhmac, authdata, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
 	kfree_sensitive(sdesc);
@@ -334,7 +335,7 @@ static int TSS_checkhmac2(unsigned char
 			  TPM_NONCE_SIZE, ononce, 1, continueflag1, 0, 0);
 	if (ret < 0)
 		goto out;
-	if (memcmp(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
+	if (crypto_memneq(testhmac1, authdata1, SHA1_DIGEST_SIZE)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -343,7 +344,7 @@ static int TSS_checkhmac2(unsigned char
 			  TPM_NONCE_SIZE, ononce, 1, continueflag2, 0, 0);
 	if (ret < 0)
 		goto out;
-	if (memcmp(testhmac2, authdata2, SHA1_DIGEST_SIZE))
+	if (crypto_memneq(testhmac2, authdata2, SHA1_DIGEST_SIZE))
 		ret = -EINVAL;
 out:
 	kfree_sensitive(sdesc);


