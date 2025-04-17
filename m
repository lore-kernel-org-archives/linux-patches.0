Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27071E98ED;
	Thu, 17 Apr 2025 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914586; cv=none; b=twKvJlaU+r5DVnlG/KeskusKfqMKTspnu4oY36s00IhP1ttaf43LEsZYwGMieCm3+FnFLy/+k+IOezUC3FunVph2ykIe61GF8W3MvnK9SL3vc5BZA77qdBcR6UG8AmliTZVPTWeRm+hsoqIBlQ2uIP831EXsi38uUFgglqAR1VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914586; c=relaxed/simple;
	bh=ftLJXzx7oae0qHcUynudvKEg1ewyspXs0kIFg112EMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQJjJNV9Ey1mImIiegZ/GFAYqWyOA2R8uk0MI6DMIpvS4LdHnF1TA5/9RAFA2NmDmFI3EnhfOO8ig3P/VeBKFENdlV2vhaPPGwPPdFB8LBtVylojawagad9lVScL2Iy0lNgTtOayKt7MrPo1LR4ZuMX34R348XFSLM6XdXiZmAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj65jaTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj65jaTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44317C4CEEA;
	Thu, 17 Apr 2025 18:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914586;
	bh=ftLJXzx7oae0qHcUynudvKEg1ewyspXs0kIFg112EMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aj65jaTN4K7L+6f8L3k0G1KLeuEsZ+CTBeUYg8KYdqRjOeRfyP4m9XZRYcT3Sn+fK
	 0jzw34avyJ0hTBS6ST24Sl5c+VgVaKP+4G7hFTc+JzlCxynf71lMP6pDe5+Z/VOElk
	 f7QUtI73MubibzJoBLsD3/weVqVxYmvirAlf7VbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 264/414] io_uring/net: fix io_req_post_cqe abuse by send bundle
Date: Thu, 17 Apr 2025 19:50:22 +0200
Message-ID: <20250417175122.048822861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 6889ae1b4df1579bcdffef023e2ea9a982565dff upstream.

[  114.987980][ T5313] WARNING: CPU: 6 PID: 5313 at io_uring/io_uring.c:872 io_req_post_cqe+0x12e/0x4f0
[  114.991597][ T5313] RIP: 0010:io_req_post_cqe+0x12e/0x4f0
[  115.001880][ T5313] Call Trace:
[  115.002222][ T5313]  <TASK>
[  115.007813][ T5313]  io_send+0x4fe/0x10f0
[  115.009317][ T5313]  io_issue_sqe+0x1a6/0x1740
[  115.012094][ T5313]  io_wq_submit_work+0x38b/0xed0
[  115.013223][ T5313]  io_worker_handle_work+0x62a/0x1600
[  115.013876][ T5313]  io_wq_worker+0x34f/0xdf0

As the comment states, io_req_post_cqe() should only be used by
multishot requests, i.e. REQ_F_APOLL_MULTISHOT, which bundled sends are
not. Add a flag signifying whether a request wants to post multiple
CQEs. Eventually REQ_F_APOLL_MULTISHOT should imply the new flag, but
that's left out for simplicity.

Cc: stable@vger.kernel.org
Fixes: a05d1f625c7aa ("io_uring/net: support bundles for send")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/8b611dbb54d1cd47a88681f5d38c84d0c02bc563.1743067183.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 +++
 io_uring/io_uring.c            |    4 ++--
 io_uring/net.c                 |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -470,6 +470,7 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
+	REQ_F_MULTISHOT_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
 	/* keep async read/write and isreg together and in order */
@@ -545,6 +546,8 @@ enum {
 	REQ_F_SINGLE_POLL	= IO_REQ_FLAG(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
 	REQ_F_DOUBLE_POLL	= IO_REQ_FLAG(REQ_F_DOUBLE_POLL_BIT),
+	/* request posts multiple completions, should be set at prep time */
+	REQ_F_MULTISHOT		= IO_REQ_FLAG(REQ_F_MULTISHOT_BIT),
 	/* fast poll multishot mode */
 	REQ_F_APOLL_MULTISHOT	= IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1818,7 +1818,7 @@ fail:
 	 * Don't allow any multishot execution from io-wq. It's more restrictive
 	 * than necessary and also cleaner.
 	 */
-	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+	if (req->flags & (REQ_F_MULTISHOT|REQ_F_APOLL_MULTISHOT)) {
 		err = -EBADFD;
 		if (!io_file_can_poll(req))
 			goto fail;
@@ -1829,7 +1829,7 @@ fail:
 				goto fail;
 			return;
 		} else {
-			req->flags &= ~REQ_F_APOLL_MULTISHOT;
+			req->flags &= ~(REQ_F_APOLL_MULTISHOT|REQ_F_MULTISHOT);
 		}
 	}
 
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -441,6 +441,7 @@ int io_sendmsg_prep(struct io_kiocb *req
 		sr->msg_flags |= MSG_WAITALL;
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
+		req->flags |= REQ_F_MULTISHOT;
 	}
 
 #ifdef CONFIG_COMPAT


