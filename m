Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E424914A604;
	Thu, 23 May 2024 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470559; cv=none; b=Qi1uA5lt4ccmhe4CWcvs8koyE8j4MmTEozRR4UZ8wOMWI/+RLD3+Xaq8u7peLL9auMB5WttJbbeGdF6NXZ6SIuLEsijHkFFy3Sd3iri0GR1uLRfokqA2zgbXRm+A1iL8HSs6lJxKaPzvS0eGxveTHa/N4fucg85EpIva/Ixct3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470559; c=relaxed/simple;
	bh=d97sStexVFxvz+QxbSd2aaXF/jqvzVQ9BLcv0APztKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4w/hji+q5yMtYzaLp0uruQ2Aqoumh/2sXJ0GViW4uox7JTTBuKEJHW6BrV4epX30W3vAK68a4QKTMajK0lX2f4JysoHDh7OPaT/V2rFXr+FIKyUKC2+kO/39gEz2LbJRPiW9dZetghjJIOJZNmhwAPqRzFqkNj03i+2oRXhULs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEZOgw01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEZOgw01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C048C2BD10;
	Thu, 23 May 2024 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470558;
	bh=d97sStexVFxvz+QxbSd2aaXF/jqvzVQ9BLcv0APztKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEZOgw01SO4O6IpbrEhkjPY++ASAoGeeyGYOZFbgj3iFdQrN01gEgmDvxK2TbJ5d0
	 pN0c8wynySDQk5AYQulk3xaxYWRP3lZW5yraPJB5kNkzFpTEDMO5k23EhbZg5fQVMT
	 gil/O5DmOi1sENCuIQPQVv4ZyfIpdh8Z6biEqldY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/102] cifs: Add client version details to NTLM authenticate message
Date: Thu, 23 May 2024 15:12:26 +0200
Message-ID: <20240523130342.520134047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Meetakshi Setiya <msetiya@microsoft.com>

[ Upstream commit 1460720c5913c11415e4d7c4df5a287eb2ad3f3e ]

The NTLM authenticate message currently sets the NTLMSSP_NEGOTIATE_VERSION
flag but does not populate the VERSION structure. This commit fixes this
bug by ensuring that the flag is set and the version details are included
in the message.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/ntlmssp.h |  4 ++--
 fs/smb/client/sess.c    | 12 +++++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/ntlmssp.h b/fs/smb/client/ntlmssp.h
index 2c5dde2ece588..875de43b72de3 100644
--- a/fs/smb/client/ntlmssp.h
+++ b/fs/smb/client/ntlmssp.h
@@ -133,8 +133,8 @@ typedef struct _AUTHENTICATE_MESSAGE {
 	SECURITY_BUFFER WorkstationName;
 	SECURITY_BUFFER SessionKey;
 	__le32 NegotiateFlags;
-	/* SECURITY_BUFFER for version info not present since we
-	   do not set the version is present flag */
+	struct	ntlmssp_version Version;
+	/* SECURITY_BUFFER */
 	char UserString[];
 } __attribute__((packed)) AUTHENTICATE_MESSAGE, *PAUTHENTICATE_MESSAGE;
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index e4168cd8b6c28..bd4dcd1a9af83 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1201,10 +1201,16 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
 	memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
 	sec_blob->MessageType = NtLmAuthenticate;
 
+	/* send version information in ntlmssp authenticate also */
 	flags = ses->ntlmssp->server_flags | NTLMSSP_REQUEST_TARGET |
-		NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_WORKSTATION_SUPPLIED;
-	/* we only send version information in ntlmssp negotiate, so do not set this flag */
-	flags = flags & ~NTLMSSP_NEGOTIATE_VERSION;
+		NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_VERSION |
+		NTLMSSP_NEGOTIATE_WORKSTATION_SUPPLIED;
+
+	sec_blob->Version.ProductMajorVersion = LINUX_VERSION_MAJOR;
+	sec_blob->Version.ProductMinorVersion = LINUX_VERSION_PATCHLEVEL;
+	sec_blob->Version.ProductBuild = cpu_to_le16(SMB3_PRODUCT_BUILD);
+	sec_blob->Version.NTLMRevisionCurrent = NTLMSSP_REVISION_W2K3;
+
 	tmp = *pbuffer + sizeof(AUTHENTICATE_MESSAGE);
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
 
-- 
2.43.0



