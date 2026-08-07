Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F67B383C86;
	Fri,  7 Aug 2026 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115441; cv=none; b=M6vL66nwH5/3GTFWSPKC+wFAUOTI/T+SpN3Ev2bSV25URMICVxJkzZDfDjKE6k29RawCLWKkdVSPTuhWXMHI31ethTcl1zS75tFAycWecwEn30Ceo7jt92Psho023FznPIkNwBUCHwDrPZ/3Io/sUiOBlXJIqRq6Z+Gl7ptvgFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115441; c=relaxed/simple;
	bh=WoYDWTFn7xiIjkt2A5njvSBxu8MWD7PlDzv9JsTiIqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElIN9hUlmZJjTmIoOCxJEhOglhNsYkWcSArLXlNCqQ2gjPOKY14Il3YKboQ7tO8HBdoackBHqYZHzW1Dvds8pT64/nkEJ6Eih/BBAcbmCdHCb6ABDMgJQEsX5cwDfw+Kw/qu963p4VovFMv4+Dc3kiPk6g9wC0yRBmZIcHjERnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1ysSdy2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1ysSdy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C269B1F000E9;
	Fri,  7 Aug 2026 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115439;
	bh=AwjLTMu6ml1BjcflhpE926NgdacfuGTZboAB4G/C4EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1ysSdy2pIrc6IexFKB6RRVvOLTM61R0lh/KSz+xsj3bxvgLQqDmg/9XzaYXJPfeK
	 GEt9shVX0/NhA5rGq/PDnq4cpUXKH5hPe+z5yi6evzvWJjlt9B0uZ9pJK6y1Dpkljj
	 MzdYVRsYj91EjbJnxtgDQR+viR8p4JX8i595/ugk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 275/396] s390/zcrypt: Fix buffer over-read in cca_cipher2protkey
Date: Fri,  7 Aug 2026 16:37:15 +0200
Message-ID: <20260807143430.189174949@linuxfoundation.org>
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

commit 36b230835b8a008266aad22168ca52afacc8a58d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/pkey_cca.c       |   15 ++------
 drivers/s390/crypto/zcrypt_ccamisc.c |   64 +++++++++++++++++++++++++++++------
 drivers/s390/crypto/zcrypt_ccamisc.h |    6 +--
 3 files changed, 62 insertions(+), 23 deletions(-)

--- a/drivers/s390/crypto/pkey_cca.c
+++ b/drivers/s390/crypto/pkey_cca.c
@@ -233,22 +233,16 @@ static int cca_key2protkey(const struct
 	if (hdr->type == TOKTYPE_CCA_INTERNAL &&
 	    hdr->version == TOKVER_CCA_AES) {
 		/* CCA AES data key */
-		if (keylen < sizeof(struct secaeskeytoken))
-			return -EINVAL;
-		if (cca_check_secaeskeytoken(pkey_dbf_info, 3, key, 0))
+		if (cca_check_secaeskeytoken(pkey_dbf_info, 3, key, keylen, 0))
 			return -EINVAL;
 	} else if (hdr->type == TOKTYPE_CCA_INTERNAL &&
 		   hdr->version == TOKVER_CCA_VLSC) {
 		/* CCA AES cipher key */
-		if (keylen < hdr->len)
-			return -EINVAL;
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
@@ -476,7 +470,7 @@ static int cca_verifykey(const u8 *key,
 	    hdr->version == TOKVER_CCA_AES) {
 		struct secaeskeytoken *t = (struct secaeskeytoken *)key;
 
-		rc = cca_check_secaeskeytoken(pkey_dbf_info, 3, key, 0);
+		rc = cca_check_secaeskeytoken(pkey_dbf_info, 3, key, keylen, 0);
 		if (rc)
 			goto out;
 		*keytype = PKEY_TYPE_CCA_DATA;
@@ -504,7 +498,8 @@ static int cca_verifykey(const u8 *key,
 		   hdr->version == TOKVER_CCA_VLSC) {
 		struct cipherkeytoken *t = (struct cipherkeytoken *)key;
 
-		rc = cca_check_secaescipherkey(pkey_dbf_info, 3, key, 0, 1);
+		rc = cca_check_secaescipherkey(pkey_dbf_info, 3,
+					       key, keylen, 0, 1);
 		if (rc)
 			goto out;
 		*keytype = PKEY_TYPE_CCA_CIPHER;
--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -63,12 +63,18 @@ static DEFINE_MUTEX(dev_status_mem_mutex
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
@@ -102,14 +108,20 @@ EXPORT_SYMBOL(cca_check_secaeskeytoken);
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
@@ -122,6 +134,18 @@ int cca_check_secaescipherkey(debug_info
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
@@ -196,6 +220,12 @@ int cca_check_sececckeytoken(debug_info_
 
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
@@ -208,6 +238,12 @@ int cca_check_sececckeytoken(debug_info_
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
@@ -444,7 +480,8 @@ int cca_genseckey(u16 cardnr, u16 domain
 
 	/* check secure key token */
 	rc = cca_check_secaeskeytoken(zcrypt_dbf_info, DBF_ERR,
-				      prepparm->lv3.keyblock.tok, 8 * keysize);
+				      prepparm->lv3.keyblock.tok,
+				      seckeysize, 8 * keysize);
 	if (rc) {
 		rc = -EIO;
 		goto out;
@@ -583,7 +620,8 @@ int cca_clr2seckey(u16 cardnr, u16 domai
 
 	/* check secure key token */
 	rc = cca_check_secaeskeytoken(zcrypt_dbf_info, DBF_ERR,
-				      prepparm->lv3.keyblock.tok, 8 * keysize);
+				      prepparm->lv3.keyblock.tok,
+				      seckeysize, 8 * keysize);
 	if (rc) {
 		rc = -EIO;
 		goto out;
@@ -843,6 +881,7 @@ int cca_gencipherkey(u16 cardnr, u16 dom
 		} kb;
 	} __packed * prepparm;
 	struct cipherkeytoken *t;
+	u32 keybuflen;
 
 	/* get already prepared memory for 2 cprbs with param block each */
 	rc = alloc_and_prep_cprbmem(PARMBSIZE, &mem,
@@ -937,23 +976,28 @@ int cca_gencipherkey(u16 cardnr, u16 dom
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
 	free_cprbmem(mem, PARMBSIZE, false, xflags);
--- a/drivers/s390/crypto/zcrypt_ccamisc.h
+++ b/drivers/s390/crypto/zcrypt_ccamisc.h
@@ -136,7 +136,7 @@ struct eccprivkeytoken {
  * also checked. Returns 0 on success or errno value on failure.
  */
 int cca_check_secaeskeytoken(debug_info_t *dbg, int dbflvl,
-			     const u8 *token, int keybitsize);
+			     const u8 *token, u32 keysize, int keybitsize);
 
 /*
  * Simple check if the token is a valid CCA secure AES cipher key
@@ -146,8 +146,8 @@ int cca_check_secaeskeytoken(debug_info_
  * Returns 0 on success or errno value on failure.
  */
 int cca_check_secaescipherkey(debug_info_t *dbg, int dbflvl,
-			      const u8 *token, int keybitsize,
-			      int checkcpacfexport);
+			      const u8 *token, u32 keysize,
+			      int keybitsize, int checkcpacfexport);
 
 /*
  * Simple check if the token is a valid CCA secure ECC private


