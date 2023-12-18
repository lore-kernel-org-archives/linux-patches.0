Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BDC3787C;
	Mon, 18 Dec 2023 14:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgSZJnn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6852BC433C8;
	Mon, 18 Dec 2023 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908407;
	bh=7l6G8gx/y01v3dAQwjFvEHj+pbG/WxFBv9Erb0P1wic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgSZJnn+yr9CpIegqfscjhdQ4OZHAtRx/5/MuxzCtZxdUsHt6wi9zKIKYXrfegg2R
	 3iTA70p9kLmw8jv6YlNbi3fjXt81UK2G5Gl66qH6Vp2QqaDLsDGsrSg3DnKBBW2wZB
	 g4IFaD/M9UwKnKOcLcCifTh0yYXy/am/6RnspJAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 166/166] RDMA/mlx5: Change the key being sent for MPV device affiliation
Date: Mon, 18 Dec 2023 14:52:12 +0100
Message-ID: <20231218135112.544728187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

commit 02e7d139e5e24abb5fde91934fc9dc0344ac1926 upstream.

Change the key that we send from IB driver to EN driver regarding the
MPV device affiliation, since at that stage the IB device is not yet
initialized, so its index would be zero for different IB devices and
cause wrong associations between unrelated master and slave devices.

Instead use a unique value from inside the core device which is already
initialized at this stage.

Fixes: 0d293714ac32 ("RDMA/mlx5: Send events from IB driver about device affiliation state")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/ac7e66357d963fc68d7a419515180212c96d137d.1697705185.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3263,7 +3263,7 @@ static bool mlx5_ib_bind_slave_port(stru
 
 	mlx5_ib_init_cong_debugfs(ibdev, port_num);
 
-	key = ibdev->ib_dev.index;
+	key = mpi->mdev->priv.adev_idx;
 	mlx5_core_mp_event_replay(mpi->mdev,
 				  MLX5_DRIVER_EVENT_AFFILIATION_DONE,
 				  &key);


