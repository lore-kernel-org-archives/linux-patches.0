Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215EF2E1747;
	Tue, 15 Jul 2025 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587087; cv=none; b=PTL+5FHFmwm9/FpBL91SfOIJwXldqvzq9xHYHY6YySJsu0TnZTOVXLzP15tJL4bAFWVo5k7lG6X5Yn2oAxPCLL+ydZtHp0bSTBjugBI/FKXxna9U9+dKE/sscdvQmqP7ToXOECL924WWdBaBuOOPDOwzz9mL42S+lEWguX5JaLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587087; c=relaxed/simple;
	bh=33fOF0xmD4U+VcEURYIttzp95Kfu83igMDFpiKWCIDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZobiLlIqEAjSfvTU0ZsFHmGEftOym2diGFrxhTf8Dl5czziDoOBUOZjNJCDOtAdsbB89VqVQejcUDTOn734Ahn75fbRpZ1c6Xs0kgyU98VypTuq7YXP0Jlow+y+K4U8LfmmId2c/O74+3xdL9It9XF87n/qROEZ7k2VqUYPEnFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCf8Oi9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCf8Oi9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6238EC4CEE3;
	Tue, 15 Jul 2025 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587086;
	bh=33fOF0xmD4U+VcEURYIttzp95Kfu83igMDFpiKWCIDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCf8Oi9O5cQCkmhkUMeD/atdCSlVUcwQ6ZNdpebE0HRJcIHgIxHW6bMYm2F9RvM8C
	 X1tEoFc7SLYNa+JbNaeOue+rT7GpQPozGsqLDiB2T9R7JRWyNcdMXPJ0b2XN3bfeBo
	 4kFz2yKyA82pzh/wIyi7K9RbDPkbq/0ZSD5XB7/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 130/192] md/raid1: Fix stack memory use after return in raid1_reshape
Date: Tue, 15 Jul 2025 15:13:45 +0200
Message-ID: <20250715130820.115382604@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1fe645e630012..80efe737010b5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3431,6 +3431,7 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
+	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
-- 
2.39.5



