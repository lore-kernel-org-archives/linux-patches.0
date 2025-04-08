Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7025019AD5C;
	Tue,  8 Apr 2025 11:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112315; cv=none; b=rsVK7i4ArTUmDdGmo5aax4vsidPPTxz+iCPjGn4e2TlEz/50yC+B6gAD1kEyUhHAX6YSDiAq7PP2lwonlUBMLQ3I7YcNXu5dEYByhS0r/dh6rh0VaF7NZRsbbi8KIG+UvScVxirAwCR1Tb4OG2MyhZsJE9aV8K4tyiXuXzz4p3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112315; c=relaxed/simple;
	bh=2MunAfwOxLnevAVCz/hz/dhszkubZJJ+HXpvZiERjlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBFI9/j0NqsudqyKSKOpXKUQgBinB4r61zmwOU8mog2oIwwuFnkQDZrJmR4C9a+D6DKndlX0nv69kOeXYptPD4J12QegSj6dM0VAjUuAGXOiUQpMwg6i4IYTTHFqZnS7YrsLqZB8eQ+ReqPNGD/FlRpusg3pxMKvZh+BpVAikqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACHrr1QF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACHrr1QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2824C4CEE5;
	Tue,  8 Apr 2025 11:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112315;
	bh=2MunAfwOxLnevAVCz/hz/dhszkubZJJ+HXpvZiERjlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACHrr1QFq7LLNBH3x5xvyzmXX6Y+aqpxfcs4IzyZP07GUyj/ixM9JRwFOrcL54bF5
	 ZU0YHWdwjxJVsBk/ncZBHyiPY3j8htTiga8rGLioL+5jmYg5MTWhC0F6xed3lLxWrh
	 B3WILbvNWQZR7Jg02+uUAPqraSVVKVTLuk4L/Ak4=
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
Subject: [PATCH 5.15 023/279] net/mlx5e: Prevent bridge link show failure for non-eswitch-allowed devices
Date: Tue,  8 Apr 2025 12:46:46 +0200
Message-ID: <20250408104827.009886269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0870da414538..321441e6ad328 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4186,11 +4186,9 @@ static int mlx5e_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
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



