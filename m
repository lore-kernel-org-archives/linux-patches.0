Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3873DE443;
	Mon,  4 May 2026 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904607; cv=none; b=NT3O80vy3mKeCpUxUt3gbiv7/9xg7xV+mfFULEH4g3So72CnkabkSX9KYfcqxbRmU94BRA4GOTCvhQSjmwZLDDc6l2ZXV0ZUTWuWHeivqkfg8Ydj99rDBXYexfn1+GutLIWYeprpy/7wQJ7oLlgrPk1bwbn9G3rTKAUrGRSKcXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904607; c=relaxed/simple;
	bh=Y9hxd4P6McvmU3CL+Crfk4QDsowkCvXwwaYtvTywl98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H11rUMwlf28DQeYSq3iVm06Cpf8GH/mTRcIZyYe7pebueJ7UHGTh81xbbdXZJqYYjcsPvJrSyN4VjyQucH7PSr2MMdl3aIrv1ss2tDVJUybtoJQ9dyI0CsnBmgepOfrTesPhz93DfAxMxqWUKDPM2IeG5WO9pbW5esucSQfQTQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baujXwN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baujXwN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D10C2BCC4;
	Mon,  4 May 2026 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904606;
	bh=Y9hxd4P6McvmU3CL+Crfk4QDsowkCvXwwaYtvTywl98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baujXwN0Cj0oAGl7XB1/CPobcdhWZuZ7en2QH9zguI/Kmvx7SAAa93vwyp/rCQwE+
	 5ymFj1wfwAkmYYUZ1OEuSbX9V4PcFSMSC6uBjrVsaQkVpIwlPA90rhL7rOd8QrZRAe
	 YVZAJeEO8oqfQB4UIZPazLrkt8w3Jxj379iBjzl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Longxuan Yu <ylong030@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 072/215] io_uring/poll: fix signed comparison in io_poll_get_ownership()
Date: Mon,  4 May 2026 15:51:31 +0200
Message-ID: <20260504135132.797788950@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longxuan Yu <ylong030@ucr.edu>

commit 326941b22806cbf2df1fbfe902b7908b368cce42 upstream.

io_poll_get_ownership() uses a signed comparison to check whether
poll_refs has reached the threshold for the slowpath:

    if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))

atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
(BIT(31)) is set in poll_refs, the value becomes negative in
signed arithmetic, so the >= 128 comparison always evaluates to
false and the slowpath is never taken.

Fix this by casting the atomic_read() result to unsigned int
before the comparison, so that the cancel flag is treated as a
large positive value and correctly triggers the slowpath.

Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Longxuan Yu <ylong030@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -93,7 +93,7 @@ static bool io_poll_get_ownership_slowpa
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
-	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+	if (unlikely((unsigned int)atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
 		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }


