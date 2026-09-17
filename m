Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E3A4B44CF;
	Thu, 17 Sep 2026 18:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671164; cv=none; b=BJdku+E1BsXBqS7fzwO8Qls8rYBpNMeGGaevlv+OWiGQe3AEfvjuj2HJfLPrG0nh0XklYr7gFzNk9wihwNhFcHUK/DfdXg9AMalJjyHYeGvIRy1oAzpFv/RVFMoa9xvnyco93QYR680hI9YD0JWlMU0lJ6GPB2JVsxhHtCnKXbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671164; c=relaxed/simple;
	bh=ORwi2dF438fIqWLuuRUd5/AONVhnRxTfy4+JX8HXuIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQowcGvssMbGM1k40rISesmjW2VB1qv2bdNr+AyKPoi5R6KMMHJGnAYDdXxCL+xUJgHI3XgJZnNnxI095F2qbn5O3npHU5wES5mw4WaD5/TjSeV1SQhDCIrrZ0e+VslqJlTOFT1sxgFKvrQgj2PYMutlwSffwuE5G4IKOcqdKMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DobQpio2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DobQpio2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8401F000FF;
	Thu, 17 Sep 2026 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671162;
	bh=Z/cphjMy+rB8aTLPHkSHiVOH2u9AxbIyPhoZnL4ufRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DobQpio23+K2/7phKDmeZeZUMDcoytESoJJ5o81Gns30nhTwyNjJ2Sd+az6/etkhd
	 4UG1X7KybfyvAs9pE9aOcftv0hezl68NWucxFAZ94DVC9/ZqMlSvWs9F3Ra9cKcp6R
	 V55Idp/mXOna3W6cxtj/pot8ouGN/pZkybJLPY8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0838/1102] io_uring/net: let io_recv_buf_select return the length of the buffer region
Date: Thu, 17 Sep 2026 16:13:01 +0100
Message-ID: <20260917151601.557473303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1104,6 +1104,7 @@ static int io_recv_buf_select(struct io_
 			      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	size_t len;
 	int ret;
 
 	/*
@@ -1145,13 +1146,14 @@ static int io_recv_buf_select(struct io_
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
 
 		*sel = io_buffer_select(req, &len, issue_flags);
 		if (!sel->addr)
@@ -1165,7 +1167,7 @@ map_ubuf:
 			return ret;
 	}
 
-	return 0;
+	return len;
 }
 
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)


