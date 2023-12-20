Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C146448;
	Wed, 20 Dec 2023 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws1Vmz/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BA1C433C7;
	Wed, 20 Dec 2023 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088887;
	bh=dxR665H3SHIR3fjTtRFOy/i6WIlzQ7kfioKKfKqlz8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ws1Vmz/cwUWli+02+ZZWDaKc3Z0vuqDXOiJGPLQs0ELagsN19vPxMTgmuyJXXlp3a
	 FutwcSohcVJ4WOiU5aPa27lPJ0ZWSmVgpOQS6Lmfssflb1h2Amlk4YKY7l47rFa7h4
	 1YS518XQ/8SiSWJYhOZbcqdMcejlBMUhRiqxM+0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 065/159] ksmbd: set SMB2_SESSION_FLAG_ENCRYPT_DATA when enforcing data encryption for this share
Date: Wed, 20 Dec 2023 17:08:50 +0100
Message-ID: <20231220160934.400788378@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 37ba7b005a7a4454046bd8659c7a9c5330552396 ]

Currently, SMB2_SESSION_FLAG_ENCRYPT_DATA is always set session setup
response. Since this forces data encryption from the client, there is a
problem that data is always encrypted regardless of the use of the cifs
seal mount option. SMB2_SESSION_FLAG_ENCRYPT_DATA should be set according
to KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION flags, and in case of
KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF, encryption mode is turned off for
all connections.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ksmbd_netlink.h |    1 +
 fs/ksmbd/smb2ops.c       |   10 ++++++++--
 fs/ksmbd/smb2pdu.c       |    8 +++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -74,6 +74,7 @@ struct ksmbd_heartbeat {
 #define KSMBD_GLOBAL_FLAG_SMB2_LEASES		BIT(0)
 #define KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION	BIT(1)
 #define KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL	BIT(2)
+#define KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF	BIT(3)
 
 /*
  * IPC request for ksmbd server startup
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -248,8 +248,9 @@ void init_smb3_02_server(struct ksmbd_co
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
 
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION &&
-	    conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION)
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
+	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
+	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
@@ -272,6 +273,11 @@ int init_smb3_11_server(struct ksmbd_con
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
 
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
+	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
+	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
+		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
+
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -934,7 +934,7 @@ static void decode_encrypt_ctxt(struct k
 		return;
 	}
 
-	if (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION))
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF)
 		return;
 
 	for (i = 0; i < cph_cnt; i++) {
@@ -1538,7 +1538,8 @@ static int ntlm_authenticate(struct ksmb
 			return -EINVAL;
 		}
 		sess->enc = true;
-		rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
 		/*
 		 * signing is disable if encryption is enable
 		 * on this session
@@ -1629,7 +1630,8 @@ static int krb5_authenticate(struct ksmb
 			return -EINVAL;
 		}
 		sess->enc = true;
-		rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
+		if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION)
+			rsp->SessionFlags = SMB2_SESSION_FLAG_ENCRYPT_DATA_LE;
 		sess->sign = false;
 	}
 


