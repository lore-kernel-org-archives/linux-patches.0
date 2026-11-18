Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051980;
	b=TnEnBBY09VKBtr0o2Ftb8y/V4IStslmYzhJnj5Ll5hOr2VO3fPr3WrDK9iIFoHlD6ZtM
	 E5yx5BYKAO2BjCUxKzhfRB8DW0p8MEk5cXYGVOaNc3wYJLu8M0qcMLXOU5tT4QhVXl2i3
	 vaRHbehSNDjYZpPne1GVhk01Yds/8oxJDbIkOssDqNFEIx+R2YJxCmRZOJiAotrcM+P0s
	 9BFBErFcwbuXhKbAEhEJqkFr/+FdtnYCRyKcoiz6LUqo4UC0QZYWhzshcHphPwtgO1zdW
	 g0doTII0pp1GfvE5BDIDqvnoJ17CyvuEDqTAa1HoKD7SAGsBfpbFOj0WGgtH2Cua1Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hW3H5DSP8CKqJuWDJl4vVEklKCmKuRDaOR/UqpTmEM0=;
	b=0a/5IdXnujJewbLEF48yF/u/cyJvXZ+HSS7F39UKxOhn7T2ZTs9ziiU12C3A7YtoRhjA
	 GfRPAFfywvpDNlzzMP4FyKiWWfgGVqD0K3sDFhytTVgNnlI7ZLLhFLyBlkdxRwreG5YsZ
	 DpZaRjislW0wzgasQSA3tt1FouinZwRvMpRzuY2O/memxMfyG7+I3IYIotuWjxUxYRKTw
	 6AFAtOhglXzC+/U+V/81lPPDPyeBk6CzzIXGOd+gXP3s8HROqjQWRfRZXtGVl5vYjPZ07
	 YR4+ZJsIHaIBgfgRMKfykrtn1EHWRtaFralpV8YHZUWvqxJdXm90of1T0G+dmQKHrCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ENzUmlJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27653606A325;
	Thu, 19 Nov 2026 01:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ENzUmlJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9461F000C4;
	Thu, 19 Nov 2026 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051980;
	bh=hW3H5DSP8CKqJuWDJl4vVEklKCmKuRDaOR/UqpTmEM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ENzUmlJzCIGVr+atlI16BT7GFk5/Qmyup2OTENmn6SkFY0oMLZ8fdm7PEAhm+dwS
	 fFG7IgrJoKVL7urv8yRkH5uhyjSrbJ8uL4+Dqx/kp1nr9+sZ9EjivxFVQK4HpEfwBV
	 KVjl1x7vyhuxp2xdHtDHVHMU584/DP/0F7rIpNH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0400/2214] ksmbd: fix out-of-bounds read when padding the final compound response
Date: Wed, 18 Nov 2026 15:34:36 +0100
Message-ID: <20261118150026.763765949@linuxfoundation.org>
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
[ sashal: Adapted buffer allocation to use work->conn->vals->max_trans_size and GFP_KERNEL instead of the local vals pointer and KSMBD_DEFAULT_GFP. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c2162321bd722..eec98bbe4e788 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -532,7 +532,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 	size_t large_sz = small_sz + work->conn->vals->max_trans_size;
-	size_t sz = small_sz;
+	size_t sz = small_sz, pad_sz = 0;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
@@ -554,10 +554,17 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
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



