Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121FB2D73A6;
	Sat, 17 Oct 2026 15:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252594; cv=none; b=VI7CE8igbUU49oN8Ppv/HrvC+tQwvmYOKZ7ovJjuAidQ2jhmXEuKLg7qgb51LgHy88+xw3GgL423ydGifjsmO1sw5fs7a8t2lx5rr+8arHaStjuKp3aY0P4fd4LYVWy9kg8fWZ6vgaze7oyUx1Ndcn5eJnt65x3rCfoSGGI1muE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252594; c=relaxed/simple;
	bh=lHFWOcCKauamkE0jyTkc1b/hN5W2SI/D9CIDPuMh/cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7NtNWBuWhOUCEbm4mHfjvw15Eg/Lr1xDYaMZ1SqdybP4fAVZzId384rUXCVJ+rxOha56VcwnUnnZFtiXYE8luYKTpob31qV2iAdItsvATV52LYuIu+pEC3XcmMDZs+3OgwQWZpI4tlnqxktW73yde6ZKvTFKhy0CZFvRwOM+dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAeLVa4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAeLVa4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC881F000C4;
	Sat, 17 Oct 2026 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252592;
	bh=VfivRKY04lb3SfGrA5shwuYrea4uM2GfH747UyLwze4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAeLVa4VeAVylCBL2NAf5hP6xuWSQ2JTyaRoeFZcdurz1qvMxVBLsoS7GfNkOYWiM
	 lct75cMwQm598FMPrIOi5PhwMdGdWaUn3owQFym4Ii2ZLXbnPUumgZVwzTQcdAWewp
	 /a2Yqp9H+BGOqTGANfvyBBB4xpFw+CAmGidRW+bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris J Arges <carges@cloudflare.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 32/52] ima: Fix stack-out-of-bounds in is_bprm_creds_for_exec()
Date: Sat, 17 Oct 2026 17:54:33 +0200
Message-ID: <20261017155105.881049384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: Chris J Arges <carges@cloudflare.com>

[ Upstream commit 377cae9851e8559e9d8b82a78c1ac0abeb18839c ]

KASAN reported a stack-out-of-bounds access in ima_appraise_measurement
from is_bprm_creds_for_exec:

BUG: KASAN: stack-out-of-bounds in ima_appraise_measurement+0x12dc/0x16a0
 Read of size 1 at addr ffffc9000160f940 by task sudo/550
The buggy address belongs to stack of task sudo/550
and is located at offset 24 in frame:
  ima_appraise_measurement+0x0/0x16a0
This frame has 2 objects:
  [48, 56) 'file'
  [80, 148) 'hash'

This is caused by using container_of on the *file pointer. This offset
calculation is what triggers the stack-out-of-bounds error.

In order to fix this, pass in a bprm_is_check boolean which can be set
depending on how process_measurement is called. If the caller has a
linux_binprm pointer and the function is BPRM_CHECK we can determine
is_check and set it then. Otherwise set it to false.

Fixes: 95b3cdafd7cb7 ("ima: instantiate the bprm_creds_for_exec() hook")

Signed-off-by: Chris J Arges <carges@cloudflare.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima.h          |  6 ++++--
 security/integrity/ima/ima_appraise.c | 16 +++-------------
 security/integrity/ima/ima_main.c     | 22 +++++++++++++---------
 3 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index e3d71d8d56e38..89ebe98ffc5e5 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -441,7 +441,8 @@ int ima_check_blacklist(struct ima_iint_cache *iint,
 int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 			     struct file *file, const unsigned char *filename,
 			     struct evm_ima_xattr_data *xattr_value,
-			     int xattr_len, const struct modsig *modsig);
+			     int xattr_len, const struct modsig *modsig,
+			     bool bprm_is_check);
 int ima_must_appraise(struct mnt_idmap *idmap, struct inode *inode,
 		      int mask, enum ima_hooks func);
 void ima_update_xattr(struct ima_iint_cache *iint, struct file *file);
@@ -466,7 +467,8 @@ static inline int ima_appraise_measurement(enum ima_hooks func,
 					   const unsigned char *filename,
 					   struct evm_ima_xattr_data *xattr_value,
 					   int xattr_len,
-					   const struct modsig *modsig)
+					   const struct modsig *modsig,
+					   bool bprm_is_check)
 {
 	return INTEGRITY_UNKNOWN;
 }
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index a87ef7c05f11e..a3bdb7a0ab121 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -480,17 +480,6 @@ int ima_check_blacklist(struct ima_iint_cache *iint,
 	return rc;
 }
 
