Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F9F20C00A;
	Fri, 17 Oct 2025 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715052; cv=none; b=TVw4f9qgWaI4U1M+Rx0y4KY5Nu7GwkZH3uSquhl7tfvJqRX4vigkWWpADgg5DPl3J4IzVOL7zVE/HnTuXs3OWN0N+rkHdBoMeWMWVEyII8ONd1PhasP4BjEX0ns5fKJeAlSmRkYhfmAhItS6WhR06/SsNNcMXESGPnigEOHgVHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715052; c=relaxed/simple;
	bh=YqqsTdxEtiQu/BMy8m59Z18uI1DsgaoARxN9g5J/8v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlxFs6q9k7EI2wz3D8U4OteeG/hxTC01upYW5DhA8yuFLk+j3GrXhFuHQK38w2D0YAU9/DSpQ4t090NYnob9cz8uaCgaARLy28l/90ljflLHklogDhDhJ6pIHgloarJOy+hd64kij15Oi3CJVpi/MdUJ3cNruHg4zWyffrZON3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4HeowvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4HeowvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1F3C4CEE7;
	Fri, 17 Oct 2025 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715052;
	bh=YqqsTdxEtiQu/BMy8m59Z18uI1DsgaoARxN9g5J/8v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4HeowvEnW/Geo28u+6NFwmgA/n4sbP43GU1Dv1+EYLWaNmjir1fXqvDo4hR4umeI
	 qL2Q58Qul5ZO3FzQ5GCgdYA/AvSoVJAI/5EJ+Utr6KQtfmvA1EKcIy3YKevHESIZtM
	 LW/kPV4ZfQ7UayPyGPVWHNZU8PryLV0u3M76dwuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 081/371] net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()
Date: Fri, 17 Oct 2025 16:50:56 +0200
Message-ID: <20251017145204.869419338@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d2071aff7b8f3..308b4458e0d44 100644
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



