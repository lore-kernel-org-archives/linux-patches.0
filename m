Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223762248B3;
	Sat, 17 Oct 2026 16:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254350; cv=none; b=fpIbFXuFIUJbEIla6EPW7k3kFlw8YCamnmPq/Di+7gXLk2re3ihnc3QygOAmNr+avvMzdRXTRcqcHe7dK83E18CiQ1T2Y+i/PnURm1Ypf/Z/m8eiR+8rOBjJbvltAO4EUNw9JzByrOW4fc9XZNl957+iULKvjbYOIa8g4hkZHsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254350; c=relaxed/simple;
	bh=AkwsdtrjwUa7EMJwltP0HPb8cGDQTzZLrIrlbEhJZ00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP5D5WJMSfmHvxIj2nDPd0a4t4yZboKgfh0Q2SMpiQw3Ae1x0ydPwzi7kivTzE8isiTsIG8kgMwBVc2/DtrsRKTwG+4ReQeCYaU7mMhA0k594pzdqfEv6rLzmhg0tWxkLnSigEVpXIV4iO5h+lqd18Aj/Bm5YJTQbhHFAVCPPM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1QfltOp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1QfltOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7BE1F000C4;
	Sat, 17 Oct 2026 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254349;
	bh=/ANnRcXyrVguGIEiWceK+jLFZFfYSXPbMBUqunoFZk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1QfltOpBkeXFHGHzT93FFeaNC/jzyHR2cHrhn3NNpSd5WHkuw528WAqlAt5fY3Cf
	 /A6EC79IkD0OYiBx3DVwQQ6A5AiRPRQQHQ4u1yaqJSalE4gTzmSHFGtnLpO7d3Nj9e
	 f45W6iIZVRJbh/4buvK8FWb+GuvRtcVFZxiL8MH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 416/869] s390/zcrypt: Fix buffer over-read in cca_cipher2protkey
Date: Sat, 17 Oct 2026 17:54:17 +0200
Message-ID: <20261017160047.801942077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 36b230835b8a008266aad22168ca52afacc8a58d ]

Add validation of both the actual key buffer size and token length
fields in all the cca_check_sec*token() functions. Additionally check
in cca_gencipherkey() for possible underflow with returned key size.

The CCA token structures contain user-controlled len fields that
were used in operations without proper validation against both the
actual buffer size and minimum token structure size. An attacker
could set this field larger than the actual buffer size, leading to
reading beyond buffer boundaries. This may result in a kernel crash or
exposure of memory via sending this as part of a request down to the
crypto card. Also an attacker could have used a very small len value
and thus enforce a buffer under-run which may produce similar effects
as a over-read.

So now a key must
- key buf length must be at least sizeof the token struct
- the key len field inside the token must fit into the range of
  sizeof key token struct ... key buf length

Fixes: 4bc123b18ce6 ("s390/zcrypt: Add low level functions for CCA AES cipher keys")
Cc: stable@vger.kernel.org
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_cca.c       | 11 +++--
 drivers/s390/crypto/zcrypt_ccamisc.c | 64 +++++++++++++++++++++++-----
 drivers/s390/crypto/zcrypt_ccamisc.h |  6 +--
 3 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/crypto/pkey_cca.c b/drivers/s390/crypto/pkey_cca.c
