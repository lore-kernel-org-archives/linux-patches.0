Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826994;
	b=PoJ+Ntcrcz+UO8CYNdU8uQTKOArANKdcyel6UVnD4kNqk7MMwmvgVMM0xnZeNlOGjW+F
	 thkr2P0ePSvFaP9b9dcA26Qbi5J+SEEOtc34ruDoc6fF5QF1WS31dFYtNLm5WdNBxlQfv
	 ocTqoLk7Rzo15gh7keo6Izh7nXiD42NNfLbnMT05JcpYEUjk9ZYFjew3szcfa2fzDyCXq
	 nWECgUXlFpV0SNFYsWysjujt/z9SBK9Ubb4KKMDnHyeXpQd/jvWsj9Mn5y/SaKGMKrfr5
	 pCLCWqRne9CxllRGa8OPKOtwcZyIe+5hQDXvEOZpNLmSMXOfJttRBmJZOLmzSHbh53A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ggwTrOEQCVMopGfn/XloKl6/N5e8QKopfvpX4I+sYg=;
	b=rXGTg4i4wS+eRjmT6ZJJX1Ow0V8GWozk86qEuiq6CSWvt1Lc+sIAKVVGvuPxfkfJjKqC
	 53O7oqYI7Y2U6vvat43fyw76LsFtZAKiKXkNMS7Pi9gDQ4HEeFDDqTwJH+9HK4iK3P5M/
	 KRdO6Ml1/dTwZI/3HlmsJOFmslTYQoabjF3GCeVKxFN0px16JEL0dri3UQ4aeA3HbgmIz
	 ftYHuyeq94ZSYhH9ji2CVyXEkQXUwFb3LJI/X8eGMZlbNzI9p/CbPN7ypFgw0YH5FpKCv
	 Q52ix+R77+pY7hU0D/BEFjECCrKz9sXNMU9BQyIbD+uJ1ov5EG9tjuZ0HgGWktItJeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R1m/n5Vb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622F26074904;
	Wed,  4 Nov 2026 21:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1m/n5Vb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1891F000C1;
	Wed,  4 Nov 2026 21:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826993;
	bh=9ggwTrOEQCVMopGfn/XloKl6/N5e8QKopfvpX4I+sYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1m/n5VbsCB48mcVWJsB5iUIzz7ThPOCok4f4CxDn8+4Mm2J9zEaISSfoM9HL5bz+
	 Xc1Jaq1HVMDbbxbPbrceyfE0PUQw+mZwjvBe4QHtsT6V5FboENZaQq+3I1fKWas9lU
	 qyOZEw4OjQiuD3jAN4LbfwODzqq8pLHV3tTD1Vt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 7.3 129/547] ksmbd: prevent stale data from being written by SMB2 WRITE requests
Date: Wed,  4 Nov 2026 16:05:13 -0500
Message-ID: <20261104211041.843340842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit bc0e0f5ac1d7b044d403f859406b4b66d4b1ce9b upstream.

Initialize the compatibility byte in request buffers without zeroing
the entire allocation. Keep the one-byte compatibility exception for
SMB2 messages so valid zero-length WRITE requests remain compatible,
and validate the data range in the WRITE handlers against the current
compound request before accessing it.

This prevents stale request-buffer data from being written to files or
sent to IPC pipes.

Fixes: 443d61d1fa9f ("ksmbd: allocate one more byte for implied bcc[0]")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-32436
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/compress.c   |    1 +
 fs/smb/server/connection.c |    1 +
 fs/smb/server/smb2pdu.c    |   27 ++++++++++++++++++---------
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -65,6 +65,7 @@ static int __ksmbd_decompress_request(st
 		return -ENOMEM;
 
 	*(__be32 *)out = cpu_to_be32(out_size);
+	out[out_size + 4] = 0;
 	rc = smb_compression_decompress(conn->compress_algorithm,
 					conn->compress_chained,
 					conn->compress_pattern,
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -753,6 +753,7 @@ recheck:
 		if (!conn->request_buf)
 			break;
 
+		conn->request_buf[pdu_size + 4] = 0;
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 
 		/*
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9303,23 +9303,25 @@ static noinline int smb2_write_pipe(stru
 	int err = 0, ret = 0;
 	char *data_buf;
 	size_t length;
+	unsigned int data_offset, req_len;
 
 	WORK_BUFFERS(work, req, rsp);
 
 	length = le32_to_cpu(req->Length);
 	id = req->VolatileFileId;
+	data_offset = le16_to_cpu(req->DataOffset);
+	req_len = smb2_current_req_len(work, &req->hdr);
 
-	if ((u64)le16_to_cpu(req->DataOffset) + length >
-	    get_rfc1002_len(work->request_buf)) {
-		pr_err("invalid write data offset %u, smb_len %u\n",
-		       le16_to_cpu(req->DataOffset),
-		       get_rfc1002_len(work->request_buf));
+	if (data_offset < offsetof(struct smb2_write_req, Buffer) ||
+	    data_offset > req_len || length > req_len - data_offset) {
+		pr_err("invalid write data offset %u, length %zu, req_len %u\n",
+		       data_offset, length, req_len);
 		err = -EINVAL;
 		goto out;
 	}
 
 	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-			   le16_to_cpu(req->DataOffset));
+			   data_offset);
 
 	rpc_resp = ksmbd_rpc_write(work->sess, id, data_buf, length);
 	if (rpc_resp) {
@@ -9606,14 +9608,21 @@ int smb2_write(struct ksmbd_work *work)
 		writethrough = true;
 
 	if (is_rdma_channel == false) {
-		if (le16_to_cpu(req->DataOffset) <
-		    offsetof(struct smb2_write_req, Buffer)) {
+		unsigned int data_offset = le16_to_cpu(req->DataOffset);
+		unsigned int req_len = smb2_current_req_len(work, &req->hdr);
+
+		if (data_offset < offsetof(struct smb2_write_req, Buffer) ||
+		    data_offset > req_len ||
+		    length > req_len - data_offset) {
+			ksmbd_debug(SMB,
+				    "invalid write data offset %u, length %zu, req_len %u\n",
+				    data_offset, length, req_len);
 			err = -EINVAL;
 			goto out;
 		}
 
 		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
-				    le16_to_cpu(req->DataOffset));
+				    data_offset);
 
 		ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
 			    fp->filp, offset, length);


