Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7682F352C4F;
	Tue, 10 Mar 2026 11:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141139; cv=none; b=eL59hW+3w8mUIqPxzGyq+7T9IS3X2UusYn6CHZnbKu9LBiUtB/+SoHKI4rFu9SCobxUn+AcmCo/EttpV+biVzzcD6L+ITRX0stNvtPF+ULQN51CLlCofpElVvQomhNf1t/3y9XT3QAOM28DNcCKwI916FTTRV2dL5gO5WxsFR18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141139; c=relaxed/simple;
	bh=dLRfHKCDBSBZ7py2cuo16+q2aXkSmPQKrk3JWRU5pvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbnRBNlngizqlgYJGUHIfwsOTHDWRC4erR0gQ3cAFdrji+Zf1Ld2Ep5rHkDizu6qU8GJ2seEa1sPD/Yvo/aSpFXRvEScvIM7/2IfuvqkbOApDF3Z70OyejBgmy+iu6vrzCvvOASmGeG9MQNhlLDULLLtW+jt8xSLbV2KLHNK6pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UAeKD9+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UAeKD9+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE01C2BC86;
	Tue, 10 Mar 2026 11:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141139;
	bh=dLRfHKCDBSBZ7py2cuo16+q2aXkSmPQKrk3JWRU5pvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAeKD9+KWFhsJyn0QnsyUe5HXvyTgfEQa7sZKVJmVsP9pXGLByfi4LG3IRALWHjad
	 P/wJhtbn9ceWvwAOrdnZxmiQVB7UMxQEx1vQeArqZVKsKY8dT6vL2xlI9SvUINlVnu
	 sx1UCJ4TxW0Lvl9LS/INo1tgfeqcRtGGYWgdOI6FRBGZvndn9rDUBeiVh7zEsXZ1Ys
	 ftfUF4G0WeQlx2HUYcTZwB/xlbHPmPbdeJ0Bkbj90ze3t5nUfKdBoYK1pLDMKPBM1A
	 H9WN2nD/uj4PArG3m+QMvtdI6XZ1+HSwqPSvCpurTykmreaPgu+DphjkNhJEZSIVzM
	 xN1/QJqeUzJrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 143/311] ksmbd: Compare MACs in constant time
Date: Tue, 10 Mar 2026 07:03:10 -0400
Message-ID: <1a349ff37a37c8da920e7aed0ee771a6b26e460e.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 fs/smb/server/Kconfig   | 1 +
 fs/smb/server/auth.c    | 4 +++-
 fs/smb/server/smb2pdu.c | 5 +++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 2775162c535c6..12594879cb640 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -13,6 +13,7 @@ config SMB_SERVER
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
+	select CRYPTO_LIB_UTILS
 	select CRYPTO_CMAC
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 09af55b71153e..a69e8694605aa 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -15,6 +15,7 @@
 #include <crypto/aead.h>
 #include <crypto/md5.h>
 #include <crypto/sha2.h>
+#include <crypto/utils.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
@@ -165,7 +166,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 			     ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE,
 			     sess->sess_key);
 
-	if (memcmp(ntlmv2->ntlmv2_hash, ntlmv2_rsp, CIFS_HMAC_MD5_HASH_SIZE) != 0)
+	if (crypto_memneq(ntlmv2->ntlmv2_hash, ntlmv2_rsp,
+			  CIFS_HMAC_MD5_HASH_SIZE))
 		return -EINVAL;
 	return 0;
 }
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1022d794bd232..b682e8160504a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4,6 +4,7 @@
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <crypto/utils.h>
 #include <linux/inetdevice.h>
 #include <net/addrconf.h>
 #include <linux/syscalls.h>
@@ -8879,7 +8880,7 @@ int smb2_check_sign_req(struct ksmbd_work *work)
 	ksmbd_sign_smb2_pdu(work->conn, work->sess->sess_key, iov, 1,
 			    signature);
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
@@ -8967,7 +8968,7 @@ int smb3_check_sign_req(struct ksmbd_work *work)
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
-- 
2.51.0

