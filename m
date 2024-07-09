Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CA5155389;
	Tue,  9 Jul 2024 11:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523655; cv=none; b=ixF3u7KLCib9ghBE7SIgtAyHXqf9KVcDjnaVO/MWkjWMk4bKUsGeY+Kntf/1E3b3/v500t5f/YP0rD1oW1bSYN7tMecrhLyNyX/YvXRnrnSBjK9u6KGSu4uPDsd+k+a1IMtFsK4Mu7J0mh69BouEUofDmlByfox3DUfB2Fb+2bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523655; c=relaxed/simple;
	bh=PTURZPSJUxKmckwcIBB40wVfkY0GuIFKs9PuTpmRccM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJoDonkP1CDsAM+Z5fTisLhL1908dSafRgWbgOmGNFV1CSvxFh9owdwTGIiA5l6VAO1NGF845NQ0rvpejt3rIYMg7Zz0oHTxIgK3uZPmGQFSBHQ1aXpEuQC4SzikSLl/+EqvssdiQ+UN5LwL7XD3T96oDv9Trky9WWh7ujE0kpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUt5Ewsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUt5Ewsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959A8C3277B;
	Tue,  9 Jul 2024 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523655;
	bh=PTURZPSJUxKmckwcIBB40wVfkY0GuIFKs9PuTpmRccM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUt5EwslSywu9S2buEpYDyhO8XtiB/niUwsBinfzukIKPf5tFjBFJrXshu3a/zjFr
	 EF5frZWAvGuADY6PZgjDPZXto3jonRP16Eh6mUN5vP1nSxzsPMG3qGEsaIdddFBVy8
	 Ssibk28pAw9WROytjujuxW7M0VhoWRxuYJMG03K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/139] net/mlx5e: Add mqprio_rl cleanup and free in mlx5e_priv_cleanup()
Date: Tue,  9 Jul 2024 13:09:25 +0200
Message-ID: <20240709110700.689442650@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e87a776ea2bfd..a65c407aa60bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5700,6 +5700,11 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
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



