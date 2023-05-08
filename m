Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0350F168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F69FC433D2;
	Mon,  8 May 2023 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544605;
	bh=TYdkKJtk8KHRsS8WwudwpLdKAq+ymgp9oX96xCy6G9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHezt/q+XZ5nNKdZux1LURjp3e6kBGXWyshCM5McyBMFPI2r50ogYBMzN43QekkkI
	 2lKVQ6AViimCP8+24OQdJHle/O+VbfnFaHAlsrH634FnTjvdcDPVAE6lRufXokd4gO
	 QNylqIUwvR0XYUxrVhYKHxcJ0Dbgyvvc3RsLwXw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 464/694] net/mlx5: Release tunnel device after tc update skb
Date: Mon,  8 May 2023 11:44:59 +0200
Message-Id: <20230508094448.770807297@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 4fbef0f8ea6350eaea89b1e3175f9325252913ac ]

The cited commit causes a regression. Tunnel device is not released
after tc update skb if skb needs to be freed. The following error
message will be printed:

  unregister_netdevice: waiting for vxlan1 to become free. Usage count = 11

Fix it by releasing tunnel device if skb needs to be freed.

Fixes: 93a1ab2c545b ("net/mlx5: Refactor tc miss handling to a single function")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 8f7452dc00ee3..668fdee9cf057 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -715,5 +715,6 @@ void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
 	return;
 
 free_skb:
+	dev_put(tc_priv.fwd_dev);
 	dev_kfree_skb_any(skb);
 }
-- 
2.39.2



