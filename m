Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BFB2E3398;
	Tue, 15 Jul 2025 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585625; cv=none; b=DpuV6C6IeiaeSpGoTOql6Bq7inUbZkfvmiyQhior16VOpXaaxWovgmFcl0adK696Q8/IGMebpjttShOlNe5yvGZ9ZJIVTxypCKAfljMOz+xw9Tu+bkoaGQV3t9e4oyymVbdMBk1UlWy4YqWcY+xpxqr6i4eGIot6oXAJgy1k5D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585625; c=relaxed/simple;
	bh=KC3NLrlQ4H8ccBV8QVnmIqUe92B1AUDaSNam9hw+68g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGIOxaBHu4OzM72pdrR38mBeilE++JEdMtCNdoYl76bZYGFZCwf5wRuJd8Wp26dolJ7vD2YnaQN2aNMsCwvgxpa9xa3+f+Mj7AuQ/Ehe0eZz+G5p71WlVE1IsWYBxtusbmQ4NRtN9uaLhLcXmBf3tUdi9d2ztJIKjaqybsgWMEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2HHo3BN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2HHo3BN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC440C4CEE3;
	Tue, 15 Jul 2025 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585625;
	bh=KC3NLrlQ4H8ccBV8QVnmIqUe92B1AUDaSNam9hw+68g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2HHo3BNgV9UdeuP5TRALsqEuDoM/M6zupV8vWnt1xMlvClxOprwtmteKR99agz2V
	 h+d8iIJk1NkpdnQeN5xvQhj0QckGFI1hiz+U9BiLNfB04HHaalCBZTf430Y1J/kriz
	 plkeMKfKkWhvz7jZtviMwRZKqE/rydmkzFEWrQ60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/163] md/raid1: Fix stack memory use after return in raid1_reshape
Date: Tue, 15 Jul 2025 15:12:58 +0200
Message-ID: <20250715130813.269485625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wang Jinchao <wangjinchao600@gmail.com>

[ Upstream commit d67ed2ccd2d1dcfda9292c0ea8697a9d0f2f0d98 ]

In the raid1_reshape function, newpool is
allocated on the stack and assigned to conf->r1bio_pool.
This results in conf->r1bio_pool.wait.head pointing
to a stack address.
Accessing this address later can lead to a kernel panic.

Example access path:

raid1_reshape()
{
	// newpool is on the stack
	mempool_t newpool, oldpool;
	// initialize newpool.wait.head to stack address
	mempool_init(&newpool, ...);
	conf->r1bio_pool = newpool;
}

raid1_read_request() or raid1_write_request()
{
	alloc_r1bio()
	{
		mempool_alloc()
		{
			// if pool->alloc fails
			remove_element()
			{
				--pool->curr_nr;
			}
		}
	}
}

mempool_free()
{
	if (pool->curr_nr < pool->min_nr) {
		// pool->wait.head is a stack address
		// wake_up() will try to access this invalid address
		// which leads to a kernel panic
		return;
		wake_up(&pool->wait);
	}
}

Fix:
reinit conf->r1bio_pool.wait after assigning newpool.

Fixes: afeee514ce7f ("md: convert to bioset_init()/mempool_init()")
Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250612112901.3023950-1-wangjinchao600@gmail.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6b6cd753d61a9..fe1599db69c84 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3380,6 +3380,7 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
+	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
-- 
2.39.5



