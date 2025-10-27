Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BFE324B1B;
	Mon, 27 Oct 2025 18:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591216; cv=none; b=DnXHn1ZBR9FLUNIYTSVO2C9CEb6urk/ih71mAx3VRx3aKRjjTPMb9gsEoeMmugI4Pyqzlny0jr7PtMMUJc70rGiKzHapOb2Klm5AGdNtL7krPLCcG0RvXEH4IpV39WSakI1QFL7afARmTm8PD9Blbl8SbugmKmPrDnVaPiXCq8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591216; c=relaxed/simple;
	bh=kjeJfq4Bozo9YbIMPRiJXpM8JTVFtDYlO3P0b3CHONU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDCCpF6WpM16cqz09QjSepQ0GsAYg5OlborPodQtPARTx8pPCNCFkgiZJ0HLtFP/L4ZaYWTa5Chp6AdpfdwRN9bQcw1S2UKtN2QPIhMDgaJ5XmM/088frPlVP/Xj4tKdK3emTiGwxsDTMb+hf05SlIs7j/h3Bq0L+clssKeSsdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+goeaq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+goeaq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C9EC4CEF1;
	Mon, 27 Oct 2025 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591215;
	bh=kjeJfq4Bozo9YbIMPRiJXpM8JTVFtDYlO3P0b3CHONU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+goeaq6yXwFA7gxumAZ4MAc5VYzt7OKXtpwi1vO/kioMVASCca5bGyR4JKosiL2I
	 h2T/u/fo0+HxGdlwA+tcL9q+Iq5AGiznJ+oSX3QLsV2uWHbCTkkVkC/SdF8/NjpFbe
	 drNI37u/HwUXodUxSDiHE2NhSW4fBljZivQmJWzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/332] net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()
Date: Mon, 27 Oct 2025 19:32:43 +0100
Message-ID: <20251027183527.521545509@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0551d6c2ffd6..264f5ae76e072 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1176,9 +1176,9 @@ static void mlx4_en_do_uc_filter(struct mlx4_en_priv *priv,
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



