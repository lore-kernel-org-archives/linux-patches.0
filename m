Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8415314B8F;
	Sat, 17 Oct 2026 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257648; cv=none; b=naLeVepka3AeMkaHQQXtAyLTkwbQBkkKsTMKUFbmcHqqdzhQGwY2K2tnnYkKn/F1yOd+bvY7vClBhB9Gd2VZ04fQURd8IRYLJdp8FAazMU2WyYZ51u6QsywwYNZzoqQE/7BJxEpORbuI9j4gAyqp2AybLWzepNZ/DhCd0+ehZz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257648; c=relaxed/simple;
	bh=Rne5+mVF3eD+mBIqq6vSw2O9nkU2dChdIVsuKbfMc2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4UAX+6dMIAAvBhlkKg0VlQcD+Fnk2dYE4XTHVMWCv9DJqhj7OGJx9dUAt8wk/9ce7SVxRZYEt10D4NWFI8HU6p5Y6r/v4U6tfVpGMhwdHPNqSAqKR08EZpZYBcGRqGjWVIlW04+pWtAcHgT8xpWmAuPN6Im0Rk/h/jV9LNAAtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzpy7eV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzpy7eV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107E41F000C4;
	Sat, 17 Oct 2026 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257647;
	bh=4PcL0pLm+ZIqzi3FmfkTK+1ZhJDjIoLwg495f7FXyB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzpy7eV6tlYDvVgZTYKjZLNIKxAsHJl7Vb1UmWsMXWISEhSoPCyXmSqhtAJoujtM7
	 5Gj05S4TwRatIMNFj7+gESDl737ojEQMYDddg9F3eSe5JG0OqrPjP+Y5dfIoFUqWhg
	 ps6FgYMyqaIRUj8HXQetW05+AeOdELSxPgso2cIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0627/1674] s390/pkey: harmonize pkey s390 debug feature calls
Date: Sat, 17 Oct 2026 17:48:19 +0200
Message-ID: <20261017160447.186045363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit 0ccac45295403a7730d7bdd8b047a824b7a23a2e ]

Cleanup and harmonize the s390 debug feature calls
and defines for the pkey module to be similar to
the debug feature as it is used in the zcrypt device
driver and AP bus.

More or less only renaming but no functional changes.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Adapt this dependency to the ioctl call sites used by the follow-up
protected- and secure-key wiping change. Use pr_debug() directly at
those sites, matching the later dynamic-debug conversion, and omit the
unrelated debug-handle, macro and helper-call renames.

Replace the three existing key-blob wipe-and-free sequences with
kfree_sensitive() to provide the cleanup context expected by that
change. Preserve the existing clear-key error-path wiping and array
allocation overflow checks. No functions are added.

Stable-dep-of: f2ebdadd85af ("s390/pkey: Wipe copies of protected- and secure-keys")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 21fc6151af79f..6f435055f685c 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1350,7 +1350,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 			return -EFAULT;
 		rc = cca_genseckey(kgs.cardnr, kgs.domain,
 				   kgs.keytype, kgs.seckey.seckey);
-		DEBUG_DBG("%s cca_genseckey()=%d\n", __func__, rc);
+		pr_debug("%s cca_genseckey()=%d\n", __func__, rc);
 		if (rc)
 			break;
 		if (copy_to_user(ugs, &kgs, sizeof(kgs)))
@@ -1381,7 +1381,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = cca_sec2protkey(ksp.cardnr, ksp.domain,
 				     ksp.seckey.seckey, ksp.protkey.protkey,
 				     &ksp.protkey.len, &ksp.protkey.type);
-		DEBUG_DBG("%s cca_sec2protkey()=%d\n", __func__, rc);
+		pr_debug("%s cca_sec2protkey()=%d\n", __func__, rc);
 		if (rc)
 			break;
 		if (copy_to_user(usp, &ksp, sizeof(ksp)))
@@ -1428,7 +1428,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		ksp.protkey.len = sizeof(ksp.protkey.protkey);
 		rc = pkey_skey2pkey(ksp.seckey.seckey, ksp.protkey.protkey,
 				    &ksp.protkey.len, &ksp.protkey.type);
-		DEBUG_DBG("%s pkey_skey2pkey()=%d\n", __func__, rc);
+		pr_debug("%s pkey_skey2pkey()=%d\n", __func__, rc);
 		if (rc)
 			break;
 		if (copy_to_user(usp, &ksp, sizeof(ksp)))
@@ -1443,7 +1443,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 			return -EFAULT;
 		rc = pkey_verifykey(&kvk.seckey, &kvk.cardnr, &kvk.domain,
 				    &kvk.keysize, &kvk.attributes);
