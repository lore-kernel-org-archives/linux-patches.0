Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3271BC8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1694C433C8;
	Mon, 26 Jun 2023 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805028;
	bh=E1fO1tt4fUwGv2DQigrQHa/p/so8o+gzWkZ7OFxdBao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hi0EHrkOSS96zIdvUfVmiegI7UDz+hGxeqRE/caLXGUU/uvDzgIoKk6uFhYqhNhlC
	 gfAxdm2bZxRRnn732d3ZCnbMe46yY5aAr51mtMmbkPEsh0R9c/JbVmme2PwpgjYbjU
	 Pd5FEczJhh7b23luBjQ4+7a6wgTBRuXTuYxSP3go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 25/81] io_uring/net: disable partial retries for recvmsg with cmsg
Date: Mon, 26 Jun 2023 20:12:07 +0200
Message-ID: <20230626180745.519692460@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

Commit 78d0d2063bab954d19a1696feae4c7706a626d48 upstream.

We cannot sanely handle partial retries for recvmsg if we have cmsg
attached. If we don't, then we'd just be overwriting the initial cmsg
header on retries. Alternatively we could increment and handle this
appropriately, but it doesn't seem worth the complication.

Move the MSG_WAITALL check into the non-multishot case while at it,
since MSG_WAITALL is explicitly disabled for multishot anyway.

Link: https://lore.kernel.org/io-uring/0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk/
Cc: stable@vger.kernel.org # 5.10+
Reported-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5053,7 +5053,7 @@ static int io_recvmsg(struct io_kiocb *r
 	flags = req->sr_msg.msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
+	if (flags & MSG_WAITALL && !kmsg->msg.msg_controllen)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,


