Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035593;
	b=rPQNLsAECdolzAd/n4KDQZBkeAmJW1Fr1H4ntlHxX5BMZ73mtdP5vPUUdx0p+wdDmrji
	 6hnmom/2P9xNb3dpMIFIXNcdoehL+zoaZYIGsojUjLu/VeNxjZy64vDsAwUe5w2afJstk
	 KznlfuSyVYfxGiu3FnIobNDBOWp5okULpTkc4Mxg4HxxZFeAgI/X83/lirXzPM3oFGryq
	 BWzPcf+Knfd8b9Gx0BmCbYMJN31g08J4iALXsnhG9kahqFRRsMQC46lNhEGuLR2JlykMZ
	 r74vday+r4g2CFezE6tazDhQWRqCKayT3D5iW5+54TNtMjqYGGNYqe84SyfCuQhw1Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RqfD0IrsPCQS1ZYAq9/sW01WgoIxKpBtVBDtTeTl1b8=;
	b=Rw1yzRcdlLzYc+QHSj+jbvLALqElkY4YE7nQ7WHAdVmh6jYg1Q/edKNsSCu3ewYR5oVf
	 S2qyYRc+gACvTBw/fxZd/V2GZIrAPDv9ZvUbcR0FixDIUEwufTwIlO5vt7EI+hd9U5KCM
	 SUP6X4wHTJ0WOEnrtWHBYpggD2tsP6zuytzMmv7xHCbMzw44EYZszWRBwmKwaKpiMi1EW
	 HlNuQEmTfnPtZ97CPhQLukLiX+ublVmAjrkEDIWe4NyUtfVoEIIk1688SyD6V3WZj1SvI
	 9AeTbEfvHMImUTKGLdSnIGygSPGXWSvHbKFPm0cWTEscA0ABQyMmIaRJbddb3crbD6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IA6uvP7G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15241606A31C;
	Wed, 18 Nov 2026 20:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IA6uvP7G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6FF1F000C4;
	Wed, 18 Nov 2026 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035592;
	bh=RqfD0IrsPCQS1ZYAq9/sW01WgoIxKpBtVBDtTeTl1b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IA6uvP7GfEtWyOufR8mUy+YI3Xhb3r44eprRxuI6U3hby1o95DAy4jTeqJj+04nq/
	 fbHEpsm/NwXxRCUzqnm8CWN930G8Yy8S5UpNrSm9GksPfDVTrxTGy5TxdzOafguOZf
	 trYb9pOZbyf3lKxqN5sxAo2l5ZMjxgaGYw/LoCSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 0760/3318] ksmbd: prevent stale data from being written by SMB2 WRITE requests
Date: Wed, 18 Nov 2026 15:23:02 +0100
Message-ID: <20261118150341.499693129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced smb2_current_req_len() calls with inline NextCommand and RFC1002 length calculations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c |  1 +
 fs/smb/server/smb2pdu.c    | 34 +++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index ec265f12c4902..833105f23d260 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -520,6 +520,7 @@ int ksmbd_conn_handler_loop(void *p)
 		if (!conn->request_buf)
 			break;
 
+		conn->request_buf[pdu_size + 4] = 0;
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 
 		/*
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0f92fb2efc473..52142a08f9683 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7145,23 +7145,28 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
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
@@ -7312,14 +7317,25 @@ int smb2_write(struct ksmbd_work *work)
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



