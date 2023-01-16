Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174B46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A82FC433EF;
	Mon, 16 Jan 2023 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885123;
	bh=pzyQHGEYss7NSj63f8HO/yDtGBGN67sxZjCJb3zZFx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnfG+aalhvV2sIFHOrPu0z3VuNpjt/j0Lqr2+nWfB8QiLETCJoVeh3nIIW9bKwH+i
	 gCSRkFLkOvWx5GkyTJtpb9r3wnf3InUrUIlHbkSpx14Tmt/pMr4bfvLeerotdxOGJU
	 QIKPpPy5qddeLq8XKQ7FtXePGfio/qD7VJcDiJ/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 83/86] io_uring/io-wq: only free worker if it was allocated for creation
Date: Mon, 16 Jan 2023 16:51:57 +0100
Message-Id: <20230116154750.480675740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit e6db6f9398dadcbc06318a133d4c44a2d3844e61 upstream.

We have two types of task_work based creation, one is using an existing
worker to setup a new one (eg when going to sleep and we have no free
workers), and the other is allocating a new worker. Only the latter
should be freed when we cancel task_work creation for a new worker.

Fixes: af82425c6a2d ("io_uring/io-wq: free worker if task_work creation is canceled")
Reported-by: syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1217,7 +1217,12 @@ static void io_wq_cancel_tw_create(struc
 
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
-		kfree(worker);
+		/*
+		 * Only the worker continuation helper has worker allocated and
+		 * hence needs freeing.
+		 */
+		if (cb->func == create_worker_cont)
+			kfree(worker);
 	}
 }
 


