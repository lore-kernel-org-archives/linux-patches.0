Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061826;
	b=bINBp7cao8/GqnKSoiaJg3FW8RHTx/PN6k+HQEOesXQF1EOD9Wn8ZYbmpTxZAbcSHP7A
	 bAwfMZv9H17/Lm2UYhgGjfaHNiznymhiN3XBNemkd5m3ASWcvZuV11Ewrr4mYCQKYJqc6
	 YH6qpOvFneKvMdH3cLwt4LWztE904ePa1tEjx4RNgWghKpXpk7gPREDWsEsBsHxWhjx8s
	 Wi8bmvVioCRhkHA7kwwHl06aQAAhkXCXGi3Pe9zNcCCxWPibDMNdSEF2RgVNCNQRjSTrm
	 9OdOHsXrFkIan8PyoQqNx5wQhtgbrQoFVjbUEpBbhzQue5z+VOs+GhfPG1ah7ZlgfXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWODjUy9+ZTPwi6uQERUjjcRoG7en8gclEJcf3YO5ks=;
	b=tL4Qi+rTqKobMY44mTkqAqzbTYqh0XbclVMIE6vw0c+QA+tV4knV7xyhRxiAdpsQdryw
	 uoS+Fm2kFJkHdnzVjPjfYwDLqTBC3k0puME0mXl3PgEwICBO7zKwCd3MAZA7jUPqwbuPU
	 4uH09Xlpe6Ysbgx4/x43fvgnMu7FYoVKBZtaGZC4YB3TglsUCy0CNjzz/AOflNFJsUCpY
	 /qQT+OmmfmiCSGAHsb0MdC2xtFnf9DreG6FLh0w2hgz/PCzc2hmYO6hY8/clKS7tJSc+I
	 hlEvQlL5e8yVWlpDn9MkozzlkMqzHPOXpCJ1W/zNeZdATXsxllD9q1Vy+cKK7eWBDwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNYEEVbt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB44A606A326;
	Sat,  7 Nov 2026 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QNYEEVbt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CEE1F008A1;
	Sat,  7 Nov 2026 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061825;
	bh=rWODjUy9+ZTPwi6uQERUjjcRoG7en8gclEJcf3YO5ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNYEEVbtZllkIOvRQI49fgIhbhcplVFXeW90M2YAIDZiXyyhFICg4dXRneF/OX8Y7
	 hjNRCkOOG4Bfqkw0MP4pZ7xgM5i9i81oFQCsMh+R13dVoRzN7g0wj40G6ejTyUbSqm
	 EAiwVLtF4ytg+BN38voPaBeFyBmFROnmy16S4QIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0848/1536] ksmbd: fix out-of-bounds read when padding the final compound response
Date: Sat,  7 Nov 2026 08:47:44 -0500
Message-ID: <20261107135021.366518395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for direct work->conn->vals access instead of a local vals variable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0ecec7bf31119..d892fd736785f 100644
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
 
-	work->response_buf = kvzalloc(sz, KSMBD_DEFAULT_GFP);
+	work->response_buf = kvzalloc(sz + pad_sz, KSMBD_DEFAULT_GFP);
 	if (!work->response_buf)
 		return -ENOMEM;
 
-- 
2.53.0



