Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC22A2580E4;
	Tue, 25 Mar 2025 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906054; cv=none; b=U94UJkLEbDC5OQv+lLEyaEXLJMCBCQvkhaahsNRdPeAOroYM/1Y7nYVHfvB0O56PgwjFHhQuZrFVh35cbIFgow7foJrh3d+hYW5S3BOQ6dWZR06x5xltFO/WeR98xDCLdw9Ruk7hDrv7nRaW3u0Z01fEYnK5mc55wBpga0390+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906054; c=relaxed/simple;
	bh=6g7cu+RNWtlBzoXHntOhNxmX7/a3Q96O6k1F7MpeZzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNUqisg9pbI9VXg3Pz3Da6Rp5uJzwpLVEjWZB0qyuU3KsA1RlGkyXxsttnpdnSygUSfffW0ekNNRlI7o0qksC1WvhIhIGG5WSi8DzUiYyY6agTA/odfQmuV2phZ2KY5MbM092NKZ8yJdhsJfnLkItdGFc9pDMex0aHtPu0idxbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htWziMiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htWziMiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BFEC4CEE4;
	Tue, 25 Mar 2025 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906053;
	bh=6g7cu+RNWtlBzoXHntOhNxmX7/a3Q96O6k1F7MpeZzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htWziMiqk7igM2SSbWeI5e9zu9sqOARLCVEQjB8KRAjQDqTp/r6bj4Bh5tl4X1qnn
	 t27v3jlLvlpGvPdhmCrqjkL0D+fk6w7dyjrlW6ULGG/Mdj+Pl1BdC6LloB5V0YZjJ/
	 md/wq3Gf2EZtASv+x6mBCTmBXM86O2tkI8UCAfbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 109/119] io_uring/net: fix sendzc double notif flush
Date: Tue, 25 Mar 2025 08:22:47 -0400
Message-ID: <20250325122151.838047861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

commit 67c007d6c12da3e456c005083696c20d4498ae72 upstream.

refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 5823 at lib/refcount.c:28 refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
RIP: 0010:refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
Call Trace:
 <TASK>
 io_notif_flush io_uring/notif.h:40 [inline]
 io_send_zc_cleanup+0x121/0x170 io_uring/net.c:1222
 io_clean_op+0x58c/0x9a0 io_uring/io_uring.c:406
 io_free_batch_list io_uring/io_uring.c:1429 [inline]
 __io_submit_flush_completions+0xc16/0xd20 io_uring/io_uring.c:1470
 io_submit_flush_completions io_uring/io_uring.h:159 [inline]

Before the blamed commit, sendzc relied on io_req_msg_cleanup() to clear
REQ_F_NEED_CLEANUP, so after the following snippet the request will
never hit the core io_uring cleanup path.

io_notif_flush();
io_req_msg_cleanup();

The easiest fix is to null the notification. io_send_zc_cleanup() can
still be called after, but it's tolerated.

Reported-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com
Tested-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com
Fixes: cc34d8330e036 ("io_uring/net: don't clear REQ_F_NEED_CLEANUP unconditionally")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e1306007458b8891c88c4f20c966a17595f766b0.1742643795.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1439,6 +1439,7 @@ int io_send_zc(struct io_kiocb *req, uns
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(zc->notif);
+		zc->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
@@ -1499,6 +1500,7 @@ int io_sendmsg_zc(struct io_kiocb *req,
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(sr->notif);
+		sr->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);


