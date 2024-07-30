Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488C01A76D4;
	Tue, 30 Jul 2024 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360067; cv=none; b=lK3N08Qwv1tsw05zeheZPT2jIarjfI+ZGGRYNoTFqRppPZeXs3iLipOPK2GpLkoGhIquI77X0MK1xaEaFjxzP/4BgqYRHshw31ZddiCf9fwcb7VjRKf6FQUonIR8ljf+lpZa1wpMVAIRBhwPojVsE8zQUkF6Q+4alqsDqb+wyBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360067; c=relaxed/simple;
	bh=wHHRli6hdC7a+McLUZSl4ZtuU2/wwhyOLairREMqwhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4sMKdbNv2QwpYiOUteQ0brJtmIoAt6eporkHD83cGp3qcIr3cCHTr5ksyASo7KNjiO9f1bDqyFt9QWMLnf3DYX3RU7IjsNJI3SLTfgTxoqcG95HTL1+atSxwgXA7kaf6cZneyIQc1QflXzWQ+xsAbowdEACtwMUS32w7po9iSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lem/EEnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lem/EEnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAF8C32782;
	Tue, 30 Jul 2024 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360067;
	bh=wHHRli6hdC7a+McLUZSl4ZtuU2/wwhyOLairREMqwhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lem/EEnb5LJInE2aaIdmvGCtjpEgCpgyQgLJBO0lz6shQq3TM30mxjcybz0LXJRyh
	 IE1s1b1aqQJ9htNlnArGjgZJaETGaGqv/s2rgbqinKUlp/xnrvjapSNHEGCly9/iJc
	 b6YfM6DHv9/kxujkcxM35DjZpnMyeDO+iarkmZ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 566/568] io_uring: fix io_match_task must_hold
Date: Tue, 30 Jul 2024 17:51:13 +0200
Message-ID: <20240730151702.279073929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7fd7dbb211d64..4f1f710197d62 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -644,7 +644,7 @@ void io_queue_linked_timeout(struct io_kiocb *req)
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
-	__must_hold(&req->ctx->timeout_lock)
+	__must_hold(&head->ctx->timeout_lock)
 {
 	struct io_kiocb *req;
 
-- 
2.43.0



