Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374292E973D;
	Tue, 15 Jul 2025 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587910; cv=none; b=C/ADqmX+++zxV+NGSi7WUuxLadhov4+2xPEX2TEjg67XnLfNIONjCaTQl6lV9Rj7VIHFYRVNG+FOn8Cba+jLeASvIAwXAhOBYvwAy2C9wcPTHDC4zWMurCr6JmK9YvRYJ0MWGTURvbInpC8lShqQbafY76vGmTOJR6/cmT05Ypg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587910; c=relaxed/simple;
	bh=yuyKurA70QG32saSU8AU4FDgV23q3BgFlJyjJ6nTtnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbFfa0bcNfEDZYctzp5bSm7+eOgLjGJynO6hWsqFgiJDcdWKiPQbUrCbvm/gZp5rdDgD1TwgcT2Psa/KqeKgDuWAoF1E8q+ShP4RhwpbrpBCXuSZ/83/QpsDHAI0v4CcNIkdp9lSIMSetVSe6ClOm0ByL5AFBubLvJeu1svfBrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnDTfE27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnDTfE27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02CAC4CEE3;
	Tue, 15 Jul 2025 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587910;
	bh=yuyKurA70QG32saSU8AU4FDgV23q3BgFlJyjJ6nTtnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnDTfE27bX4iOBa1hfri0pA2rImr6bflprT63IRIG3Z5o3Z7Noez8mpGbX8VUeXle
	 /aULZVO/wYxNe/roVkUpQGDuh69Q4f/U/lOc903LiJCANPae1SJCHmwSi2cbERQt6w
	 DdHDybuy4lOTvyIZw1qRwj88xhKAbEA7MfC+NNMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/208] md/raid1: Fix stack memory use after return in raid1_reshape
Date: Tue, 15 Jul 2025 15:14:57 +0200
Message-ID: <20250715130818.482037660@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dada9b2258a61..51e05ea3f1373 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3290,6 +3290,7 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
+	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
-- 
2.39.5



