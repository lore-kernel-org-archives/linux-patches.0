Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75516283C9A;
	Tue, 25 Mar 2025 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905541; cv=none; b=B5z8oiT06YKRYwVZOphibI06tQqXoVBEn9kEccLgqPD9LEv08j10REQ7V8rz1xVKwvd/lnTPSFnmpjyvLtZ35aqOuHGskCh0rzCf2GeROsJXqnH+s6zlagzRVih/zGWnJXPrvkzQQCMRNvVTJVY1sPM1QAQUOt/J8EzD49F2lck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905541; c=relaxed/simple;
	bh=n8Y5LNTzXIWgSj6F/FnUTYZBkQnagsf+DFk27b7dExI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cC8FXMsO9Y3YI5cZZR5ZjuwnycHGXEeiEJ6XlK7KkYTuL0eT9jj50S5Yj+lztkAhfqTvCPq4chtMapSz7g15uVg2FovuqZQgNoJQbjST/VLktVs+hO48jpejw2auOydSKfqQjLLrLrnkkF8aBdl0qdu9WAe9yvfIe7patt4+0zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6fnMyVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6fnMyVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2556DC4CEE9;
	Tue, 25 Mar 2025 12:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905541;
	bh=n8Y5LNTzXIWgSj6F/FnUTYZBkQnagsf+DFk27b7dExI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6fnMyVvKv77mxho/3OhdLxtpin9waY1V0+LTwanfPZb6J8VY/54DMsRpKaRWigHQ
	 6y1wrwxpLJWY2VkYWkpeRgzbx4EOwIQ5TXE4ZhBlKPfeoMu1jtC367LtkqmkNJO38j
	 /m4pBS6rSy6ZSPyvC4hmgVyEZmrKU7rz7Its9em0=
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
Subject: [PATCH 6.1 030/198] net/mlx5e: Prevent bridge link show failure for non-eswitch-allowed devices
Date: Tue, 25 Mar 2025 08:19:52 -0400
Message-ID: <20250325122157.431034301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8ee6a81b42b47..f520949b2024c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4791,11 +4791,9 @@ static int mlx5e_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
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



