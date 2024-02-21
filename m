Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0527E797;
	Wed, 21 Feb 2024 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522183; cv=none; b=XT0zFA2TqRmTguygXMtS1KB0BjYANIWJszqGTCmjQO0FJrUTToV5ZyhJOBhOCkYntnodr+qRYKlZk5npJFdr0+3+rRs00Yk+COB61jbtn6ZfPM3tL3J9j14Koxu5f5r7/cmjdSXrHt/aMKOEIiYV/KzVl4uG0Q+CoDFEUtS8J6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522183; c=relaxed/simple;
	bh=a9yVN54Dxf0rp2gmc7cmY1chxGWF6zBjqG7HsmnmM+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVf9sV6E5uhghgitgDLQX2Bx2C25qLOcIKSIg2N/48GOAwspeUXe1ZE19fYe5zGmkT0nqR9DtG+cu2FiFPnNAuN4+IawPAjLxQqbxJa9SLs1JDTKb+RfZ7NIqUAdHdoAoxR2vJtw2SoflI7vyoTmWxp0LZTYHf6LqREMhtZ++2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhiHMmfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhiHMmfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3D9C433C7;
	Wed, 21 Feb 2024 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522183;
	bh=a9yVN54Dxf0rp2gmc7cmY1chxGWF6zBjqG7HsmnmM+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhiHMmfuAzobVkbhmhCK5LC4M+b1M4PpQFFFe8lsO0FpwAh7AogMNlYNpyuE1UKq8
	 5KlO9CoAo82BpRj7I05w1xaD4VW6/QKYSdwkJ8dyHbVCMeNfVKwDwwOgTACMVdI9cR
	 opxj7DkjlzTMvO6cNftss+NnrWGjjz/TUaqRfXCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/476] fs/pipe: move check to pipe_has_watch_queue()
Date: Wed, 21 Feb 2024 14:02:30 +0100
Message-ID: <20240221130011.650137890@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e08f0fe55584..1a43948c0c36 100644
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
@@ -1374,10 +1370,8 @@ struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice)
 
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
index d15190b3e032..0613daf8997a 100644
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