-		DEBUG_DBG("%s pkey_verifykey()=%d\n", __func__, rc);
+		pr_debug("%s pkey_verifykey()=%d\n", __func__, rc);
 		if (rc)
 			break;
 		if (copy_to_user(uvk, &kvk, sizeof(kvk)))
@@ -1459,7 +1459,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		kgp.protkey.len = sizeof(kgp.protkey.protkey);
 		rc = pkey_genprotkey(kgp.keytype, kgp.protkey.protkey,
 				     &kgp.protkey.len, &kgp.protkey.type);
-		DEBUG_DBG("%s pkey_genprotkey()=%d\n", __func__, rc);
+		pr_debug("%s pkey_genprotkey()=%d\n", __func__, rc);
 		if (rc)
 			break;
 		if (copy_to_user(ugp, &kgp, sizeof(kgp)))
@@ -1474,7 +1474,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 			return -EFAULT;
 		rc = pkey_verifyprotkey(kvp.protkey.protkey,
 					kvp.protkey.len, kvp.protkey.type);
-		DEBUG_DBG("%s pkey_verifyprotkey()=%d\n", __func__, rc);
+		pr_debug("%s pkey_verifyprotkey()=%d\n", __func__, rc);
 		break;
 	}
 	case PKEY_KBLOB2PROTK: {
@@ -1490,9 +1490,8 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		ktp.protkey.len = sizeof(ktp.protkey.protkey);
 		rc = pkey_keyblob2pkey(kkey, ktp.keylen, ktp.protkey.protkey,
 				       &ktp.protkey.len, &ktp.protkey.type);
-		DEBUG_DBG("%s pkey_keyblob2pkey()=%d\n", __func__, rc);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		pr_debug("%s pkey_keyblob2pkey()=%d\n", __func__, rc);
+		kfree_sensitive(kkey);
 		if (rc)
 			break;
 		if (copy_to_user(utp, &ktp, sizeof(ktp)))
@@ -1519,7 +1518,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_genseckey2(apqns, kgs.apqn_entries,
 				     kgs.type, kgs.size, kgs.keygenflags,
 				     kkey, &klen);
-		DEBUG_DBG("%s pkey_genseckey2()=%d\n", __func__, rc);
+		pr_debug("%s pkey_genseckey2()=%d\n", __func__, rc);
 		kfree(apqns);
 		if (rc) {
 			kfree(kkey);
@@ -1564,7 +1563,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_clr2seckey2(apqns, kcs.apqn_entries,
 				      kcs.type, kcs.size, kcs.keygenflags,
 				      kcs.clrkey.clrkey, kkey, &klen);
-		DEBUG_DBG("%s pkey_clr2seckey2()=%d\n", __func__, rc);
+		pr_debug("%s pkey_clr2seckey2()=%d\n", __func__, rc);
 		kfree(apqns);
 		if (rc) {
 			kfree(kkey);
@@ -1603,7 +1602,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_verifykey2(kkey, kvk.keylen,
 				     &kvk.cardnr, &kvk.domain,
 				     &kvk.type, &kvk.size, &kvk.flags);
-		DEBUG_DBG("%s pkey_verifykey2()=%d\n", __func__, rc);
+		pr_debug("%s pkey_verifykey2()=%d\n", __func__, rc);
 		kfree(kkey);
 		if (rc)
 			break;
@@ -1632,10 +1631,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 					kkey, ktp.keylen,
 					ktp.protkey.protkey, &ktp.protkey.len,
 					&ktp.protkey.type);
-		DEBUG_DBG("%s pkey_keyblob2pkey2()=%d\n", __func__, rc);
+		pr_debug("%s pkey_keyblob2pkey2()=%d\n", __func__, rc);
 		kfree(apqns);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc)
 			break;
 		if (copy_to_user(utp, &ktp, sizeof(ktp)))
@@ -1666,7 +1664,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		}
 		rc = pkey_apqns4key(kkey, kak.keylen, kak.flags,
 				    apqns, &nr_apqns);
-		DEBUG_DBG("%s pkey_apqns4key()=%d\n", __func__, rc);
+		pr_debug("%s pkey_apqns4key()=%d\n", __func__, rc);
 		kfree(kkey);
 		if (rc && rc != -ENOSPC) {
 			kfree(apqns);
@@ -1761,8 +1759,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 					protkey, &protkeylen, &ktp.pkeytype);
 		DEBUG_DBG("%s pkey_keyblob2pkey3()=%d\n", __func__, rc);
 		kfree(apqns);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc) {
 			kfree(protkey);
 			break;
-- 
2.53.0



