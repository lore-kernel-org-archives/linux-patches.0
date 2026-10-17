Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79403D6498;
	Sat, 17 Oct 2026 16:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255569; cv=none; b=dwC1BS0hq3n+2nW0KvGEyWSeE0Pv2mKuWBwQQ7FNv5jqO/bHjFt+tL23DDI1f9M3ZOQWKyc8ORw/AHETJa7SS13nw5i6SAkx+rf0enbtQVgEuP26bp47azBvzaQ5OIwQs9xjHnGJyCYBS2EXnt4IOHCOKyqZutuC+jQghyPDOCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255569; c=relaxed/simple;
	bh=7gF1cD/f3/1L/gxg6zUTjKAwdhHd/xle9Fl7KoCiwps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDqnekh8q4IE9TLaAUsL3KDXkqz14RpMmYt4YUe1xakztgGfWkr6Jqxx2B7cqfrSYGIAY2Ax4vZ79sSqoNNMI4mqcq8uLS/dX9b9eGwPKKXMw5xhJhqdcjHmFFdgJcBKyXJYXxU/hEGDgJshMY18Hsljv9XDJukqg5hnbXZOOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxlMQKgE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxlMQKgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A631F000C4;
	Sat, 17 Oct 2026 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255568;
	bh=Bj0m2DZhc9Y6ZfWcd2V3OtSDqyILEGcXgoT+1L/tyTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxlMQKgEHENySWVqc0B4pLD7/Z87YmTrhfEqJZZuG7oWQh7CoVI+BjgQstr65ego1
	 2unAxMTgBYCg2LhD89+caolPWkoLFb84u5PmSh2HN5VWT01sW5+Oxxp7ZFgyXQQDAl
	 maHsbcZI6kUBLjQoA5V1Bm6Pec5GmXTeFewYMoec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 819/869] ublk: fix dead loop when canceling io command
Date: Sat, 17 Oct 2026 18:01:00 +0200
Message-ID: <20261017160057.886135363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit dd24f87f65c957f30e605e44961d2fd53a44c780 ]

Commit:

f40139fde527 ("ublk: fix race between io_uring_cmd_complete_in_task and
		ublk_cancel_cmd")

adds a request state check in ublk_cancel_cmd(), and if the request is
started, skips canceling this uring_cmd.

However, the current uring_cmd may be in ACTIVE state, without block
request coming to the uring command. Meantime, if the cached request in
tag_set.tags[tag] has been delivered to ublk server and reycycled, then
this uring_cmd can't be canceled.

ublk requests are aborted in ublk char device release handler, which
depends on canceling all ACTIVE uring_cmd. So it causes a dead loop.

Fix this issue by not taking a stale request into account when canceling
uring_cmd in ublk_cancel_cmd().

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/linux-block/mruqwpf4tqenkbtgezv5oxwq7ngyq24jzeyqy4ixzvivatbbxv@4oh2wzz4e6qn/
Fixes: f40139fde527 ("ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250515162601.77346-1-ming.lei@redhat.com
[axboe: rewording of commit message]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 7fd286d8aadb2..085a4d624659f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1580,7 +1580,7 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, unsigned tag,
 	 * that ublk_dispatch_req() is always called
 	 */
 	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
-	if (req && blk_mq_request_started(req))
+	if (req && blk_mq_request_started(req) && req->tag == tag)
 		return;
 
 	spin_lock(&ubq->cancel_lock);
-- 
2.53.0



