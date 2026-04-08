Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49773D75AF;
	Wed,  8 Apr 2026 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673598; cv=none; b=Po/2j+p9PlS+Hv3+/M/wLowLcacX3ZwE0p6hJ2FPsx1oXXMlh7IGLgjra54qBjEFqvNmh4L7C3h5gbKpowOY3GtogBwTB7vzpyQwnCxyC/n1C/X9vGRupz82WUBd9Jqn7nC01gm+vSk+azkxxhpfLHHevEInvJxW7YwlxHNzxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673598; c=relaxed/simple;
	bh=Rglg6x+t1cvF7PJbP4VdiLlVef+qlGCtBmxi2wllPvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLtMx8pqLR2GkOiel3XGIMY2FCNuSFuJ9Dd36+W3zEgKuW4cl5RxgTiMblQlh+ANEJ8wTKd4zexhqQKQVcNWFH6YBKNYQoQ+LmHPD3W4wQZmLBjoUldeA9ZaLIHMUsJY79Ju0PF0PUAfTJrhin6ILauqW464/uByAthmnULTwNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPlHYsVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPlHYsVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3B8C19421;
	Wed,  8 Apr 2026 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673598;
	bh=Rglg6x+t1cvF7PJbP4VdiLlVef+qlGCtBmxi2wllPvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPlHYsVdN8clZqVej12sbctYyhw43836NtRZWhPdXojRnWkVhlWd3axgimlmBXxDp
	 eVywcD4WzZWp9RHd7RzjHYD7ACkEvXk19yHOg3F9WI99ToDOFYd9R6J0Uy3eaxwWAc
	 Y8I7GJlX4MvVDTB4R/u21dLhB9PeDDoE+tJfRJXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 017/242] io_uring: remove async/poll related provided buffer recycles
Date: Wed,  8 Apr 2026 20:00:57 +0200
Message-ID: <20260408175927.716757470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit e973837b54024f070b2b48c7ee9725548548257a upstream.

These aren't necessary anymore, get rid of them.

Link: https://lore.kernel.org/r/20250821020750.598432-13-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 --
 io_uring/poll.c     |    4 ----
 2 files changed, 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1921,11 +1921,9 @@ static void io_queue_async(struct io_kio
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
-		io_kbuf_recycle(req, NULL, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-		io_kbuf_recycle(req, NULL, 0);
 		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -356,10 +356,8 @@ void io_poll_task_func(struct io_kiocb *
 
 	ret = io_poll_check_events(req, ts);
 	if (ret == IOU_POLL_NO_ACTION) {
-		io_kbuf_recycle(req, NULL, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
-		io_kbuf_recycle(req, NULL, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}
@@ -753,8 +751,6 @@ int io_arm_poll_handler(struct io_kiocb
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-	io_kbuf_recycle(req, NULL, issue_flags);
-
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask, issue_flags);
 	if (ret)
 		return ret > 0 ? IO_APOLL_READY : IO_APOLL_ABORTED;


