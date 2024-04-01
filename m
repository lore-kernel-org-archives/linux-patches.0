Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF624778C;
	Mon,  1 Apr 2024 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986904; cv=none; b=Wu2JHSmYfR9TJ06GUAgA/NHBnzpqFpsoc4h1+9ZD6iklN2VuhvjrMb3AhUlfirRqzEBbq+VKV7sxcQAota8m6weht1plP0zViqtRjh+21K1Jxb7lGIn+1bP/rlGi54nym0AMR8rt/YLo5qQc+9j1JoliLGQeJJKHGTmn/9JpDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986904; c=relaxed/simple;
	bh=J4dOEknYgD9M/UWK6+btH9ya6W5Gg/MwWXxKdF62BAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFGWLSeX0AeOaUcYAZwqEtvbI3CUCayWdseXvNj2xqGzvsFL6zQU9TlRi6Fjj+cF2hYglh0QllGi/+F+9JA1Lkdm3eCMndiq070chPwg+krgIeSsuMlie11XFAP6f4TBZCMg/OXBDC8yx/4UcxpwZfFCibHJ7mLlLMBDHXnk2OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD2zM2Lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD2zM2Lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075FDC433C7;
	Mon,  1 Apr 2024 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986904;
	bh=J4dOEknYgD9M/UWK6+btH9ya6W5Gg/MwWXxKdF62BAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD2zM2LjPiC2sCOnB4FccnunolJItk5GbQ0qo8VsNpXSApv5OVDW3lh+Pff0bQjR1
	 wZwIHmJCkac5vh2GpTCwJ1mO6qBnMQa7hhyjqGafiCn4NCFJJsn+JDj7x+t/5mTvqd
	 7U7264yHam7yDNi5z8whMulfBFqguN47VVLwne8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 122/399] io_uring: fix mshot read defer taskrun cqe posting
Date: Mon,  1 Apr 2024 17:41:28 +0200
Message-ID: <20240401152552.829587075@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 70581dcd0601a09f134f23268e3374e15d736824 ]

We can't post CQEs from io-wq with DEFER_TASKRUN set, normal completions
are handled but aux should be explicitly disallowed by opcode handlers.

Cc: stable@vger.kernel.org
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc717..8756e367acd91 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -932,6 +932,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!file_can_poll(req->file))
 		return -EBADFD;
+	if (issue_flags & IO_URING_F_IOWQ)
+		return -EAGAIN;
 
 	ret = __io_read(req, issue_flags);
 
-- 
2.43.0



