Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA2A3A1D01;
	Sat, 17 Oct 2026 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257929; cv=none; b=jtK7qn/o4inrxUnj3hQiyjYah/WaJpT4aQ35W/hyk994hRWPhEKPsyKY5jiliwG/6oEbs5/RNILk/xKw9e934rrQg7l3XpLPA59dmgiGgNbqIGPpc9xkjGmSIgLzhpCMO3PceyhYO8HPfGogybOOFBLZpjGD6darUuqULP+3hQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257929; c=relaxed/simple;
	bh=PDGMGCxCkXEo5OP5eOiRETgeh2VLlxSuhLZFPBvXv/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F07D8RHwJip45Zz4M6XvvlavqkYIwPG5/N91S3ML3MoStTprZSvWwLtwfbL7yUcur4XW0MABAFd4680yLaBmF7nsffulf7IypipHBrZGe8eOVR9EmF3ZoSHfAXTg+8V44V4V1MiaSitUb9VGEw21HLmLPXCYirbO6dUZVM7q6Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvA3pYUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvA3pYUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBBF1F000C4;
	Sat, 17 Oct 2026 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257928;
	bh=ziiMAaY9qq4nJBS9qIW6u8UoC0S2XH2tKyfwXonFFSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvA3pYUq4+T57M5ukGrfiPex33b9O+TIT9+cEIVtqzDCdhBKjnlQqryiEpmt4DX/+
	 LnO/WaBluUF8XlAfT2eniZwZN2KuVcHatvSigmwTiCsjdovTBC8c6CJAvhNIjoNcFi
	 EJ471dYRoJkTIMrPN+d6mL6f6Zzuv6mMSsokFqg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0717/1674] smb: client: allocate crypto only for primary server
Date: Sat, 17 Oct 2026 17:49:49 +0200
Message-ID: <20261017160449.510909905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit f7025d861694362348efc14eaad6a17840c4e9a4 ]

For extra channels, point ->secmech.{enc,dec} to the primary
server ones.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 9502dd5c7029 ("smb: client: fix UAF in decryption with multichannel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsencrypt.c | 17 +++++++++++------
 fs/smb/client/smb2pdu.c     | 10 +++++++---
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 3d6b663212335..1043341be1248 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -850,13 +850,18 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 	cifs_free_hash(&server->secmech.sha512);
 	cifs_free_hash(&server->secmech.hmacmd5);
 
-	if (server->secmech.enc) {
-		crypto_free_aead(server->secmech.enc);
-		server->secmech.enc = NULL;
-	}
+	if (!SERVER_IS_CHAN(server)) {
+		if (server->secmech.enc) {
+			crypto_free_aead(server->secmech.enc);
+			server->secmech.enc = NULL;
+		}
 
-	if (server->secmech.dec) {
-		crypto_free_aead(server->secmech.dec);
+		if (server->secmech.dec) {
+			crypto_free_aead(server->secmech.dec);
+			server->secmech.dec = NULL;
+		}
+	} else {
+		server->secmech.enc = NULL;
 		server->secmech.dec = NULL;
 	}
 }
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 6bdcc942d36b3..1b1804f21414f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1281,9 +1281,13 @@ SMB2_negotiate(const unsigned int xid,
 	}
 
 	if (server->cipher_type && !rc) {
-		rc = smb3_crypto_aead_allocate(server);
-		if (rc)
-			cifs_server_dbg(VFS, "%s: crypto alloc failed, rc=%d\n", __func__, rc);
+		if (!SERVER_IS_CHAN(server)) {
+			rc = smb3_crypto_aead_allocate(server);
+		} else {
+			/* For channels, just reuse the primary server crypto secmech. */
+			server->secmech.enc = server->primary_server->secmech.enc;
+			server->secmech.dec = server->primary_server->secmech.dec;
+		}
 	}
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
-- 
2.53.0



