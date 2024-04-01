Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F7547A5D;
	Mon,  1 Apr 2024 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988260; cv=none; b=hjlX6P+EXrRrX1qyxDtMQbMdeMKsXJ+sYJU3XvNd9itR5BW3Nriz0l6Ud1jm19QZYJs4vxcS8RKZvcvatNPYBncgncbzLiVg9KEpNWyfeS38oY/z1WkQQM5BKSrFHEYYWDZEDmrwa2zAmSyYHRkqIZ/at/uQEG0P0srSUsAbZJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988260; c=relaxed/simple;
	bh=TTvnmAH0yNAZh4z1KOCFEJZBmg27SLkzVDWbHqI6Co4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqEtHiiDn41re1jFmsNVLH0BRjQ9wqFzh5MlbyBUwYakUa7yBord8wZiyQAV5tuXmzDe7DeFgweEuY/oR/FtaM4hpqmGcGFKqGUnX88avvHFf5q41gZLWnznox1pqhFipqYcMkbAYk+GDiI1strvL1J2dxzQm/S1jKhX/xxWlQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbPs4NbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbPs4NbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCA8C433C7;
	Mon,  1 Apr 2024 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988259;
	bh=TTvnmAH0yNAZh4z1KOCFEJZBmg27SLkzVDWbHqI6Co4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbPs4NbZ34qtJHDh+IyTAQl3Hn7bGQAC1R9apXgAZF8CdHvNV9FIibmcsHbBdgzK2
	 Fy0sgYe7gxyJHv4lzPLKk29Y8oE+qL04DeFpJVWoeKGEsdw4G70Ktc8EPLSChsOrPl
	 P3YcpJU2TtCoyNGdNvfejO3OxM167MmsQBzjr5NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 130/432] io_uring: fix mshot io-wq checks
Date: Mon,  1 Apr 2024 17:41:57 +0200
Message-ID: <20240401152557.008986761@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



