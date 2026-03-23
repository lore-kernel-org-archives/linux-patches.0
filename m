Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCC73B19A2;
	Mon, 23 Mar 2026 16:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283128; cv=none; b=VeRiJRETbGO8sbtiAGPFhAgPgf9l8u1oTEv6q/mV98TC0YMaOvvnjt2MUtzIIVIXxkQVhTRZDjD/QtuVBqm748lR8fCABlY2GB2WlK4Ljs7Vr24lj89GOPLSl7RySmCsqMXg8SHQ6CUxULWvyJ3gvygLIM8hOsqTNxBv9+OpK80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283128; c=relaxed/simple;
	bh=FonFDEUxyr+xsmjCLDddmpl7u4FMh1LS9k8IsF6OQ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSOQfVZCPH1sAAjzKf46ZVw2qEGKXXffg+G43g3/I8rSSj0nLgFF/tAy+lfKvGKoJkAYz6IRm79UWIKQ5hyjRKiAckR/lbVJTQUmMSP2WfcOHBt++lcc3IxGFL5XAfwGnzoS0ON/XhWO44DYp2n4PYpf47P4psYw4Fp2kEEbmXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpPnw77B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpPnw77B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA59C4CEF7;
	Mon, 23 Mar 2026 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283128;
	bh=FonFDEUxyr+xsmjCLDddmpl7u4FMh1LS9k8IsF6OQ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpPnw77BwnM3auqAEVo8MNlQUZbWNF77r9b7Mg3Swhg0aHxeV+M8ANW1ZNYZeaOAa
	 aGwr7/RCuF/5mmEFft1NqsoOtgarSpBe2pn0uUeNBdxrcqxNwlQqK6T7D90YiIK5K+
	 2aGufsgxz9x4blYlsARsZ13zCRJuMaRUKxDO7T7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 375/481] ksmbd: Compare MACs in constant time
Date: Mon, 23 Mar 2026 14:45:57 +0100
Message-ID: <20260323134534.270294854@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/auth.c    |    4 +++-
 fs/smb/server/smb2pdu.c |    5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -13,6 +13,7 @@
 #include <linux/xattr.h>
 #include <crypto/hash.h>
 #include <crypto/aead.h>
+#include <crypto/algapi.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
 
@@ -281,7 +282,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn
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
 
+#include <crypto/algapi.h>
 #include <linux/inetdevice.h>
 #include <net/addrconf.h>
 #include <linux/syscalls.h>
@@ -8430,7 +8431,7 @@ int smb2_check_sign_req(struct ksmbd_wor
 				signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}
@@ -8518,7 +8519,7 @@ int smb3_check_sign_req(struct ksmbd_wor
 	if (ksmbd_sign_smb3_pdu(conn, signing_key, iov, 1, signature))
 		return 0;
 
-	if (memcmp(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
+	if (crypto_memneq(signature, signature_req, SMB2_SIGNATURE_SIZE)) {
 		pr_err("bad smb2 signature\n");
 		return 0;
 	}


