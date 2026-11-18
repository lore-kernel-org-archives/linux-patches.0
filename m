Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035598;
	b=k2rjkQAmKEyd9OAb1ZLM6LRGtwJSsKre7mqR9StR+retRfGtJAoSBYkN42Puxd/OMwrU
	 545dzfEr4gm7/u2WUvcgNpIOvClRytj9lKmG9qI35NBm7AAE56wkC+nojxw7vgN5z8RY5
	 ggvHJUrgpxcRtVihlQjvf7MOQqqw8wd0nijniQIXgzEbV/dE23E+q2MpWesfUUVY+QamX
	 Tb747JBDPH3D9/YqCzjgQDMqZ8b/s2JeZm2JlLfOW64dH0ZDXfhNKqfw1T4po57EMZAg8
	 qPb/mSsv6xVA1cLoUtVMxXROnBLtQibAJizedbxrsXFL3DgSib/jSOylxOtoVgyO/PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rGJfd73FuVQ3FsJg86uZdbOlD11MQDY++ZPVCUN4rY=;
	b=t03h0EYRp4XcD0TIoWy5dhid+2XVb+niIrQhuHIneWSXxKbFvLBd6BAX0TM9J9cJ0Xm1
	 4pYUfNqmNensAoNv3tkO5Ye9gRUACCUIH4EWZO1prCdrVsQurTc6HEnX848gw0w5jOZdy
	 ggmOxOo6COreDOXd3EiX52YuWwzd59cYuE6hyfAOXWMlmVg0VDKwDaYolmHpA6sPAclLH
	 VDKTFwKIPjHaA3xh2Brq6GIptvhBnMkgT+EIHJMJG3VTaM/oauvh3sMJD3vy/X3EAyLie
	 1oRSsSGXzm5yzTATakL7hHthjxFIPvU2W5+JWOb3Qn2frE1bXxORIMleVkc5Casy+OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hezfIUHx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E90606A31C;
	Wed, 18 Nov 2026 20:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hezfIUHx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D511F000C4;
	Wed, 18 Nov 2026 20:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035598;
	bh=6rGJfd73FuVQ3FsJg86uZdbOlD11MQDY++ZPVCUN4rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hezfIUHxTrJWrCB2SKNJL3BxZnRlUzOS2l+dmTwYfmWd6Rf44VIZzX9PuyQwp6NwA
	 ATQkN1ZhtDrGKdCow9w6L8evxftGUeJ7YMSB8lS331jDEjHyN+AkwZcwBjU3C7GDZz
	 87K7CmxZjAWL2oZrAU992P5WY1d3qdWkzDzND1ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0762/3318] ksmbd: fix out-of-bounds read when padding the final compound response
Date: Wed, 18 Nov 2026 15:23:04 +0100
Message-ID: <20261118150341.575942314@linuxfoundation.org>
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
[ sashal: Retained direct work->conn->vals->max_trans_size access and GFP_KERNEL instead of the local vals pointer and KSMBD_DEFAULT_GFP. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8bd4e2c1e12d6..bacdbd76ad8e7 100644
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



