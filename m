Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC47143C48;
	Tue, 23 Apr 2024 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908463; cv=none; b=po6V8QUQsfwJYhxjrEvhDjXgS7hKTKI5rv50NIww6vJ7JJvOOJENitPrOJKkzQGuvk6o9+CyciZ1T6nli1UfM786CKZKMJ6lmoNGr/wJUKpk0SPB06VQt9XsXIWRq+8ayyOgf4BlbWvEEcaYXdEPNj21gRNVgvPSzl8fow1SzPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908463; c=relaxed/simple;
	bh=YrVdWoPcHiTWKXpAH/vvGfNPdVcawK8sWUb0p0sb/qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Epk6szXgf9sHJCVsXfnuHyzeo8VB5Y90eppEOWQ+ZLC7LpiAH403+FUOKneUL3i+6cUlrO1APT7N6YQmAluSQ1gxOqb2NhlZsmwYKQtAgtJew6ly2PMH24M65MZ6ZV5mAFyU/Be6dSvUyLLdY/Qc0Yo2iH8NNefLCndDSt6nNcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUdgJAR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUdgJAR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D15C3277B;
	Tue, 23 Apr 2024 21:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908463;
	bh=YrVdWoPcHiTWKXpAH/vvGfNPdVcawK8sWUb0p0sb/qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUdgJAR6mVs7i0+Y210ZYyiMAvDcmTNEqk+hpZ8yH4Xb0zPBxnHA0dQ72Hrx9NZkt
	 PPfhLmjlgzzqbFiRE0aH7HcCQ7KwHu/X0AdttB2CC8QcQYfz6cJcycwX9Bpb2ToCUe
	 LqIjvnCBDvd4DpWXwkhUqHb0CI+oHhXwju8dDKMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 025/158] net/mlx5: Lag, restore buckets number to default after hash LAG deactivation
Date: Tue, 23 Apr 2024 14:37:27 -0700
Message-ID: <20240423213856.690592776@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d14459e5c04fc..69d482f7c5a29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -703,8 +703,10 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
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



