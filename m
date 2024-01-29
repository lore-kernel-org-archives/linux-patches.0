Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D907C76032;
	Mon, 29 Jan 2024 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548628; cv=none; b=HkHPwC/D19gAoaWJonbXBkTqNwyuHyJoc28v5vhQ4S5pAUTzXw+yzSyqWrgaZLJPoWsBSOwPgiQsebZw0tmLUaAqvpEI1QvnrpDpFyu1/BlZERM13c3tYzLxFkAMMX70OXJ96p3IGAVsNa3TkGuTGQjG4yQ1CxhTKL6hzjURR4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548628; c=relaxed/simple;
	bh=A3SxKA+upng5DytG2L34UC/Zmvebju8E0Evm1avDGpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+AUyni2Jj/1dBZQ6gFLDOp7Wobam3+21oc4Jsmz/CCQinBMhT8cdcqdRM06aR1ggBeEIb8QBbCi13lt694Kzl1GAzdGzNJMElohx1714LtC5qLlcQExDi81myo+/7aag83WhE0v4BGo7ZCkDikk7R/6l9ZWuRfZQCrg/gugHCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ujkPyaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ujkPyaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CECCC43390;
	Mon, 29 Jan 2024 17:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548628;
	bh=A3SxKA+upng5DytG2L34UC/Zmvebju8E0Evm1avDGpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ujkPyaYU0XiwAHJyLjBG67lgAs6kwBMlDofYkBJ3Ow0w/yFItIm2HC8KBWPdU7lp
	 4ZiMHFi2z803gTbZGDctIqJ3agHefi8e7vUnup7GZDVOymOj68ohq/C36F+PCC0/8B
	 +hBAaT4oC4o90bynd9FLTbJLet9hSyroBSR2OmRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/331] fs/pipe: move check to pipe_has_watch_queue()
Date: Mon, 29 Jan 2024 09:05:41 -0800
Message-ID: <20240129170022.969266791@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
index 139190165a1c..603ab19b0861 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -437,12 +437,10 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
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
@@ -1324,10 +1322,8 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned int arg)
 	unsigned int nr_slots, size;
 	long ret = 0;
 
-#ifdef CONFIG_WATCH_QUEUE
-	if (pipe->watch_queue)
+	if (pipe_has_watch_queue(pipe))
 		return -EBUSY;
-#endif
 
 	size = round_pipe_size(arg);
 	nr_slots = size >> PAGE_SHIFT;
@@ -1379,10 +1375,8 @@ struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice)
 
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
index 608a9eb86bff..288a8081a9db 100644
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



