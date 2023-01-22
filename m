Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9397E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A6FC433D2;
	Sun, 22 Jan 2023 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400306;
	bh=odPrDUPLmEh/8Be9TXFGBz348m/8cxCGmy9j8UMvwbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAOOetMYmEPpWlTzbAL2W/h6z62ymJsMj1rivOFurNxoyDuIw6wbt7NcMSwOGd8Qj
	 R5TXqgJBrkt5vlQJAsdi1l45vkre37sllMVE0gE5Jt8azrxxPhZWX/eE220yzlAoEN
	 sUNGZx8rPSOoIEA/Xs5ZzlujCZGTEn3LipDWz3v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/98] io_uring: allow re-poll if we made progress
Date: Sun, 22 Jan 2023 16:03:41 +0100
Message-Id: <20230122150230.528435632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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

commit 10c873334febaeea9aa0c25c10b5ac0951b77a5f upstream.

We currently check REQ_F_POLLED before arming async poll for a
notification to retry. If it's set, then we don't allow poll and will
punt to io-wq instead. This is done to prevent a situation where a buggy
driver will repeatedly return that there's space/data available yet we
get -EAGAIN.

However, if we already transferred data, then it should be safe to rely
on poll again. Gate the check on whether or not REQ_F_PARTIAL_IO is
also set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 75d833269751..cc8e13de5fa9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5694,7 +5694,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if (req->flags & REQ_F_POLLED)
+	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -5710,7 +5710,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+	if (req->flags & REQ_F_POLLED)
+		apoll = req->apoll;
+	else
+		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
-- 
2.39.0



