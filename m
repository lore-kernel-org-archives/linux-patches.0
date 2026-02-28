Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EE7342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301759; cv=none; b=bPeiSL7W1HeVXl6vjZqq2M9zBXQJ/hZ1jMWv6GO2wZW8NqtLoqPLAKbRRbdjiOannElJ6X41EFyQ4g1MthZ7VTtjWHhSypQJchzgZSxgaYRHxCZMP+niZLOPD6+TJLanWxcGiKGaiYIgsnt8TCmHYxXxqACoFnVSSteoESw3vrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301759; c=relaxed/simple;
	bh=Xp7DgJRsguXHrDFr5XC4+DEVFFe1oo+xu+Rhfuj5/vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD2/Qr8gg9SGSyohfkQUxeyMZWYrCiXP2qWkgGuZP1Dr8abdUm7el1ZHLy0Bmk/jWxYbER38/32XakJPRiYq4fPPjHYMklw/xUggt/2zhe+rcoXcTxBTJwds2GqYhNYWtFifVZYKMCG6zu786wL0ZI5kjJNq5ZD5kbFga6kQKZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m74PDKLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m74PDKLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D25C19423;
	Sat, 28 Feb 2026 18:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301758;
	bh=Xp7DgJRsguXHrDFr5XC4+DEVFFe1oo+xu+Rhfuj5/vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m74PDKLLj0dXoq/U44b6ZPZMVP45MRs1K4Ym8cvIeynQor2isaTlwBvy5FUY6Xblh
	 HRl8zyPrhLXEYpDWz1HH0+FJUaQCQ9zNdGwWIcImX/bKvxCkDcYfO7Gd5zRsy1WG0f
	 G8bcccRNpQBc/bRA8SDthe+0K3p0H56N6LQe23mPUrXrdx0xt4vkV2MckMYUCtWAOm
	 t8j1EQk/gOcQR0lXKn4aNJQ/J5oIAzbBeRDbNoE5Dktam0/peAsar6YjqvHnxl/R54
	 JCs25Ob2W0mt2QGN4RS4IBTsAqyP09aKna0MfQM2iGXZwPFFhUrNl2rCEZ2BQsoS+I
	 /jnINaYwbbHeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/385] evm: Use ordered xattrs list to calculate HMAC in evm_init_hmac()
Date: Sat, 28 Feb 2026 12:56:25 -0500
Message-ID: <20260228180011.1568201-163-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 0496fc9cdc384f67be4413b1c6156eb64fccd5c4 ]

Commit 8e5d9f916a96 ("smack: deduplicate xattr setting in
smack_inode_init_security()") introduced xattr_dupval() to simplify setting
the xattrs to be provided by the SMACK LSM on inode creation, in the
smack_inode_init_security().

Unfortunately, moving lsm_get_xattr_slot() caused the SMACK64TRANSMUTE
xattr be added in the array of new xattrs before SMACK64. This causes the
HMAC of xattrs calculated by evm_init_hmac() for new files to diverge from
the one calculated by both evm_calc_hmac_or_hash() and evmctl.

evm_init_hmac() calculates the HMAC of the xattrs of new files based on the
order LSMs provide them, while evm_calc_hmac_or_hash() and evmctl calculate
the HMAC based on an ordered xattrs list.

Fix the issue by making evm_init_hmac() calculate the HMAC of new files
based on the ordered xattrs list too.

Fixes: 8e5d9f916a96 ("smack: deduplicate xattr setting in smack_inode_init_security()")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 7c06ffd633d24..c588af7cc5f87 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -401,6 +401,7 @@ int evm_init_hmac(struct inode *inode, const struct xattr *xattrs,
 {
 	struct shash_desc *desc;
 	const struct xattr *xattr;
+	struct xattr_list *xattr_entry;
 
 	desc = init_desc(EVM_XATTR_HMAC, HASH_ALGO_SHA1);
 	if (IS_ERR(desc)) {
@@ -408,11 +409,16 @@ int evm_init_hmac(struct inode *inode, const struct xattr *xattrs,
 		return PTR_ERR(desc);
 	}
 
-	for (xattr = xattrs; xattr->name; xattr++) {
-		if (!evm_protected_xattr(xattr->name))
-			continue;
+	list_for_each_entry_lockless(xattr_entry, &evm_config_xattrnames,
+				     list) {
+		for (xattr = xattrs; xattr->name; xattr++) {
+			if (strcmp(xattr_entry->name +
+				   XATTR_SECURITY_PREFIX_LEN, xattr->name) != 0)
+				continue;
 
-		crypto_shash_update(desc, xattr->value, xattr->value_len);
+			crypto_shash_update(desc, xattr->value,
+					    xattr->value_len);
+		}
 	}
 
 	hmac_add_misc(desc, inode, EVM_XATTR_HMAC, hmac_val);
-- 
2.51.0

