Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0258353AB
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5526CC433CA;
	Sun, 17 Sep 2023 20:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982915;
	bh=uWiKhEhj8TZEepOH4/tkUof6npJRh1T3M7j6hUI4hVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQ3Puk35wZuZAk1PTjb37FuYxNfKNt41NEvqZf3VuqiyxCerxAf74WD9Yyangyc/M
	 Eh7LRm6qzeO0ZIr+cTFl/bvV2KAgTe36/3Pw5nc1m1Hp8frSa1o2m3mhbOo9w4oWtC
	 do+7lUYKv+LKfkVDC2berWoRG7RdZWwVYW9H6DoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.15 373/511] io_uring: always lock in io_apoll_task_func
Date: Sun, 17 Sep 2023 21:13:20 +0200
Message-ID: <20230917191122.811671478@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

From: Dylan Yudaken <dylany@meta.com>

[ upstream commit c06c6c5d276707e04cedbcc55625e984922118aa ]

This is required for the failure case (io_req_complete_failed) and is
missing.

The alternative would be to only lock in the failure path, however all of
the non-error paths in io_poll_check_events that do not do not return
IOU_POLL_NO_ACTION end up locking anyway. The only extraneous lock would
be for the multishot poll overflowing the CQE ring, however multishot poll
would probably benefit from being locked as it will allow completions to
be batched.

So it seems reasonable to lock always.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
Link: https://lore.kernel.org/r/20221124093559.3780686-3-dylany@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5716,6 +5716,7 @@ static void io_apoll_task_func(struct io
 	if (ret > 0)
 		return;
 
+	io_tw_lock(req->ctx, locked);
 	io_poll_remove_entries(req);
 	spin_lock(&ctx->completion_lock);
 	hash_del(&req->hash_node);


