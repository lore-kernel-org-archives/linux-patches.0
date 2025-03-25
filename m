Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B9D25DAEB;
	Tue, 25 Mar 2025 12:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906444; cv=none; b=GKyhBL2lDpEsqjcC7TJZ8WM2qiV/ntaYdUmTkC11c/Zw+HD9cQL0kHtln3SwfbdDa6SNKiETZVHxjUgEqObWH5i7t2OAGPBwZBaSDtelEt7F6ROVxhnDitnNW4TjurSQ5UvSzyOHSfbgVTJLHjgIIjhu5eFbLJ+buBhfm5A7YRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906444; c=relaxed/simple;
	bh=sJxuaeA48g/5j3wYwYqSzEiVAFVGFhcSKE9MDHjweSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAAsJoz4WbtyO4TrD/Ig7lbzfamdNojVF2NrRHkHPa1cnrZARMTv9GRQXprxEE5pKZKG6wXZr50gycuSEiM9VoLF0Dzrlm7MbZfHhEd377xBMerPxXZLeriG697ich8nP2EW3L2FKgdjRbvLPjpktWkOUsOUL0cIMfi9RpaPTJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vrfb2Jxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vrfb2Jxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C29C4CEED;
	Tue, 25 Mar 2025 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906444;
	bh=sJxuaeA48g/5j3wYwYqSzEiVAFVGFhcSKE9MDHjweSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vrfb2JxtfNNkv2I3QFkabC6ogSpLPpTeB8Blr0kgfwhbTnIMHaS1fX8ddbG+xbTgo
	 Uh7FRGE+D57atbK83ltx0Jjqdt03pK2dpT59qNx+5siAwER5zuRRye9pC3p0suQjFR
	 /yNGWHK6h6m1RoPsay8zSN2wNkJVDWPbHxPUFKV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 103/116] io_uring/net: fix sendzc double notif flush
Date: Tue, 25 Mar 2025 08:23:10 -0400
Message-ID: <20250325122151.838023085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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
@@ -1427,6 +1427,7 @@ int io_send_zc(struct io_kiocb *req, uns
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(zc->notif);
+		zc->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
@@ -1487,6 +1488,7 @@ int io_sendmsg_zc(struct io_kiocb *req,
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(sr->notif);
+		sr->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);


