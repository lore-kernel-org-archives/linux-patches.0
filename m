Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829075;
	b=HTT4jC+BwAxZNXgZHGMe6MlCP2HlVp/DRzFXaZVKDhIfUJWPqkyfJJwm3lDLWeKMjjpe
	 3qlaW344RFhplgV3O2wQSBZ0fU6INf7DbzhoSHsjgDlKeHJ5nCKset015bi36RvQ+hgtn
	 ak8gdwrTqWBRoeiYHpPsAlUvMDzvnSUoAvvvbfKi2z5HC0JqioLAkmTr+8VESbf0thiEF
	 Ba4i56JD3wgTSWSDyeiOWl9Ztp5PheKbfCIVBf0I5i4seShsd9RDGa+wp2Eo0ckMazBxB
	 gqWakYUmNqHqpUII774Ds5nCeWo5PIO6aDgVfcTebo1YYFYPkIQxoqiXADFLi04U2Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jEFSwNGzVLLgYs2D+tX7pGQjYQR081e6BPDuEQfSXbg=;
	b=I0WbPg6uigQSrX9FUoNgSF8dZHHSmLPyzIHo9rw092245R9A4tb7d2Ad6PQo1hINIPHH
	 rocIlQTXOIpuIrCofgF/HFXY7vybi9nJsQNOW9gdNTxfXA3UpkHE22oKN72PYduGHN//b
	 Tn9vEVkVjCjYx/z4H12uSk4m6Mf4KEMUrAhdfp4+kjbJjI9YuljCoQ6IUvz/HF9ZY967f
	 Cbq8TuUTNxqfDLGR1vXjRQ2HahX1tCOuTjoAh6NE/FetD4Z73qACguR9svPf+2+iqdH1t
	 P7tEKYYaYUJ6gwzNtgH8pRN6JyR8KlsgueUGDE2uU6bt8QcIw4cLijmuKG57kdhHRAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3bHyoYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6649606EEB6;
	Wed,  4 Nov 2026 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3bHyoYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177E21F00A18;
	Wed,  4 Nov 2026 21:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829074;
	bh=jEFSwNGzVLLgYs2D+tX7pGQjYQR081e6BPDuEQfSXbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3bHyoYWT1Mz/KK06qJhrRso61hLzxSRPDD64kZqA6EP3mweyOGmXVbCyJ8jagmNu
	 8B9l/13hK37/vylbK3EGqN/poYH9cLw9AyyKnk0UhSGw6yBo/KE+fqBf9LS1K6dpgq
	 U4XRlogFag37FHp/Q/xdxu2a284zvYuEnQVKVOlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 391/547] smb: client: validate the data area in SMB2_read()
Date: Wed,  4 Nov 2026 16:09:35 -0500
Message-ID: <20261104211049.407829671@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

commit 2ec9cdf469dd32bcf33073aeb30c08e9356e0ca1 upstream.

SMB2_read() copies le32_to_cpu(rsp->DataLength) bytes from
(char *)rsp + rsp->DataOffset without checking that the range lies
within the response actually received. A READ response with
DataOffset == 0 makes smb2_get_data_area_len() zero the data length, so
smb2_check_message() accepts a frame as short as the fixed response,
while SMB2_read() still uses the server-supplied DataLength, capped only
by CIFS_MAX_MSGSIZE and the caller's length.

A malicious server can answer the synchronous read used by the
mfsymlinks (or SFU) symlink parser with an 81-byte READ response
carrying DataOffset 0 and DataLength 1067, making the client copy 1067
bytes from a 448-byte receive object (KASAN slab-out-of-bounds; up to
16 KiB in the general case).

Clamp a zero (or header-overlapping) DataOffset to read_rsp_size, as
handle_read_data() does for the asynchronous path, and reject the
response unless DataOffset + DataLength fits within rsp_iov.iov_len.
The SMB1 helper was fixed the same way in 5be5bdda5863.

Fixes: d8e050398d23 ("CIFS: Add readpage support for SMB2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4962,6 +4962,7 @@ SMB2_read(const unsigned int xid, struct
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	unsigned int total_len;
+	u16 data_offset;
 	int flags = CIFS_LOG_ERROR;
 	struct cifs_ses *ses = io_parms->tcon->ses;
 
@@ -5021,8 +5022,29 @@ SMB2_read(const unsigned int xid, struct
 		*nbytes = 0;
 	}
 
+	data_offset = rsp->DataOffset;
+	if (data_offset < io_parms->server->vals->read_rsp_size) {
+		/*
+		 * win2k8 sometimes sends an offset of 0 when the read is beyond
+		 * the EOF.  Treat it as if the data starts just after the header,
+		 * as handle_read_data() does.
+		 */
+		cifs_dbg(FYI, "data offset %u inside read response header\n",
+			 data_offset);
+		data_offset = io_parms->server->vals->read_rsp_size;
+	}
+
+	/* The data area must lie within the response actually received */
+	if (*nbytes && (size_t)data_offset + *nbytes > rsp_iov.iov_len) {
+		cifs_dbg(FYI, "bad data offset %u length %u for response of %zu\n",
+			 data_offset, *nbytes, rsp_iov.iov_len);
+		rc = smb_EIO2(smb_eio_trace_read_bad_offset,
+			      data_offset, *nbytes);
+		*nbytes = 0;
+	}
+
 	if (*buf) {
-		memcpy(*buf, (char *)rsp + rsp->DataOffset, *nbytes);
+		memcpy(*buf, (char *)rsp + data_offset, *nbytes);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	} else if (resp_buftype != CIFS_NO_BUFFER) {
 		*buf = rsp_iov.iov_base;


