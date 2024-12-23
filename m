Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B4D188733;
	Mon, 23 Dec 2024 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970076; cv=none; b=uCejGx4XyG1Lh5aacJ0v8plckJus80Jxtx/pjCg84qRANSCQPTDeVAUAQwdieQtWqaBZQ3Bkc3gMTtcJ3ccwJHuaerODu6E74qNS52STg4UaFJ85jhFk9WLP6wqugNIC8CXi9dGcRaSxIAHhO1CuI7H5xlM6luXpd66DlgJ/2L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970076; c=relaxed/simple;
	bh=r4ZlWVGH8okTRFWP3a532vsf+dvYK64DLxh7bdNk6JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO4N9cdA/N+xiOs7QEgrOybquOVHvcO/dEYJr1r2+lOwSw3Fy1bL80lTPrzI65b72aJ20A/3Uwaj9BoDFCaOrCtoz2+kejUpdYZT3PeGrjgJhL+zIsTJSdDJ6dY2K9kcbDWwqCuzYqmuLZvbnGvy8JcPGXl7SwvRXZHNny27VEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXwy21iC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXwy21iC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B43C4CED3;
	Mon, 23 Dec 2024 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970076;
	bh=r4ZlWVGH8okTRFWP3a532vsf+dvYK64DLxh7bdNk6JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXwy21iCt1ddDbk/yKPn0cPDgMuBzqZZKmXC3/NAVxxfmNn0prHn54rOb4AwhaTrm
	 TC+zDvbUiwZkM/EIAXwvLmfDAUZY0HEzX3pcbg/YiDKdVzXUgw17/+Ylmvx5MkBguw
	 MYwQ6QQGhfo3SUBc7njyzS0VD1VK3a1TC2FPxboQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will <willsroot@protonmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 137/160] io_uring: check if iowq is killed before queuing
Date: Mon, 23 Dec 2024 16:59:08 +0100
Message-ID: <20241223155414.084823328@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -515,7 +515,11 @@ static void io_queue_iowq(struct io_kioc
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


