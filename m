Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F9A18757D;
	Mon, 12 Aug 2024 16:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479061; cv=none; b=cLXlTa5ap2tdMArlhorcaW6KX4SodBYJZgbObr+QXLKOCYJwMYKU/+7OgDdCzEcRKh21Ym9UMaYQOoKnkqUUJ5YKFs1CqUIvJY9hu8FAUH5vxhkJAKqTYDcNPBZTNJhebdNNyHcJ8D6uKN0I02cUyb37zo8of9R/sU9HytPfWSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479061; c=relaxed/simple;
	bh=e7FTtHVh51ToS6J/CgaAPnQ+TOj1ExVltDqjrZ9UrkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uT+fsrGKtpLkjRwTxGjhgyFprBxXL3uyxrtoPTA+8qtYppVX9vYaq98IdxyXaqV/bQfYQRJEjn23R0p6hKhsEEa70axwRrXAgc5Gg9Uk7pJGcZes9sOtW5xz+kEDwljTjDgjbCiEranR4E45Hsx+wk/IEn73QxPryHp457Y+5r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+WyYzAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+WyYzAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAFBC32782;
	Mon, 12 Aug 2024 16:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479061;
	bh=e7FTtHVh51ToS6J/CgaAPnQ+TOj1ExVltDqjrZ9UrkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+WyYzAongToHAdetfYtrR3LyttEIgDLb4WwS2lV8kyYY2iK9n6CLMMMGJ5on9+UF
	 ASk7200jqAtEXkUr8NoQBZjzk5g7uqpC7JA4g5ZPo/dBORKEboZx4u/P/QxBFbGqiv
	 BSbpfUi9Rk62qZwT/3ezqg0TWfaWNIt0EQvk2a4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 119/150] smb3: fix setting SecurityFlags when encryption is required
Date: Mon, 12 Aug 2024 18:03:20 +0200
Message-ID: <20240812160129.754630190@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -960,7 +960,7 @@ static int cifs_security_flags_proc_open
 static void
 cifs_security_flags_handle_must_flags(unsigned int *flags)
 {
-	unsigned int signflags = *flags & CIFSSEC_MUST_SIGN;
+	unsigned int signflags = *flags & (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL);
 
 	if ((*flags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
 		*flags = CIFSSEC_MUST_KRB5;
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1820,7 +1820,7 @@ static inline bool is_retryable_error(in
 #define   CIFSSEC_MAY_SIGN	0x00001
 #define   CIFSSEC_MAY_NTLMV2	0x00004
 #define   CIFSSEC_MAY_KRB5	0x00008
-#define   CIFSSEC_MAY_SEAL	0x00040 /* not supported yet */
+#define   CIFSSEC_MAY_SEAL	0x00040
 #define   CIFSSEC_MAY_NTLMSSP	0x00080 /* raw ntlmssp with ntlmv2 */
 
 #define   CIFSSEC_MUST_SIGN	0x01001
@@ -1830,11 +1830,11 @@ require use of the stronger protocol */
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
 


