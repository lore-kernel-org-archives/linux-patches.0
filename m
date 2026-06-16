Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDE5318EDA;
	Tue, 16 Jun 2026 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636619; cv=none; b=TUTLa4nXyjZO2Nv3GvVedf8g/zDcluvyJheya7O8vrC9eWY7Db8/WuXYssyLnsDTP/pkmhcmEPGEKQe5tTW4ClVl3a6lAjKyn9UNnEM3U9+Ps9r6AICbbXewMHLjjt4Mdpo3HU40xuGZxq1P6BhY2r9T2YMvnFDeuWgeCQCG8Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636619; c=relaxed/simple;
	bh=B5rM8LkaYtfgDkI9uiPyXX+XzDdullIkCBQN3+4gW3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3TORiLAmiE5zDhu3H0hQ4936m2JFBw38jcTyupkGJp+ZupSyFPv2I9AtRd8gFRZrfgy03JfEU86dinUtf0xDyEkzL7m04q6lk97JxTdHbKhKmJMvFE5IH485rJgXJn2taDGhMolvqEjz8N2wm3oz3p/XypKbJMb5bR+V9x7X/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSV6RqNK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSV6RqNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCE91F000E9;
	Tue, 16 Jun 2026 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636618;
	bh=qoOGi64HQ2Pu9rHh6/AElOHWiRzRP2nJ+yx2TG4xEGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSV6RqNK1ZxRJtlmd/WFP7/UaAXVqQI7sUD6mY22oz7fltBK6/vWLPGXSmoBlt7dn
	 7SUI4KxKOkpwWYfiDNx6MdIQEOOcTP2NPBTZgj7ewP+hAvkF/CHjaoJH8XcHooBq0j
	 jTOzJXd8bFsuegugMMrsucKN8E+GrImSI/07HXfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Piyush Sachdeva <psachdeva@microsoft.com>,
	Piyush Sachdeva <s.piyush1024@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/342] smb: client: Use FullSessionKey for AES-256 encryption key derivation
Date: Tue, 16 Jun 2026 20:29:29 +0530
Message-ID: <20260616145101.060730890@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted to old crypto_shash API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2transport.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -305,7 +305,8 @@ out:
 }
 
 static int generate_key(struct cifs_ses *ses, struct kvec label,
-			struct kvec context, __u8 *key, unsigned int key_size)
+			struct kvec context, __u8 *key, unsigned int key_size,
+			unsigned int full_key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -326,7 +327,7 @@ static int generate_key(struct cifs_ses
 	}
 
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
-		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		ses->auth_key.response, full_key_size);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set with session key\n", __func__);
 		goto smb3signkey_ret;
@@ -407,10 +408,9 @@ static int
 generate_smb3signingkey(struct cifs_ses *ses,
 			const struct derivation_triplet *ptriplet)
 {
-	int rc;
-#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
+	unsigned int full_key_size = SMB2_NTLMV2_SESSKEY_SIZE;
 	struct TCP_Server_Info *server = ses->server;
-#endif
+	int rc;
 
 	/*
 	 * All channels use the same encryption/decryption keys but
@@ -426,30 +426,46 @@ generate_smb3signingkey(struct cifs_ses
 		rc = generate_key(ses, ptriplet->signing.label,
 				  ptriplet->signing.context,
 				  cifs_ses_binding_channel(ses)->signkey,
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
 		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
 		       SMB3_SIGN_KEY_SIZE);
 
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
@@ -464,7 +480,7 @@ generate_smb3signingkey(struct cifs_ses
 			&ses->Suid);
 	cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
 	cifs_dbg(VFS, "Session Key   %*ph\n",
-		 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
+		 (int)ses->auth_key.len, ses->auth_key.response);
 	cifs_dbg(VFS, "Signing Key   %*ph\n",
 		 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||


