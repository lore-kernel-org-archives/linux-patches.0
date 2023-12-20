Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D12482F8;
	Wed, 20 Dec 2023 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewaO2Ns7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F4CC433C8;
	Wed, 20 Dec 2023 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088798;
	bh=VyjR1efKzSeGbteHwwX5uWtn6fOp848Oo9XW7hSTsSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewaO2Ns7Kecl6h9qgcTOprQvkUurrX9fny1F+MDNsslPG7qRy9rF0nEo02c7sJTb9
	 h/PZYuf4S697wZDvIXUSP8bMikqsfZWeSFSZOdyAzWStMRU81KnFlEwArtZgHduqYV
	 1DXEsBKMScgY0XkfzuzOgy9rHjsr1A5mEFLN0Dlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 033/159] ksmbd: smbd: change prototypes of RDMA read/write related functions
Date: Wed, 20 Dec 2023 17:08:18 +0100
Message-ID: <20231220160932.831363995@linuxfoundation.org>
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

[ Upstream commit 1807abcf8778bcbbf584fe54da9ccbe9029c49bb ]

Change the prototypes of RDMA read/write
operations to accept a pointer and length
of buffer descriptors.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c     |   20 ++++++++++----------
 fs/ksmbd/connection.h     |   27 ++++++++++++++++-----------
 fs/ksmbd/smb2pdu.c        |   23 ++++++++---------------
 fs/ksmbd/transport_rdma.c |   30 +++++++++++++++++-------------
 4 files changed, 51 insertions(+), 49 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -206,31 +206,31 @@ int ksmbd_conn_write(struct ksmbd_work *
 	return 0;
 }
 
-int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
-			 unsigned int buflen, u32 remote_key, u64 remote_offset,
-			 u32 remote_len)
+int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
+			 void *buf, unsigned int buflen,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len)
 {
 	int ret = -EINVAL;
 
 	if (conn->transport->ops->rdma_read)
 		ret = conn->transport->ops->rdma_read(conn->transport,
 						      buf, buflen,
-						      remote_key, remote_offset,
-						      remote_len);
+						      desc, desc_len);
 	return ret;
 }
 
-int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
-			  unsigned int buflen, u32 remote_key,
-			  u64 remote_offset, u32 remote_len)
+int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
+			  void *buf, unsigned int buflen,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len)
 {
 	int ret = -EINVAL;
 
 	if (conn->transport->ops->rdma_write)
 		ret = conn->transport->ops->rdma_write(conn->transport,
 						       buf, buflen,
-						       remote_key, remote_offset,
-						       remote_len);
+						       desc, desc_len);
 	return ret;
 }
 
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -116,11 +116,14 @@ struct ksmbd_transport_ops {
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
 		      int size, bool need_invalidate_rkey,
 		      unsigned int remote_key);
-	int (*rdma_read)(struct ksmbd_transport *t, void *buf, unsigned int len,
-			 u32 remote_key, u64 remote_offset, u32 remote_len);
-	int (*rdma_write)(struct ksmbd_transport *t, void *buf,
-			  unsigned int len, u32 remote_key, u64 remote_offset,
-			  u32 remote_len);
+	int (*rdma_read)(struct ksmbd_transport *t,
+			 void *buf, unsigned int len,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len);
+	int (*rdma_write)(struct ksmbd_transport *t,
+			  void *buf, unsigned int len,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len);
 };
 
 struct ksmbd_transport {
@@ -142,12 +145,14 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
-int ksmbd_conn_rdma_read(struct ksmbd_conn *conn, void *buf,
-			 unsigned int buflen, u32 remote_key, u64 remote_offset,
-			 u32 remote_len);
-int ksmbd_conn_rdma_write(struct ksmbd_conn *conn, void *buf,
-			  unsigned int buflen, u32 remote_key, u64 remote_offset,
-			  u32 remote_len);
+int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
+			 void *buf, unsigned int buflen,
+			 struct smb2_buffer_desc_v1 *desc,
+			 unsigned int desc_len);
+int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
+			  void *buf, unsigned int buflen,
+			  struct smb2_buffer_desc_v1 *desc,
+			  unsigned int desc_len);
 void ksmbd_conn_enqueue_request(struct ksmbd_work *work);
 int ksmbd_conn_try_dequeue_request(struct ksmbd_work *work);
 void ksmbd_conn_init_server_callbacks(struct ksmbd_conn_ops *ops);
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6193,7 +6193,6 @@ out:
 static int smb2_set_remote_key_for_rdma(struct ksmbd_work *work,
 					struct smb2_buffer_desc_v1 *desc,
 					__le32 Channel,
-					__le16 ChannelInfoOffset,
 					__le16 ChannelInfoLength)
 {
 	unsigned int i, ch_count;
@@ -6219,7 +6218,8 @@ static int smb2_set_remote_key_for_rdma(
 
 	work->need_invalidate_rkey =
 		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
-	work->remote_key = le32_to_cpu(desc->token);
+	if (Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE)
+		work->remote_key = le32_to_cpu(desc->token);
 	return 0;
 }
 
@@ -6227,14 +6227,12 @@ static ssize_t smb2_read_rdma_channel(st
 				      struct smb2_read_req *req, void *data_buf,
 				      size_t length)
 {
-	struct smb2_buffer_desc_v1 *desc =
-		(struct smb2_buffer_desc_v1 *)&req->Buffer[0];
 	int err;
 
 	err = ksmbd_conn_rdma_write(work->conn, data_buf, length,
-				    le32_to_cpu(desc->token),
-				    le64_to_cpu(desc->offset),
-				    le32_to_cpu(desc->length));
+				    (struct smb2_buffer_desc_v1 *)
+				    ((char *)req + le16_to_cpu(req->ReadChannelInfoOffset)),
+				    le16_to_cpu(req->ReadChannelInfoLength));
 	if (err)
 		return err;
 
@@ -6283,7 +6281,6 @@ int smb2_read(struct ksmbd_work *work)
 						   (struct smb2_buffer_desc_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
-						   req->ReadChannelInfoOffset,
 						   req->ReadChannelInfoLength);
 		if (err)
 			goto out;
@@ -6461,21 +6458,18 @@ static ssize_t smb2_write_rdma_channel(s
 				       struct ksmbd_file *fp,
 				       loff_t offset, size_t length, bool sync)
 {
-	struct smb2_buffer_desc_v1 *desc;
 	char *data_buf;
 	int ret;
 	ssize_t nbytes;
 
-	desc = (struct smb2_buffer_desc_v1 *)&req->Buffer[0];
-
 	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
 	if (!data_buf)
 		return -ENOMEM;
 
 	ret = ksmbd_conn_rdma_read(work->conn, data_buf, length,
-				   le32_to_cpu(desc->token),
-				   le64_to_cpu(desc->offset),
-				   le32_to_cpu(desc->length));
+				   (struct smb2_buffer_desc_v1 *)
+				   ((char *)req + le16_to_cpu(req->WriteChannelInfoOffset)),
+				   le16_to_cpu(req->WriteChannelInfoLength));
 	if (ret < 0) {
 		kvfree(data_buf);
 		return ret;
@@ -6527,7 +6521,6 @@ int smb2_write(struct ksmbd_work *work)
 						   (struct smb2_buffer_desc_v1 *)
 						   ((char *)req + ch_offset),
 						   req->Channel,
-						   req->WriteChannelInfoOffset,
 						   req->WriteChannelInfoLength);
 		if (err)
 			goto out;
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1357,14 +1357,18 @@ static void write_done(struct ib_cq *cq,
 	read_write_done(cq, wc, DMA_TO_DEVICE);
 }
 
-static int smb_direct_rdma_xmit(struct smb_direct_transport *t, void *buf,
-				int buf_len, u32 remote_key, u64 remote_offset,
-				u32 remote_len, bool is_read)
+static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
+				void *buf, int buf_len,
+				struct smb2_buffer_desc_v1 *desc,
+				unsigned int desc_len,
+				bool is_read)
 {
 	struct smb_direct_rdma_rw_msg *msg;
 	int ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct ib_send_wr *first_wr = NULL;
+	u32 remote_key = le32_to_cpu(desc[0].token);
+	u64 remote_offset = le64_to_cpu(desc[0].offset);
 
 	ret = wait_for_credits(t, &t->wait_rw_avail_ops, &t->rw_avail_ops);
 	if (ret < 0)
@@ -1429,22 +1433,22 @@ err:
 	return ret;
 }
 
-static int smb_direct_rdma_write(struct ksmbd_transport *t, void *buf,
-				 unsigned int buflen, u32 remote_key,
-				 u64 remote_offset, u32 remote_len)
+static int smb_direct_rdma_write(struct ksmbd_transport *t,
+				 void *buf, unsigned int buflen,
+				 struct smb2_buffer_desc_v1 *desc,
+				 unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-				    remote_key, remote_offset,
-				    remote_len, false);
+				    desc, desc_len, false);
 }
 
-static int smb_direct_rdma_read(struct ksmbd_transport *t, void *buf,
-				unsigned int buflen, u32 remote_key,
-				u64 remote_offset, u32 remote_len)
+static int smb_direct_rdma_read(struct ksmbd_transport *t,
+				void *buf, unsigned int buflen,
+				struct smb2_buffer_desc_v1 *desc,
+				unsigned int desc_len)
 {
 	return smb_direct_rdma_xmit(smb_trans_direct_transfort(t), buf, buflen,
-				    remote_key, remote_offset,
-				    remote_len, true);
+				    desc, desc_len, true);
 }
 
 static void smb_direct_disconnect(struct ksmbd_transport *t)


