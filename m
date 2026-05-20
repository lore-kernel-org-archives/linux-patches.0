Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259093FC5A9;
	Wed, 20 May 2026 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299958; cv=none; b=VbYRFWp83jpfHV1n2DDWi/ogZvqTtIB53WRP9NaJunyNSnBRoeMRtGzVFq+EVXiNe8O2Ea2W4h9U4Ld5kRxhPqH9Xm3qPQdaYq0NsRtoFGuN8nXX7m3GIfu9wQDlYRB2CTYty6rqsYllNYJfD49nQjIhocJBAXmTQEZzp+Ujs08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299958; c=relaxed/simple;
	bh=BO1xSwcu2kC5T1QmtCDS2HLE16Brt4SFZd+UUysr/qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8U/FAAcUlCkGGVOD7udqUZBT5984n/dS0VhzL8ShjaEqN69rOEdPuqeMmtAOCWF2B23qOB294Qr3Qss+8NeXN9w7TpfOLUnfXOs6vzrqWF15I6F0BqdeT9XE/tBFjEQzYYTk+mfamB8bTiNT1d9KSjPX6WJP4MFscybPXLuxbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bbzct2vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bbzct2vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921C61F00893;
	Wed, 20 May 2026 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299955;
	bh=41QJrCRmAdw8v6U4FAtq0bbtWUD8S8UXGbBUcDdQW7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bbzct2vmCYxOIP1/X9TVjiQdEEwZnLwHc6wNceNjBuRfNviiy40f7ES6KwPOgONsm
	 p4tjmMzPXXo3hVkZsO6jvi/RS59z0KvX2nsK4qh7PHoR7aGKUIzBbkYBKxUTsqpsRx
	 vfmhiVozd3T2LCsoMXv0KehE3OiPTOZif1oDfnUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Piyush Sachdeva <psachdeva@microsoft.com>,
	Piyush Sachdeva <s.piyush1024@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 950/957] smb: client: Use FullSessionKey for AES-256 encryption key derivation
Date: Wed, 20 May 2026 18:23:53 +0200
Message-ID: <20260520162155.203948976@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/ioctl.c         |    2 +-
 fs/smb/client/smb2transport.c |   32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -297,7 +297,7 @@ search_end:
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
@@ -259,7 +259,8 @@ smb2_calc_signature(struct smb_rqst *rqs
 }
 
 static int generate_key(struct cifs_ses *ses, struct kvec label,
-			struct kvec context, __u8 *key, unsigned int key_size)
+			struct kvec context, __u8 *key, unsigned int key_size,
+			unsigned int full_key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -280,7 +281,7 @@ static int generate_key(struct cifs_ses
 	}
 
 	hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
-				     SMB2_NTLMV2_SESSKEY_SIZE);
+				     full_key_size);
 	hmac_sha256_update(&hmac_ctx, i, 4);
 	hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
 	hmac_sha256_update(&hmac_ctx, &zero, 1);
@@ -314,6 +315,7 @@ generate_smb3signingkey(struct cifs_ses
 			struct TCP_Server_Info *server,
 			const struct derivation_triplet *ptriplet)
 {
+	unsigned int full_key_size = SMB2_NTLMV2_SESSKEY_SIZE;
 	int rc;
 	bool is_binding = false;
 	int chan_index = 0;
@@ -348,17 +350,31 @@ generate_smb3signingkey(struct cifs_ses
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
@@ -368,13 +384,15 @@ generate_smb3signingkey(struct cifs_ses
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
@@ -389,7 +407,7 @@ generate_smb3signingkey(struct cifs_ses
 			&ses->Suid);
 	cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
 	cifs_dbg(VFS, "Session Key   %*ph\n",
-		 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
+		 (int)ses->auth_key.len, ses->auth_key.response);
 	cifs_dbg(VFS, "Signing Key   %*ph\n",
 		 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||


