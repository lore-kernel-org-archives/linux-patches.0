Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4932F75A;
	Mon, 29 Dec 2025 16:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025483; cv=none; b=bzcgGDwXUNXapF6odzN7UWXPeY+QwiOER4hHljuUwbIMtHLzIqC0Hag1duQ7p2vfDVCyiRNZ1/qgZUDoTZCJkimw2fwN5WJUAt3sSAWG+g/KF95nqg0XXEExuakZ4sh/krc+DKMsN9E802mQp6Ev4SrrSoHoaOi1ZXvR6y3s1AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025483; c=relaxed/simple;
	bh=VPCgSvQP5vHUT1kQBdJVS5WHcOu5O7ScbO9AZlDnPVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3CR3tYG7GZwx8LaUW7gdSltNFh6vaTXMe8z6ON/2OIYRHpsTvWBsDxQWQiku0J128GyXofRSrYBe8HnR+md2O6obf+lGne0fW8af+Z/9ii0b7YBUwAW7pyZZj6/pSshyjYtyiumFiV9ffc+vjP/2gTYroN/Xg2Gg6KN5q2Erws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHEtvG5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHEtvG5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BC0C4CEF7;
	Mon, 29 Dec 2025 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025483;
	bh=VPCgSvQP5vHUT1kQBdJVS5WHcOu5O7ScbO9AZlDnPVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHEtvG5iRjaSSNa+eJ2WH8xxq93TYYp6edQCowEYzCUR9QYgSDw9m4+yDRG2sTcTx
	 ogjnI4LMq58K3e9lt2FAJO5mzG8fGPdBoeFr3ypaMhFAUbXFuBzaLR14ojJjr7xmft
	 m4o1gqvav0/OdNAttjQHZmxPKHYT9eCjXAamLs3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 229/430] io_uring/poll: correctly handle io_poll_add() return value on update
Date: Mon, 29 Dec 2025 17:10:31 +0100
Message-ID: <20251229160732.782774359@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 84230ad2d2afbf0c44c32967e525c0ad92e26b4e upstream.

When the core of io_uring was updated to handle completions
consistently and with fixed return codes, the POLL_REMOVE opcode
with updates got slightly broken. If a POLL_ADD is pending and
then POLL_REMOVE is used to update the events of that request, if that
update causes the POLL_ADD to now trigger, then that completion is lost
and a CQE is never posted.

Additionally, ensure that if an update does cause an existing POLL_ADD
to complete, that the completion value isn't always overwritten with
-ECANCELED. For that case, whatever io_poll_add() set the value to
should just be retained.

Cc: stable@vger.kernel.org
Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Tested-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -936,12 +936,17 @@ int io_poll_remove(struct io_kiocb *req,
 
 		ret2 = io_poll_add(preq, issue_flags & ~IO_URING_F_UNLOCKED);
 		/* successfully updated, don't complete poll request */
-		if (!ret2 || ret2 == -EIOCBQUEUED)
+		if (ret2 == IOU_ISSUE_SKIP_COMPLETE)
 			goto out;
+		/* request completed as part of the update, complete it */
+		else if (ret2 == IOU_COMPLETE)
+			goto complete;
 	}
 
-	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
+complete:
+	if (preq->cqe.res < 0)
+		req_set_fail(preq);
 	preq->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(preq);
 out:


