Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DBB8827;
	Mon, 23 Dec 2024 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970549; cv=none; b=iSqPL6/6UXkS/cyDT02C7S07Fsty1mBbK/M+Xtpd4kStILDExURtcdgpPf0vABl8p+wJWIW7yzbi+ANSk3wlS+xodwr71m31SWswyptxlr8SH5O2Eqkd91T6vIupA73efXYwwE2k62bbdVArth/fhDklNOJ1fwTLtipvHGei7ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970549; c=relaxed/simple;
	bh=VGE1m+vaGoAHYdxWO5l/w06P3zFNHkbA31looErgutQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtS6Ui+13IL4m4nCPVEPkKddKYUqSsEaW8FGNWP9wDYGfa1zZkVyphuVjL0GsF7aS/AwLk/QR8oBxdsVi2xOB9sb2iw2cVj3YXQhm/TbCCCBwkz+r1sql740PUddhX/nb6OD+bvHGIXKfkdK5WRGq7Xg404kwwrSIrNBLUJ0zbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVO76wpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVO76wpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A5AC4CED3;
	Mon, 23 Dec 2024 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970549;
	bh=VGE1m+vaGoAHYdxWO5l/w06P3zFNHkbA31looErgutQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVO76wpRvjFweFPclszyNpwananGr8s3DosCq4OWrosXWx2TB2AifaAqmvf+NKDHY
	 Hf6TC9+BqSqJYwJvREd5Sxb0colJ/Wfot/q3HJ+zB96oOzRidIjU2OG5kqqozBLRrG
	 1EEKEkNbNTnxz3EeIZPMfXPmPioGDiaQtRpW+mmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will <willsroot@protonmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 098/116] io_uring: check if iowq is killed before queuing
Date: Mon, 23 Dec 2024 16:59:28 +0100
Message-ID: <20241223155403.372235093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit dbd2ca9367eb19bc5e269b8c58b0b1514ada9156 upstream.

task work can be executed after the task has gone through io_uring
termination, whether it's the final task_work run or the fallback path.
In this case, task work will find ->io_wq being already killed and
null'ed, which is a problem if it then tries to forward the request to
io_queue_iowq(). Make io_queue_iowq() fail requests in this case.

Note that it also checks PF_KTHREAD, because the user can first close
a DEFER_TASKRUN ring and shortly after kill the task, in which case
->iowq check would race.

Cc: stable@vger.kernel.org
Fixes: 50c52250e2d74 ("block: implement async io_uring discard cmd")
Fixes: 773af69121ecc ("io_uring: always reissue from task_work context")
Reported-by: Will <willsroot@protonmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/63312b4a2c2bb67ad67b857d17a300e1d3b078e8.1734637909.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -498,7 +498,11 @@ void io_queue_iowq(struct io_kiocb *req,
 	struct io_uring_task *tctx = req->task->io_uring;
 
 	BUG_ON(!tctx);
-	BUG_ON(!tctx->io_wq);
+
+	if ((current->flags & PF_KTHREAD) || !tctx->io_wq) {
+		io_req_task_queue_fail(req, -ECANCELED);
+		return;
+	}
 
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);


