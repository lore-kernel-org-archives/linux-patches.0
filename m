Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2393E5A1A;
	Tue, 12 May 2026 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608538; cv=none; b=qdwFfz0UPWleYzM/1J8r0jnCeIBuqsSLInrzT0urlZR+hs3oPW56Mi8tkllt92kjd4HNcop9iKS9z86TylCd6rjlKHrm1SzvDuiZODMDwwO8Z2ENklPB7tqTqN4NIc6MjkH4hVHTERo0WCuwba0ZhsbBnDnAi6avA+HjNoTqTQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608538; c=relaxed/simple;
	bh=QpLagqGTOm2jsiI8ktN/GTkvYhpYqDT96vT3HIhdtyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSX9ROqwsAoM8m+Cc87K7R/ZhrTtDDNQpyGX2miEjhCt97qdPZ5WsmqYfI63JdmI3/sxZR/BWHCGOXmUqwZLM8CbvwGEx6T4j64waw2NzEKGNzi0//WLXNGCDx9XSjcRwvdGHgCxL1jfK4Dj1ON/DInPge4iCL4Czgmt7q+aBJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWs2qBD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWs2qBD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044D9C2BCC7;
	Tue, 12 May 2026 17:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608538;
	bh=QpLagqGTOm2jsiI8ktN/GTkvYhpYqDT96vT3HIhdtyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWs2qBD+AUjPo04q2j2zacdEZJahEkn5BTAeDSAd+HLXUQRR1sWtNbsAAiR/wZpOh
	 4G6vJebgMtR7kAnX/ieO/rWQ6SEduxZbIG7spKJuoQJDOeDDQMUTI9Mv0bqk1uEhhO
	 FPNr6shXaWYIOnaz4ne7n2fM4XYcbexDzInxKEYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 116/270] block: only read from sqe on initial invocation of blkdev_uring_cmd()
Date: Tue, 12 May 2026 19:38:37 +0200
Message-ID: <20260512173940.900207500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

commit 212ec34e4e726e8cd4af7bea4740db24de8a9dab upstream.

This passthrough helper currently only supports discards. Part of that
command is the start and length, which is read from the SQE. It does
so on every invocation, where it really should just make it stable
on the first invocation. This avoids needing to copy the SQE upfront,
as we only really need those two 8b values stored in our per-req
payload.

Cc: stable@vger.kernel.org # 6.17+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -765,6 +765,8 @@ long compat_blkdev_ioctl(struct file *fi
 #endif
 
 struct blk_iou_cmd {
+	u64 start;
+	u64 len;
 	int res;
 	bool nowait;
 };
@@ -852,23 +854,27 @@ int blkdev_uring_cmd(struct io_uring_cmd
 {
 	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
 	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
-	const struct io_uring_sqe *sqe = cmd->sqe;
 	u32 cmd_op = cmd->cmd_op;
-	uint64_t start, len;
 
-	if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||
-		     sqe->rw_flags || sqe->file_index))
-		return -EINVAL;
+	/* Read what we need from the SQE on the first issue */
+	if (!(issue_flags & IORING_URING_CMD_REISSUE)) {
+		const struct io_uring_sqe *sqe = cmd->sqe;
+
+		if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||
+			     sqe->rw_flags || sqe->file_index))
+			return -EINVAL;
+
+		bic->start = READ_ONCE(sqe->addr);
+		bic->len = READ_ONCE(sqe->addr3);
+	}
 
 	bic->res = 0;
 	bic->nowait = issue_flags & IO_URING_F_NONBLOCK;
 
-	start = READ_ONCE(sqe->addr);
-	len = READ_ONCE(sqe->addr3);
-
 	switch (cmd_op) {
 	case BLOCK_URING_CMD_DISCARD:
-		return blkdev_cmd_discard(cmd, bdev, start, len, bic->nowait);
+		return blkdev_cmd_discard(cmd, bdev, bic->start, bic->len,
+					  bic->nowait);
 	}
 	return -EINVAL;
 }


