Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2671ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97AFC433C7;
	Tue, 25 Jul 2023 11:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284378;
	bh=uhhGGkm0NojZJqMODxJzRhSLicLFDcJUvlRDhp1LMAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aapSs0DVv/RUgApsm2a9bAJ8qqg7rSxMgRkaWLjpveUgbFKhB5AoIVQeTpnQaF67V
	 nsHmo68xECXQKsmPXOI0uBmSfHymyKA4DuhFjIpmhl8t2uwVCyasLikKGNpcZFnos1
	 s3eBTmNLtuuDhTVkAhj6xeM6DkBsIVpt/ZzI7txU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 334/509] io_uring: add reschedule point to handle_tw_list()
Date: Tue, 25 Jul 2023 12:44:33 +0200
Message-ID: <20230725104609.001322124@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

Commit f58680085478dd292435727210122960d38e8014 upstream.

If CONFIG_PREEMPT_NONE is set and the task_work chains are long, we
could be running into issues blocking others for too long. Add a
reschedule check in handle_tw_list(), and flush the ctx if we need to
reschedule.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2214,9 +2214,12 @@ static void tctx_task_work(struct callba
 			}
 			req->io_task_work.func(req, &locked);
 			node = next;
+			if (unlikely(need_resched())) {
+				ctx_flush_and_put(ctx, &locked);
+				ctx = NULL;
+				cond_resched();
+			}
 		} while (node);
-
-		cond_resched();
 	}
 
 	ctx_flush_and_put(ctx, &locked);


