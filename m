Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB1E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AE0C4339B;
	Thu,  1 Jun 2023 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625727;
	bh=tRLvT91wGfWp24uirKSMXa5dwGy+OpqTKJw8sdTaS84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMuyDH++hMQ7YG7CLTHUYQqXT+ZK3pBrDydhqOMUTCHHCyp+2NyJnNttqU/r7pKYH
	 rbZh97MH6sM2aMbfxnZxpqS0AgMoLNiXnNIAVYca0w+DLfD5lHdDs2gJLFjodJIJKH
	 GWyXQ67dq2jGwRa0yMmddM1g8Ghm2tJkHLEiPZZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.4 10/16] io_uring: always grab lock in io_cancel_async_work()
Date: Thu,  1 Jun 2023 14:21:05 +0100
Message-Id: <20230601131932.434586757@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>
References: <20230601131931.947241286@linuxfoundation.org>
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

No upstream commit exists for this patch.

It's not necessarily safe to check the task_list locklessly, remove
this micro optimization and always grab task_lock before deeming it
empty.

Reported-and-tested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3738,9 +3738,6 @@ static void io_cancel_async_work(struct
 {
 	struct io_kiocb *req;
 
-	if (list_empty(&ctx->task_list))
-		return;
-
 	spin_lock_irq(&ctx->task_lock);
 
 	list_for_each_entry(req, &ctx->task_list, task_list) {


