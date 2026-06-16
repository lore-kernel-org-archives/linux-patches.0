Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ED43D669A;
	Tue, 16 Jun 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632471; cv=none; b=NgDCB12H5y/yq3Nqe7rdpkg/2qFb6LXJ5duCLzgSRMIp4HjiTP6wDO+a8hdlfODWYsEAkl4MKiC42a0SJMpTvnkFhhaBEKF7+yWv8MhGxZJEC+jqF29kwX9+iSE+w64inc8AH7zzdl28C/4dRe9F3BNMBJw7Ta4DYt4j/UQqESo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632471; c=relaxed/simple;
	bh=Zb/5BjcMuvYWgRxbWwy13ewJFC/WbiiSOxRwRQV9Cm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjY9nFoQ6Ejq84whAixP9lGvdiZ0C7ckDBksg/C41xk03C7baMHqauE4fE2b76IH2jDC0LtgXKX7eycYi7EcRpM9Tq9FSeoBxVRV3/tH3SWXusk6dmiJNp9do/blwkdPHHvU+LfHj+z/ikLhaVqYi5O0oTzrEh3tBije9AlyzHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZYM30JR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZYM30JR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0581F000E9;
	Tue, 16 Jun 2026 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632470;
	bh=CFQU5FoI0kbHica4HWWzHwujgxHghqPi61Q9gdW4/xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZYM30JRyJNIqhcJ0J7ZfsFOwKeDOgwr3cZoTFvxyPQAB/T8ffbpguHchpJF8GloG
	 f30Y9hQqQknJqPrSgmdZbFsWRp1YRw0YVtDVgwXkYeGUE5a5EO/Ufi9eWfgOaA6rZX
	 mXslgjDY3Z/842QdLZReAKBPFC3senpYenLBD6zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Piyush Sachdeva <psachdeva@microsoft.com>,
	Piyush Sachdeva <s.piyush1024@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 418/522] smb: client: Use FullSessionKey for AES-256 encryption key derivation
Date: Tue, 16 Jun 2026 20:29:25 +0530
Message-ID: <20260616145145.565833000@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Piyush Sachdeva <s.piyush1024@gmail.com>

[ Upstream commit 5be7a0cef3229fb3b63a07c0d289daf752545424 ]

When Kerberos authentication is used with AES-256 encryption (AES-256-CCM
or AES-256-GCM), the SMB3 encryption and decryption keys must be derived
using the full session key (Session.FullSessionKey) rather than just the
first 16 bytes (Session.SessionKey).

Per MS-SMB2 section 3.2.5.3.1, when Connection.Dialect is "3.1.1" and
Connection.CipherId is AES-256-CCM or AES-256-GCM, Session.FullSessionKey
must be set to the full cryptographic key from the GSS authentication
context. The encryption and decryption key derivation (SMBC2SCipherKey,
SMBS2CCipherKey) must use this FullSessionKey as the KDF input. The
signing key derivation continues to use Session.SessionKey (first 16
bytes) in all cases.

Previously, generate_key() hardcoded SMB2_NTLMV2_SESSKEY_SIZE (16) as the
HMAC-SHA256 key input length for all derivations. When Kerberos with
AES-256 provides a 32-byte session key, the KDF for encryption/decryption
was using only the first 16 bytes, producing keys that did not match the
server's, causing mount failures with sec=krb5 and require_gcm_256=1.

Add a full_key_size parameter to generate_key() and pass the appropriate
size from generate_smb3signingkey():
 - Signing: always SMB2_NTLMV2_SESSKEY_SIZE (16 bytes)
 - Encryption/Decryption: ses->auth_key.len when AES-256, otherwise 16

