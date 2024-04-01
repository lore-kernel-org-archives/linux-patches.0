Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D9C17552;
	Mon,  1 Apr 2024 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987028; cv=none; b=GA4yPov+43SsDNWIGvY09o/M2OaY4+d+F734TFVsnBtNj1+aQKP3GfHNAMMmp9MmROXB/4d8j42MuVV24zFyx7VovJuDCJMb4OYmGFnSYqHtblX62xlpDGNyacvqTFcD0nC/ggwdri3Z1v1i2NDlVAbCKpwon/V9nDH0+2Wwj0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987028; c=relaxed/simple;
	bh=C383EhdycxfArOnLJFnrYPH5dBGdcaqxEyCOBkqD2To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFH312ZwZBhfQZsANGzDN4Z6bm5aSiUWstuvUe85eniaPuPk09PI93/oIdjiyKHHnv5LSgQcHiHSrKUOp7Zd/e5FloSh6ENww0FnmxdrjsojTi7n/77/YAEDMQAng8Ep9XewDMbxA4ioFG3MA9unLDi5NUNI1sFXB3vv5/jgZo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7lbTuDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7lbTuDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF4AC433C7;
	Mon,  1 Apr 2024 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987028;
	bh=C383EhdycxfArOnLJFnrYPH5dBGdcaqxEyCOBkqD2To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7lbTuDCE6xZIIS9t6ddrB9AknwTjf3G0NQpDK5esHiFyjPgfRYxRnbpTIeei7D8j
	 GFBGitUGxN4wUW4SNpGb9sqtlZBvZdD9QHhRAak6kR8bTJS753wa45vSiPLFMv4vuw
	 3McpgyprTLM1ySnYgMVc+afK97VX6YPedawNh5zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 134/399] io_uring: fix mshot io-wq checks
Date: Mon,  1 Apr 2024 17:41:40 +0200
Message-ID: <20240401152553.189985801@linuxfoundation.org>
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

[ Upstream commit 3a96378e22cc46c7c49b5911f6c8631527a133a9 ]

When checking for concurrent CQE posting, we're not only interested in
requests running from the poll handler but also strayed requests ended
up in normal io-wq execution. We're disallowing multishots in general
from io-wq, not only when they came in a certain way.

Cc: stable@vger.kernel.org
Fixes: 17add5cea2bba ("io_uring: force multishot CQEs into task context")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d8c5b36a39258036f93301cd60d3cd295e40653d.1709905727.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 386a6745ae32f..5a4001139e288 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -87,7 +87,7 @@ static inline bool io_check_multishot(struct io_kiocb *req,
 	 * generic paths but multipoll may decide to post extra cqes.
 	 */
 	return !(issue_flags & IO_URING_F_IOWQ) ||
-		!(issue_flags & IO_URING_F_MULTISHOT) ||
+		!(req->flags & REQ_F_APOLL_MULTISHOT) ||
 		!req->ctx->task_complete;
 }
 
-- 
2.43.0



