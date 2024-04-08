Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6277B6F53D;
	Mon,  8 Apr 2024 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582235; cv=none; b=fcrTuW7k9ShtFtV9IO9G167DICcnXEj0LjaocWz6ONHGlIBNMrrapmbvSQ0SRhgKLoTbDh/J7mc5HE5ddmbyClvo1BcArnEy7Ck/rTZWViOVsxOm/aDEnjnxB05kcG4IGNpgO9F+0eH64x+prnSbEn19C6m82yKD/1tqTRGmemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582235; c=relaxed/simple;
	bh=vu9O5lz66QrsBbTd36owBDNIYC1XU9Wb7zmDyEpQd24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp1Tp20xoXHccFR+0rommzUuTluZza8y92obMHUwghycfYVb+/yZiKQT28ns+WF8kCOMS/fGIITeBOMtSUtSrF8CEqh8EsKGhXZ34hZhxYrsAHsRu3foskahuoGjUY1xZ2VYsA9xXtXSmK+t2yIsozcwzxuUaBDqtX+pqSbuBCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJQRUmUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJQRUmUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D919C433F1;
	Mon,  8 Apr 2024 13:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582235;
	bh=vu9O5lz66QrsBbTd36owBDNIYC1XU9Wb7zmDyEpQd24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJQRUmUdXeT0QocnWwTfYnXxIzh5HuTC50RoR1KdjzF1CJojY8q9CKLdcu9fCQ2Zu
	 EZsCopYOnvk/5zbaLW7cHahHJT7UfQWCTRtm+HojQF9dEb4fdlQNLMFebyIRE34OqB
	 WAe+5IB2sLBH35PfPsBLoqaPAbaJ0BJrzz5D/yec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+011e4ea1da6692cf881c@syzkaller.appspotmail.com
Subject: [PATCH 6.1 089/138] fs/pipe: Fix lockdep false-positive in watchqueue pipe_write()
Date: Mon,  8 Apr 2024 14:58:23 +0200
Message-ID: <20240408125258.992405048@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 055ca83559912f2cfd91c9441427bac4caf3c74e ]

When you try to splice between a normal pipe and a notification pipe,
get_pipe_info(..., true) fails, so splice() falls back to treating the
notification pipe like a normal pipe - so we end up in
iter_file_splice_write(), which first locks the input pipe, then calls
vfs_iter_write(), which locks the output pipe.

Lockdep complains about that, because we're taking a pipe lock while
already holding another pipe lock.

I think this probably (?) can't actually lead to deadlocks, since you'd
need another way to nest locking a normal pipe into locking a
watch_queue pipe, but the lockdep annotations don't make that clear.

Bail out earlier in pipe_write() for notification pipes, before taking
the pipe lock.

Reported-and-tested-by: <syzbot+011e4ea1da6692cf881c@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=011e4ea1da6692cf881c
Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20231124150822.2121798-1-jannh@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 9873a6030df56..aa8e6ffe1cb58 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -424,6 +424,18 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 	bool was_empty = false;
 	bool wake_next_writer = false;
 
+	/*
+	 * Reject writing to watch queue pipes before the point where we lock
+	 * the pipe.
+	 * Otherwise, lockdep would be unhappy if the caller already has another
+	 * pipe locked.
+	 * If we had to support locking a normal pipe and a notification pipe at
+	 * the same time, we could set up lockdep annotations for that, but
+	 * since we don't actually need that, it's simpler to just bail here.
+	 */
+	if (pipe_has_watch_queue(pipe))
+		return -EXDEV;
+
 	/* Null write succeeds. */
 	if (unlikely(total_len == 0))
 		return 0;
@@ -436,11 +448,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
-	if (pipe_has_watch_queue(pipe)) {
-		ret = -EXDEV;
-		goto out;
-	}
-
 	/*
 	 * If it wasn't empty we try to merge new data into
 	 * the last buffer.
-- 
2.43.0