Also fix cifs_dump_full_key() to report the actual session key length for
AES-256 instead of hardcoded CIFS_SESS_KEY_SIZE, so that userspace tools
like Wireshark receive the correct key for decryption.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ adapted upstream's void/hmac_sha256_init_usingrawkey-based generate_key() to 6.12's int-return crypto_shash_* form while threading full_key_size through all callers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/ioctl.c         |    2 +-
 fs/smb/client/smb2transport.c |   32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -279,7 +279,7 @@ search_end:
 		break;
 	case SMB2_ENCRYPTION_AES256_CCM:
 	case SMB2_ENCRYPTION_AES256_GCM:
-		out.session_key_length = CIFS_SESS_KEY_SIZE;
+		out.session_key_length = ses->auth_key.len;
 		out.server_in_key_length = out.server_out_key_length = SMB3_GCM256_CRYPTKEY_SIZE;
 		break;
 	default:
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -307,7 +307,8 @@ out:
 }
 
 static int generate_key(struct cifs_ses *ses, struct kvec label,
-			struct kvec context, __u8 *key, unsigned int key_size)
+			struct kvec context, __u8 *key, unsigned int key_size,
+			unsigned int full_key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -328,7 +329,7 @@ static int generate_key(struct cifs_ses
 	}
 
 	rc = crypto_shash_setkey(server->secmech.hmacsha256->tfm,
-		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		ses->auth_key.response, full_key_size);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set with session key\n", __func__);
 		goto smb3signkey_ret;
@@ -403,6 +404,7 @@ generate_smb3signingkey(struct cifs_ses
 			struct TCP_Server_Info *server,
 			const struct derivation_triplet *ptriplet)
 {
+	unsigned int full_key_size = SMB2_NTLMV2_SESSKEY_SIZE;
 	int rc;
 	bool is_binding = false;
 	int chan_index = 0;
@@ -431,17 +433,31 @@ generate_smb3signingkey(struct cifs_ses
 		rc = generate_key(ses, ptriplet->signing.label,
 				  ptriplet->signing.context,
 				  ses->chans[chan_index].signkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  SMB3_SIGN_KEY_SIZE,
+				  SMB2_NTLMV2_SESSKEY_SIZE);
 		if (rc)
 			return rc;
 	} else {
 		rc = generate_key(ses, ptriplet->signing.label,
 				  ptriplet->signing.context,
 				  ses->smb3signingkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  SMB3_SIGN_KEY_SIZE,
+				  SMB2_NTLMV2_SESSKEY_SIZE);
 		if (rc)
 			return rc;
 
+		/*
+		 * Per MS-SMB2 3.2.5.3.1, signing key always uses Session.SessionKey
+		 * (first 16 bytes). Encryption/decryption keys use
+		 * Session.FullSessionKey when dialect is 3.1.1 and cipher is
+		 * AES-256-CCM or AES-256-GCM, otherwise Session.SessionKey.
+		 */
+
+		if (server->dialect == SMB311_PROT_ID &&
+		    (server->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+		     server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
+			full_key_size = ses->auth_key.len;
+
 		/* safe to access primary channel, since it will never go away */
 		spin_lock(&ses->chan_lock);
 		memcpy(ses->chans[chan_index].signkey, ses->smb3signingkey,
@@ -451,13 +467,15 @@ generate_smb3signingkey(struct cifs_ses
 		rc = generate_key(ses, ptriplet->encryption.label,
 				  ptriplet->encryption.context,
 				  ses->smb3encryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
+				  SMB3_ENC_DEC_KEY_SIZE,
+				  full_key_size);
 		if (rc)
 			return rc;
 		rc = generate_key(ses, ptriplet->decryption.label,
 				  ptriplet->decryption.context,
 				  ses->smb3decryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
+				  SMB3_ENC_DEC_KEY_SIZE,
+				  full_key_size);
 		if (rc)
 			return rc;
 	}
@@ -472,7 +490,7 @@ generate_smb3signingkey(struct cifs_ses
 			&ses->Suid);
 	cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
 	cifs_dbg(VFS, "Session Key   %*ph\n",
-		 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
+		 (int)ses->auth_key.len, ses->auth_key.response);
 	cifs_dbg(VFS, "Signing Key   %*ph\n",
 		 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||


