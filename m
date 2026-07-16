Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508323D953E;
	Thu, 16 Jul 2026 13:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210292; cv=none; b=C+aH+2TtIEEo1edD2zjbObuhaktG9vyHAJswLw/SWqoi3oKO2ZalIm2NiIQLp6UFQj65MbMnGnDxZKty8snQQf27DVnrSrZ7AjOalOGvVRIuzKu78nbvuwDQXpeIxWQGkw9a+mchfs5Kk9ukqWpaBqS4YN5tt6/y0wGwIDGWZ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210292; c=relaxed/simple;
	bh=tOr55NMX0KrfnK8gOnM47AZsMTabVWABJ3u0RP3I1uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeuloN1D4O9z7wVcCoCHjgE8WKxUv1trFSimE93gvRO+0iHfdIvCJ7QfzoZlid6Y9Q6fxoxDeO6yUpN4aoXXvgeiBBa/r9CfjwNoMAQ4yvTSK6FcKMUY2hPOuiUXqViSn2jahUiutu7RGadAwig+ca8HjAjTiGpJ4QMx/wm1ZJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5oKIAof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5oKIAof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCB91F00A3A;
	Thu, 16 Jul 2026 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210290;
	bh=Pssu0lmaYJ29emMi1Le7vVjeq0HOerSVFvYepiax66E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5oKIAof2FIBp1QTppRgz6WaQfHXngU/nIqen016Czm5phLMKHtaKcff7iCpgXhcE
	 wd5PsCE3cjBb0J+cYr08PhtMgS75xAEIuFFYmCA1knQnzSfDl74JcSMH/hH9Prgb54
	 lMlyBQulxzGIlZQ4ICQfiaTo+EuTfl7S/F5aNX0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heechan Kang <gganji11@naver.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Jian Huang Li <ali@ddn.com>,
	Horst Birthelmer <horst@birthelmer.de>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 510/518] fuse-uring: fix moving cancelled entry to ent_in_userspace list
Date: Thu, 16 Jul 2026 15:32:58 +0200
Message-ID: <20260716133058.998077958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit 198f45eeb9f78b2a2d6d8be95e4e43468eb2c6bc upstream.

fuse_uring_cancel() moves entries that are available (these have no reqs
attached) to the ent_in_userspace list. ent_list_request_expired()
checks the first entry on ent_in_userspace and dereferences
ent->fuse_req unconditionally, which will crash on a cancelled entry
that was moved to this list.

Fix this by freeing the entry and dropping queue_refs directly in
fuse_uring_cancel(). This is safe because cancel is the cancel handler
itself - after io_uring_cmd_done(), no more cancels will be dispatched
for this command, and teardown serializes with cancel via queue->lock.

Since cancel now decrements queue_refs, fuse_uring_abort() must no
longer gate fuse_uring_abort_end_requests() on queue_refs > 0, as
cancelled entries may have already dropped queue_refs while requests are
still queued. Remove the gate so abort always flushes requests and stops
queues.

Reported-by: Heechan Kang <gganji11@naver.com>
Tested-by: Heechan Kang <gganji11@naver.com>
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Fixes: 4fea593e625c ("fuse: optimize over-io-uring request expiration check")
Cc: stable@vger.kernel.org
Suggested-by: Jian Huang Li <ali@ddn.com>
Suggested-by: Horst Birthelmer <horst@birthelmer.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c   |    6 ++++--
 fs/fuse/dev_uring_i.h |    6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -508,8 +508,7 @@ static void fuse_uring_cancel(struct io_
 	queue = ent->queue;
 	spin_lock(&queue->lock);
 	if (ent->state == FRRS_AVAILABLE) {
-		ent->state = FRRS_USERSPACE;
-		list_move_tail(&ent->list, &queue->ent_in_userspace);
+		list_del_init(&ent->list);
 		need_cmd_done = true;
 		ent->cmd = NULL;
 	}
@@ -518,6 +517,9 @@ static void fuse_uring_cancel(struct io_
 	if (need_cmd_done) {
 		/* no queue lock to avoid lock order issues */
 		io_uring_cmd_done(cmd, -ENOTCONN, issue_flags);
+		kfree(ent);
+		if (atomic_dec_and_test(&queue->ring->queue_refs))
+			wake_up_all(&queue->ring->stop_waitq);
 	}
 }
 
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -152,10 +152,10 @@ static inline void fuse_uring_abort(stru
 	if (ring == NULL)
 		return;
 
-	if (atomic_read(&ring->queue_refs) > 0) {
-		fuse_uring_abort_end_requests(ring);
+	fuse_uring_abort_end_requests(ring);
+
+	if (atomic_read(&ring->queue_refs) > 0)
 		fuse_uring_stop_queues(ring);
-	}
 }
 
 static inline void fuse_uring_wait_stopped_queues(struct fuse_conn *fc)