-static bool is_bprm_creds_for_exec(enum ima_hooks func, struct file *file)
-{
-	struct linux_binprm *bprm;
-
-	if (func == BPRM_CHECK) {
-		bprm = container_of(&file, struct linux_binprm, file);
-		return bprm->is_check;
-	}
-	return false;
-}
-
 /*
  * ima_appraise_measurement - appraise file measurement
  *
@@ -502,7 +491,8 @@ static bool is_bprm_creds_for_exec(enum ima_hooks func, struct file *file)
 int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 			     struct file *file, const unsigned char *filename,
 			     struct evm_ima_xattr_data *xattr_value,
-			     int xattr_len, const struct modsig *modsig)
+			     int xattr_len, const struct modsig *modsig,
+			     bool bprm_is_check)
 {
 	static const char op[] = "appraise_data";
 	int audit_msgno = AUDIT_INTEGRITY_DATA;
@@ -524,7 +514,7 @@ int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 	 * of the script interpreter(userspace). Differentiate kernel and
 	 * userspace enforced integrity audit messages.
 	 */
-	if (is_bprm_creds_for_exec(func, file))
+	if (bprm_is_check)
 		audit_msgno = AUDIT_INTEGRITY_USERSPACE;
 
 	/* If reading the xattr failed and there's no modsig, error out. */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index cda897267230d..d2a31b655822a 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -236,7 +236,8 @@ static void ima_file_free(struct file *file)
 static int process_measurement(struct file *file, const struct cred *cred,
 			       struct lsm_prop *prop, char *buf, loff_t size,
 			       int mask, enum ima_hooks func,
-			       enum kernel_read_file_id read_id)
+			       enum kernel_read_file_id read_id,
+			       bool bprm_is_check)
 {
 	struct inode *real_inode, *inode = file_inode(file);
 	struct ima_iint_cache *iint = NULL;
@@ -426,7 +427,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
 			inode_lock(inode);
 			rc = ima_appraise_measurement(func, iint, file,
 						      pathname, xattr_value,
-						      xattr_len, modsig);
+						      xattr_len, modsig,
+						      bprm_is_check);
 			inode_unlock(inode);
 		}
 		if (!rc)
@@ -493,14 +495,15 @@ static int ima_file_mmap(struct file *file, unsigned long reqprot,
 
 	if (reqprot & PROT_EXEC) {
 		ret = process_measurement(file, current_cred(), &prop, NULL,
-					  0, MAY_EXEC, MMAP_CHECK_REQPROT, 0);
+					  0, MAY_EXEC, MMAP_CHECK_REQPROT, 0,
+					  false);
 		if (ret)
 			return ret;
 	}
 
 	if (prot & PROT_EXEC)
 		return process_measurement(file, current_cred(), &prop, NULL,
-					   0, MAY_EXEC, MMAP_CHECK, 0);
+					   0, MAY_EXEC, MMAP_CHECK, 0, false);
 
 	return 0;
 }
@@ -584,7 +587,8 @@ static int ima_bprm_check(struct linux_binprm *bprm)
 
 	security_current_getlsmprop_subj(&prop);
 	return process_measurement(bprm->file, current_cred(),
-				   &prop, NULL, 0, MAY_EXEC, BPRM_CHECK, 0);
+				   &prop, NULL, 0, MAY_EXEC, BPRM_CHECK, 0,
+				   bprm->is_check);
 }
 
 /**
@@ -614,7 +618,7 @@ static int ima_creds_check(struct linux_binprm *bprm, const struct file *file)
 
 	security_current_getlsmprop_subj(&prop);
 	return process_measurement((struct file *)file, bprm->cred, &prop, NULL,
-				   0, MAY_EXEC, CREDS_CHECK, 0);
+				   0, MAY_EXEC, CREDS_CHECK, 0, false);
 }
 
 /**
@@ -662,7 +666,7 @@ static int ima_file_check(struct file *file, int mask)
 	security_current_getlsmprop_subj(&prop);
 	return process_measurement(file, current_cred(), &prop, NULL, 0,
 				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
-					   MAY_APPEND), FILE_CHECK, 0);
+					   MAY_APPEND), FILE_CHECK, 0, false);
 }
 
 /*
@@ -918,7 +922,7 @@ static int ima_read_file(struct file *file, enum kernel_read_file_id read_id,
 	func = read_idmap[read_id] ?: FILE_CHECK;
 	security_current_getlsmprop_subj(&prop);
 	return process_measurement(file, current_cred(), &prop, NULL, 0,
-				   MAY_READ, func, 0);
+				   MAY_READ, func, 0, false);
 }
 
 const int read_idmap[READING_MAX_ID] = {
@@ -962,7 +966,7 @@ static int ima_post_read_file(struct file *file, char *buf, loff_t size,
 	func = read_idmap[read_id] ?: FILE_CHECK;
 	security_current_getlsmprop_subj(&prop);
 	return process_measurement(file, current_cred(), &prop, buf, size,
-				   MAY_READ, func, read_id);
+				   MAY_READ, func, read_id, false);
 }
 
 /**
-- 
2.53.0



