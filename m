Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829238;
	b=35xN+QsLB/4CLQRTWidGsUEPusJlUUNck7jMEqTpxy5CHfNMgp1YdxLOWPVqpALlx1sF
	 zC0B77PEPGyOmqH4IcyqYVALoEsneXh8u+VmMUx7qnxCAn/Ne8lKUFkC5OEPfGg93lgEa
	 ou0R53hmMAEYK6TeAB373lWGr7hVRG1OF9wncq9a8dTpsoc8EV/JAjUD0MtEIcYDySkNo
	 Kx7CNg1/kt3p7cJMLALkyAWE1bju0qcKzzqQB20eMdJO9hiivVBDs8WJlusxf7e9zsJ3W
	 UIHb4AT/7ycM2idwfoa2aoQbII+PCJxBFa8egK7rjpRGv1orcKnj/ge8d0rrtuyyb2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5hRBBz2JCPMTXqT4AXbr1pfNeq2E4e5xXjeKkHK+MYU=;
	b=lgiTZIRKzEKoG4aGLw4cjw81SYQLM5bbjbCt2tOYmQFJTgMyuxeVA7tjgHpvkYbf1del
	 MOamhureox1ND3AP1CHCHQMQC9Qqdybz0V8kRgXqKyzpm2YTkS3NnVDjIqtM+M+IOSrXJ
	 dq+K4WhnYjYlUkRTIFO/EajqXsLrOMA9sE8MlXmmHnujwiaqVnuXhJuKoNbhOmvKq4wnW
	 5xBTE6xhx1rTzaAqcETzQpLmJpzyitajfuPuTjjICHr6A2f/H1Aho3CNUGTM8NFiAAI+3
	 6OiYkBQ/KSHxQOw6ci9zmvUeJ9m5ckiES5gketioCabC5RzO7+Trep9m0UIOExelpiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLOZYLji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8AD606D80D;
	Wed,  4 Nov 2026 21:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLOZYLji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AE41F000C1;
	Wed,  4 Nov 2026 21:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829238;
	bh=5hRBBz2JCPMTXqT4AXbr1pfNeq2E4e5xXjeKkHK+MYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLOZYLjiaZHZ88+VEOP0Wd0rMsjvcqZdt0hGj6YY3i+Scf2lA7Awi+Ckdhm1ngb6A
	 ORI74VIFxNJHJjEMj2NKcwqSViQI+BVM5FQtjB81Lpz2oPC9YU6jXHgTodV/bOTH/a
	 fTGF5R6UoA5gmsppKf2/E6B8r6WqpVKMPrRoBRHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 535/547] ksmbd: fix out-of-bounds read when padding the final compound response
Date: Wed,  4 Nov 2026 16:11:59 -0500
Message-ID: <20261104211053.594976198@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -876,7 +876,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
 	struct smb_version_values *vals = work->conn->vals;
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 	size_t large_sz = small_sz + vals->max_trans_size;
-	size_t sz = small_sz;
+	size_t sz = small_sz, pad_sz = 0;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
@@ -902,10 +902,17 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
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
 


