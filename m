Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7108A3B0AD8;
	Mon, 23 Mar 2026 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276831; cv=none; b=FNRCttfLB0I2TdpJ60eVa0QE3AvqKyic+CVwZ0jhgZtFk6UGBUggJOBPl12RCfG60DFU8SUQkyS6yuSYZjCsEAKTvem21vK71mDChwYHSFUTNldyXRWk3lyN+5cL+hSQCh3CmRwjWMhXymwHN4S5S+ZFEakWDG+oBl01Mf4+vHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276831; c=relaxed/simple;
	bh=i7Fv4+W8vbcjiJuI6nYRty8fhG0Aw97mGW1BQPGG1Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I06EXLWnHPWNyNcu40c1rb/g5VdODOquxRWrt0VLXAhv14/WXkKP5GyFiNvAcHl7RHLNCNRND29Cnz0HFP1m5/8d93k/EkhIjkY6/gFgkD2ZPZgYcs+ROcpj9wyALYQUAgpGTY+o0tlF2iac1+wgSl//r//4HeCs972T8EpacGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM+kgzWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM+kgzWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D74C2BCB3;
	Mon, 23 Mar 2026 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276831;
	bh=i7Fv4+W8vbcjiJuI6nYRty8fhG0Aw97mGW1BQPGG1Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM+kgzWQQfbUrk93ClAVJMdYARgpgDKGdJTzGMk1G/QlxTJFepVhG/1xg8HkJdm6H
	 A6fKrLb8PNxsSBBiZ6msQb0wWOw6PnRGWhO1TNcPq+1/1euUC/SRfIYxgZ/EbkWPGA
	 TDu2Emlg1/dpE1pSasgCTxiqE7+FkzLsSIAkzgxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 220/460] ksmbd: Compare MACs in constant time
Date: Mon, 23 Mar 2026 14:43:36 +0100
Message-ID: <20260323134531.903906082@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit c5794709bc9105935dbedef8b9cf9c06f2b559fa upstream.

To prevent timing attacks, MAC comparisons need to be constant-time.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/Kconfig   |    1 +
 fs/smb/server/auth.c    |    4 +++-
 fs/smb/server/smb2pdu.c |    5 +++--
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -11,6 +11,7 @@ config SMB_SERVER
 	select CRYPTO_HMAC
 	select CRYPTO_ECB
 	select CRYPTO_LIB_DES
+	select CRYPTO_LIB_UTILS
 	select CRYPTO_SHA256
 	select CRYPTO_CMAC
 	select CRYPTO_SHA512
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -13,6 +13,7 @@
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/utils.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
@@ -283,7 +284,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn
 		goto out;
 	}
 
-	if (memcmp(ntlmv2->ntlmv2_hash, ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE) != 0)
+	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
+			  CIFS_HMAC_MD5_HASH_SIZE))
 		rc = -EINVAL;
 out:
 	if (ctx)
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4,6 +4,7 @@
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <crypto/utils.h>
 #include <linux/inetdevice.h>
 #include <net/addrconf.h>
 #include <linux/syscalls.h>
@@ -8825,7 +8826,7 @@ int smb2_check_sign_req(struct ksmbd_wor
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
@@ -8913,7 +8914,7 @@ int smb3_check_sign_req(struct ksmbd_wor
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}


