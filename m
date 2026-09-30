Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B461B50E5B1;
	Wed, 30 Sep 2026 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782605; cv=none; b=W1m9VUwT6yWcQ/1+ZzSH7sPlsvvx8wC4FVhge5E5ZlmU8Vd8PdAm3eSLm6i+9ALTai631NuxX7G3kSlNaJFeWwLfyOOWQpImr9pWN6qCcYVHl5BWf7DoNu2htUCAdJy4zT4fwfyr01JcPfJKPuBfdglN5914SxB8u9Qy97ewxNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782605; c=relaxed/simple;
	bh=v3OhlcrrKh8n62ljCjApg0IEMC6BeQRyIrrFPcqO/r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHDcjWW5iKgFX1pmOwSjjG61YRUT1muB1wdMip+IZ4nz6vU7pgF2XghWykK+WtgNkwlRgnTEoCIQGtMrbzi1JoV/er6ute7neQlwg65a/OSNoZ2EUdAQ7Msn04byBkU7ZOanLxb6Zo4XAiQRXY0f5uO+AGl+4RIwIswzNyKQU4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAk/eYH6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAk/eYH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4C21F000FF;
	Wed, 30 Sep 2026 15:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782598;
	bh=ebnVIb4M0Hp6tR44My4n4fVla1wq9aoQmO74OhAIPBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iAk/eYH60FDMoaUYh7ybF9qwNKwXhPBxC/gDvD/vjN9jkfzCLZQXzC9DdijZ18nO6
	 Xfh//xk6iy4agSZaf3dwLV88QmKehTgUNX5p8f1pqmUC4HXwOLW9nVAu1rW70B75Fn
	 R0x9rI4lsZDHpU/tEommVRCYYYCOLVl+HmJApzlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/595] RDMA/mlx5: Fix state and counter desync on loopback enable failure
Date: Wed, 30 Sep 2026 17:19:55 +0200
Message-ID: <20260930152349.932783959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0d32eabccbe4b2f8d45be3192c5f3c76c8af703d ]

In mlx5_ib_enable_lb(), dev->lb.enabled was unconditionally set
to true even if mlx5_nic_vport_update_local_lb() failed.

Fix this by only setting dev->lb.enabled on success. On failure,
roll back the reference counters and return the error.

Link: https://patch.msgid.link/r/20260601095818.2227-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0e20b99cae8b6..56151a616b07c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1708,6 +1708,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	    dev->lb.qps == 1) {
 		if (!dev->lb.enabled) {
 			err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+			if (err)
+				goto err_rollback;
+
 			dev->lb.enabled = true;
 		}
 	}
@@ -1715,6 +1718,14 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	mutex_unlock(&dev->lb.mutex);
 
 	return err;
+
+err_rollback:
+	if (td)
+		dev->lb.user_td--;
+	if (qp)
+		dev->lb.qps--;
+	mutex_unlock(&dev->lb.mutex);
+	return err;
 }
 
 void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
-- 
2.53.0



