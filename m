Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61B51AB534;
	Mon, 14 Oct 2024 14:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917543; cv=none; b=AJocyJ68ncpIW1i2nGhbH6QmwrsDgIZbo1PD3/BxXDiH6q35PXadrKcvQL+HV1GkGcWJ/XkIXhDGNGvtZKdKa9I6r3gutP0Uv+2HVL9DeDfidVKhGzmR4lAEr3lwxsYOLvFq1rfhWe5fW4A8IDlXV80IVlfJliy6UbjV2BlYEws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917543; c=relaxed/simple;
	bh=zzzUKpe1TnS/cchnfWqzwapRxV7UrgvoEc44FG7s2q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B8IiB1sjYYp4I7ez9L/eOBCRi4L6rAJr+Tbtrf7GNzlF76pY7LgOGYi+fFuJHqq49EFQEVXL9BLFOFmzmnTYBouNXkNc9/L+y2CHjr650pwBnFJhGsvfMzPBUV9d9VKWJJhbtAzy2/qCKZxrLSY124kMztx5avbhzqmE8+IJhKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBRZmi0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBRZmi0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDA2C4CEC7;
	Mon, 14 Oct 2024 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917543;
	bh=zzzUKpe1TnS/cchnfWqzwapRxV7UrgvoEc44FG7s2q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBRZmi0UxvQSfoEy+U04tMY0n/XGBeGyquOy5SkhariVYsuCX/uqIOeg0BofXbZsF
	 8c2pDBTN5BwfyYZI9FNf54cLaY/EF4sxkjlZxZEVoq9ZrvZGUxpUqXGKqX6xOM/WBl
	 hMkZoAW0kngpXIgiVMfcCL798EZ+XTYFkqG28IBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/798] block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()
Date: Mon, 14 Oct 2024 16:10:18 +0200
Message-ID: <20241014141220.456745793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 0e456dba86c7f9a19792204a044835f1ca2c8dbb ]

Consider the following merge chain:

Process 1       Process 2       Process 3	Process 4
 (BIC1)          (BIC2)          (BIC3)		 (BIC4)
  Λ                |               |               |
   \--------------\ \-------------\ \-------------\|
                   V               V		   V
  bfqq1--------->bfqq2---------->bfqq3----------->bfqq4

IO from Process 1 will get bfqf2 from BIC1 first, then
bfq_setup_cooperator() will found bfqq2 already merged to bfqq3 and then
handle this IO from bfqq3. However, the merge chain can be much deeper
and bfqq3 can be merged to other bfqq as well.

Fix this problem by iterating to the last bfqq in
bfq_setup_cooperator().

Fixes: 36eca8948323 ("block, bfq: add Early Queue Merge (EQM)")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240902130329.3787024-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 30045b28ad63f..7684df94fcc62 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2889,8 +2889,12 @@ bfq_setup_cooperator(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	struct bfq_queue *in_service_bfqq, *new_bfqq;
 
 	/* if a merge has already been setup, then proceed with that first */
-	if (bfqq->new_bfqq)
-		return bfqq->new_bfqq;
+	new_bfqq = bfqq->new_bfqq;
+	if (new_bfqq) {
+		while (new_bfqq->new_bfqq)
+			new_bfqq = new_bfqq->new_bfqq;
+		return new_bfqq;
+	}
 
 	/*
 	 * Check delayed stable merge for rotational or non-queueing
-- 
2.43.0



