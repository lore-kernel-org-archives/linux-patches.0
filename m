Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F1F3D6CB4;
	Wed, 30 Sep 2026 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794354; cv=none; b=qHZIi+O8wNVAwDz2Ga0vhJqX8BkrSzBpNN75toTKmsMxRgzWEv+CysrxD5WEwJFhvbAJv7WuUWxdsUOay2NmOmkYXsbVIaJDpuLsWWKf4E+OqFAlTHPwtcGkBHeHKTRvgbTa38meh10IMj5Y1Se3dXv7YZgBVfSWBDuM4dQyxlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794354; c=relaxed/simple;
	bh=XUZRG1LrtiwNTuRtyswoTljimUcZlt7i3mR/2P23rbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU7OFPHtz7qFvK39fPNG69CzI9xTczaHasrke3CDOCncx2ZXc+XqP401Cdbp7xflOTh5tfVFvIUK2NT2rb7W7LLP/hvav89s3phR15MqCIegZIQrCxyWN18ENOVZ0uVD6ips217rwEAwOVq8K8zaFQZdnX6mPg1boYg1jeFzLLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjSt96NB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjSt96NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD381F000FF;
	Wed, 30 Sep 2026 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794353;
	bh=iOYDQM3jyx5Qvsghkkarryq8MxxbYjzrw9rOsXTnq7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjSt96NB5fT+wp1jw68Tn/bOEp1c+NZxUd57zfi4gvXcNoKvBIT/kTwoq1Mu7pujw
	 ghZNLpTz4MKdHNyZ67bOMaXk/bGKYtlyL5CQ7qTyZXpAxHsNq9FtiwicjTrdK65FIo
	 ixQkdIwh1jVivf7W+bLx9SndcSLziPBEd0kbikpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0180/1193] RDMA/mlx5: Fix state and counter desync on loopback enable failure
Date: Wed, 30 Sep 2026 17:14:24 +0200
Message-ID: <20260930152438.195928728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 57f0f9a6e8e5d..df9d4b8373d11 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1739,6 +1739,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	    dev->lb.qps == 1) {
 		if (!dev->lb.enabled) {
 			err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+			if (err)
+				goto err_rollback;
+
 			dev->lb.enabled = true;
 		}
 	}
@@ -1746,6 +1749,14 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
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



