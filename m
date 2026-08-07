Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E9D38C42A;
	Fri,  7 Aug 2026 15:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115444; cv=none; b=HBwrqqxRae2XNScE7S5eRBg0eWHLGNdm7YxRSOsoYY9BYSQntnUCuZ+GtM+jlV9nLdkHaUGcRs1sDzwDFeih+SUO3Fp5zsIQPH2XvF9/tFGt0C0ux8RsyqKJPeNv6L+K+o54a7uHiENyIdv/7CuHQ/KYtQrW4MRNkViEi+ofpZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115444; c=relaxed/simple;
	bh=SdJd1rp+e6JcurCyKLTvP198Ty23cRwPnvBnEmTZjbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qc2warpW9hUqQOAdBoPQPp5FwStZ0Eabp9UUy0LYxKOQ2tZ8gyGRyWnZB6Bj+1M1yep5CjHumkon7+Kjeel/xbh3+AcOrKRPKz879SaR/sKpVUrbVlqj7nJ8vT5oYm0Y+JGw6JoOqDsdcUF02rCmMcXedHv4nH071El5mMppBGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT3CGEMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT3CGEMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EC21F00A3A;
	Fri,  7 Aug 2026 15:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115442;
	bh=bO0ALB/a69z4y9dV7luF2X8azI61fzKj70MJolpq4Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT3CGEMneeT/OoAyujAKl1pSi12jE7OqZwTuKDYFgzD9JBp5p9jLoO8dYptmg33rr
	 pazukTFK0LBoYUR35M8xNnpek2pWRSu45UCv/HUUA7B8M518Z5exFEsK3nfkZYackO
	 C/Z/QcgptG2Z1F1ipQhbhGyHY287lfhbxpiYNJRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 276/396] s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()
Date: Fri,  7 Aug 2026 16:37:16 +0200
Message-ID: <20260807143430.210265485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -1016,7 +1016,8 @@ static int _ip_cprb_helper(u16 cardnr, u
 			   int clr_key_bit_size,
 			   u8 *key_token,
 			   int *key_token_size,
-			   u32 xflags)
+			   u32 xflags,
+			   bool scrub)
 {
 	int rc, n;
 	u8 *mem, *ptr;
@@ -1156,7 +1157,7 @@ static int _ip_cprb_helper(u16 cardnr, u
 	*key_token_size = t->len;
 
 out:
-	free_cprbmem(mem, PARMBSIZE, false, xflags);
+	free_cprbmem(mem, PARMBSIZE, scrub, xflags);
 	return rc;
 }
 
@@ -1207,28 +1208,32 @@ int cca_clr2cipherkey(u16 card, u16 dom,
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
@@ -1245,6 +1250,8 @@ int cca_clr2cipherkey(u16 card, u16 dom,
 	*keybufsize = tokensize;
 
 out:
+	memzero_explicit(exorbuf, sizeof(exorbuf));
+	memzero_explicit(mem, CPRB_MEMPOOL_ITEM_SIZE);
 	mempool_free(mem, cprb_mempool);
 	return rc;
 }


