Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D833B3C06;
	Mon, 23 Mar 2026 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274712; cv=none; b=jPhtRzEjvOFht1VYhgneP/6yJN4Eqaxvta8kwIjGSYXhVv7WovSL8vSdXpApf8HKLSotD1qS3v1jfb/OcP8OvJv3h7VQcqZlbRG957bL1ESrvyqCnffKn7+GetaxupFkcR3C2VKM1VSsFUHaIVhowQpkG5fGL5B5k6AkK6siiB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274712; c=relaxed/simple;
	bh=Pj+S0bMuu985ZoYKLJu4cP7lhg6SBEtRvIyqx6O5XJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kU6ipU0HZYwRDtaE8mYMzww3YXlYh5TZKLmms9+TaMdujcgsCCyLgGtmAI0mJ5h4sWk96zbu2oLFA1xNOXZURAj/qq5hHXgKWlryS1ujSGXDGK5Nzq9hPvujp72XhKxaymROaKLXDKo/xZ7gyP+b2ix5kun+Pfe/6ZR8LwQfD4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JROF9Sld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JROF9Sld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601D7C2BCB1;
	Mon, 23 Mar 2026 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274711;
	bh=Pj+S0bMuu985ZoYKLJu4cP7lhg6SBEtRvIyqx6O5XJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JROF9SldJP/OmQxf4WxCpIB108xFzMBfGSliCtoi4uwb4i4jE730xujTE6jY5LzIP
	 KY2d+rsD3MeDEjwWhAGSrPXfM2QA5qW1PZldJd60vkZImivcI91bE8aCITq7eadRQO
	 eBN6RArZMWNnhEENfTMcReRMQlCAdtekA1xmFLjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/212] ksmbd: Dont log keys in SMB3 signing and encryption key generation
Date: Mon, 23 Mar 2026 14:44:22 +0100
Message-ID: <20260323134505.067417200@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 441336115df26b966575de56daf7107ed474faed ]

When KSMBD_DEBUG_AUTH logging is enabled, generate_smb3signingkey() and
generate_smb3encryptionkey() log the session, signing, encryption, and
decryption key bytes. Remove the logs to avoid exposing credentials.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -802,12 +802,8 @@ static int generate_smb3signingkey(struc
 	if (!(conn->dialect >= SMB30_PROT_ID && signing->binding))
 		memcpy(chann->smb3signingkey, key, SMB3_SIGN_KEY_SIZE);
 
-	ksmbd_debug(AUTH, "dumping generated AES signing keys\n");
+	ksmbd_debug(AUTH, "generated SMB3 signing key\n");
 	ksmbd_debug(AUTH, "Session Id    %llu\n", sess->id);
-	ksmbd_debug(AUTH, "Session Key   %*ph\n",
-		    SMB2_NTLMV2_SESSKEY_SIZE, sess->sess_key);
-	ksmbd_debug(AUTH, "Signing Key   %*ph\n",
-		    SMB3_SIGN_KEY_SIZE, key);
 	return 0;
 }
 
@@ -871,23 +867,9 @@ static int generate_smb3encryptionkey(st
 	if (rc)
 		return rc;
 
-	ksmbd_debug(AUTH, "dumping generated AES encryption keys\n");
+	ksmbd_debug(AUTH, "generated SMB3 encryption/decryption keys\n");
 	ksmbd_debug(AUTH, "Cipher type   %d\n", conn->cipher_type);
 	ksmbd_debug(AUTH, "Session Id    %llu\n", sess->id);
-	ksmbd_debug(AUTH, "Session Key   %*ph\n",
-		    SMB2_NTLMV2_SESSKEY_SIZE, sess->sess_key);
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
-		ksmbd_debug(AUTH, "ServerIn Key  %*ph\n",
-			    SMB3_GCM256_CRYPTKEY_SIZE, sess->smb3encryptionkey);
-		ksmbd_debug(AUTH, "ServerOut Key %*ph\n",
-			    SMB3_GCM256_CRYPTKEY_SIZE, sess->smb3decryptionkey);
-	} else {
-		ksmbd_debug(AUTH, "ServerIn Key  %*ph\n",
-			    SMB3_GCM128_CRYPTKEY_SIZE, sess->smb3encryptionkey);
-		ksmbd_debug(AUTH, "ServerOut Key %*ph\n",
-			    SMB3_GCM128_CRYPTKEY_SIZE, sess->smb3decryptionkey);
-	}
 	return 0;
 }
 


