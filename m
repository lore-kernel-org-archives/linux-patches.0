Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B1014B075;
	Wed,  5 Mar 2025 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197540; cv=none; b=JnoXTWyWkazrw3ijQ0kkShiH8wdPjcGkQXZCCJfmgztniOq7AIzBGEnn1U6V3ocQvQoEv23mPPLFyW6nQLvMefxab2ZQ7TJ5TmWlNxRBfI2wMPLzuL7a9AkziXe2Kh6Nw4OW+wctERDw9jW9YJ3RJgP14CaJOOTQXRs5XZ2+L6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197540; c=relaxed/simple;
	bh=EUMmOGA98zUOw+GFjm9jpnB1uKvPd8ySwgxnWJbqoI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXf2sdujuVo/1qNzbzcoIbTqq/SEt6XQSSgKgC9rqw1qFEA0HF9hvpymELJlIN8gWashdSX1fX6ShpCxL1emZjF9bwuPwaag2p3E47gJIdb4gY2snFQJKQfD0sSLh53hyGkJS+54bsQfwB5FK5C0/X/7a4kMvpyeZRO3dLs2b3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zla3MEr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zla3MEr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59F7C4CED1;
	Wed,  5 Mar 2025 17:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197540;
	bh=EUMmOGA98zUOw+GFjm9jpnB1uKvPd8ySwgxnWJbqoI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zla3MEr5aEGXNk+qYG96BgAy5ynIYxc+ot+25QqJACoxI8GJkfEz4S0PKmsZbktRc
	 hujMC3IAffpPjGkKHkWogiwmE9lyQeox/N4H7Q4KssNjz4EUF6fO5PvzAJUYXrUpjZ
	 1QncppOcFXwqRe7kLY2DwG96Y+Ms/X1nI84Lg8A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/142] RDMA/mlx5: Fix bind QP error cleanup flow
Date: Wed,  5 Mar 2025 18:47:14 +0100
Message-ID: <20250305174500.953701818@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit e1a0bdbdfdf08428f0ede5ae49c7f4139ac73ef5 ]

When there is a failure during bind QP, the cleanup flow destroys the
counter regardless if it is the one that created it or not, which is
problematic since if it isn't the one that created it, that counter could
still be in use.

Fix that by destroying the counter only if it was created during this call.

Fixes: 45842fc627c7 ("IB/mlx5: Support statistic q counter configuration")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Link: https://patch.msgid.link/25dfefddb0ebefa668c32e06a94d84e3216257cf.1740033937.git.leon@kernel.org
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 8300ce6228350..b049bba215790 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -542,6 +542,7 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 				   struct ib_qp *qp)
 {
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	bool new = false;
 	int err;
 
 	if (!counter->id) {
@@ -556,6 +557,7 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 			return err;
 		counter->id =
 			MLX5_GET(alloc_q_counter_out, out, counter_set_id);
+		new = true;
 	}
 
 	err = mlx5_ib_qp_set_counter(qp, counter);
@@ -565,8 +567,10 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 	return 0;
 
 fail_set_counter:
-	mlx5_ib_counter_dealloc(counter);
-	counter->id = 0;
+	if (new) {
+		mlx5_ib_counter_dealloc(counter);
+		counter->id = 0;
+	}
 
 	return err;
 }
-- 
2.39.5



