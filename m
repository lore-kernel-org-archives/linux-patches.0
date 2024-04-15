Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99AB763EC;
	Mon, 15 Apr 2024 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191270; cv=none; b=jRTTEHwEG7HbTc97mgHFc18SzCp/fcPC/qU5XM3vZG0waGfCagEAEzO70YHiR4AAmzXQodg7Kq3pSuS/60QegrMqpeHCyNyfpHFdAaYJiHMpZ3vkBPds6kOWZo6HIEvnyh2auG+0bN0KGVgy7awPy/Fk0Lg13hpaguXKxI6HTew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191270; c=relaxed/simple;
	bh=jcNuu2K9KiiXkXUhlrDtDJnkmREDnICQ6c98W/TezWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpeaPeGWQ20iWPYVqzyO9mw1ni47ksyEKCBTKihGrfCgtcVJ8MoOSxVKV4s6y4O1pWS4YykNMFV6rjNdDGBKyj0ugo2QAp3KbVVGP84NgT1SvkDq3HKjGeLuBUBKZTm1DZEw2xtJ4fqNlaMI+7/gLheVjLDr9WVNj4XAQlD/ywk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+lsgbs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+lsgbs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23895C113CC;
	Mon, 15 Apr 2024 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191270;
	bh=jcNuu2K9KiiXkXUhlrDtDJnkmREDnICQ6c98W/TezWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+lsgbs6dlROWyQKgU1s+SEmX6xzX0CZSh+bp17SWDsi5MM8ELy8wGP2Jw1NLjAHY
	 TAGbEnRv+DxIp7ifD0Wbg9EF5x5lIcwyrMoywZcE9AacOs/wdlgQKdlLIo+4UHQbpp
	 oWXz4QdXkjLz8z90q2iwPzqKjs65LhGbASKdsLec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 087/172] net/mlx5e: RSS, Block changing channels number when RXFH is configured
Date: Mon, 15 Apr 2024 16:19:46 +0200
Message-ID: <20240415142003.043761606@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit ee3572409f74a838154af74ce1e56e62c17786a8 ]

Changing the channels number after configuring the receive flow hash
indirection table may affect the RSS table size. The previous
configuration may no longer be compatible with the new receive flow
hash indirection table.

Block changing the channels number when RXFH is configured and changing
the channels number requires resizing the RSS table size.

Fixes: 74a8dadac17e ("net/mlx5e: Preparations for supporting larger number of channels")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c    | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index cc51ce16df14a..93461b0c5703b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -451,6 +451,23 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	mutex_lock(&priv->state_lock);
 
+	/* If RXFH is configured, changing the channels number is allowed only if
+	 * it does not require resizing the RSS table. This is because the previous
+	 * configuration may no longer be compatible with the new RSS table.
+	 */
+	if (netif_is_rxfh_configured(priv->netdev)) {
+		int cur_rqt_size = mlx5e_rqt_size(priv->mdev, cur_params->num_channels);
+		int new_rqt_size = mlx5e_rqt_size(priv->mdev, count);
+
+		if (new_rqt_size != cur_rqt_size) {
+			err = -EINVAL;
+			netdev_err(priv->netdev,
+				   "%s: RXFH is configured, block changing channels number that affects RSS table size (new: %d, current: %d)\n",
+				   __func__, new_rqt_size, cur_rqt_size);
+			goto out;
+		}
+	}
+
 	/* Don't allow changing the number of channels if HTB offload is active,
 	 * because the numeration of the QoS SQs will change, while per-queue
 	 * qdiscs are attached.
-- 
2.43.0



