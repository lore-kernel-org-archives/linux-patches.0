Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4111B2566DE;
	Thu, 17 Apr 2025 18:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915810; cv=none; b=sQUEm7rRf2P5hufv7dQHcUdjlweI2yBMfpDZeTFVx++X/+xOdLI2iLuCJHMO5jqOkm+Ra1JJfGIGBeas1+FMikckO3lIGdDBXyuR+tDQG4wp+mY7ei14Q+hzV4oouXeM7EzFbp9AXbkJ2h1Kxpyn6nvCl0yrdANHd50pRhAVicw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915810; c=relaxed/simple;
	bh=4GRpzLjJK6kJK7qddnQRiVa/TywQdytI5JXp+42zzFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4Ym2XOoy3MEqzK6p4ozz+fbq87eX2oVWR9eHiOjs2nNuBgfepDcbrzg6AAA+6c7oKSYjjUwysjBxxbeUYBHSo66bSHeGbJKVf8ZCcxx3yDpD6jKLne1ugGNE65namNKLZ/0Ehe9UIhvxtguUe6niuuaQuP+A/uG1ygfNF+wveU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlEE6U5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlEE6U5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB86FC4CEE4;
	Thu, 17 Apr 2025 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915810;
	bh=4GRpzLjJK6kJK7qddnQRiVa/TywQdytI5JXp+42zzFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlEE6U5r/GaIgJDMflgoILqtSSSx8evLWoxC8n9hypV+xx2M+XivLXih2t/5TkIkl
	 u+ebGORqKcb0/KydgNYDyudnwIybWrd9mtgZEvFDmOjoIOXeroHo9aMpvIoKOCE4/9
	 arawv36pb+ZNt+mijcgq68NFGVQaZmqQ6m/IyPPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 247/393] io_uring/net: fix io_req_post_cqe abuse by send bundle
Date: Thu, 17 Apr 2025 19:50:56 +0200
Message-ID: <20250417175117.526510363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -457,6 +457,7 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
+	REQ_F_MULTISHOT_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
 	REQ_F_HASH_LOCKED_BIT,
@@ -530,6 +531,8 @@ enum {
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
@@ -1821,7 +1821,7 @@ fail:
 	 * Don't allow any multishot execution from io-wq. It's more restrictive
 	 * than necessary and also cleaner.
 	 */
-	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+	if (req->flags & (REQ_F_MULTISHOT|REQ_F_APOLL_MULTISHOT)) {
 		err = -EBADFD;
 		if (!io_file_can_poll(req))
 			goto fail;
@@ -1832,7 +1832,7 @@ fail:
 				goto fail;
 			return;
 		} else {
-			req->flags &= ~REQ_F_APOLL_MULTISHOT;
+			req->flags &= ~(REQ_F_APOLL_MULTISHOT|REQ_F_MULTISHOT);
 		}
 	}
 
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -435,6 +435,7 @@ int io_sendmsg_prep(struct io_kiocb *req
 		sr->msg_flags |= MSG_WAITALL;
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
+		req->flags |= REQ_F_MULTISHOT;
 	}
 
 #ifdef CONFIG_COMPAT


