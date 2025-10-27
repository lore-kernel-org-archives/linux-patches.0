Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A1F31B824;
	Mon, 27 Oct 2025 18:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590558; cv=none; b=X3UtYdh9MuQDeVLzPK3srCiUIi7ziYlPPk2/7iaC4/92JSOJVyAGNdBTOyiT+m/kK75nXWFPi36IDMoMZNe/ufmiyGxsN9Pwlx9DcwYoJOeAMzUIWpVOvGWm0oE42TBlisNHO3pqgI21n8Ouhi1dwmjSJkzm1aE1cXszbKmIVq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590558; c=relaxed/simple;
	bh=Jh7jeJrffm+d2IMZtwog/jYHynAmeQBzAeyeLcUKFoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avobXYpzZDHaqDkbqQF/9B73S5iZOu1lAK48S42aenkslwJofLdn1IJi/HaZh+CRiY8SdUWRsqfoXdYFbKek4H9UJGcd2TJzyDLLhQh+4gzW2k5wZuxVUn04lR6KTW1ZQ2n/+tVybk2GJ6Bj5nyzzqf7zP7D1ubOPntewzppzsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Igdko/kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Igdko/kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07861C4CEFD;
	Mon, 27 Oct 2025 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590558;
	bh=Jh7jeJrffm+d2IMZtwog/jYHynAmeQBzAeyeLcUKFoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Igdko/kD1dANRR1g+TbBK7QR7ddDI0b8WHux9EMf5El7xGiYEryHRlb55x20LYvcc
	 eWgnO+5Od7Z2PdGcqcmaAIISwAQJJHqbcXvIyLJsdL/be4T1mQhrJ4Pv4lDH8r8iJ9
	 z0v/W1u8sae74+4DSix18gGp1oPpdllNQQI7eKhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/224] net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()
Date: Mon, 27 Oct 2025 19:33:55 +0100
Message-ID: <20251027183511.374957485@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 91334229c1205..545658afb4f5c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1175,9 +1175,9 @@ static void mlx4_en_do_uc_filter(struct mlx4_en_priv *priv,
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



