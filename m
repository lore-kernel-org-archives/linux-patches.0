Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65934191466;
	Tue, 10 Sep 2024 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964815; cv=none; b=M1mckQmFwIu+lEj74LTBt2wOKbqN/p+tOd1TXkWRAX8LySiWr7m6tUWBbWS6E5QzBYGGxa/rbTgmILSr1rsfcOqFJg4rmPERT6rbk50vcJMpiIM9UolF7wAjwPc+I6GygnwKbGAiH3Pfysn5EGeTHTp0isR3xR6pgOpmqwn3I3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964815; c=relaxed/simple;
	bh=0wOdwaxe5s3CAKor/0KwkdnDEh5pxIMf1SG9Z6Cg4Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALGI63H0lCxNb/G7atZbL545vOkOAU39dFmYXbWm7+evkEIIQzd1Y7SMqNJDAc3W7t89qSWxpL3r2+3FlGQDwxOhGUw9mRHqz/J4XhVn1zwjMGIgicBgKUYsQszN2SZ6TtK6vhPzv76j1ewz3ZvGTcxYpvR/Y8EzOcotW7r3PIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuIjn3s/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuIjn3s/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06DFC4CEC3;
	Tue, 10 Sep 2024 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964815;
	bh=0wOdwaxe5s3CAKor/0KwkdnDEh5pxIMf1SG9Z6Cg4Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuIjn3s/XZ3YPSQyh2+rAuePRB35Gbak33Lecj129ju/G/OoDScED/ym6vTMczOOw
	 IGFtCkLVeC8Dfrmtl5isfQ2feItaUEs1WFS2uRkigTcI9cz4KVsjYKx2G9qeQ68yXk
	 aW7IEvOGBUj9CVStPA40P2JsP6/XAi5gfULB0FI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/186] block: remove the blk_flush_integrity call in blk_integrity_unregister
Date: Tue, 10 Sep 2024 11:32:16 +0200
Message-ID: <20240910092556.221403309@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit e8bc14d116aeac8f0f133ec8d249acf4e0658da7 ]

Now that there are no indirect calls for PI processing there is no
way to dereference a NULL pointer here.  Additionally drivers now always
freeze the queue (or in case of stacking drivers use their internal
equivalent) around changing the integrity profile.

This is effectively a revert of commit 3df49967f6f1 ("block: flush the
integrity workqueue in blk_integrity_unregister").

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20240613084839.1044015-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 9e83159f5a52..2bcf3760538c 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -431,8 +431,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!bi->profile)
 		return;
 
-	/* ensure all bios are off the integrity workqueue */
-	blk_flush_integrity();
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
-- 
2.43.0



