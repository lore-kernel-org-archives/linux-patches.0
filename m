Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBA143E9FB;
	Mon, 17 Aug 2026 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978422; cv=none; b=Af0ixenDAZWNImlFkj00OZ16xe1jkSmcAWnqmoWJzRE2MwQta53WKDjAPgRjEfjDDUiev0VztB/qATe8LqVq7jVnI9e5/TpMRtRCl/Cu6IQM3Xg3Zn3Yizm1mAV7JRmOPi7aGMarxIO70fuJCECQpXxgjHSW8jREoxt4tCGlZ70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978422; c=relaxed/simple;
	bh=VsG/JVvpu1ZiWUf85gwqWzgZfayTCVfakAyzAo38n64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr/96DbcWn7rSmWDjk/SrtREaDHo3SC4ArJcff8qJ2twIAd663QBAyednoWcyX3vt5eHziksnV5tWrTeJqLQpsmAVC8X/Wb7DoB7KTxW6OAnyzPgcxGdritdvqBz3N3dqOTMrpB3yRD23hpzh7uGOS0duAi/U82tA7WcBWCmBgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5nmsvS8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5nmsvS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A21F00A3A;
	Mon, 17 Aug 2026 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978419;
	bh=J2/6y1BrVdVczzIy1qToHhC9gx11pq8by45CwnP95nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5nmsvS8X3ZJ8NutscTeeCCAzWfYGpea3EXVC+dKnp6WB2sp14qq6psOuImAiEjuL
	 k0WW4+glmuxrjhHIT5KrTx1qqsEsYj517Ns8lBSJFs9dwP7LBYYPeEWYf2w0+ce/Fj
	 VXOEHz9Kb+wuUT62XHlvbyijuu7uNocNggshqK98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/156] s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()
Date: Mon, 17 Aug 2026 15:32:17 +0200
Message-ID: <20260817132534.795357840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 01476391aecef36a3b789ee844357b22fbc90665 ]

The helper function _ip_cprb_helper() uses internal buffer memory for
building and processing CPRBs. After use this buffer was never
scrubbed which could lead to leaving for example clear key material in
memory which could be exposed via tricky reuse of this same memory.

Extend the _ip_cprb_helper() function with another parameter 'scrub'
used to steer scrubbing of this buffer. So now the caller has the
opportunity to decide if scrubbing is needed or not.

Extend the clear key to secure key token import process in function
cca_clr2cipherkey() to tell the helper function from above to scrub
the cprb buffer when the clear key value is part of the request data.

Add explicit scrubbing on return from function cca_clr2cipherkey() for
the random EXOR buffer and the cprb buffer.

Overall this cleans the internal used buffer in case of clear key
import to prevent sensitive data to get exposed.

Fixes: 4bc123b18ce6 ("s390/zcrypt: Add low level functions for CCA AES cipher keys")
Cc: stable@vger.kernel.org
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_ccamisc.c b/drivers/s390/crypto/zcrypt_ccamisc.c
index c3e3f3a3d8f96..b8526219ecebe 100644
--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -946,7 +946,8 @@ static int _ip_cprb_helper(u16 cardnr, u16 domain,
 			   const u8 *clr_key_value,
 			   int clr_key_bit_size,
 			   u8 *key_token,
-			   int *key_token_size)
+			   int *key_token_size,
+			   bool scrub)
 {
 	int rc, n;
 	u8 *mem, *ptr;
@@ -1087,7 +1088,7 @@ static int _ip_cprb_helper(u16 cardnr, u16 domain,
 	*key_token_size = t->len;
 
 out:
-	free_cprbmem(mem, PARMBSIZE, 0);
+	free_cprbmem(mem, PARMBSIZE, scrub);
 	return rc;
 }
 
@@ -1130,7 +1131,8 @@ int cca_clr2cipherkey(u16 card, u16 dom, u32 keybitsize, u32 keygenflags,
 	 * 4/4 COMPLETE the secure cipher key import
 	 */
 	rc = _ip_cprb_helper(card, dom, "AES     ", "FIRST   ", "MIN3PART",
-			     exorbuf, keybitsize, token, &tokensize);
+			     exorbuf, keybitsize, token, &tokensize,
+			     true);
 	if (rc) {
 		DEBUG_ERR(
 			"%s clear key import 1/4 with CSNBKPI2 failed, rc=%d\n",
@@ -1138,7 +1140,8 @@ int cca_clr2cipherkey(u16 card, u16 dom, u32 keybitsize, u32 keygenflags,
 		goto out;
 	}
 	rc = _ip_cprb_helper(card, dom, "AES     ", "ADD-PART", NULL,
-			     clrkey, keybitsize, token, &tokensize);
+			     clrkey, keybitsize, token, &tokensize,
+			     true);
 	if (rc) {
 		DEBUG_ERR(
 			"%s clear key import 2/4 with CSNBKPI2 failed, rc=%d\n",
@@ -1146,7 +1149,8 @@ int cca_clr2cipherkey(u16 card, u16 dom, u32 keybitsize, u32 keygenflags,
 		goto out;
 	}
 	rc = _ip_cprb_helper(card, dom, "AES     ", "ADD-PART", NULL,
-			     exorbuf, keybitsize, token, &tokensize);
+			     exorbuf, keybitsize, token, &tokensize,
+			     true);
 	if (rc) {
 		DEBUG_ERR(
 			"%s clear key import 3/4 with CSNBKPI2 failed, rc=%d\n",
@@ -1154,7 +1158,8 @@ int cca_clr2cipherkey(u16 card, u16 dom, u32 keybitsize, u32 keygenflags,
 		goto out;
 	}
 	rc = _ip_cprb_helper(card, dom, "AES     ", "COMPLETE", NULL,
-			     NULL, keybitsize, token, &tokensize);
+			     NULL, keybitsize, token, &tokensize,
+			     true);
 	if (rc) {
 		DEBUG_ERR(
 			"%s clear key import 4/4 with CSNBKPI2 failed, rc=%d\n",
@@ -1172,7 +1177,8 @@ int cca_clr2cipherkey(u16 card, u16 dom, u32 keybitsize, u32 keygenflags,
 	*keybufsize = tokensize;
 
 out:
-	kfree(token);
+	memzero_explicit(exorbuf, sizeof(exorbuf));
+	kfree_sensitive(token);
 	return rc;
 }
 EXPORT_SYMBOL(cca_clr2cipherkey);
-- 
2.53.0



