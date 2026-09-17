Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F794FC330;
	Thu, 17 Sep 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664393; cv=none; b=lzk93IcoEmpAJKKzrFD9hQTVPuQZFSk09dSunBSE9fslXzPDQcFQXzyShs6AQg5/YnpRtpAxnDXxDG87Tpj5qAz7tA4AnQNWkuFvo8bFeZiuKNfLsRIT7xXAW6sbCW0XwhIW1OnYW3Q0BV875JKOkAr0Q2YdB/msXYmxEiBVKxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664393; c=relaxed/simple;
	bh=Dvc6UlfOYpxVj5YFQhoBpJSytCMfXcjPhQ8rL53APWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGBzO13depbNJ76qtniIGDf2bnZ1RAaU/nFKsTUV08N6pAX4Sf93b74QZxAqd4kLJWmelMUZ3Y7edPoNHWXt+t/pEy0nmpRvDjWF5YxveLlG50NT1IU168+6ivewG8GgM0uPMkQ0MQpK2rPMmHF9O+ZHvcfKnBUFUjiEEbrk+yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mucxXksM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mucxXksM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBB21F00893;
	Thu, 17 Sep 2026 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664392;
	bh=IgqKF/TbV6EN9grueLbcl5Ncy0X1PqrHWQFMtrUCwzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mucxXksMhcbX58peynSRO64UXhx9SCER04ypPbOmlTyU6wGILfY5kfXM4PKp0LwTG
	 qMf4rDxCdtMLWwUHL7LOHU1AcQ0MsiqSYS+5zl+WwHvEQR+P8ssTx217PYfuPbE+Te
	 m2v1YJIRaJ6Os+bT/6bTsclctb+ZjWWGUKgjy7rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0341/1250] RDMA/mlx5: Fix state and counter desync on loopback enable failure
Date: Thu, 17 Sep 2026 16:02:16 +0100
Message-ID: <20260917151601.323426424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7c82518e9f046..c6b0bb786739d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2019,6 +2019,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	    dev->lb.qps == 1) {
 		if (!dev->lb.enabled) {
 			err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+			if (err)
+				goto err_rollback;
+
 			dev->lb.enabled = true;
 		}
 	}
@@ -2026,6 +2029,14 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
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



