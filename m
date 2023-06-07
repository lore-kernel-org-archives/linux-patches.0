Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD153925E
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5DAC433EF;
	Wed,  7 Jun 2023 20:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169297;
	bh=17L55NsQn/JO1fhwW7Z5oAOkBc/zfFpEmTO+AjjHJ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3/gtwUTv4P7Yb1akZJ+2eZTrEB1yCe+CV9GyGDspA/oSaaua74XMsE9X/kn3Akwr
	 9sYBGPeGZMRRxadIbFnuJHSBbXQlHlBcql84TEPmH0e7atYYdMcS1erfi8juj9p/eY
	 9AsZCGaYLZXEY1xsm/G1Q3bTNU74FxkUMYfJhPmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 027/286] net/mlx5: SF, Drain health before removing device
Date: Wed,  7 Jun 2023 22:12:06 +0200
Message-ID: <20230607200923.904348667@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit b4646da0573fae9dfa2b8f1f10936cb6eedd7230 ]

There is no point in recovery during device removal. Also, if health
work started need to wait for it to avoid races and NULL pointer
access.

Hence, drain health WQ before removing device.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index a7377619ba6f2..2424cdf9cca99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -63,6 +63,7 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
 
+	mlx5_drain_health_wq(sf_dev->mdev);
 	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
-- 
2.39.2



