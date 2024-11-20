Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4425B15853A;
	Wed, 20 Nov 2024 12:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107492; cv=none; b=S4LghRy8bkGoFvpkccbfIcHldu7fLYJEN6wMbW7nhnQUsWyQxaVY4WPXnKFV66zL3vpcmt4kEhF/s3kND9maszeK7acz9c2aPS3BZmSstQEwq9WdvV1rraZHLF3t63d4OYNthnkEOVv03XbxWSSuqWELWGDxOKFT575fHvHBXcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107492; c=relaxed/simple;
	bh=4qYbZkL8CecxlzD/SlHXidXU9+nc6/aXySldRK58K4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noSjRsylBmlYRQACET7Eg0MZlPzZQo3c/h9EkWrUCsnBiQfUIr6H6y43PueorLDyWkaLSc+oOQoISGxdt2did4MVP1MgH/yk+74cPAoLLCegeDC9Zfa8GJn92gMDzGYzuLbygkvVQzTVU9gOL/Qvrq3lVIeIKRW0wNH8sIUz6sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w49jN2xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w49jN2xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C505FC4CED8;
	Wed, 20 Nov 2024 12:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107491;
	bh=4qYbZkL8CecxlzD/SlHXidXU9+nc6/aXySldRK58K4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w49jN2xPJnpBP9B+kFFMi+j8fwPBTO2a9mQ6PfRuqMQ0bRHnVb7PAnX5VRffWQOvY
	 +vxsX/MjKn4xnvY9PaxsFwggkYb5pWty/9N4jnKnrgsi3iqRRnBWHxu0utSFZ1ym27
	 aJZHnJ5LSSDOVFRQbSja68iJzKatnx+btiZM8dig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 013/107] net/mlx5e: Disable loopback self-test on multi-PF netdev
Date: Wed, 20 Nov 2024 13:55:48 +0100
Message-ID: <20241120125629.980088020@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit d1ac33934a66e8d58a52668999bf9e8f59e56c81 ]

In Multi-PF (Socket Direct) configurations, when a loopback packet is
sent through one of the secondary devices, it will always be received
on the primary device. This causes the loopback layer to fail in
identifying the loopback packet as the devices are different.

To avoid false test failures, disable the loopback self-test in
Multi-PF configurations.

Fixes: ed29705e4ed1 ("net/mlx5: Enable SD feature")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241107183527.676877-8-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 5bf8318cc48b8..1d60465cc2ca4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -36,6 +36,7 @@
 #include "en.h"
 #include "en/port.h"
 #include "eswitch.h"
+#include "lib/mlx5.h"
 
 static int mlx5e_test_health_info(struct mlx5e_priv *priv)
 {
@@ -247,6 +248,9 @@ static int mlx5e_cond_loopback(struct mlx5e_priv *priv)
 	if (is_mdev_switchdev_mode(priv->mdev))
 		return -EOPNOTSUPP;
 
+	if (mlx5_get_sd(priv->mdev))
+		return -EOPNOTSUPP;
+
 	return 0;
 }
 
-- 
2.43.0



