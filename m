Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3176E49F91;
	Wed, 20 Dec 2023 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9CpKN1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1D0C433C8;
	Wed, 20 Dec 2023 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088711;
	bh=WUbydB37wN68P+T3n4xj81VGA9nmhF9KjB5S5T2/OzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9CpKN1VDHsMOvQTuV6daS2Zn0Eug1BRf9HhYgL5l0EczUb5XklE4GynQQHCfH5o9
	 Vp6gdIhVRm1iKWstZp8GpPufQ+ZTGKA+P/dWypkasXfdWiLEnKt0NvYW8YkU+HDX5n
	 ndvGexi8lxlMzi9sR1Dmh0if5LM5BqqmHdLfywZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 006/159] ksmbd: remove smb2_buf_length in smb2_transform_hdr
Date: Wed, 20 Dec 2023 17:07:51 +0100
Message-ID: <20231220160931.578901707@linuxfoundation.org>
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

[ Upstream commit 2dd9129f7dec1de369e4447a54ea2edf695f765b ]

To move smb2_transform_hdr to smbfs_common, This patch remove
smb2_buf_length variable in smb2_transform_hdr.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/auth.c       |    7 +++----
 fs/ksmbd/connection.c |    2 +-
 fs/ksmbd/smb2pdu.c    |   37 +++++++++++++++++--------------------
 fs/ksmbd/smb2pdu.h    |    5 -----
 4 files changed, 21 insertions(+), 30 deletions(-)

--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -994,7 +994,7 @@ static struct scatterlist *ksmbd_init_sg
 					 u8 *sign)
 {
 	struct scatterlist *sg;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int i, nr_entries[3] = {0}, total_entries = 0, sg_idx = 0;
 
 	if (!nvec)
@@ -1058,9 +1058,8 @@ static struct scatterlist *ksmbd_init_sg
 int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
 			unsigned int nvec, int enc)
 {
-	struct smb2_transform_hdr *tr_hdr =
-		(struct smb2_transform_hdr *)iov[0].iov_base;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
+	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(iov[0].iov_base);
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -173,7 +173,7 @@ int ksmbd_conn_write(struct ksmbd_work *
 
 	if (work->tr_buf) {
 		iov[iov_idx] = (struct kvec) { work->tr_buf,
-				sizeof(struct smb2_transform_hdr) };
+				sizeof(struct smb2_transform_hdr) + 4 };
 		len += iov[iov_idx++].iov_len;
 	}
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8572,13 +8572,13 @@ void smb3_preauth_hash_rsp(struct ksmbd_
 	}
 }
 
-static void fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, char *old_buf,
-			       __le16 cipher_type)
+static void fill_transform_hdr(void *tr_buf, char *old_buf, __le16 cipher_type)
 {
-	struct smb2_hdr *hdr = (struct smb2_hdr *)old_buf;
+	struct smb2_transform_hdr *tr_hdr = tr_buf + 4;
+	struct smb2_hdr *hdr = smb2_get_msg(old_buf);
 	unsigned int orig_len = get_rfc1002_len(old_buf);
 
-	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
+	memset(tr_buf, 0, sizeof(struct smb2_transform_hdr) + 4);
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
 	tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
 	tr_hdr->Flags = cpu_to_le16(0x01);
@@ -8588,14 +8588,13 @@ static void fill_transform_hdr(struct sm
 	else
 		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
 	memcpy(&tr_hdr->SessionId, &hdr->SessionId, 8);
-	inc_rfc1001_len(tr_hdr, sizeof(struct smb2_transform_hdr) - 4);
-	inc_rfc1001_len(tr_hdr, orig_len);
+	inc_rfc1001_len(tr_buf, sizeof(struct smb2_transform_hdr));
+	inc_rfc1001_len(tr_buf, orig_len);
 }
 
 int smb3_encrypt_resp(struct ksmbd_work *work)
 {
 	char *buf = work->response_buf;
-	struct smb2_transform_hdr *tr_hdr;
 	struct kvec iov[3];
 	int rc = -ENOMEM;
 	int buf_size = 0, rq_nvec = 2 + (work->aux_payload_sz ? 1 : 0);
@@ -8603,15 +8602,15 @@ int smb3_encrypt_resp(struct ksmbd_work
 	if (ARRAY_SIZE(iov) < rq_nvec)
 		return -ENOMEM;
 
-	tr_hdr = kzalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
-	if (!tr_hdr)
+	work->tr_buf = kzalloc(sizeof(struct smb2_transform_hdr) + 4, GFP_KERNEL);
+	if (!work->tr_buf)
 		return rc;
 
 	/* fill transform header */
-	fill_transform_hdr(tr_hdr, buf, work->conn->cipher_type);
+	fill_transform_hdr(work->tr_buf, buf, work->conn->cipher_type);
 
-	iov[0].iov_base = tr_hdr;
-	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
+	iov[0].iov_base = work->tr_buf;
+	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
 	buf_size += iov[0].iov_len - 4;
 
 	iov[1].iov_base = buf + 4;
@@ -8631,15 +8630,14 @@ int smb3_encrypt_resp(struct ksmbd_work
 		return rc;
 
 	memmove(buf, iov[1].iov_base, iov[1].iov_len);
-	tr_hdr->smb2_buf_length = cpu_to_be32(buf_size);
-	work->tr_buf = tr_hdr;
+	*(__be32 *)work->tr_buf = cpu_to_be32(buf_size);
 
 	return rc;
 }
 
 bool smb3_is_transform_hdr(void *buf)
 {
-	struct smb2_transform_hdr *trhdr = buf;
+	struct smb2_transform_hdr *trhdr = smb2_get_msg(buf);
 
 	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
 }
@@ -8651,9 +8649,8 @@ int smb3_decrypt_req(struct ksmbd_work *
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
 	struct kvec iov[2];
-	int buf_data_size = pdu_length + 4 -
-		sizeof(struct smb2_transform_hdr);
-	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
+	int buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
+	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(buf);
 	int rc = 0;
 
 	if (pdu_length < sizeof(struct smb2_transform_hdr) ||
@@ -8676,8 +8673,8 @@ int smb3_decrypt_req(struct ksmbd_work *
 	}
 
 	iov[0].iov_base = buf;
-	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
-	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
+	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
+	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr) + 4;
 	iov[1].iov_len = buf_data_size;
 	rc = ksmbd_crypt_message(conn, iov, 2, 0);
 	if (rc)
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -160,11 +160,6 @@ struct smb2_pdu {
 #define SMB3_AES_GCM_NONCE 12
 
 struct smb2_transform_hdr {
-	__be32 smb2_buf_length; /* big endian on wire */
-	/*
-	 * length is only two or three bytes - with
-	 * one or two byte type preceding it that MBZ
-	 */
 	__le32 ProtocolId;      /* 0xFD 'S' 'M' 'B' */
 	__u8   Signature[16];
 	__u8   Nonce[16];


