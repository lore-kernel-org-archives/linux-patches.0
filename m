Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFA9314B8F;
	Sat, 17 Oct 2026 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257652; cv=none; b=r/Sad1v8ofJToaRzRQPaexdgOUtetLQvp1fPWkYSoCDyiFTaNvU2uHD8zyrrg5kjQ2tICMxykaTGC6O4as17ZXdWuLx20suYK88eBtYynHHY5IMlSpTLXl3J+aMGFrOel2xYG8Zh5o6dcnSEmCBc/V9mr4lIm1fXsKFVAlQ4OX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257652; c=relaxed/simple;
	bh=y7ojt9Y42ECrikT8rmlCtQ/YphY/FVIA/96+T7saQU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knNyvHU0mQ4gFdw25PapJUU+zz3z74HTMCrEtM6IS16pICnfBo+y9DURWQhox+m2BU4mlm+/qgcmVcS6dcSn7zij9BFIObzj6/PqS7jzFSUTkcbPw+mL0wPwjgcY4h6jL75a5R7Gs1Y71EKn7zvR19/nIOKDNKISrMpRqiJAnzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SathmdWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SathmdWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9E61F000C4;
	Sat, 17 Oct 2026 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257650;
	bh=GfDTbjPyzRriFTFww9DKBxLXv5iOi2auQUFWo06Q6GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SathmdWaOr8xYtW/aI+03wkZXAo7nBCu6rca3/nkYyXgvWLAKx63fq27yWmpg6lmH
	 E7esrz6NkMZ25SJRwwzYOZvbfNQOcEubGurhriOR3Yaf1VsPZLjaunRULaDaeeX+iN
	 0ktW66t2PKoB5WrC1u/uYnQ+9hVWOcw40SVnPmUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0628/1674] s390/pkey: Wipe copies of protected- and secure-keys
Date: Sat, 17 Oct 2026 17:48:20 +0200
Message-ID: <20261017160447.213442339@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

[ Upstream commit f2ebdadd85af4f4d0cae1e5d009c70eccc78c207 ]

Although the clear-key of neither protected- nor secure-keys is
accessible, this key material should only be visible to the calling
process. So wipe all copies of protected- or secure-keys from stack,
even in case of an error.

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 80 ++++++++++++++++------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 6f435055f685c..a9e6cde29d664 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1351,10 +1351,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = cca_genseckey(kgs.cardnr, kgs.domain,
 				   kgs.keytype, kgs.seckey.seckey);
 		pr_debug("%s cca_genseckey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ugs, &kgs, sizeof(kgs)))
-			return -EFAULT;
+		if (!rc && copy_to_user(ugs, &kgs, sizeof(kgs)))
+			rc = -EFAULT;
+		memzero_explicit(&kgs, sizeof(kgs));
 		break;
 	}
 	case PKEY_CLR2SECK: {
@@ -1382,10 +1381,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 				     ksp.seckey.seckey, ksp.protkey.protkey,
 				     &ksp.protkey.len, &ksp.protkey.type);
 		pr_debug("%s cca_sec2protkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(usp, &ksp, sizeof(ksp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(usp, &ksp, sizeof(ksp)))
+			rc = -EFAULT;
+		memzero_explicit(&ksp, sizeof(ksp));
 		break;
 	}
 	case PKEY_CLR2PROTK: {
@@ -1429,10 +1427,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_skey2pkey(ksp.seckey.seckey, ksp.protkey.protkey,
 				    &ksp.protkey.len, &ksp.protkey.type);
 		pr_debug("%s pkey_skey2pkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(usp, &ksp, sizeof(ksp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(usp, &ksp, sizeof(ksp)))
+			rc = -EFAULT;
+		memzero_explicit(&ksp, sizeof(ksp));
 		break;
 	}
 	case PKEY_VERIFYKEY: {
@@ -1444,10 +1441,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_verifykey(&kvk.seckey, &kvk.cardnr, &kvk.domain,
 				    &kvk.keysize, &kvk.attributes);
 		pr_debug("%s pkey_verifykey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(uvk, &kvk, sizeof(kvk)))
-			return -EFAULT;
+		if (!rc && copy_to_user(uvk, &kvk, sizeof(kvk)))
+			rc = -EFAULT;
+		memzero_explicit(&kvk, sizeof(kvk));
 		break;
 	}
 	case PKEY_GENPROTK: {
@@ -1460,10 +1456,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_genprotkey(kgp.keytype, kgp.protkey.protkey,
 				     &kgp.protkey.len, &kgp.protkey.type);
 		pr_debug("%s pkey_genprotkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ugp, &kgp, sizeof(kgp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(ugp, &kgp, sizeof(kgp)))
+			rc = -EFAULT;
+		memzero_explicit(&kgp, sizeof(kgp));
 		break;
 	}
 	case PKEY_VERIFYPROTK: {
@@ -1475,6 +1470,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_verifyprotkey(kvp.protkey.protkey,
 					kvp.protkey.len, kvp.protkey.type);
 		pr_debug("%s pkey_verifyprotkey()=%d\n", __func__, rc);
+		memzero_explicit(&kvp, sizeof(kvp));
 		break;
 	}
 	case PKEY_KBLOB2PROTK: {
@@ -1492,10 +1488,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 				       &ktp.protkey.len, &ktp.protkey.type);
 		pr_debug("%s pkey_keyblob2pkey()=%d\n", __func__, rc);
 		kfree_sensitive(kkey);
-		if (rc)
-			break;
-		if (copy_to_user(utp, &ktp, sizeof(ktp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(utp, &ktp, sizeof(ktp)))
+			rc = -EFAULT;
+		memzero_explicit(&ktp, sizeof(ktp));
 		break;
 	}
 	case PKEY_GENSECK2: {
@@ -1521,23 +1516,23 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		pr_debug("%s pkey_genseckey2()=%d\n", __func__, rc);
 		kfree(apqns);
 		if (rc) {
-			kfree(kkey);
+			kfree_sensitive(kkey);
 			break;
 		}
 		if (kgs.key) {
 			if (kgs.keylen < klen) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				return -EINVAL;
 			}
 			if (copy_to_user(kgs.key, kkey, klen)) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				return -EFAULT;
 			}
 		}
 		kgs.keylen = klen;
 		if (copy_to_user(ugs, &kgs, sizeof(kgs)))
 			rc = -EFAULT;
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		break;
 	}
 	case PKEY_CLR2SECK2: {
@@ -1566,18 +1561,18 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		pr_debug("%s pkey_clr2seckey2()=%d\n", __func__, rc);
 		kfree(apqns);
 		if (rc) {
-			kfree(kkey);
+			kfree_sensitive(kkey);
 			memzero_explicit(&kcs, sizeof(kcs));
 			break;
 		}
 		if (kcs.key) {
 			if (kcs.keylen < klen) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				memzero_explicit(&kcs, sizeof(kcs));
 				return -EINVAL;
 			}
 			if (copy_to_user(kcs.key, kkey, klen)) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				memzero_explicit(&kcs, sizeof(kcs));
 				return -EFAULT;
 			}
@@ -1586,7 +1581,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
 			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		break;
 	}
 	case PKEY_VERIFYKEY2: {
@@ -1603,7 +1598,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 				     &kvk.cardnr, &kvk.domain,
 				     &kvk.type, &kvk.size, &kvk.flags);
 		pr_debug("%s pkey_verifykey2()=%d\n", __func__, rc);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc)
 			break;
 		if (copy_to_user(uvk, &kvk, sizeof(kvk)))
@@ -1634,10 +1629,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		pr_debug("%s pkey_keyblob2pkey2()=%d\n", __func__, rc);
 		kfree(apqns);
 		kfree_sensitive(kkey);
-		if (rc)
-			break;
-		if (copy_to_user(utp, &ktp, sizeof(ktp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(utp, &ktp, sizeof(ktp)))
+			rc = -EFAULT;
+		memzero_explicit(&ktp, sizeof(ktp));
 		break;
 	}
 	case PKEY_APQNS4K: {
@@ -1665,7 +1659,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_apqns4key(kkey, kak.keylen, kak.flags,
 				    apqns, &nr_apqns);
 		pr_debug("%s pkey_apqns4key()=%d\n", __func__, rc);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc && rc != -ENOSPC) {
 			kfree(apqns);
 			break;
@@ -1751,7 +1745,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		protkey = kmalloc(protkeylen, GFP_KERNEL);
 		if (!protkey) {
 			kfree(apqns);
-			kfree(kkey);
+			kfree_sensitive(kkey);
 			return -ENOMEM;
 		}
 		rc = pkey_keyblob2pkey3(apqns, ktp.apqn_entries,
@@ -1761,20 +1755,20 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		kfree(apqns);
 		kfree_sensitive(kkey);
 		if (rc) {
-			kfree(protkey);
+			kfree_sensitive(protkey);
 			break;
 		}
 		if (ktp.pkey && ktp.pkeylen) {
 			if (protkeylen > ktp.pkeylen) {
-				kfree(protkey);
+				kfree_sensitive(protkey);
 				return -EINVAL;
 			}
 			if (copy_to_user(ktp.pkey, protkey, protkeylen)) {
-				kfree(protkey);
+				kfree_sensitive(protkey);
 				return -EFAULT;
 			}
 		}
-		kfree(protkey);
+		kfree_sensitive(protkey);
 		ktp.pkeylen = protkeylen;
 		if (copy_to_user(utp, &ktp, sizeof(ktp)))
 			return -EFAULT;
-- 
2.53.0