index 9370513817209..6c4dac5fa256e 100644
--- a/drivers/s390/crypto/pkey_cca.c
+++ b/drivers/s390/crypto/pkey_cca.c
@@ -227,7 +227,7 @@ static int cca_key2protkey(const struct pkey_apqn *apqns, size_t nr_apqns,
 		/* CCA AES data key */
 		if (keylen != sizeof(struct secaeskeytoken))
 			return -EINVAL;
-		if (cca_check_secaeskeytoken(pkey_dbf_info, 3, key, 0))
+		if (cca_check_secaeskeytoken(pkey_dbf_info, 3, key, keylen, 0))
 			return -EINVAL;
 	} else if (hdr->type == TOKTYPE_CCA_INTERNAL &&
 		   hdr->version == TOKVER_CCA_VLSC) {
@@ -235,12 +235,10 @@ static int cca_key2protkey(const struct pkey_apqn *apqns, size_t nr_apqns,
 		if (keylen < hdr->len || keylen > MAXCCAVLSCTOKENSIZE)
 			return -EINVAL;
 		if (cca_check_secaescipherkey(pkey_dbf_info,
-					      3, key, 0, 1))
+					      3, key, keylen, 0, 1))
 			return -EINVAL;
 	} else if (hdr->type == TOKTYPE_CCA_INTERNAL_PKA) {
 		/* CCA ECC (private) key */
-		if (keylen < sizeof(struct eccprivkeytoken))
-			return -EINVAL;
 		if (cca_check_sececckeytoken(pkey_dbf_info, 3, key, keylen, 1))
 			return -EINVAL;
 	} else {
@@ -474,7 +472,7 @@ static int cca_verifykey(const u8 *key, u32 keylen,
 	    hdr->version == TOKVER_CCA_AES) {
 		struct secaeskeytoken *t = (struct secaeskeytoken *)key;
 
-		rc = cca_check_secaeskeytoken(pkey_dbf_info, 3, key, 0);
+		rc = cca_check_secaeskeytoken(pkey_dbf_info, 3, key, keylen, 0);
 		if (rc)
 			goto out;
 		*keytype = PKEY_TYPE_CCA_DATA;
@@ -501,7 +499,8 @@ static int cca_verifykey(const u8 *key, u32 keylen,
 		   hdr->version == TOKVER_CCA_VLSC) {
 		struct cipherkeytoken *t = (struct cipherkeytoken *)key;
 
-		rc = cca_check_secaescipherkey(pkey_dbf_info, 3, key, 0, 1);
+		rc = cca_check_secaescipherkey(pkey_dbf_info, 3,
+					       key, keylen, 0, 1);
 		if (rc)
 			goto out;
 		*keytype = PKEY_TYPE_CCA_CIPHER;
diff --git a/drivers/s390/crypto/zcrypt_ccamisc.c b/drivers/s390/crypto/zcrypt_ccamisc.c
index 48d36d5a87118..c84aa0bdfcae3 100644
--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -46,12 +46,18 @@ static DEFINE_SPINLOCK(cca_info_list_lock);
  * also checked. Returns 0 on success or errno value on failure.
  */
 int cca_check_secaeskeytoken(debug_info_t *dbg, int dbflvl,
-			     const u8 *token, int keybitsize)
+			     const u8 *token, u32 keysize, int keybitsize)
 {
 	struct secaeskeytoken *t = (struct secaeskeytoken *)token;
 
 #define DBF(...) debug_sprintf_event(dbg, dbflvl, ##__VA_ARGS__)
 
+	if (keysize < sizeof(*t)) {
+		if (dbg)
+			DBF("%s keysize %u < min token size %zu\n",
+			    __func__, keysize, sizeof(*t));
+		return -EINVAL;
+	}
 	if (t->type != TOKTYPE_CCA_INTERNAL) {
 		if (dbg)
 			DBF("%s token check failed, type 0x%02x != 0x%02x\n",
@@ -85,14 +91,20 @@ EXPORT_SYMBOL(cca_check_secaeskeytoken);
  * Returns 0 on success or errno value on failure.
  */
 int cca_check_secaescipherkey(debug_info_t *dbg, int dbflvl,
-			      const u8 *token, int keybitsize,
-			      int checkcpacfexport)
+			      const u8 *token, u32 keysize,
+			      int keybitsize, int checkcpacfexport)
 {
 	struct cipherkeytoken *t = (struct cipherkeytoken *)token;
 	bool keybitsizeok = true;
 
 #define DBF(...) debug_sprintf_event(dbg, dbflvl, ##__VA_ARGS__)
 
+	if (keysize < sizeof(*t)) {
+		if (dbg)
+			DBF("%s keysize %u < min token size %zu\n",
+			    __func__, keysize, sizeof(*t));
+		return -EINVAL;
+	}
 	if (t->type != TOKTYPE_CCA_INTERNAL) {
 		if (dbg)
 			DBF("%s token check failed, type 0x%02x != 0x%02x\n",
@@ -105,6 +117,18 @@ int cca_check_secaescipherkey(debug_info_t *dbg, int dbflvl,
 			    __func__, (int)t->version, TOKVER_CCA_VLSC);
 		return -EINVAL;
 	}
+	if (t->len > keysize) {
+		if (dbg)
+			DBF("%s token check failed, len %d > keysize %u\n",
+			    __func__, (int)t->len, keysize);
+		return -EINVAL;
+	}
+	if (t->len < sizeof(*t)) {
+		if (dbg)
+			DBF("%s token check failed, len %d < min token size %zu\n",
+			    __func__, (int)t->len, sizeof(*t));
+		return -EINVAL;
+	}
 	if (t->algtype != 0x02) {
 		if (dbg)
 			DBF("%s token check failed, algtype 0x%02x != 0x02\n",
@@ -179,6 +203,12 @@ int cca_check_sececckeytoken(debug_info_t *dbg, int dbflvl,
 
 #define DBF(...) debug_sprintf_event(dbg, dbflvl, ##__VA_ARGS__)
 
+	if (keysize < sizeof(*t)) {
+		if (dbg)
+			DBF("%s keysize %u < min token size %zu\n",
+			    __func__, keysize, sizeof(*t));
+		return -EINVAL;
+	}
 	if (t->type != TOKTYPE_CCA_INTERNAL_PKA) {
 		if (dbg)
 			DBF("%s token check failed, type 0x%02x != 0x%02x\n",
@@ -191,6 +221,12 @@ int cca_check_sececckeytoken(debug_info_t *dbg, int dbflvl,
 			    __func__, (int)t->len, keysize);
 		return -EINVAL;
 	}
+	if (t->len < sizeof(*t)) {
+		if (dbg)
+			DBF("%s token check failed, len %d < min token size %zu\n",
+			    __func__, (int)t->len, sizeof(*t));
+		return -EINVAL;
+	}
 	if (t->secid != 0x20) {
 		if (dbg)
 			DBF("%s token check failed, secid 0x%02x != 0x20\n",
@@ -414,7 +450,8 @@ int cca_genseckey(u16 cardnr, u16 domain,
 
 	/* check secure key token */
 	rc = cca_check_secaeskeytoken(zcrypt_dbf_info, DBF_ERR,
-				      prepparm->lv3.keyblock.tok, 8 * keysize);
+				      prepparm->lv3.keyblock.tok,
+				      seckeysize, 8 * keysize);
 	if (rc) {
 		rc = -EIO;
 		goto out;
@@ -552,7 +589,8 @@ int cca_clr2seckey(u16 cardnr, u16 domain, u32 keybitsize,
 
 	/* check secure key token */
 	rc = cca_check_secaeskeytoken(zcrypt_dbf_info, DBF_ERR,
-				      prepparm->lv3.keyblock.tok, 8 * keysize);
+				      prepparm->lv3.keyblock.tok,
+				      seckeysize, 8 * keysize);
 	if (rc) {
 		rc = -EIO;
 		goto out;
@@ -811,6 +849,7 @@ int cca_gencipherkey(u16 cardnr, u16 domain, u32 keybitsize, u32 keygenflags,
 		} kb;
 	} __packed * prepparm;
 	struct cipherkeytoken *t;
+	u32 keybuflen;
 
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem, &preqcblk, &prepcblk);
@@ -904,23 +943,28 @@ int cca_gencipherkey(u16 cardnr, u16 domain, u32 keybitsize, u32 keygenflags,
 	}
 
 	/* and some checks on the generated key */
+	t = (struct cipherkeytoken *)prepparm->kb.tlv1.gen_key;
+	if (prepparm->kb.tlv1.len < 2 * sizeof(uint16_t) + sizeof(*t)) {
+		rc = -EIO;
+		goto out;
+	}
+	keybuflen = prepparm->kb.tlv1.len - 2 * sizeof(uint16_t);
 	rc = cca_check_secaescipherkey(zcrypt_dbf_info, DBF_ERR,
 				       prepparm->kb.tlv1.gen_key,
-				       keybitsize, 1);
+				       keybuflen, keybitsize, 1);
 	if (rc) {
 		rc = -EIO;
 		goto out;
 	}
 
 	/* copy the generated vlsc key token */
-	t = (struct cipherkeytoken *)prepparm->kb.tlv1.gen_key;
 	if (keybuf) {
-		if (*keybufsize >= t->len)
-			memcpy(keybuf, t, t->len);
+		if (*keybufsize >= keybuflen)
+			memcpy(keybuf, t, keybuflen);
 		else
 			rc = -EINVAL;
 	}
-	*keybufsize = t->len;
+	*keybufsize = keybuflen;
 
 out:
 	free_cprbmem(mem, PARMBSIZE, 0);
diff --git a/drivers/s390/crypto/zcrypt_ccamisc.h b/drivers/s390/crypto/zcrypt_ccamisc.h
index aed7e83845426..bdddebcaad782 100644
--- a/drivers/s390/crypto/zcrypt_ccamisc.h
+++ b/drivers/s390/crypto/zcrypt_ccamisc.h
@@ -135,7 +135,7 @@ struct eccprivkeytoken {
  * also checked. Returns 0 on success or errno value on failure.
  */
 int cca_check_secaeskeytoken(debug_info_t *dbg, int dbflvl,
-			     const u8 *token, int keybitsize);
+			     const u8 *token, u32 keysize, int keybitsize);
 
 /*
  * Simple check if the token is a valid CCA secure AES cipher key
@@ -145,8 +145,8 @@ int cca_check_secaeskeytoken(debug_info_t *dbg, int dbflvl,
  * Returns 0 on success or errno value on failure.
  */
 int cca_check_secaescipherkey(debug_info_t *dbg, int dbflvl,
-			      const u8 *token, int keybitsize,
-			      int checkcpacfexport);
+			      const u8 *token, u32 keysize,
+			      int keybitsize, int checkcpacfexport);
 
 /*
  * Simple check if the token is a valid CCA secure ECC private
-- 
2.53.0



