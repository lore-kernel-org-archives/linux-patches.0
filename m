Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACFC15FD07;
	Mon, 27 May 2024 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836337; cv=none; b=WjmOPsu3Z8WzZ1Mfn/MWk1PlxQFbOJQmBhTEgHl4g/nMg6CRZ4/CHJCZGggweyJwGx6olIg0LPgk+6ZzK97TORUub+Sn3FQLd2dHEPpK5T/+nmlT1iWT1jvaZ4HUgOTjKysOW0fLEMjiWnHsaQPslFhWDbfFuqsrvDkLQvQyKOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836337; c=relaxed/simple;
	bh=/AKVM0vpIQpvopgYMbkJ7AwprYJYwMZ5xJ2lDOTEnsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQxngXl5iYvUzEn5qLsmsHp2U9r3KOzoW+2I0FzRvdzGyjmpEzpYA6WRb/zoGVLWhmV4S7i08ZoyxUMXwBT4xIfNi9Oi5ZCEBqFspGLN4B1vlwrR9RA7JIpi25z+pd88FMF57YNu21bxx3DLe2rBEyNo3y1Y3HyPcaBgDSPjadI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usLGZcf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usLGZcf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AA1C32782;
	Mon, 27 May 2024 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836337;
	bh=/AKVM0vpIQpvopgYMbkJ7AwprYJYwMZ5xJ2lDOTEnsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usLGZcf/tJ1V6TxLYDMzQ3y4EKYJews9U45OFd2nwy5w+5wfFCFYh6lf9ZYAJ00VP
	 2sHHod5dAIuHMYUW6iFOhHNtSWMM0lfWFnxeoQRxDpg0LKbhe44SXUJOr4gO+ofSWO
	 fOibFMhMjwYafMVLgFg8wKq8KsAGo9p8iFYy7ino=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6.9 015/427] io_uring: fail NOP if non-zero op flags is passed in
Date: Mon, 27 May 2024 20:51:02 +0200
Message-ID: <20240527185603.161611897@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 3d8f874bd620ce03f75a5512847586828ab86544 upstream.

The NOP op flags should have been checked from beginning like any other
opcode, otherwise NOP may not be extended with the op flags.

Given both liburing and Rust io-uring crate always zeros SQE op flags, just
ignore users which play raw NOP uring interface without zeroing SQE, because
NOP is just for test purpose. Then we can save one NOP2 opcode.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240510035031.78874-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/nop.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -12,6 +12,8 @@
 
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	if (READ_ONCE(sqe->rw_flags))
+		return -EINVAL;
 	return 0;
 }
 


