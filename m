Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFE04756AE;
	Fri,  7 Aug 2026 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117517; cv=none; b=qhGDJTt9r/I4W5Wk9G0Zo61a51n9by1BZ0vGSvliQp6/Uunidq2l4kmvrk5KSvSLKNNvb4hBsicZiIIhnOd9C0QgWrs0DUkpAPjSx2+vw4q2iA3/5uRdviGAZEiuP7/hDsTKh9DOnqeUdPpJWz/pNe7PzLpXlvumRgLkoKZVnK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117517; c=relaxed/simple;
	bh=KXeB9usGSuGM41QUtYdn6oohFp+dtJ/rrjVxKmB5pN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkHIQKT0EYv5LBaucdEsJx/P1BJtJb/nmCVzVp5A3y/rwzdL1HoAnw0TuX5fTLEr9kIO45+Vgu+hL+lYc7m3ukb1aalZTN8IViZMBuIQc0qWl7+8OInTQ2JT7h60kSthAvZvCaMgzI7kt9Pv4WV56RssAhqHto8t2wd9QuVXdfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQOPgZP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQOPgZP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8811F000E9;
	Fri,  7 Aug 2026 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117515;
	bh=ShHlmfCFqv+P2XowXmJi7rzbcZj94ZDiqJF6e5wVuZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQOPgZP0FBe9FPvlWodbeULhuIP+X4ZfRXGlazJDq5PA/3zFN2V6KJZn6zhWkimUO
	 BR0tOnz8mCL2UMTcixxbdjG5P4+oKNzG4oHndKWo/sHTtfyPjioomAEdDzc5yDASxr
	 uPfm0IKnTOhLm3MfUS0UwjJ000BCSZ83Gm/+ivsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 344/438] s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()
Date: Fri,  7 Aug 2026 16:39:00 +0200
Message-ID: <20260807143435.308435129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 01476391aecef36a3b789ee844357b22fbc90665 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_ccamisc.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1015,7 +1015,8 @@ static int _ip_cprb_helper(u16 cardnr, u
 			   int clr_key_bit_size,
 			   u8 *key_token,
 			   int *key_token_size,
-			   u32 xflags)
+			   u32 xflags,
+			   bool scrub)
 {
 	int rc, n;
 	u8 *mem, *ptr;
@@ -1155,7 +1156,7 @@ static int _ip_cprb_helper(u16 cardnr, u
 	*key_token_size = t->len;
 
 out:
-	free_cprbmem(mem, PARMBSIZE, false, xflags);
+	free_cprbmem(mem, PARMBSIZE, scrub, xflags);
 	return rc;
 }
 
@@ -1206,28 +1207,32 @@ int cca_clr2cipherkey(u16 card, u16 dom,
 	 * 4/4 COMPLETE the secure cipher key import
 	 */
 	rc = _ip_cprb_helper(card, dom, "AES     ", "FIRST   ", "MIN3PART",
-			     exorbuf, keybitsize, token, &tokensize, xflags);
+			     exorbuf, keybitsize, token, &tokensize,
+			     xflags, true);
 	if (rc) {
 		ZCRYPT_DBF_ERR("%s clear key import 1/4 with CSNBKPI2 failed, rc=%d\n",
 			       __func__, rc);
 		goto out;
 	}
 	rc = _ip_cprb_helper(card, dom, "AES     ", "ADD-PART", NULL,
-			     clrkey, keybitsize, token, &tokensize, xflags);
+			     clrkey, keybitsize, token, &tokensize,
+			     xflags, true);
 	if (rc) {
 		ZCRYPT_DBF_ERR("%s clear key import 2/4 with CSNBKPI2 failed, rc=%d\n",
 			       __func__, rc);
 		goto out;
 	}
 	rc = _ip_cprb_helper(card, dom, "AES     ", "ADD-PART", NULL,
-			     exorbuf, keybitsize, token, &tokensize, xflags);
+			     exorbuf, keybitsize, token, &tokensize,
+			     xflags, true);
 	if (rc) {
 		ZCRYPT_DBF_ERR("%s clear key import 3/4 with CSNBKPI2 failed, rc=%d\n",
 			       __func__, rc);
 		goto out;
 	}
 	rc = _ip_cprb_helper(card, dom, "AES     ", "COMPLETE", NULL,
-			     NULL, keybitsize, token, &tokensize, xflags);
+			     NULL, keybitsize, token, &tokensize,
+			     xflags, true);
 	if (rc) {
 		ZCRYPT_DBF_ERR("%s clear key import 4/4 with CSNBKPI2 failed, rc=%d\n",
 			       __func__, rc);
@@ -1244,6 +1249,8 @@ int cca_clr2cipherkey(u16 card, u16 dom,
 	*keybufsize = tokensize;
 
 out:
+	memzero_explicit(exorbuf, sizeof(exorbuf));
+	memzero_explicit(mem, CPRB_MEMPOOL_ITEM_SIZE);
 	mempool_free(mem, cprb_mempool);
 	return rc;
 }


