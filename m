Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051975;
	b=h3D19/xAaQ6HQvUFDOv0+qsZXvq+5JuTeuLfV5ow8sGlLON445/bRmFevJS+okMIxZqp
	 X1hNWMfI1+sgAKQog7oC2E10yqojRjLjccqsVjX3EnUXH91MF5kGJhrodbuWxAUKf3GTV
	 dCtNCi5DrqB5fWseapEu00JmlkOT/yuxIZrQoCtH2whvB0agja2b/VKaYvlvC4ypRNN64
	 jDQWaVSevKiM48nUxCoFtqIfMAr3JyKFk+gyqnkSMV9qG3hXkdhHKhTOFuVya4h8kURfN
	 nlHMvmH0uejNsv6FuTUXsa3PHtjkPUPYrPZsAcz75U6baoxzqnuV36EI01XxrkAFQjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NbdQqad2mV7/uo4Dm0UoQKWjMF0xIkLyRuV/9QpBrQE=;
	b=XCmS3GOp7oEzbkmPoBMGhV5NZmLwQaNYuRPAoeX5AQdZqq6oowneWHgccJtTvcidruUq
	 Zzu5yecBBvMOOyH2UgD4+WzzJQ1UrP8ZfUcKFIF3ImlOYQsibyCy3mxVoprZpxWinfsC/
	 qH4+5XexWgqP6oJyd6QHb7+mtoA/5TKkn1PdL6jxEOG+yIXvik5mDvccaZiJTAJS0Y0X+
	 9FIZ2zKbdNa3t4FQHM5P/3R+TIEy2ebmlCa3l87gXJvKX5pmUEsadsdwWKl1SmzFS2HP+
	 Swp9+OcEDljOfQ5qxNgV46xiDUl95mKQ8y5twCssDpLNdAbdrtlAs4t4rWJ6kv5HfWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1TT1M8b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B47606A332;
	Thu, 19 Nov 2026 01:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1TT1M8b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1271F000C4;
	Thu, 19 Nov 2026 01:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051974;
	bh=NbdQqad2mV7/uo4Dm0UoQKWjMF0xIkLyRuV/9QpBrQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1TT1M8b/FROp4hjuQsV3rwZHTSWk++ZcIDS9iehxUODDFJwwdjbEdAjzZpcnw5Se
	 llI9UjamboBcGHRvjKL1OzOLM0hcRZdgjfcLZMMH4zDSefgmbXgNjpBrFCWw8BeIub
	 TMrXZ/MkuQL0qj8zbtYFkilc6fzNKx3Kc4hCDb4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 0398/2214] ksmbd: prevent stale data from being written by SMB2 WRITE requests
Date: Wed, 18 Nov 2026 15:34:34 +0100
Message-ID: <20261118150026.683739346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: inlined smb2_current_req_len() calculations at both call sites because the helper is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.c |  1 +
 fs/ksmbd/smb2pdu.c    | 34 +++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 65dd05290c9ba..9dd02322275fc 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -399,6 +399,7 @@ int ksmbd_conn_handler_loop(void *p)
 		if (!conn->request_buf)
 			break;
 
+		conn->request_buf[pdu_size + 4] = 0;
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 
 		/*
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0346305edf8a4..a74605abee913 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6553,23 +6553,28 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
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
@@ -6720,14 +6725,25 @@ int smb2_write(struct ksmbd_work *work)
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



