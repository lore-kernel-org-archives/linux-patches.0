Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81347E772;
	Mon,  8 Apr 2024 13:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583113; cv=none; b=G60fJA5/1LxcmhXBshS+kdpP9cRE900KIcTzifFZu8wNKp7GoTilau9YxEkgjgilz/wG6Ww3jPOMzJNeiYA0MQnjhJ8DNsZdu/88MMWOWjINvabMabplDsplPeyHPLlLUQZO+zE9uitH7h2ywCzBlKisPOa4TPTVlVdu5lUwQz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583113; c=relaxed/simple;
	bh=ggMWnJCrth+TA3y9XhE+V7xsTL+X9ZKxmD0rMJp8AL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKpRgldeCAJdUKaVk60vjKxx3RrfldeiXSFfCv+i7nCuPcyfeLKr5A4v9jdhZIEh67IMnIAGZtcG3aWDpS8Q+TlB9hi0tbaMQHaZ1WxOrtf5b+4sJSFJfQMw149L823ZrE/yYgbtM6uQnjLmJAErecW9faugtN0hLxqTwvd4VHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5vTfNy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5vTfNy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724CBC433C7;
	Mon,  8 Apr 2024 13:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583112;
	bh=ggMWnJCrth+TA3y9XhE+V7xsTL+X9ZKxmD0rMJp8AL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5vTfNy5e+SMzhlL/8bOelyxZzyBNAi2tKcu9zVfZnWJfZ79GDAQSInuOqXDwJ19d
	 fnKqCFKt4BKSV6593qrhwM1Eftl6+5rWfjmvbm3oHKo8wNguELPraDkkhuoFon5hwD
	 yf8RpgySRzuutu5Yp5wmAA2YvvHHF4SSEBOXel8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+011e4ea1da6692cf881c@syzkaller.appspotmail.com
Subject: [PATCH 6.6 158/252] fs/pipe: Fix lockdep false-positive in watchqueue pipe_write()
Date: Mon,  8 Apr 2024 14:57:37 +0200
Message-ID: <20240408125311.559868102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index a234035cc375d..ba4376341ddd2 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -425,6 +425,18 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
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
@@ -437,11 +449,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
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



