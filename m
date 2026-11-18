Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044740;
	b=KA3R+N/GyQ+xkZ1wRH0XfqCbEuXUI6ZPZa/bFGY2YwWtbyswnwkxSoqpAg/nvDJTJxni
	 +MXeEZGCiQgVzbIYmmzG7/p2v4H9VGvCKq8YRaKUrvg5dZKbTgFXEMByWNe8JrwjVKwiQ
	 NIcnnDirw1ygBNt4ylmdCsxwr4p5pZKvIrMNB0t9/A8sIOjVv2pvhYtvZ9qJyYz41YF08
	 HiqS84FHMpNesY1QNdAxgtF6sdhyKdxY6fAWIqUEYOnvkIoxEOITGF3mJPHsmvBLbzJTT
	 SLKq49gBpMrXOP95Rkg7qMj6fJ0rOasSurTwO4JBy1r4FDvC/ZyliLV5y+1gsSO+7cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RwxCITINSjyeSIZKg5fUq2PJAcKTQj9hxbB94E1PXWw=;
	b=WqkcXicivjKWiX/0Ruc4yHDO5bElEAaz0/Dhq7fqY0Y453OeETqy+wvUCwoNvlFOYJIa
	 X2qOrRIJqyr/gBqEIDQE13uf3DoniHiSpVdjvac12jwgLVvjOQ+l8hKu8Os0bVZPHIN6N
	 KDEPU0U9Tm5hZ4OPJleY5LzYXp5oCUVMHODCpQBdGrgA/Zz+LGPSStYzWOpnsP33MHrVl
	 YVPEFJgzp4yrfkYnxIkwMlmr0g+ldYJ84zJk0fGkrG2bff0qljTF4kVo0IjPi/JZ43f65
	 0eY+X9mBYBtCZzaaDBoolFe274/Scfk4GbRTNf0CCu69ULrUbDgWCiB+JSGqXs3xVfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XExZ9p68;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6BA606A320;
	Wed, 18 Nov 2026 23:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XExZ9p68
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0C51F000C4;
	Wed, 18 Nov 2026 23:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044740;
	bh=RwxCITINSjyeSIZKg5fUq2PJAcKTQj9hxbB94E1PXWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XExZ9p68s79PbI2I4MH737KCUtWGg4BhfJBea1Ib+eXmKMf2hFYnplB6zuszLS2qb
	 crY2xZNALDo86oliMNd3VwEA36SGva2aqGtaS6cPkhytOZUmqAVh6FxLZXpMuiEalK
	 z3lR6rHFc1548fidS0HSus+1E23dwMmYfPn1bnv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 0672/2857] ksmbd: prevent stale data from being written by SMB2 WRITE requests
Date: Wed, 18 Nov 2026 15:28:26 +0100
Message-ID: <20261118150225.757642729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit bc0e0f5ac1d7b044d403f859406b4b66d4b1ce9b ]

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
[ sashal: replaced smb2_current_req_len() calls with inline calculations using NextCommand or the remaining request buffer length ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c |  1 +
 fs/smb/server/smb2pdu.c    | 34 +++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 168292f73a843..28c60d3070a25 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -403,6 +403,7 @@ int ksmbd_conn_handler_loop(void *p)
 		if (!conn->request_buf)
 			break;
 
+		conn->request_buf[pdu_size + 4] = 0;
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 
 		/*
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1157acc74caf2..ef70f17ac9303 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6688,23 +6688,28 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	int err = 0, ret = 0;
 	char *data_buf;
 	size_t length;
+	unsigned int data_offset, req_len;
 
 	WORK_BUFFERS(work, req, rsp);
 
 	length = le32_to_cpu(req->Length);
 	id = req->VolatileFileId;
+	data_offset = le16_to_cpu(req->DataOffset);
+	req_len = le32_to_cpu(req->hdr.NextCommand);
+	if (!req_len)
+		req_len = get_rfc1002_len(work->request_buf) -
+			work->next_smb2_rcv_hdr_off;
 
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
@@ -6855,14 +6860,25 @@ int smb2_write(struct ksmbd_work *work)
 		writethrough = true;
 
 	if (is_rdma_channel == false) {
-		if (le16_to_cpu(req->DataOffset) <
-		    offsetof(struct smb2_write_req, Buffer)) {
+		unsigned int data_offset = le16_to_cpu(req->DataOffset);
+		unsigned int req_len = le32_to_cpu(req->hdr.NextCommand);
+
+		if (!req_len)
+			req_len = get_rfc1002_len(work->request_buf) -
+				work->next_smb2_rcv_hdr_off;
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
-- 
2.53.0



