Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE3B32E144;
	Fri, 17 Oct 2025 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714158; cv=none; b=G1yvTKIg2HbXS9jkepLJiyATRg/x/Y5Ps1da4quBdCzw75zqBZb9/n0GRUnUSgpxMDhd9htyOVRTatuC2gmvBfGQZK3EuLU/BSHAi2z2eh6VuXO+DJ4xuEncgJTyne6hPXcbzMEZyqvRgJ3RniiQphX75cDoH8UjfZ/xH8TVY9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714158; c=relaxed/simple;
	bh=DOV3mQBhFPhg1xEVP90Si08JGqo7+rDKkMUaPtmiQZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpvCBpzcsYk83cqd5xsiOCli+qFJjKCgHGKhgxLB1n8serxyYdJTctIgrcF8hRJtgmkc20s0bkZ89KUTS+y8qkkm79s9uq5hjkNmrNXfaod8pAv/MtHAwl/QqjOdVQU6Cv2Aa9J56gEbIaVslSXJaa3vP0igCiXZa7RLv9OJ2XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cReK5Vzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cReK5Vzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6AFC4CEE7;
	Fri, 17 Oct 2025 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714158;
	bh=DOV3mQBhFPhg1xEVP90Si08JGqo7+rDKkMUaPtmiQZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cReK5VzyATlYzKPmdb5E+eICe+YkUBYv8w8z8aORiZmlhODHLLVxEg5Uz+Wbwtl0L
	 IEIEl1leIyJIM12jlS9Gjd5afjjOV3pTq5ytvFXJHq8LJLVrh017VYSIEjLugImPBP
	 lh61eQoCgSDzZSCKrifTgfiYXiQEbMuKarxisYag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/277] net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()
Date: Fri, 17 Oct 2025 16:50:54 +0200
Message-ID: <20251017145148.865559141@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 281b34af0bb48..3160a1a2d2ab3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1180,9 +1180,9 @@ static void mlx4_en_do_uc_filter(struct mlx4_en_priv *priv,
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



