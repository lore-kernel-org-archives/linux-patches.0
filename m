Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831956;
	b=tK63E25KkDNPQQKxkjP0xZNbinULynfbHx7E6UCabN/jsB9gBMV0HAma3QFkyIHxmTlX
	 /rh5qz/shrD2NtXqxWds/usYieIOyjUmSt6nJXUhmXlNYwYmKcuGNE4w5Spawr8wAXPuM
	 HpaB/mGmHSSqX1ezjZzGcHnPh/oxnGpLo1LQ064dI3BPlnvXQtGxXsPsx3hmnQnCgdEj6
	 7y4dE5KVm/PyfLD6/QMyH5JzspXFTT/xBXIpIW88Zgga5uRZcqdsbxnA3PWt8sK/YgdDY
	 1zSK7DowUGuY8MhtkWhoqCnvGACL9OMh83xCY4pKOKC6MPvsfs4gsmQSASL8WQErIDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w75BLrcYq/ahEGFc3yqJS8JFZU85jgJ3DK2SU43lTNE=;
	b=0ksFE62H9gTafY5La30MYGwsQ8eU4TzGZ6Zq2JjySnTxh35KE3sAV+u8jKLf1qNhyv30
	 yDeUG7MdjsVswBaI1HTND6sRbqAmKgZ2KxEFgZuuPVQXeqw/85l989ez8+3cFQtN1EYnm
	 T1ymPK6YTwaisA6UQwAwV9pH4orgrrve1LYCb9OIHl9dcB6x22Xc/Mlf5gBxtunK0DRt5
	 VwAmhEXL3qpI1Stn6q4HOZeFktNm3ZCckFHYqOBpXZqCA2rzc1Ha9tGw+2muYLiOllFTS
	 dKlBkA3533fcTksKlX76df6AMuEKIf6+TPvayzmIf3G3oJmnNoJmrjRQMvKLg7W+adQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8GgUa25;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B3C606A875;
	Wed,  4 Nov 2026 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B8GgUa25
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003AD1F00919;
	Wed,  4 Nov 2026 22:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831956;
	bh=w75BLrcYq/ahEGFc3yqJS8JFZU85jgJ3DK2SU43lTNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8GgUa25IIsrIUMDs0nyuhnBLN59Qy57huef2f2ht0wDNfgKEGqYMLg9FZP5VY7HG
	 eoxI8CzG0m79qVSUJxOf+SQFreG8BtJx0xTqoXDg12OsgWsi0JbcFJJr+Z34lYjf2B
	 /3E9vsoOW/UpD6W5pdZSHQ/n1++Ls0B/LbzwY8l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.18 0989/1005] ksmbd: prevent stale data from being written by SMB2 WRITE requests
Date: Wed,  4 Nov 2026 16:12:02 -0500
Message-ID: <20261104211110.740515746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Inlined the unavailable smb2_current_req_len() helper and omitted the decompression change because compression support is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    1 +
 fs/smb/server/smb2pdu.c    |   36 ++++++++++++++++++++++++++----------
 2 files changed, 27 insertions(+), 10 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -520,6 +520,7 @@ recheck:
 		if (!conn->request_buf)
 			break;
 
+		conn->request_buf[pdu_size + 4] = 0;
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 
 		/*
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7218,23 +7218,28 @@ static noinline int smb2_write_pipe(stru
 	int err = 0, ret = 0;
 	char *data_buf;
 	size_t length;
+	unsigned int data_offset, req_len;
 
 	WORK_BUFFERS(work, req, rsp);
 
 	length = le32_to_cpu(req->Length);
 	id = req->VolatileFileId;
-
-	if ((u64)le16_to_cpu(req->DataOffset) + length >
-	    get_rfc1002_len(work->request_buf)) {
-		pr_err("invalid write data offset %u, smb_len %u\n",
-		       le16_to_cpu(req->DataOffset),
-		       get_rfc1002_len(work->request_buf));
+	data_offset = le16_to_cpu(req->DataOffset);
+	req_len = le32_to_cpu(req->hdr.NextCommand);
+	if (!req_len)
+		req_len = get_rfc1002_len(work->request_buf) -
+			work->next_smb2_rcv_hdr_off;
+
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
@@ -7391,14 +7396,25 @@ int smb2_write(struct ksmbd_work *work)
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


