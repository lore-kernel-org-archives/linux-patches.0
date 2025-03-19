Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF2B1C7013;
	Wed, 19 Mar 2025 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394864; cv=none; b=QQy6KCgCxa9gVh3cPF9dveBpgvhhwda+r0nZuRaiX9KWlSw1M36A8m3mCaunteaJ8cCdA++O2f5hY5zUK1/wa4/tNgxMOQ60E1cfLrGxIXIn9DYyZn72sfaYqkpGDSZzwBtW4qJsFyG1FcvyIY0ADT2CY57c7g+RnnPmc89Nd5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394864; c=relaxed/simple;
	bh=XKuNocVFsgddL+zS69tHYFmBXW6WVjhgHf88zCCkfDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkDt1RaBN77kdPD7HZPAemQT0aIhBWKmVWvYQ9HDe5zUwTAySR83rCKBnk6ty4lbKJ1sh9E4STBz7UpD4lCqRbWu+y6Cy38/1UdNLRVjCIgQsp5RjCZuKqkia9qGR0z0KQvtrkTwOMZDyh4BEDWkMT+MVoDm57hp6zynNMHGynw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoSxoj/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoSxoj/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DFCC4CEE4;
	Wed, 19 Mar 2025 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394864;
	bh=XKuNocVFsgddL+zS69tHYFmBXW6WVjhgHf88zCCkfDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoSxoj/kguCkAVqYETpenRCxb6l6OrjVQzNgVfxWm3jCL1017WCZk15fifIazrC1s
	 JDSWamWqo1cdDXXQhJs2mb1UmJ2u4v6Qbo3mcTUzIClRxUGrhG1seS01cpSG1MDfwt
	 AU2xIFSn6P/gN7ov8ETAr0NC4N29qigUg0+WtxDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 055/241] net/mlx5e: Prevent bridge link show failure for non-eswitch-allowed devices
Date: Wed, 19 Mar 2025 07:28:45 -0700
Message-ID: <20250319143029.087180227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit e92df790d07a8eea873efcb84776e7b71f81c7d5 ]

mlx5_eswitch_get_vepa returns -EPERM if the device lacks
eswitch_manager capability, blocking mlx5e_bridge_getlink from
retrieving VEPA mode. Since mlx5e_bridge_getlink implements
ndo_bridge_getlink, returning -EPERM causes bridge link show to fail
instead of skipping devices without this capability.

To avoid this, return -EOPNOTSUPP from mlx5e_bridge_getlink when
mlx5_eswitch_get_vepa fails, ensuring the command continues processing
other devices while ignoring those without the necessary capability.

Fixes: 4b89251de024 ("net/mlx5: Support ndo bridge_setlink and getlink")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/1741644104-97767-7-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cb93f46eaa7c3..e02bb589104a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5131,11 +5131,9 @@ static int mlx5e_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 mode, setting;
-	int err;
 
-	err = mlx5_eswitch_get_vepa(mdev->priv.eswitch, &setting);
-	if (err)
-		return err;
+	if (mlx5_eswitch_get_vepa(mdev->priv.eswitch, &setting))
+		return -EOPNOTSUPP;
 	mode = setting ? BRIDGE_MODE_VEPA : BRIDGE_MODE_VEB;
 	return ndo_dflt_bridge_getlink(skb, pid, seq, dev,
 				       mode,
-- 
2.39.5



