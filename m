Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284EE47F47;
	Wed, 20 Dec 2023 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfxqU0Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ECFC433C7;
	Wed, 20 Dec 2023 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088689;
	bh=Bt2WSSBrqI1UIRo3y+M6yFdsmFwrPkSmUNfP+ttU2Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfxqU0YzFi7u2GvB6mfw99DeULYB1JZIAAE9XNIIT12FG1r1ARFB6s/r2QNf3a8/B
	 7ZQvEqkj5ZTMnqeq8uHBi9LfZiU+LIN+ANhEX+i5Bsxc99Vhbe8GRNfs2kcxy54CKa
	 LggUuFOTw7A1IcS3YbleAKZowXl8T1WwYLLXitkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 022/159] ksmbd: smbd: fix missing clients memory region invalidation
Date: Wed, 20 Dec 2023 17:08:07 +0100
Message-ID: <20231220160932.307506902@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 2fd5dcb1c8ef96c9f0fa8bda53ca480524b80ae7 ]

if the Channel of a SMB2 WRITE request is
SMB2_CHANNEL_RDMA_V1_INVALIDTE, a client
does not invalidate its memory regions but
ksmbd must do it by sending a SMB2 WRITE response
with IB_WR_SEND_WITH_INV.

But if errors occur while processing a SMB2
READ/WRITE request, ksmbd sends a response
with IB_WR_SEND. So a client could use memory
regions already in use.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   71 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 26 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6203,25 +6203,33 @@ out:
 	return err;
 }
 
-static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
-				      struct smb2_read_req *req, void *data_buf,
-				      size_t length)
+static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
+					struct smb2_buffer_desc_v1 *desc,
+					__le32 Channel,
+					__le16 ChannelInfoOffset,
+					__le16 ChannelInfoLength)
 {
-	struct smb2_buffer_desc_v1 *desc =
-		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
-	int err;
-
 	if (work->conn->dialect == SMB30_PROT_ID &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1)
+	    Channel != SMB2_CHANNEL_RDMA_V1)
 		return -EINVAL;
 
-	if (req->ReadChannelInfoOffset == 0 ||
-	    le16_to_cpu(req->ReadChannelInfoLength) < sizeof(*desc))
+	if (ChannelInfoOffset == 0 ||
+	    le16_to_cpu(ChannelInfoLength) < sizeof(*desc))
 		return -EINVAL;
 
 	work->need_invalidate_rkey =
-		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
+		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
 	work->remote_key = le32_to_cpu(desc->token);
+	return 0;
+}
+
+static ssize_t smb2_read_rdma_channel(struct ksmbd_work *work,
+				      struct smb2_read_req *req, void *data_buf,
+				      size_t length)
+{
+	struct smb2_buffer_desc_v1 *desc =
+		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
+	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
 				    le32_to_cpu(desc->token),
@@ -6263,6 +6271,18 @@ int smb2_read(struct ksmbd_work *work)
 		return smb2_read_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		err = smb2_set_remote_key_for_rdma(work,
+						   (struct smb2_buffer_desc_v1 *)
+						   &req->Buffer[0],
+						   req->Channel,
+						   req->ReadChannelInfoOffset,
+						   req->ReadChannelInfoLength);
+		if (err)
+			goto out;
+	}
+
 	fp = ksmbd_lookup_fd_slow(work, le64_to_cpu(req->VolatileFileId),
 				  le64_to_cpu(req->PersistentFileId));
 	if (!fp) {
@@ -6448,21 +6468,6 @@ static ssize_t smb2_write_rdma_channel(s
 
 	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 
-	if (work->conn->dialect == SMB30_PROT_ID &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1)
-		return -EINVAL;
-
-	if (req->Length != 0 || req->DataOffset != 0)
-		return -EINVAL;
-
-	if (req->WriteChannelInfoOffset == 0 ||
-	    le16_to_cpu(req->WriteChannelInfoLength) < sizeof(*desc))
-		return -EINVAL;
-
-	work->need_invalidate_rkey =
-		(req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
-	work->remote_key = le32_to_cpu(desc->token);
-
 	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
 	if (!data_buf)
 		return -ENOMEM;
@@ -6509,6 +6514,20 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
+	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
+	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		if (req->Length != 0 || req->DataOffset != 0)
+			return -EINVAL;
+		err = smb2_set_remote_key_for_rdma(work,
+						   (struct smb2_buffer_desc_v1 *)
+						   &req->Buffer[0],
+						   req->Channel,
+						   req->WriteChannelInfoOffset,
+						   req->WriteChannelInfoLength);
+		if (err)
+			goto out;
+	}
+
 	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		ksmbd_debug(SMB, "User does not have write permission\n");
 		err = -EACCES;


