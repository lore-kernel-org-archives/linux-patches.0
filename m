Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBDA482E9;
	Wed, 20 Dec 2023 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQPvrOFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF7BC433C8;
	Wed, 20 Dec 2023 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088713;
	bh=CmkxIncAdiqaX6TuLwuv2/RvupettdyM+avLjcomvjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQPvrOFL0Y9EJH7ke+Z+g+N8Z6Lea5nHXdWqMeB4x2/+zgCSmfehmeTkC3hTt3IlC
	 FyvWAAW8sGbQ3O8wZPF6XOma3mcHPLWe4t0HeVIIzmqcUk69+Ahp7YWyPIJUpZ0BBo
	 aXD/BFh0EzGtI6u2WXH1KPLAuwANZ9CqwEQJ5gJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 007/159] ksmbd: change LeaseKey data type to u8 array
Date: Wed, 20 Dec 2023 17:07:52 +0100
Message-ID: <20231220160931.627868951@linuxfoundation.org>
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

[ Upstream commit 2734b692f7b8167b93498dcd698067623d4267ca ]

cifs define LeaseKey as u8 array in structure. To move lease structure
to smbfs_common, ksmbd change LeaseKey data type to u8 array.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c  |   24 +++++++++---------------
 fs/ksmbd/oplock.h  |    2 --
 fs/ksmbd/smb2pdu.h |   11 +++++------
 3 files changed, 14 insertions(+), 23 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1336,19 +1336,16 @@ __u8 smb2_map_lease_to_oplock(__le32 lea
  */
 void create_lease_buf(u8 *rbuf, struct lease *lease)
 {
-	char *LeaseKey = (char *)&lease->lease_key;
-
 	if (lease->version == 2) {
 		struct create_lease_v2 *buf = (struct create_lease_v2 *)rbuf;
-		char *ParentLeaseKey = (char *)&lease->parent_lease_key;
 
 		memset(buf, 0, sizeof(struct create_lease_v2));
-		buf->lcontext.LeaseKeyLow = *((__le64 *)LeaseKey);
-		buf->lcontext.LeaseKeyHigh = *((__le64 *)(LeaseKey + 8));
+		memcpy(buf->lcontext.LeaseKey, lease->lease_key,
+		       SMB2_LEASE_KEY_SIZE);
 		buf->lcontext.LeaseFlags = lease->flags;
 		buf->lcontext.LeaseState = lease->state;
-		buf->lcontext.ParentLeaseKeyLow = *((__le64 *)ParentLeaseKey);
-		buf->lcontext.ParentLeaseKeyHigh = *((__le64 *)(ParentLeaseKey + 8));
+		memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
+		       SMB2_LEASE_KEY_SIZE);
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
 				(struct create_lease_v2, lcontext));
 		buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context_v2));
@@ -1363,8 +1360,7 @@ void create_lease_buf(u8 *rbuf, struct l
 		struct create_lease *buf = (struct create_lease *)rbuf;
 
 		memset(buf, 0, sizeof(struct create_lease));
-		buf->lcontext.LeaseKeyLow = *((__le64 *)LeaseKey);
-		buf->lcontext.LeaseKeyHigh = *((__le64 *)(LeaseKey + 8));
+		memcpy(buf->lcontext.LeaseKey, lease->lease_key, SMB2_LEASE_KEY_SIZE);
 		buf->lcontext.LeaseFlags = lease->flags;
 		buf->lcontext.LeaseState = lease->state;
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
@@ -1417,19 +1413,17 @@ struct lease_ctx_info *parse_lease_state
 		if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
 			struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
-			*((__le64 *)lreq->lease_key) = lc->lcontext.LeaseKeyLow;
-			*((__le64 *)(lreq->lease_key + 8)) = lc->lcontext.LeaseKeyHigh;
+			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 			lreq->req_state = lc->lcontext.LeaseState;
 			lreq->flags = lc->lcontext.LeaseFlags;
 			lreq->duration = lc->lcontext.LeaseDuration;
-			*((__le64 *)lreq->parent_lease_key) = lc->lcontext.ParentLeaseKeyLow;
-			*((__le64 *)(lreq->parent_lease_key + 8)) = lc->lcontext.ParentLeaseKeyHigh;
+			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
+			       SMB2_LEASE_KEY_SIZE);
 			lreq->version = 2;
 		} else {
 			struct create_lease *lc = (struct create_lease *)cc;
 
-			*((__le64 *)lreq->lease_key) = lc->lcontext.LeaseKeyLow;
-			*((__le64 *)(lreq->lease_key + 8)) = lc->lcontext.LeaseKeyHigh;
+			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 			lreq->req_state = lc->lcontext.LeaseState;
 			lreq->flags = lc->lcontext.LeaseFlags;
 			lreq->duration = lc->lcontext.LeaseDuration;
--- a/fs/ksmbd/oplock.h
+++ b/fs/ksmbd/oplock.h
@@ -28,8 +28,6 @@
 #define OPLOCK_WRITE_TO_NONE		0x04
 #define OPLOCK_READ_TO_NONE		0x08
 
-#define SMB2_LEASE_KEY_SIZE		16
-
 struct lease_ctx_info {
 	__u8			lease_key[SMB2_LEASE_KEY_SIZE];
 	__le32			req_state;
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -734,22 +734,21 @@ struct create_posix_rsp {
 
 #define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE	cpu_to_le32(0x02)
 
+#define SMB2_LEASE_KEY_SIZE			16
+
 struct lease_context {
-	__le64 LeaseKeyLow;
-	__le64 LeaseKeyHigh;
+	__u8 LeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le32 LeaseState;
 	__le32 LeaseFlags;
 	__le64 LeaseDuration;
 } __packed;
 
 struct lease_context_v2 {
-	__le64 LeaseKeyLow;
-	__le64 LeaseKeyHigh;
+	__u8 LeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le32 LeaseState;
 	__le32 LeaseFlags;
 	__le64 LeaseDuration;
-	__le64 ParentLeaseKeyLow;
-	__le64 ParentLeaseKeyHigh;
+	__u8 ParentLeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le16 Epoch;
 	__le16 Reserved;
 } __packed;


