Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E169A1420BE;
	Tue, 23 Apr 2024 21:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908694; cv=none; b=VL5r7lPT2nrxLBLKm80gCs7fYFuSKY6xiRoUwK4qq5P1T+uPv8mUfq69pPo+hyzhaA1hEZSZLCVJARBZ8ZkmntI6dLkXKHuKVltlcnJWXzWhFpuBhaoKWsdMeaJFLc+gE8yjYQn6BpFzh0GpUZFq66yNIGDbwBz89TPsNVjhYqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908694; c=relaxed/simple;
	bh=VFyNtQpN/nnVG3XdIZrp0bNMfQcN/qHUdyPHFTMw67g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojxtH+TAKvjCM/uJugO04F/I//0GSU8sCpGBab9g27+SbN/QwHYxEN02LnxpSJ87AvU+5iCh7UF7oqnijh9U4laCHEuVm+nVhCA8/whLNtxjDqwaXQAHkzr6/L13sbo+SPNa3Gp4fhn4aqSXc2dZd7DncfzXkdNsRlSl6g8XmX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o26vMj+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o26vMj+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DCBC116B1;
	Tue, 23 Apr 2024 21:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908693;
	bh=VFyNtQpN/nnVG3XdIZrp0bNMfQcN/qHUdyPHFTMw67g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o26vMj+9/quXFk1o2kdlMrCuyC5wVRJ07Mks/91vV0HH0hld0bEpPDqFmaI2Nn9Je
	 0XYi4PO30cshprVfIGlOH6oje25Z0Yzk0sxvrZ+QOKhC1pNXOGOlLefuwa9zNEBw2K
	 lbUDMRQqVDBg2fneGpqxz/5xDXPYMIbdnP7unlQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/141] net/mlx5: Lag, restore buckets number to default after hash LAG deactivation
Date: Tue, 23 Apr 2024 14:38:30 -0700
Message-ID: <20240423213854.636140783@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 37cc10da3a50e6d0cb9808a90b7da9b4868794dd ]

The cited patch introduces the concept of buckets in LAG in hash mode.
However, the patch doesn't clear the number of buckets in the LAG
deactivation. This results in using the wrong number of buckets in
case user create a hash mode LAG and afterwards create a non-hash
mode LAG.

Hence, restore buckets number to default after hash mode LAG
deactivation.

Fixes: 352899f384d4 ("net/mlx5: Lag, use buckets in hash mode")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240411115444.374475-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index ad32b80e85018..01c0e1ee918d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -679,8 +679,10 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 		return err;
 	}
 
-	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
 		mlx5_lag_port_sel_destroy(ldev);
+		ldev->buckets = 1;
+	}
 	if (mlx5_lag_has_drop_rule(ldev))
 		mlx5_lag_drop_rule_cleanup(ldev);
 
-- 
2.43.0



