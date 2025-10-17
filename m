Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCEF32E144;
	Fri, 17 Oct 2025 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713537; cv=none; b=Dd+cYs4p5ymG/YRq0HzQw1yQ4Eh96tF9I+Ax6EfcapMb27k/XcwA8r1pYT3xeZ0YmKI8Opkc1s9BDebS9U1aVsl985C+7yLTt2rwcrp0VnY3esK1QFiKg7LjgjuDxjGWR7hY8tLpe3IuTMgppJahSFwpW7HHWzZRJfzkepmOWZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713537; c=relaxed/simple;
	bh=66lAXbvNcWzYoNPTHvbm47tsu/kkBO4/YmvmLCpD6DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmqRrXBKEUrT+Y+mZmKlWElqqZ/+oeVgbIV8NsSrXJPgLurDvFV1n7GUGWQnewECMYhQuqL40nXCucAo5i6UFE1F/aicNd91eNyzhTdTivpTjGbVW2aGanCc+Tf9R5Be9n2RZ82jhevMZ7VC5o6Aooo5UiB8CiLff2Oita4IgRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6CJ3Ux5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6CJ3Ux5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEE0C4CEE7;
	Fri, 17 Oct 2025 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713537;
	bh=66lAXbvNcWzYoNPTHvbm47tsu/kkBO4/YmvmLCpD6DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6CJ3Ux535jPCIyAHfxI3m8RQqwSzf28vy9uRgDsDr5MiF6fZFCDBXSrpZYlR7vPQ
	 zWuDMXmRCyx9C1gDQagnhwJt/h7zNUyVt8X88qjRMKIyAEftWMgCSK83Kj+HOTb1iV
	 Zuh5uO2gO3Qb1dP4xKJlnSaQ2SJlC2l27MRIOwHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/201] net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()
Date: Fri, 17 Oct 2025 16:51:32 +0200
Message-ID: <20251017145135.886977386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4f0d91ba72811fd5dd577bcdccd7fed649aae62c ]

Print "entry->mac" before freeing "entry".  The "entry" pointer is
freed with kfree_rcu() so it's unlikely that we would trigger this
in real life, but it's safer to re-order it.

Fixes: cc5387f7346a ("net/mlx4_en: Add unicast MAC filtering")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/aNvMHX4g8RksFFvV@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 33bbcced81059..275561272721e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1177,9 +1177,9 @@ static void mlx4_en_do_uc_filter(struct mlx4_en_priv *priv,
 				mlx4_unregister_mac(mdev->dev, priv->port, mac);
 
 				hlist_del_rcu(&entry->hlist);
-				kfree_rcu(entry, rcu);
 				en_dbg(DRV, priv, "Removed MAC %pM on port:%d\n",
 				       entry->mac, priv->port);
+				kfree_rcu(entry, rcu);
 				++removed;
 			}
 		}
-- 
2.51.0



