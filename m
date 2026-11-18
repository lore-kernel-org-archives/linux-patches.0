Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044746;
	b=WS8HHCWu2Qjye+HhO5OoMRc6R0Yxw1sTtWXPxp4JuAInj/0GHBJyCxxTrW3NbW0snUCZ
	 ofhjS/mB6gYUn0yXHS8aLCyJ5l18u+lbQCXtFTGrTBNkbgkR4kCx0OcTXZ3H1oWez/0wV
	 HE+0VzVNCOPgF1A9fUhZAm5TJMGsYP9g+Nmt54RaVHvCf4g5ANwF79ShB6tF7r3+EqBET
	 uEsUydfcntMz/2DKEyaLVFjd9tvkUzoVmK5/0vp2aMYQAJNwgMf4bBLrmvr5H4XuoTexH
	 0BZxdnwlb6HM1xGmLi/gwlqNVFlR0uVcsoTYjwSmX1775Obp6nHVaI6AkFhWbQ2p9IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R45pvSStZAG5wL0ULMgOPrcXt8IYlooywnmXlKs93Hw=;
	b=MKypNwWeO6WTG7yYKSPZteyKECoXVNTnwgYjQVJXCkIbMduZ0bAwoyM94AFJK3/xcyYh
	 eGwn7SNjFBwcVqnxzWMqm918ipC7h+3sNvdqq0oS0RGgBuj4AJIKCbaWYdMA56x5MxXV4
	 dyPlGXOiRY9r2/pMZnJ1d2nNNGvmX47eKm3Bz4MNHUlBjSpngf9tZv185j1SrlSwZkm5U
	 P15NYQS92083XaMzHdW887KTMOLdsnnEkR6EM86M/oPbX+OZG0kUUxEuuduQ8NoCLGxR8
	 V7YoNsWLYCAVPzUvIvPD7q+p91meLDDQ7IXtGGqSDEf9JxisKCJpF/vnjoyUGOPtUQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WV7+BBSF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5BE606A33D;
	Wed, 18 Nov 2026 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WV7+BBSF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A33E1F000CA;
	Wed, 18 Nov 2026 23:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044745;
	bh=R45pvSStZAG5wL0ULMgOPrcXt8IYlooywnmXlKs93Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WV7+BBSFHIHnbvSPom9n0bEzg3ToJ/dUGZ3o0gd3Ljj4jBJLfpHjcaZGAxjH59v0n
	 0qUvaSn2FvISC3QzhoqOAVbgxDY8ENL/GCpYEJoSdN8MVcYgkH8anIXsqun1XqcLCJ
	 FFeOS/Ta3f0rBPHKr2KN5xlST+2f5GQS6p33ZRUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0674/2857] ksmbd: fix out-of-bounds read when padding the final compound response
Date: Wed, 18 Nov 2026 15:28:28 +0100
Message-ID: <20261118150225.830029151@linuxfoundation.org>
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
[ sashal: used GFP_KERNEL instead of KSMBD_DEFAULT_GFP in the response buffer allocation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6b24448a55e18..2e9e4d7581c0b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -538,7 +538,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 	size_t large_sz = small_sz + work->conn->vals->max_trans_size;
-	size_t sz = small_sz;
+	size_t sz = small_sz, pad_sz = 0;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
@@ -560,10 +560,17 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
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
 
-	work->response_buf = kvzalloc(sz, GFP_KERNEL);
+	work->response_buf = kvzalloc(sz + pad_sz, GFP_KERNEL);
 	if (!work->response_buf)
 		return -ENOMEM;
 
-- 
2.53.0



