Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B4D131E54;
	Tue, 23 Jan 2024 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969113; cv=none; b=swk6OfdHk+vvhEGnMbKbqps87JNor+EIuA4xOMXHzGGCoSMQYAuqfYL+trvQfOYiwCSlq1wVzpI7AI28viqDUhfiKF2c/eKrh+LulSH3jACWZqyOz8KN+SDCsU7r14m3EY+ZKbDYoSj4uoUmHtQ0jFN180/lmqBrhTT/xQUH40Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969113; c=relaxed/simple;
	bh=dsXKEg8+XzHA5hR+04WPBXEq3CAM1G05a/fP0VgEejE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMh80gYDm/qRKnvqWV1ryDKYcq7HTo4IzOwiY3d/XMj8wxSN3UTlxAYGvh8iBdKEqFLRdJrP0QneO5CK8GaGEqP7VLub1jifCEKQB1MM0GF4Jt/JW3y8rCARMLAKG48VFNyYP7qYCYoyX9ZErEaHBfb2berjwfXUi6eN72NOEAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQqNWHZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQqNWHZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE97C433F1;
	Tue, 23 Jan 2024 00:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969113;
	bh=dsXKEg8+XzHA5hR+04WPBXEq3CAM1G05a/fP0VgEejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQqNWHZDElNfaentqEjzjE+cKwbQ8W3eXheDSq6JDZCjpft6tFf9URLVzedgUamzJ
	 D2j29IrDUTwlJwMF6CGroWp5Fb1pZUyAE0tKMGUkiUHAnCmEvhNMNr1K4S1pz5NwC9
	 b5n8NTlGd6bKKZXXeF6T80a7p0wmjCJMY2DYtpls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+011e4ea1da6692cf881c@syzkaller.appspotmail.com
Subject: [PATCH 6.7 005/641] fs/pipe: Fix lockdep false-positive in watchqueue pipe_write()
Date: Mon, 22 Jan 2024 15:48:29 -0800
Message-ID: <20240122235818.266114862@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 804a7d789452..226e7f66b590 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -446,6 +446,18 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
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
@@ -458,11 +470,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
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



