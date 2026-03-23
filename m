Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC36B3B9DB7;
	Mon, 23 Mar 2026 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278714; cv=none; b=qi8glk/UuZJBbFor3fGomVajg6a53v+S3jrY2RN0CW02iw7jbjTwz8DvavEfEpEb8v/g516iaHmqvg3SkKvYUK49o6/sD4ZuB6Ird4Sy0pGhdw5RyAgMelPcuS5+zjpADc1Yg6RrUWvck92X2GW7LM8gA5R1EDtK59JbiYVzxaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278714; c=relaxed/simple;
	bh=0W9jethkkYjdtBG5kGeE2KS9cs8VV12s7+9l4u/9crc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDHxIzGmaTSn88DRJO6ppXIXW0SrYZ7g1lDnvs+quUVA3c5AMNRuwGb7D5fJRXnJm8ObiLw0GoH4sRVxv9pXGiLkEg+LAoUNBS8hfzDOS2rzh02nF0lPcJkj/i567LEqYmCiOxYmHjA0dkIuzFll422zIj2yQK+07RmUBYYnFo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AAbSNpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AAbSNpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC80C4CEF7;
	Mon, 23 Mar 2026 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278714;
	bh=0W9jethkkYjdtBG5kGeE2KS9cs8VV12s7+9l4u/9crc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AAbSNpXQBguOxBitRNndn8mgHLyqNUkZLv86VTry7lvLEKWOpksyme2AXXbpvMsn
	 np+8cMjSfNIkiKRnE2UA0Yyz9dQba+sCEayNLnlGXZy0PWGzg1B75Nj/y3nhXbu2n0
	 syEMCQfXfFLo63EgU11l3wKpYG3vcEwRlFXcUCS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 396/567] ksmbd: Compare MACs in constant time
Date: Mon, 23 Mar 2026 14:45:16 +0100
Message-ID: <20260323134543.656437256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
@@ -8804,7 +8805,7 @@ int smb2_check_sign_req(struct ksmbd_wor
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
@@ -8892,7 +8893,7 @@ int smb3_check_sign_req(struct ksmbd_wor
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}


