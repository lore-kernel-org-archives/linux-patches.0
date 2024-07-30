Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0023187FEC;
	Tue, 30 Jul 2024 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360768; cv=none; b=Ls5de3qMT9t5NLipOTuLgODYei/k5oomNfnijOM5rOm8A56Omaj1lyu/kj2OlT1bEyZh+pk1gXTvylPRJzNxr42GUmmauEqmpToqaDwAOw8ZiPjU7AQ3ZS/YlZqqccthsGmELqmjrHZZDl95SasKDbrHWFUB3LqvESiVS2HeSgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360768; c=relaxed/simple;
	bh=3j5lImWqy7Btm6tF6SytgUX1mRLlzgAJz0x/0HLk0Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8DsADxhzjbGjYvKFQhXSio++uRGK/3t1Ravw7eKbTec/ghgNoZmAszIe1827NZH4lPRwTbIr6hTO/1d3jauFvRkE3zJ2JpYXokLBevLvjk8OApwXMEZ2SR8o+E9FGDFQQEsxcEju+l4IcPYcUSsqHsvCmIEHNvXTCYetLW2xV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEP5DK5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEP5DK5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A905C32782;
	Tue, 30 Jul 2024 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360768;
	bh=3j5lImWqy7Btm6tF6SytgUX1mRLlzgAJz0x/0HLk0Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEP5DK5tIIpOVjePXkBuaAYo7/+Ef1Q57HCJETsPR1XOXIuYT4ljk2JckUom04xug
	 n0pWpbCVvN2sL5e57tUjqR2Ddqw9F3t5r03h5Z2RV3CGpk4Kg9kZ6cDOcQB5QS82Q2
	 PjZDFvezo11G1bCTio+2rzJeuBgiXVcM1ZHTBFi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 802/809] io_uring: fix io_match_task must_hold
Date: Tue, 30 Jul 2024 17:51:18 +0200
Message-ID: <20240730151756.657919405@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e142e9cd8891b0c6f277ac2c2c254199a6aa56e3 ]

The __must_hold annotation in io_match_task() uses a non existing
parameter "req", fix it.

Fixes: 6af3f48bf6156 ("io_uring: fix link traversal locking")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3e65ee7709e96507cef3d93291746f2c489f2307.1721819383.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 1c9bf07499b19..9973876d91b0e 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -639,7 +639,7 @@ void io_queue_linked_timeout(struct io_kiocb *req)
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
-	__must_hold(&req->ctx->timeout_lock)
+	__must_hold(&head->ctx->timeout_lock)
 {
 	struct io_kiocb *req;
 
-- 
2.43.0



