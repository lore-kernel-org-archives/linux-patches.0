Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5AC4DAF85;
	Thu, 17 Sep 2026 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660388; cv=none; b=ItmxXxf35aEOeR2s94CVGT5qZmDlVKKJRWnTUA0mdkQd/SmrmJJTHIQhNKGB1fYiimvgj/z/YePIKySX+pocr/LfZZhBWuqhvLONJt1BI76yLDW3APSxPka76MRl8a+Lj1/lx084lDFW6Mmo6Z6Wo1b5APJqy27eC7/miotxKRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660388; c=relaxed/simple;
	bh=Go/JfwXP4ymwmHOFxaK5pR9Uv8yjYqdMb5LNsPJAVng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ea/ZrNZSCLdYxtJ/1wa67tJhhlZKZk3YjLjv36xw8fgZ3d1EK6AN2LIS6t7E7lgE6SIy/elCWlqWZzTlbbvvORAt9pTmpOF+iyrVs6f+TdUdM42QqtdpQ3Ay/nFdoNPhFPINHMvd+kaMDP+2ueFpWWwuDfpbg9vIwK6nUcxxzpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLWOZ3Ah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLWOZ3Ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0F61F000FF;
	Thu, 17 Sep 2026 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660386;
	bh=InsYiR7Nrvut5jOdWM8dGyD8Nm2BZbgsllLW+QGRJjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLWOZ3AhCAxcVrml4oPRvrzvIEPapmwi3HCc5QvdbQGL1+b3CTwUEDj0tQoNFyhCc
	 IZAZJ88K5c8lREQCL7aNGsxVNyQvF6V/w8l4mqfQUlHImjYpC+QeNSSyBrft2Zf/Da
	 s4XYhhCIwgAZNBPLITrFxz1zyTD0oKZnFUlVsVyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 538/733] io_uring/net: let io_recv_buf_select return the length of the buffer region
Date: Thu, 17 Sep 2026 16:14:06 +0100
Message-ID: <20260917151405.627340786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

commit dcbd1c054848848a1937ca0768ce2bdbc31ae621 upstream.

In preparation to using this field as an upper limit to truncation,
return the size of the allocated region.

Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260902230041.1320658-2-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1139,6 +1139,7 @@ static int io_recv_buf_select(struct io_
 			      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	size_t len;
 	int ret;
 
 	/*
@@ -1184,13 +1185,14 @@ static int io_recv_buf_select(struct io_
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
-			sr->len = arg.iovs[0].iov_len;
+			len = sr->len = arg.iovs[0].iov_len;
 			goto map_ubuf;
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
-				arg.out_len);
+			      arg.out_len);
+		len = arg.out_len;
 	} else {
-		size_t len = sel->val;
+		len = sel->val;
 
 		*sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel->addr)
@@ -1204,7 +1206,7 @@ map_ubuf:
 			return ret;
 	}
 
-	return 0;
+	return len;
 }
 
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)


