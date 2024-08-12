Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70AA29CA;
	Mon, 12 Aug 2024 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479647; cv=none; b=l0iti+J0ud/FoGO6iENPusi4rF+oyksJjK3dqQhwL9scA2ux9+bLJqUQ5SL+gzKWXP9ywP/DxbnCRUYynNztfBtXaDKMN2joFhqu+JU7wBrn35MZimtljqIn4Ll1z3YkA+KWY+8PNNx68VxS5e53dea/F2F9teQaDvRG9S/d9r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479647; c=relaxed/simple;
	bh=+WypOlvp5qtTWERsLKg4mEywDLFpnc0dAFDXX5PTC0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDbMka4bVMCP7qfjJlvEXiUKjr5dReqPl0cGSzREjQvJkpJVL3x7PpQXstoT2U9DFsAPIN9tQIDcRXNDiJFm/ofHY3VHC76SOjbzwa0DeHjO9oWSRxgn9qglqGxshjrckB1fkEpWVzt+s6yI0hPezTj2UsxKaFa6QWRGzA+3OSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTTz6isV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTTz6isV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D3FC32782;
	Mon, 12 Aug 2024 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479647;
	bh=+WypOlvp5qtTWERsLKg4mEywDLFpnc0dAFDXX5PTC0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTTz6isVIfeBZF6p6NOeDQoto/Eetzyxn6ws7hYTs9D67w7G0t+Nh/U0fGXd+ASin
	 uwH+I1yp3GKizcL59T79uTCn/K16T07s/TXyKNlzNccxe7hUBXce6sdkKI/YiGXi4d
	 PNl+WeLAyC1i220DgMo++P7GzFTfIL88DJiRvTrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 150/189] smb3: fix setting SecurityFlags when encryption is required
Date: Mon, 12 Aug 2024 18:03:26 +0200
Message-ID: <20240812160137.916724855@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steve French <stfrench@microsoft.com>

commit 1b5487aefb1ce7a6b1f15a33297d1231306b4122 upstream.

Setting encryption as required in security flags was broken.
For example (to require all mounts to be encrypted by setting):

  "echo 0x400c5 > /proc/fs/cifs/SecurityFlags"

Would return "Invalid argument" and log "Unsupported security flags"
This patch fixes that (e.g. allowing overriding the default for
SecurityFlags  0x00c5, including 0x40000 to require seal, ie
SMB3.1.1 encryption) so now that works and forces encryption
on subsequent mounts.

Acked-by: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cifs/usage.rst |    2 +-
 fs/smb/client/cifs_debug.c               |    2 +-
 fs/smb/client/cifsglob.h                 |    8 ++++----
 fs/smb/client/smb2pdu.c                  |    3 +++
 4 files changed, 9 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/cifs/usage.rst
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -741,7 +741,7 @@ SecurityFlags		Flags which control secur
 			  may use NTLMSSP               		0x00080
 			  must use NTLMSSP           			0x80080
 			  seal (packet encryption)			0x00040
-			  must seal (not implemented yet)               0x40040
+			  must seal                                     0x40040
 
 cifsFYI			If set to non-zero value, additional debug information
 			will be logged to the system error log.  This field
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -1072,7 +1072,7 @@ static int cifs_security_flags_proc_open
 static void
 cifs_security_flags_handle_must_flags(unsigned int *flags)
 {
-	unsigned int signflags = *flags & CIFSSEC_MUST_SIGN;
+	unsigned int signflags = *flags & (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL);
 
 	if ((*flags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
 		*flags = CIFSSEC_MUST_KRB5;
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1922,7 +1922,7 @@ static inline bool is_replayable_error(i
 #define   CIFSSEC_MAY_SIGN	0x00001
 #define   CIFSSEC_MAY_NTLMV2	0x00004
 #define   CIFSSEC_MAY_KRB5	0x00008
-#define   CIFSSEC_MAY_SEAL	0x00040 /* not supported yet */
+#define   CIFSSEC_MAY_SEAL	0x00040
 #define   CIFSSEC_MAY_NTLMSSP	0x00080 /* raw ntlmssp with ntlmv2 */
 
 #define   CIFSSEC_MUST_SIGN	0x01001
@@ -1932,11 +1932,11 @@ require use of the stronger protocol */
 #define   CIFSSEC_MUST_NTLMV2	0x04004
 #define   CIFSSEC_MUST_KRB5	0x08008
 #ifdef CONFIG_CIFS_UPCALL
-#define   CIFSSEC_MASK          0x8F08F /* flags supported if no weak allowed */
+#define   CIFSSEC_MASK          0xCF0CF /* flags supported if no weak allowed */
 #else
-#define	  CIFSSEC_MASK          0x87087 /* flags supported if no weak allowed */
+#define	  CIFSSEC_MASK          0xC70C7 /* flags supported if no weak allowed */
 #endif /* UPCALL */
-#define   CIFSSEC_MUST_SEAL	0x40040 /* not supported yet */
+#define   CIFSSEC_MUST_SEAL	0x40040
 #define   CIFSSEC_MUST_NTLMSSP	0x80080 /* raw ntlmssp with ntlmv2 */
 
 #define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP | CIFSSEC_MAY_SEAL)
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -80,6 +80,9 @@ int smb3_encryption_required(const struc
 	if (tcon->seal &&
 	    (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
 		return 1;
+	if (((global_secflags & CIFSSEC_MUST_SEAL) == CIFSSEC_MUST_SEAL) &&
+	    (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
+		return 1;
 	return 0;
 }
 


