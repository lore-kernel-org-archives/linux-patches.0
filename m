Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2614D114;
	Wed, 20 Dec 2023 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lstWtp5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AB5C433CB;
	Wed, 20 Dec 2023 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088782;
	bh=/P8DqtWEq0SGxh9rCWy+Jz6uaLieGvoAKOj7t5/ev3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lstWtp5dqhG7piLqg1mXsCniPTimDg8RowWwYy5UcLyXfSPK2Tvuo2CwUZ+vkZpCN
	 miUVHXJhmL+xEtCSjn3JIkE87Kp0Fpn5My9DlCPe6yD+19OLxT2sEAD+4RQn7StAZ0
	 HSIjop4ex6QvvM/yx4g2v4shzFIUQvzjNlkE4T20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 056/159] ksmbd: fix encryption failure issue for session logoff response
Date: Wed, 20 Dec 2023 17:08:41 +0100
Message-ID: <20231220160933.942578599@linuxfoundation.org>
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

[ Upstream commit af705ef2b0ded0d8f54c238fdf3c17a1d47ad924 ]

If client send encrypted session logoff request on seal mount,
Encryption for that response fails.

ksmbd: Could not get encryption key
CIFS: VFS: cifs_put_smb_ses: Session Logoff failure rc=-512

Session lookup fails in ksmbd_get_encryption_key() because sess->state is
set to SMB2_SESSION_EXPIRED in session logoff. There is no need to do
session lookup again to encrypt the response. This patch change to use
ksmbd_session in ksmbd_work.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/auth.c    |   12 ++++++++----
 fs/ksmbd/auth.h    |    3 ++-
 fs/ksmbd/smb2pdu.c |    7 +++----
 3 files changed, 13 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -988,13 +988,16 @@ out:
 	return rc;
 }
 
-static int ksmbd_get_encryption_key(struct ksmbd_conn *conn, __u64 ses_id,
+static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 				    int enc, u8 *key)
 {
 	struct ksmbd_session *sess;
 	u8 *ses_enc_key;
 
-	sess = ksmbd_session_lookup_all(conn, ses_id);
+	if (enc)
+		sess = work->sess;
+	else
+		sess = ksmbd_session_lookup_all(work->conn, ses_id);
 	if (!sess)
 		return -EINVAL;
 
@@ -1082,9 +1085,10 @@ static struct scatterlist *ksmbd_init_sg
 	return sg;
 }
 
-int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
+int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 			unsigned int nvec, int enc)
 {
+	struct ksmbd_conn *conn = work->conn;
 	struct smb2_transform_hdr *tr_hdr = smb2_get_msg(iov[0].iov_base);
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
@@ -1098,7 +1102,7 @@ int ksmbd_crypt_message(struct ksmbd_con
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	struct ksmbd_crypto_ctx *ctx;
 
-	rc = ksmbd_get_encryption_key(conn,
+	rc = ksmbd_get_encryption_key(work,
 				      le64_to_cpu(tr_hdr->SessionId),
 				      enc,
 				      key);
--- a/fs/ksmbd/auth.h
+++ b/fs/ksmbd/auth.h
@@ -33,9 +33,10 @@
 
 struct ksmbd_session;
 struct ksmbd_conn;
+struct ksmbd_work;
 struct kvec;
 
-int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
+int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 			unsigned int nvec, int enc);
 void ksmbd_copy_gss_neg_header(void *buf);
 int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8646,7 +8646,7 @@ int smb3_encrypt_resp(struct ksmbd_work
 	buf_size += iov[1].iov_len;
 	work->resp_hdr_sz = iov[1].iov_len;
 
-	rc = ksmbd_crypt_message(work->conn, iov, rq_nvec, 1);
+	rc = ksmbd_crypt_message(work, iov, rq_nvec, 1);
 	if (rc)
 		return rc;
 
@@ -8665,7 +8665,6 @@ bool smb3_is_transform_hdr(void *buf)
 
 int smb3_decrypt_req(struct ksmbd_work *work)
 {
-	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess;
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
@@ -8686,7 +8685,7 @@ int smb3_decrypt_req(struct ksmbd_work *
 		return -ECONNABORTED;
 	}
 
-	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
+	sess = ksmbd_session_lookup_all(work->conn, le64_to_cpu(tr_hdr->SessionId));
 	if (!sess) {
 		pr_err("invalid session id(%llx) in transform header\n",
 		       le64_to_cpu(tr_hdr->SessionId));
@@ -8697,7 +8696,7 @@ int smb3_decrypt_req(struct ksmbd_work *
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
 	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr) + 4;
 	iov[1].iov_len = buf_data_size;
-	rc = ksmbd_crypt_message(conn, iov, 2, 0);
+	rc = ksmbd_crypt_message(work, iov, 2, 0);
 	if (rc)
 		return rc;
 


