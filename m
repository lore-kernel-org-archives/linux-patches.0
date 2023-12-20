Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D701482F0;
	Wed, 20 Dec 2023 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlVe0m+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFDFC433C8;
	Wed, 20 Dec 2023 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088730;
	bh=yVHPHYaPdtoRlTZAt1MxyI8hs3sSoFm+p+B0W7myjps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlVe0m+z8wZANeBD1+XQ1W1Wh0y4Z4MHnmQSl1FNWASEvFIUh5knQExfQsQve5NgX
	 4ir07xoJi/Pf5AuN2/NakM8Q4ZZBcQR8zWMVFZiqs2FTA76wTZTHPn6sDvMnN+HPLN
	 EYftzdfRP3rm8STxmjz3a4kwv4T8YQ53W4DJS7Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 038/159] ksmbd: fix wrong smbd max read/write size check
Date: Wed, 20 Dec 2023 17:08:23 +0100
Message-ID: <20231220160933.073629860@linuxfoundation.org>
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

[ Upstream commit 7a84399e1ce3f5f2fbec3e7dd93459ba25badc2f ]

smb-direct max read/write size can be different with smb2 max read/write
size. So smb2_read() can return error by wrong max read/write size check.
This patch use smb_direct_max_read_write_size for this check in
smb-direct read/write().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c        |   39 +++++++++++++++++++++++++--------------
 fs/ksmbd/transport_rdma.c |    5 +++++
 fs/ksmbd/transport_rdma.h |    2 ++
 3 files changed, 32 insertions(+), 14 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6252,6 +6252,8 @@ int smb2_read(struct ksmbd_work *work)
 	size_t length, mincount;
 	ssize_t nbytes = 0, remain_bytes = 0;
 	int err = 0;
+	bool is_rdma_channel = false;
+	unsigned int max_read_size = conn->vals->max_read_size;
 
 	WORK_BUFFERS(work, req, rsp);
 	if (work->next_smb2_rcv_hdr_off) {
@@ -6268,6 +6270,11 @@ int smb2_read(struct ksmbd_work *work)
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+		is_rdma_channel = true;
+		max_read_size = get_smbd_max_read_write_size();
+	}
+
+	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->ReadChannelInfoOffset);
 
 		if (ch_offset < offsetof(struct smb2_read_req, Buffer)) {
@@ -6299,9 +6306,9 @@ int smb2_read(struct ksmbd_work *work)
 	length = le32_to_cpu(req->Length);
 	mincount = le32_to_cpu(req->MinimumCount);
 
-	if (length > conn->vals->max_read_size) {
+	if (length > max_read_size) {
 		ksmbd_debug(SMB, "limiting read size to max size(%u)\n",
-			    conn->vals->max_read_size);
+			    max_read_size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -6333,8 +6340,7 @@ int smb2_read(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
 		    nbytes, offset, mincount);
 
-	if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
-	    req->Channel == SMB2_CHANNEL_RDMA_V1) {
+	if (is_rdma_channel == true) {
 		/* write data to the client using rdma channel */
 		remain_bytes = smb2_read_rdma_channel(work, req,
 						      work->aux_payload_buf,
@@ -6495,8 +6501,9 @@ int smb2_write(struct ksmbd_work *work)
 	size_t length;
 	ssize_t nbytes;
 	char *data_buf;
-	bool writethrough = false;
+	bool writethrough = false, is_rdma_channel = false;
 	int err = 0;
+	unsigned int max_write_size = work->conn->vals->max_write_size;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -6505,8 +6512,17 @@ int smb2_write(struct ksmbd_work *work)
 		return smb2_write_pipe(work);
 	}
 
+	offset = le64_to_cpu(req->Offset);
+	length = le32_to_cpu(req->Length);
+
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||
 	    req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+		is_rdma_channel = true;
+		max_write_size = get_smbd_max_read_write_size();
+		length = le32_to_cpu(req->RemainingBytes);
+	}
+
+	if (is_rdma_channel == true) {
 		unsigned int ch_offset = le16_to_cpu(req->WriteChannelInfoOffset);
 
 		if (req->Length != 0 || req->DataOffset != 0 ||
@@ -6541,12 +6557,9 @@ int smb2_write(struct ksmbd_work *work)
 		goto out;
 	}
 
-	offset = le64_to_cpu(req->Offset);
-	length = le32_to_cpu(req->Length);
-
-	if (length > work->conn->vals->max_write_size) {
+	if (length > max_write_size) {
 		ksmbd_debug(SMB, "limiting write size to max size(%u)\n",
-			    work->conn->vals->max_write_size);
+			    max_write_size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -6554,8 +6567,7 @@ int smb2_write(struct ksmbd_work *work)
 	if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
 		writethrough = true;
 
-	if (req->Channel != SMB2_CHANNEL_RDMA_V1 &&
-	    req->Channel != SMB2_CHANNEL_RDMA_V1_INVALIDATE) {
+	if (is_rdma_channel == false) {
 		if (le16_to_cpu(req->DataOffset) <
 		    offsetof(struct smb2_write_req, Buffer)) {
 			err = -EINVAL;
@@ -6579,8 +6591,7 @@ int smb2_write(struct ksmbd_work *work)
 		/* read data from the client using rdma channel, and
 		 * write the data.
 		 */
-		nbytes = smb2_write_rdma_channel(work, req, fp, offset,
-						 le32_to_cpu(req->RemainingBytes),
+		nbytes = smb2_write_rdma_channel(work, req, fp, offset, length,
 						 writethrough);
 		if (nbytes < 0) {
 			err = (int)nbytes;
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -220,6 +220,11 @@ void init_smbd_max_io_size(unsigned int
 	smb_direct_max_read_write_size = sz;
 }
 
+unsigned int get_smbd_max_read_write_size(void)
+{
+	return smb_direct_max_read_write_size;
+}
+
 static inline int get_buf_page_count(void *buf, int size)
 {
 	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -57,11 +57,13 @@ int ksmbd_rdma_init(void);
 void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 void init_smbd_max_io_size(unsigned int sz);
+unsigned int get_smbd_max_read_write_size(void);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline int ksmbd_rdma_destroy(void) { return 0; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
 static inline void init_smbd_max_io_size(unsigned int sz) { }
+static inline unsigned int get_smbd_max_read_write_size(void) { return 0; }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */


