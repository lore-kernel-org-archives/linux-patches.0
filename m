Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4259F374E6F;
	Sat, 12 Sep 2026 09:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204080; cv=none; b=lLgVqu28Eiq538CFa1KH904nC3AHJ/3tf5lqv0XfFu73zMHSzds85APF9DA3S7+YOCIbkl4jGXD72bb9N5CKXEduLWN0MYBwX5pHPWI/oVB7iLaQP05lOyO1lYn2eZMseYy50XRfiy7JcfymUWC5rGmAKgQMxGslOP4lEeH4228=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204080; c=relaxed/simple;
	bh=4SlinqJUGs4crz0t2tQD+yL9goXdcxe11WsI5GEjMrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIN/WKezvmQucKYk0Q9TPok8lGrYrRQEvDQL1tjM0XtVQozv2yPbrQYLSRgj+fO8K3aQV2Y7M7JlP984VLqRfLDAMsiYlByJMqJvk1pAxjkI6Amj/CNDqZgKfpztgpPI7+MMifuc/s2Kw9oK15VZA/tCQ2AKexTWW0IkQFtbfNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4S9USAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4S9USAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478131F000FF;
	Sat, 12 Sep 2026 09:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204079;
	bh=hsMacL5Lx+pah4MR1pmIOpXECNMgyP+3P+wVc0gdeOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4S9USAnFhQ3ooJqIdNVp+borq9UpJZ7foYOJnGjutqDkPhUM9UDze93CYtvgrlAf
	 aUes1t6hOARy18iWsmKgY1fQVUQOgvS+3ZmM/uv22UVQF5J3y9OhxxiuegVDedZr6s
	 ep6WoU7Vr8ordqYCcxq4iNb0AlmCFbRdrf+PqYYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1538/1815] ksmbd: handle encrypted compressed requests
Date: Sat, 12 Sep 2026 08:54:48 +0200
Message-ID: <20260912065725.114330087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6639b6928ba22dd6750ff3c6f6de77715cf46d50 ]

SMB3 permits a message to be compressed before it is encrypted. After
decrypting such a request, ksmbd must trim the AEAD tag using
OriginalMessageSize, decompress the nested compression transform, and
validate the resulting SMB2 PDU.

Share the decompression helper between the connection receive path and
the post-decryption work path so unencrypted and encrypted compressed
requests follow the same validation.

Fixes: a08de24c2b85 ("ksmbd: negotiate and decode SMB2 compression")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/compress.c | 76 ++++++++++++++++++++++++++++++----------
 fs/smb/server/compress.h |  1 +
 fs/smb/server/server.c   | 22 ++++++++++++
 fs/smb/server/smb2pdu.c  | 22 ++++++++----
 4 files changed, 97 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 01d1771ff6636..5162fb84c755a 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -14,24 +14,14 @@
 
 #define SMB_COMPRESS_MIN_LEN	PAGE_SIZE
 
-/**
- * ksmbd_decompress_request() - replace a compressed request with its SMB2 PDU
- * @conn: connection which owns the current RFC1002 request buffer
- *
- * Derive the uncompressed size from the transform variant, enforce ksmbd's
- * normal message limits, and ask the common decoder to validate every payload.
- * On success, replace conn->request_buf with a regular RFC1002-framed SMB2
- * message so the rest of the request path needs no compression awareness.
- *
- * Return: 0 on success, otherwise a negative errno.
- */
-int ksmbd_decompress_request(struct ksmbd_conn *conn)
+static int __ksmbd_decompress_request(struct ksmbd_conn *conn,
+					     void *request_buf, void **out_buf)
 {
 	struct smb2_compression_hdr *hdr;
-	unsigned int pdu_size = get_rfc1002_len(conn->request_buf);
+	unsigned int pdu_size = get_rfc1002_len(request_buf);
 	u32 orig_size, offset, out_size;
 	u32 max_allowed_pdu_size;
-	char *buf, *out;
+	char *out;
 	int rc;
 
 	if (pdu_size < sizeof(struct smb2_compression_hdr))
@@ -41,7 +31,7 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 	    conn->compress_algorithm == SMB3_COMPRESS_NONE)
 		return -EINVAL;
 
-	hdr = smb_get_msg(conn->request_buf);
+	hdr = smb_get_msg(request_buf);
 	if (hdr->ProtocolId != SMB2_COMPRESSION_TRANSFORM_ID)
 		return -EINVAL;
 
@@ -74,19 +64,69 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 	if (!out)
 		return -ENOMEM;
 
-	buf = (char *)hdr;
 	*(__be32 *)out = cpu_to_be32(out_size);
 	rc = smb_compression_decompress(conn->compress_algorithm,
 					conn->compress_chained,
 					conn->compress_pattern,
-					buf, pdu_size, out + 4, out_size);
+					(char *)hdr, pdu_size, out + 4, out_size);
 	if (rc) {
 		kvfree(out);
 		return rc;
 	}
 
+	*out_buf = out;
+	return 0;
+}
+
+/**
+ * ksmbd_decompress_request() - replace a compressed request with its SMB2 PDU
+ * @conn: connection which owns the current RFC1002 request buffer
+ *
+ * Derive the uncompressed size from the transform variant, enforce ksmbd's
+ * normal message limits, and ask the common decoder to validate every payload.
+ * On success, replace conn->request_buf with a regular RFC1002-framed SMB2
+ * message so the rest of the request path needs no compression awareness.
+ *
+ * Return: 0 on success, otherwise a negative errno.
+ */
+int ksmbd_decompress_request(struct ksmbd_conn *conn)
+{
+	void *out_buf;
+	int rc;
+
+	rc = __ksmbd_decompress_request(conn, conn->request_buf, &out_buf);
+	if (rc)
+		return rc;
+
 	kvfree(conn->request_buf);
-	conn->request_buf = out;
+	conn->request_buf = out_buf;
+	return 0;
+}
+
+/**
+ * ksmbd_decompress_work_request() - decompress an encrypted work request
+ * @work: work item whose request buffer contains a compression transform
+ *
+ * SMB3 encrypts a compressed message by applying compression first and
+ * encryption second.  The receive loop can therefore only decode the
+ * compression transform before work allocation for an unencrypted request;
+ * an encrypted request must be decompressed after its encryption layer has
+ * been removed.
+ *
+ * Return: 0 on success, otherwise a negative errno.
+ */
+int ksmbd_decompress_work_request(struct ksmbd_work *work)
+{
+	void *out_buf;
+	int rc;
+
+	rc = __ksmbd_decompress_request(work->conn, work->request_buf,
+					&out_buf);
+	if (rc)
+		return rc;
+
+	kvfree(work->request_buf);
+	work->request_buf = out_buf;
 	return 0;
 }
 
diff --git a/fs/smb/server/compress.h b/fs/smb/server/compress.h
index 663c6f44f09b0..13df2eb221e8c 100644
--- a/fs/smb/server/compress.h
+++ b/fs/smb/server/compress.h
@@ -11,6 +11,7 @@
 #include "../common/compress/compress.h"
 
 int ksmbd_decompress_request(struct ksmbd_conn *conn);
+int ksmbd_decompress_work_request(struct ksmbd_work *work);
 int ksmbd_compress_response(struct ksmbd_work *work);
 
 #endif /* __KSMBD_COMPRESS_H__ */
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0425ef045db0b..46a67642f814e 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -188,6 +188,28 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 			return;
 		}
 		work->encrypted = true;
+
+		/*
+		 * SMB3 applies compression before encryption.  The receive loop
+		 * handles a plain compression transform before allocating work, but
+		 * an encrypted request exposes that transform only after decryption.
+		 */
+		if (((struct smb2_hdr *)smb_get_msg(work->request_buf))->ProtocolId ==
+		    SMB2_COMPRESSION_TRANSFORM_ID) {
+			rc = ksmbd_decompress_work_request(work);
+			if (rc < 0) {
+				ksmbd_conn_abort(conn);
+				return;
+			}
+		}
+
+		/* The decrypted payload must now be a complete SMB2 request. */
+		if (((struct smb2_hdr *)smb_get_msg(work->request_buf))->ProtocolId !=
+			SMB2_PROTO_NUMBER ||
+		    get_rfc1002_len(work->request_buf) < sizeof(struct smb2_pdu)) {
+			ksmbd_conn_abort(conn);
+			return;
+		}
 	}
 
 	if (conn->ops->allocate_rsp_buf(work))
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6e1fb37452b42..4cf7083f35ccd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10857,18 +10857,27 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
 	struct kvec iov[2];
-	int buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
+	unsigned int buf_data_size;
 	struct smb2_transform_hdr *tr_hdr = smb_get_msg(buf);
+	unsigned int original_msg_size;
 	int rc = 0;
 
-	if (pdu_length < sizeof(struct smb2_transform_hdr) ||
-	    buf_data_size < sizeof(struct smb2_hdr)) {
+	if (pdu_length < sizeof(struct smb2_transform_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
 		       pdu_length);
 		return -ECONNABORTED;
 	}
 
-	if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) {
+	buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
+	original_msg_size = le32_to_cpu(tr_hdr->OriginalMessageSize);
+	if (buf_data_size < sizeof(struct smb2_compression_hdr) ||
+	    original_msg_size < sizeof(struct smb2_compression_hdr)) {
+		pr_err("Transform message is too small (%u)\n",
+		       pdu_length);
+		return -ECONNABORTED;
+	}
+
+	if (buf_data_size < original_msg_size) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
 	}
@@ -10881,8 +10890,9 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	if (rc)
 		return rc;
 
-	memmove(buf + 4, iov[1].iov_base, buf_data_size);
-	*(__be32 *)buf = cpu_to_be32(buf_data_size);
+	/* Drop the AEAD authentication tag from the inner RFC1002 frame. */
+	memmove(buf + 4, iov[1].iov_base, original_msg_size);
+	*(__be32 *)buf = cpu_to_be32(original_msg_size);
 
 	return rc;
 }
-- 
2.53.0



