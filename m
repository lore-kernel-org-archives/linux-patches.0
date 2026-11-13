Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585247;
	b=1r5i85hr3IxSGkWEKf0+A9lfEnKJQqsQdtWKRsoA6qOqLpTvkYlYACm1D8f3olO0ZHII
	 38sFFklyAVhGnwD7N4kpjPigicxncda6iX4l/JuZHAocSjAD+2iMg/C1xBoVXJj+kE93M
	 Cj8hy3+V5UA4TJoJUydlUimmNphHMVVSNEnROzoW1/F/zaYruLf4rlBceUxM4kZvmmKqF
	 jXIElGOUNGWkpMyxRnSlyjpcynylsqd3xvsSkD6BWSinyT5ci2fEmxM/DEJkEaD0nITTl
	 dm7IA6MES27eQWT+PpICk7h4bRWJsFR0XqL1lgJBDLio8zXTuX85M5sHte/5MfBA1mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j2U5IjJES7uyOeRUiD843nN4TdmDLvWzm5wl6po7O3Y=;
	b=pW26lRl5P3WZhE6589jjSFE4WGTNhTB0RkOwixWF3njxQyCVZam0HIbVaLXTekc/rnWd
	 zkZWL0i5LsED04p+WhgKMp6TpGNH9LmKgiX7eVRxKuvM2YtH9oOhl+LJ42ch6CCXpQo94
	 UrI2Mazw6u+F/itZG7TUXyiwZ+JGeTayuF/WjkuvX+KDwDyy+PcU4urHD2DAgR+qKIJ7x
	 ZQr0amoytYP9SK4S6LXYCZ1x8lozdceg0CI7d5CERCVQKIVRwICRHeucXt5L5Lxnhreii
	 UiOlg4Opap4nX34J0XV5aexgphUyYSYoe9+0LD1I08AlZgdglrXRPGNqhwe3h2EjgKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XAfGD0Fc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653B606A32D;
	Fri, 13 Nov 2026 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XAfGD0Fc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783771F000C4;
	Fri, 13 Nov 2026 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585246;
	bh=j2U5IjJES7uyOeRUiD843nN4TdmDLvWzm5wl6po7O3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAfGD0Fcu/ZaFGicwlnQWg7gWbrabSicSg6wjEl+9YtahgHW1cEvqmv1EgycChF3p
	 4OehXkQVF4qU1QI7wkVfLg8TShwv7QpFFWWsfd0uMt6pJnFBf3/u/54mbqYXZhayXp
	 yFCPXFhtuQs5ZIzS9gzGU7OcDau7o3s/ALjPTMe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/686] smb: client: validate the data area in SMB2_read()
Date: Fri, 13 Nov 2026 10:42:14 -0500
Message-ID: <20261113153820.980815627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 2ec9cdf469dd32bcf33073aeb30c08e9356e0ca1 ]

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
[ sashal: Replaced the smb_EIO2() call with -EIO because smb_eio_trace_read_bad_offset is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 6d610f136f43e..5185f8cc8bcc8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4839,6 +4839,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	unsigned int total_len;
+	u16 data_offset;
 	int flags = CIFS_LOG_ERROR;
 	struct cifs_ses *ses = io_parms->tcon->ses;
 
@@ -4897,8 +4898,28 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
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
+		rc = -EIO;
+		*nbytes = 0;
+	}
+
 	if (*buf) {
-		memcpy(*buf, (char *)rsp + rsp->DataOffset, *nbytes);
+		memcpy(*buf, (char *)rsp + data_offset, *nbytes);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	} else if (resp_buftype != CIFS_NO_BUFFER) {
 		*buf = rsp_iov.iov_base;
-- 
2.53.0



