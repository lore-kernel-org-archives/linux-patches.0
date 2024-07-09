Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C0413E41D;
	Tue,  9 Jul 2024 11:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524630; cv=none; b=ETCaGuesrBjtBeFQ4YRKQZixLR7Y8OhNs60Nh0i45Va+IH0dS4rTkKGAwLkAetobM01L3p4G31eSWoCbSA8x79LRnc/i0P5hEupagFaP3R348SnQrzq0rCb1QpGmHBe4N53AeVOGvh7zdUy0mKB/gXK/yIA4Kwtq9VPT3H6yCa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524630; c=relaxed/simple;
	bh=BvrAb5TW2xodL2mvO+0Rkul0GK63OqkqJG7Tz1kH/p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/8lCGCOY2jXb6OyyZQrkIN0YvLZgYRdqJ3HOyyUiw/9rsfdkZX3wuXnZsbBWyNNY6atp0Rw7UVq7rOSRG/sbTtw+zZQwKJF/4AXOa5QNoLeL8oIpg06G3x2013umJqOCZ7Ws8UK2fgZANIO8bMRnM5LAeUx1C1wc3wfBmoN4N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCeLea4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCeLea4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98467C3277B;
	Tue,  9 Jul 2024 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524630;
	bh=BvrAb5TW2xodL2mvO+0Rkul0GK63OqkqJG7Tz1kH/p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCeLea4H1FO7EWFbrsb2qUHK6l8v3sUI/Z1c4lqGjM+n3+vvtoK2wDFc1eRdfpvX2
	 lUoPvezVQl8TBVAFQq371lbxF6BLaXkAMzVWFWWCtCyuhbocKyDwI2kUi9/4PKd+xd
	 8DdPTKWEHtHDCYTjJd/utL7dAjPQUTuXyj1pNAVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/102] net/mlx5e: Add mqprio_rl cleanup and free in mlx5e_priv_cleanup()
Date: Tue,  9 Jul 2024 13:10:10 +0200
Message-ID: <20240709110653.202961196@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c0eac83546de..385904502a6be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5584,6 +5584,11 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
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



