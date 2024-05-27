Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9D2168C4;
	Mon, 27 May 2024 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837737; cv=none; b=rmbW6H8Q4OfHKmdLBtEezloqqpuVJqXdSHtnnbrRQ1WFM8E34eGrBqaWE4LgfUgwsjB3MHuXPAqIWXKAXjankquAYOIq3roTp1/GSNaeuSR6F7F5aoT8R/XmQ4mebhTDwnkWd3lmRAdGH5FYGGc9EzWw49sHFjk1aEMo40Do3/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837737; c=relaxed/simple;
	bh=jC+63dnOZ4qK71Sjlaqdse/Jey8/BKGTw6a311RYPNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bw4j6b/tDlAn88nPC9yq3E5dT9+ZcuxHMixFlDnVPK/aFqn/lQHr3nq7qg9M12atbnrlQU5cNIsureqpc7UGWxqdDnMOtVvbTChI1j9pbfOjvAqnjlg2RrZU6SQqRQo45sxLjpi4BEbk6A6pJ5Z39oy4A+UMv4bNBpuF2M7ap74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtwPCLkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtwPCLkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C57EC2BBFC;
	Mon, 27 May 2024 19:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837737;
	bh=jC+63dnOZ4qK71Sjlaqdse/Jey8/BKGTw6a311RYPNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtwPCLkN45Bt+b6P1Z1lgN1/0/pX6VL0bIAn58ZMH/60C8OkshpH8n2MrWfQb/Pvq
	 8dGrdtJXR6QGNll5PRT/lixe5SLzu4wPzKg3q/0LmgGVfQQmMfWEeUDwSaMNNv4m6O
	 rmdodIUbhX9nNoM4Xn+RlfEoqYVzUHDtPRpYGlhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 123/493] io_uring: use the right type for work_llist empty check
Date: Mon, 27 May 2024 20:52:05 +0200
Message-ID: <20240527185634.517805112@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 22537c9f79417fed70b352d54d01d2586fee9521 ]

io_task_work_pending() uses wq_list_empty() on ctx->work_llist, but it's
not an io_wq_work_list, it's a struct llist_head. They both have
->first as head-of-list, and it turns out the checks are identical. But
be proper and use the right helper.

Fixes: dac6a0eae793 ("io_uring: ensure iopoll runs local task work as well")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d5495710c1787..c0cff024db7b4 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -301,7 +301,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
+	return task_work_pending(current) || !llist_empty(&ctx->work_llist);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
-- 
2.43.0



