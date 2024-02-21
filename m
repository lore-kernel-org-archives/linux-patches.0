Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17B955E5E;
	Wed, 21 Feb 2024 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523887; cv=none; b=XPzemOLZsRYwQ9Yfmj1fz6ki9IAssQZkNw6wRAizc0Epc5oqjNzYlMgy6WzarP0FbiklqMEY1YL76V1kNNl0ip+by3GOkDedEPvQbVJYpSkIRiO6oFvBo+GiHzGGwVHdVwqVHDfe/qncwn5cFx6DmmthTtB5o220E2yEsjZCAbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523887; c=relaxed/simple;
	bh=BMVp2L0+2s1HOPWXodfdBGGxM25vV/q/KGTxKKyihjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjZdJke8Oe0RGeP881AEEUmyOlNWja5HlTi9WSpEMq8g7eh0fqR1whXoO+6YJQZYogtBjF6TX/dGifukBFtREJTIkSsQqUggChuobJosbYP+LCiXvkABUc0jxzEIMw8LyZTE1AnkXRdEU/87dVqOLbdpwMgxQvn44JCzKs2haDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auLCJKE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auLCJKE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515C1C433C7;
	Wed, 21 Feb 2024 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523886;
	bh=BMVp2L0+2s1HOPWXodfdBGGxM25vV/q/KGTxKKyihjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auLCJKE9BbW/UlqRuo0uJGpEHJSVcAI7BPSi9v3qddzftVBdzEU9dRKhgM4ss3UgY
	 ZWuGxd4oPX0xuTzr85MhUWVV818kqxhwVhVW27kP6WT/eE6wjz0nneqsGM+xbdVgLU
	 vLrsEn8RZw9VtfkhzpZWyCg6yfxgjv7KFBzkvHbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/379] fs/pipe: move check to pipe_has_watch_queue()
Date: Wed, 21 Feb 2024 14:04:20 +0100
Message-ID: <20240221125957.305275519@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit b4bd6b4bac8edd61eb8f7b836969d12c0c6af165 ]

This declutters the code by reducing the number of #ifdefs and makes
the watch_queue checks simpler.  This has no runtime effect; the
machine code is identical.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Message-Id: <20230921075755.1378787-2-max.kellermann@ionos.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: e95aada4cb93 ("pipe: wakeup wr_wait after setting max_usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c                 | 12 +++---------
 include/linux/pipe_fs_i.h | 16 ++++++++++++++++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index dbb090e1b026..7b3e94baba21 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -435,12 +435,10 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
-#ifdef CONFIG_WATCH_QUEUE
-	if (pipe->watch_queue) {
+	if (pipe_has_watch_queue(pipe)) {
 		ret = -EXDEV;
 		goto out;
 	}
-#endif
 
 	/*
 	 * If it wasn't empty we try to merge new data into
@@ -1319,10 +1317,8 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 	unsigned int nr_slots, size;
 	long ret = 0;
 
-#ifdef CONFIG_WATCH_QUEUE
-	if (pipe->watch_queue)
+	if (pipe_has_watch_queue(pipe))
 		return -EBUSY;
-#endif
 
 	size = round_pipe_size(arg);
 	nr_slots = size >> PAGE_SHIFT;
@@ -1375,10 +1371,8 @@ struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice)
 
 	if (file->f_op != &pipefifo_fops || !pipe)
 		return NULL;
-#ifdef CONFIG_WATCH_QUEUE
-	if (for_splice && pipe->watch_queue)
+	if (for_splice && pipe_has_watch_queue(pipe))
 		return NULL;
-#endif
 	return pipe;
 }
 
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index ef236dbaa294..7b72d93c2653 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -124,6 +124,22 @@ struct pipe_buf_operations {
 	bool (*get)(struct pipe_inode_info *, struct pipe_buffer *);
 };
 
+/**
+ * pipe_has_watch_queue - Check whether the pipe is a watch_queue,
+ * i.e. it was created with O_NOTIFICATION_PIPE
+ * @pipe: The pipe to check
+ *
+ * Return: true if pipe is a watch queue, false otherwise.
+ */
+static inline bool pipe_has_watch_queue(const struct pipe_inode_info *pipe)
+{
+#ifdef CONFIG_WATCH_QUEUE
+	return pipe->watch_queue != NULL;
+#else
+	return false;
+#endif
+}
+
 /**
  * pipe_empty - Return true if the pipe is empty
  * @head: The pipe ring head pointer
-- 
2.43.0



