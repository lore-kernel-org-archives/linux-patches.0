Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D6213A25F;
	Tue,  9 Jul 2024 11:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524167; cv=none; b=LH5px1w302QgXOgce+B2z5ItQCtnyIXD7s1CDx72MaCrvc+VSj/bzmLSjakJbb64lLeRGmYd4KF8HFQAxnm++1yFNWSU2dtZaujVhZDYqu2fZVh9aKfZKktKolJicC0A/+a1p/qbYBbC4Upqd8fSKAUTbNJKdiAbvyK2ibvGeXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524167; c=relaxed/simple;
	bh=4jl/bcrWTeVcReeBQpEGWGIXoFy4n2ggVUgItOiRy7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geuX+gBjt0q5xhYWKA6EXxSgVTqdApB2/snBTt+v+lnYNnWwtO6Q1eZmzAj6g9D4sc93MA6r2zFi2qHNLFEsSbKA2lwC7Bwca8EpuMBF4tM0zwzMK3J+/IqgJvnO2x4ZyHocEIc+tJSjZFla+VdTk8SWmFT1s4JGXeDGBxB5n8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L27Tt6q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L27Tt6q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4153DC3277B;
	Tue,  9 Jul 2024 11:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524166;
	bh=4jl/bcrWTeVcReeBQpEGWGIXoFy4n2ggVUgItOiRy7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L27Tt6q8L7IwjXrPyebqBH5h1H2y+hX5Ew1UgjsG/RR6nFXACp67WO7USyQyOWcTK
	 /Cn/Qeztm410IzG8czujYiSYZnqyWro1izWPgS8uyfc35jrBtwA6dglEDPFY2M8qlg
	 g4sZJK4SRmRPFLwww7winQ+ATvJHRkI6fMigehCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 091/197] net/mlx5e: Add mqprio_rl cleanup and free in mlx5e_priv_cleanup()
Date: Tue,  9 Jul 2024 13:09:05 +0200
Message-ID: <20240709110712.486234156@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 1da839eab6dbc26b95bfcd1ed1a4d1aaa5c144a3 ]

In the cited commit, mqprio_rl cleanup and free are mistakenly removed
in mlx5e_priv_cleanup(), and it causes the leakage of host memory and
firmware SCHEDULING_ELEMENT objects while changing eswitch mode. So,
add them back.

Fixes: 0bb7228f7096 ("net/mlx5e: Fix mqprio_rl handling on devlink reload")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 981a3e058840d..cab1770aa476c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5732,6 +5732,11 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 		kfree(priv->htb_qos_sq_stats[i]);
 	kvfree(priv->htb_qos_sq_stats);
 
+	if (priv->mqprio_rl) {
+		mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
+		mlx5e_mqprio_rl_free(priv->mqprio_rl);
+	}
+
 	memset(priv, 0, sizeof(*priv));
 }
 
-- 
2.43.0



