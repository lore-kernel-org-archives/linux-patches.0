Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831917;
	b=iXEPkaxPu5tciEd97vEr+QlPfs5FDIAEt6onjcvbCVvHFBT35Sdt4Pe1XHKWMoM443wh
	 hl7kwEz37CbZ6exB+GYbpuUEHsScCJVgP08Rx8Y9Ec7fZXV0boJuUQnqj8l878K+d6zqy
	 gRj34OczYtsD0ruBOcp5rx3Y7NSN8l8+pXeCow0yhhMH6N/Oi66pVuMXlN3eUL36USoYS
	 WyC74UkR5DUH9dHIlQfEATGbvT/zXdPfK4Sg9WBiMzw3k9Q9HFQYpbu+taXFDJ7APfK2A
	 sk0UzR8H2LK4WRVshtUMnEIf4rGSjZzXDGrAbYbPJywZWulncHmRd5EUlS4iu7m+MyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3IpThQ4kY9a3CoV0nDaJ007tdBDx5t5HB+Ek+TShN0k=;
	b=A4y/HZkuCDzvhP/pLEQ0i0RRPa5yxR9SvDAkH8wuQ9HAaO2Er/yQtxbA0lJHV6b2uq8v
	 QMNOo6tDcMdbIwrUDcfPdMaeONf6558iwDz/s0Zl6ThK/koutL2d6NqkRXi7J80D8lcwy
	 YeK+eio+YIGu2iy8Qo9dJb9mLhMJ0C7ZYWeL8O4dIvSdiFjWj01Wo3zNfSsCIb/RMsKWq
	 3oKxlQD7p6zZrXrXLUFdIvCd7YFtE5fXS5kQebk38Z19caAI0L8/rpLx5QZR/c075foeu
	 Q9RQTE0KCoICKPVTzgttl8AQSfTW2L66oGi52qz1QW3FZD1QKX2VxTq6aPyOrMK7New==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXDt2jmX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5250606A86E;
	Wed,  4 Nov 2026 22:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXDt2jmX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CED1F00919;
	Wed,  4 Nov 2026 22:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831916;
	bh=3IpThQ4kY9a3CoV0nDaJ007tdBDx5t5HB+Ek+TShN0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXDt2jmXo+NEcJkvQrGbsEuZKQjwu4HtHX2ep11u/XfLqkAQ0Bm2JibIqZFest8sB
	 jSPk5XtdWu/DZgIJnLilfe+yqsPupvWTWkBctNLpH4aAbhJZE2PiJk57tm/dF0TOWq
	 kANEkGN+yhjnsapOuj6BkRIjeFPxH4m5ZeyAo5X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0992/1005] ksmbd: fix out-of-bounds read when padding the final compound response
Date: Wed,  4 Nov 2026 16:12:05 -0500
Message-ID: <20261104211110.823433885@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 714f27729121d59f103ca4dad7b0c2d1c125cd71 ]

Compound response handling pads the last response of a compound to an
8-byte boundary by growing the final iov and the RFC1002 length.
smb2_allocate_rsp_buf() allocates exactly response_sz. A command can
fill the response buffer to within 7 bytes of its end, for example a
QUERY_INFO whose output is bounded only by the space left. The padding
can then run past the allocation, and ksmbd_tcp_writev() reads those
bytes when it sends the response.

  BUG: KASAN: slab-out-of-bounds in _copy_from_iter+0x744/0x10e0
  Call Trace:
   _copy_from_iter+0x744/0x10e0
   tcp_sendmsg_locked+0x2290/0x3f80
   ksmbd_tcp_writev+0x10c7/0x1ab0 [ksmbd]

Allocate room for the padding when the request is a compound, as
smb2_read() and smb2_read_pipe() do for their payloads. response_sz is
unchanged, so commands still fill only up to it, and kvzalloc() zeroes
the padding.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Adjusted context to retain work->conn->vals->max_trans_size instead of vals->max_trans_size. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -539,7 +539,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 	size_t large_sz = small_sz + work->conn->vals->max_trans_size;
-	size_t sz = small_sz;
+	size_t sz = small_sz, pad_sz = 0;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
@@ -561,10 +561,17 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
 	}
 
 	/* allocate large response buf for chained commands */
-	if (le32_to_cpu(hdr->NextCommand) > 0)
+	if (le32_to_cpu(hdr->NextCommand) > 0) {
 		sz = large_sz;
+		/*
+		 * is_chained_smb2_message() pads the last response of a
+		 * compound to 8 bytes, which can take it past response_sz.
+		 * Leave room for the padding. kvzalloc() zeroes it.
+		 */
+		pad_sz = ALIGN(sz - sizeof(__be32), 8) - (sz - sizeof(__be32));
+	}
 
-	work->response_buf = kvzalloc(sz, KSMBD_DEFAULT_GFP);
+	work->response_buf = kvzalloc(sz + pad_sz, KSMBD_DEFAULT_GFP);
 	if (!work->response_buf)
 		return -ENOMEM;
 


