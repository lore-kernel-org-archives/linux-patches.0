Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BC82571CA;
	Mon, 24 Feb 2025 14:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409188; cv=none; b=VkxCNFPq1GZPBS/GMOQ9Jtzi26Idl8Dohr6B9ajb6fGSic2Gyy7zqYekAaT6KeIdYZwZiJAEV4NoFQUjtGAxG9mte8oc8KslPSJP5tvQ9Am4hM+nWG4ciqIPyJRBS31nkPEZ3LAoOgtv9ILEQeYWFJxvaYNqRVzP+uQg3IQskho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409188; c=relaxed/simple;
	bh=M3DXJn9w9royXN1+T2niAuV8xKFWpcYV3LCe0zXd7Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwQj+VIpIBT3/1k0m17uean0x3Kq8/DLWGBHEidyaU1PjIEQnpctBxUeB9tg+Qyv7qEN3f7W+RAxwrKHMrUHnBOvYGLO12sRkV/iaLS1cZo8cCRll4+3WpkjSvcbHFfUD1xW0QikjBdAQO3HAQL8f3g10zXWlrRJwdfOvl8YVJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6kqRA4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6kqRA4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E28C4CEE6;
	Mon, 24 Feb 2025 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409188;
	bh=M3DXJn9w9royXN1+T2niAuV8xKFWpcYV3LCe0zXd7Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6kqRA4/vukf+SCgI89JzqPkUpWdIdz7X9D2EXaa+I8UikWDNDvjw8JR1ig2qSIYr
	 fU7L4xLiKqVHZK6gV5RqEMPaO0GuVyBPe1qgBzFGXnG5bwCU+thlHcDVwQHN8IMLvu
	 xX7amEdB9H6lnaZ8wZooxv2o4PbaPAVf3ZNsVinw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chase xd <sl1589472800@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 095/138] io_uring/rw: forbid multishot async reads
Date: Mon, 24 Feb 2025 15:35:25 +0100
Message-ID: <20250224142608.214313234@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

commit 67b0025d19f99fb9fbb8b62e6975553c183f3a16 upstream.

At the moment we can't sanely handle queuing an async request from a
multishot context, so disable them. It shouldn't matter as pollable
files / socekts don't normally do async.

Patching it in __io_read() is not the cleanest way, but it's simpler
than other options, so let's fix it there and clean up on top.

Cc: stable@vger.kernel.org
Reported-by: chase xd <sl1589472800@gmail.com>
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7d51732c125159d17db4fe16f51ec41b936973f8.1739919038.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -866,7 +866,15 @@ static int __io_read(struct io_kiocb *re
 	if (unlikely(ret))
 		return ret;
 
-	ret = io_iter_do_read(rw, &io->iter);
+	if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
+		void *cb_copy = rw->kiocb.ki_complete;
+
+		rw->kiocb.ki_complete = NULL;
+		ret = io_iter_do_read(rw, &io->iter);
+		rw->kiocb.ki_complete = cb_copy;
+	} else {
+		ret = io_iter_do_read(rw, &io->iter);
+	}
 
 	/*
 	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
@@ -891,7 +899,8 @@ static int __io_read(struct io_kiocb *re
 	} else if (ret == -EIOCBQUEUED) {
 		return IOU_ISSUE_SKIP_COMPLETE;
 	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
+		   (issue_flags & IO_URING_F_MULTISHOT)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}


