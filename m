Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB532820D1;
	Mon, 22 Sep 2025 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569986; cv=none; b=pJDEtgmvwrq/ZravNBsqkgW+VY57kML/IwBp0O9V+HRo2lrI2ZU7oXiQCKl7OnPyT4tqhqL50u/VG/3A/DJzAFmIVFWfVdQSHCnMoCRxoquiAdeJwi0N0rZWbMCuUZJ4o+hE7Fy/0esJze4CvQKHUs6aMnVFBrmKNmeHVPjJghI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569986; c=relaxed/simple;
	bh=hm7k6tUyWUHT8WxwsC010eK0QuX/JEZlg4VGBe0bCtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOcJoeecfjLusSlNr6Mo+zDlfiYnrZCIkR34numu8GTqNbYEIgJYKX1hr0P8Y0yzonregt21SYGsNvc2RqQAjWqsDiNEwlVR03PF4wJDGff7L+zQ8pK1pGqxwJv0J5FIAUoZHwSovp9c5XoiEvkgGixffhuxpCV0Wn7W1xvK6nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bn9Fp0hZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bn9Fp0hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD9FC4CEF0;
	Mon, 22 Sep 2025 19:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569985;
	bh=hm7k6tUyWUHT8WxwsC010eK0QuX/JEZlg4VGBe0bCtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bn9Fp0hZe4qY/WRV0iLquCqtZixg1FUBBVCFUg7u5ToLWzFqvBvOUh2vjSEbbVAoB
	 N3FPdVaPQ9slxKwQGKZHlRhPmmMpxzshGcyD0Cq9A51ejqw1Fr2pU7r1OHeS6rwlKc
	 7caadq+PlvfTaSP2MOPSogkUWpn9sdk44C+HNLgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 066/105] io_uring/cmd: let cmds to know about dying task
Date: Mon, 22 Sep 2025 21:29:49 +0200
Message-ID: <20250922192410.639733104@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit df3b8ca604f224eb4cd51669416ad4d607682273 upstream.

When the taks that submitted a request is dying, a task work for that
request might get run by a kernel thread or even worse by a half
dismantled task. We can't just cancel the task work without running the
callback as the cmd might need to do some clean up, so pass a flag
instead. If set, it's not safe to access any task resources and the
callback is expected to cancel the cmd ASAP.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    1 +
 io_uring/uring_cmd.c           |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
+	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
 struct io_wq_work_node {
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -116,9 +116,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_canc
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
+
+	if (current->flags & (PF_EXITING | PF_KTHREAD))
+		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,


