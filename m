Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15983A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDC4C433D2;
	Tue, 10 Jan 2023 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374117;
	bh=dgBuJ/wNFAepbRyhDsrrdjQVSLl/ASi5irr8hnsThJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyr/EZ1yVvRO1In89JBXBaGysIqUzC9Rr1AzB50pC3aRFmZA7tpA2amVoHFfqgEEX
	 Yr6tqyoLZhw+3ikE5Q07yy7OAFra4LeoDB6RxrXvORns/ENK7gmE1WitFv+NmAFTHW
	 bahJCjV065uDfob4wlTmXIOxd/u12oRi1TAcg0t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 052/148] net/mlx5: Fix io_eq_size and event_eq_size params validation
Date: Tue, 10 Jan 2023 19:02:36 +0100
Message-Id: <20230110180018.876633126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

[ Upstream commit 44aee8ea15ac205490a41b00cbafcccbf9f7f82b ]

io_eq_size and event_eq_size params are of param type
DEVLINK_PARAM_TYPE_U32. But, the validation callback is addressing them
as DEVLINK_PARAM_TYPE_U16.

This cause mismatch in validation in big-endian systems, in which
values in range were rejected while 268500991 was accepted.
Fix it by checking the U32 value in the validation callback.

Fixes: 0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 66c6a7017695..9e4e8d551884 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -563,7 +563,7 @@ static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
 					  union devlink_param_value val,
 					  struct netlink_ext_ack *extack)
 {
-	return (val.vu16 >= 64 && val.vu16 <= 4096) ? 0 : -EINVAL;
+	return (val.vu32 >= 64 && val.vu32 <= 4096) ? 0 : -EINVAL;
 }
 
 static const struct devlink_param mlx5_devlink_params[] = {
-- 
2.35.1



