Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AC33370F7;
	Fri, 17 Oct 2025 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713050; cv=none; b=OG9RL5qRFB2W0XIeLy7NDkn+K+qcvi1M+OFpyH8WjhKLGisJ7Ka9cAm47YpN0XlfJa/QdIZGd7QY2OukaVjL05A8KzRy4lcTbwgZBp3HUlEw3Na5dlyykc/iVe03no1xjKZwPU/mdIoULmsQGBh5iwRNcaCcTqbYYdX9sll5b3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713050; c=relaxed/simple;
	bh=3w6xi/j5Gq0yqgvEMbjlSdLfJJQIsK/CEsVarpxm3K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW7xG6QlGYvzeFdrRzLwDqYkB4TImytRgDktdDkVzt6cTz6CBAZB7zv93VAwNgQQlgsZbnDaLNrG2FTyblN5LKoJPZg5ulOcu3H5WHo+jZ8hrZZ9+OFX+FCxDal9qYDxUMBnYBm/oJC7uao9vxpGzv8MYwAOHD6nGl/HqxprSzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Na1bvfj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Na1bvfj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA4BC4CEE7;
	Fri, 17 Oct 2025 14:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713048;
	bh=3w6xi/j5Gq0yqgvEMbjlSdLfJJQIsK/CEsVarpxm3K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Na1bvfj8bf6iClMc3fSOHRA9Q4S3VZGb7briah4pM1Mo85PtceeTBIk87k61w8f5k
	 /Rc8wbyk573v5c6U6xF6vUK1rAD/10/6+5d6luNowWP4sKClMdX3Qxfwmz6LRl4IbE
	 Nv/j/yfANq75J4jQIfbBQyk6+ZtPi0q2uAvJtCW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/168] net/mlx4: prevent potential use after free in mlx4_en_do_uc_filter()
Date: Fri, 17 Oct 2025 16:51:49 +0200
Message-ID: <20251017145130.128917636@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ca4b93a010346..e66f77af677cf 100644
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



