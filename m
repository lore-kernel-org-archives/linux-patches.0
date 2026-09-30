Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2EB5208D6;
	Wed, 30 Sep 2026 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790928; cv=none; b=rykekakQ6ZFbyD2ZX1vZdDC++vZdUYCKqsYDUTk0kq42ujjSS4Pf4rSbxHPMih+Vhxd2PpLnjIYsQ8EVr1Wr3Z+ZxbfA81vIWdAEcGgQFrAv9/Eanp/eZ/p6BL6aZkMLmSS8A3bVB4xaSkhJ0iTPLaJiO4LtnzkA+v9TR9XgMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790928; c=relaxed/simple;
	bh=F6iBwmngFErD+bC4hJPGgHPen1+pQPGfviWZyU9xRqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNzc3Ig1xoAnc237ZyhpbCUBN0tjt9TXoRP1n4Hf0xqCeRH+fyaTZpXDFIe0+oWvkR/IrGVEmtu33RnSTaqEm/XV+BofxU48D8Z01np7R153pKuT8aof61stdcn/k+DMDLxhn3Z/pIVMU2NIjiMm47b9J9y27ETFfVqztQNCQ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dypw/mFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dypw/mFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA7E1F000FF;
	Wed, 30 Sep 2026 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790926;
	bh=18QPl/yNzHBgNQ1JW4Xyf4kz6auqb43j3Sk//hLkWT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dypw/mFSRVb5YHAAhhj7ibo9g/uZtBMlNcE98U9U+UrCB9ZegD5SYjByJcEzMRx6W
	 lzkX2ocGroCQQUkKu/NUBlzbSURrxDoVvps3RzMCNlOazfekC1KnBa7YVScyByOPJx
	 MbPjxPN/a/e3XxL/mBsUTwfPbxzWoHLjGRbLVrcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/752] RDMA/mlx5: Fix state and counter desync on loopback enable failure
Date: Wed, 30 Sep 2026 17:19:51 +0200
Message-ID: <20260930152400.798454997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3d4eb71904bcb..7afccf1d79d66 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1721,6 +1721,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	    dev->lb.qps == 1) {
 		if (!dev->lb.enabled) {
 			err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+			if (err)
+				goto err_rollback;
+
 			dev->lb.enabled = true;
 		}
 	}
@@ -1728,6 +1731,14 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
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



