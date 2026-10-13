Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FDA4F5E19;
	Tue, 13 Oct 2026 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893611; cv=none; b=pKUs1JnbDNnpj5JfdiF+pwclJyb7I6MKrOGgqLQjJSFH/ahBVWa6FbXNtLd1ex6hosE02vQyEvo4geKl2XJ2CGSju1hFskmdWZadDDBjjThJ1+UKOBB2/8FZtDRWGy4dPGQgU+yrzdr0oAKYITkMAY+4+Admx2jd1yRz0EE4FGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893611; c=relaxed/simple;
	bh=ebWarcB9cP5N0xL4bM+Lz8HwSbzAdqW/tMqnaaI7o40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6k6zGxJh9psTl6q1eM4kiNdCWgREkchFLsiZ8a2Ky8E+iA7RZguNtLWbfbAKz2GR+TkFo2B/a5+IJ+rJJHJ7/8RSPC8pkeUYRbndAQuk3ioTHGYh7UxTIhGdQe/BS1JwvMJLE9T2YXOK1oInSE4W2kAg40ELJOTJcY7B+WkGOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQhc9Rs9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQhc9Rs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1FE1F000FF;
	Tue, 13 Oct 2026 12:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893610;
	bh=gfT0kNRLK3cIywNHel1Y7mfE3DEjmwICtwIX2LADlUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQhc9Rs9LGVht0Po9Rw4UEjaWKj/XwnVcZINrtR0QzNidig0sx54c7n+Rsg8e9Rl6
	 462vH58RrEPSL56ri/EGYVD+LvLPbd2mTlREmZ5Cwb/0eTQ+HgJ5AUay4H/yrOPeof
	 Xr2NPwAjEMKyVaj+S/VewakHRlL2j7juKbG6tiJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 282/621] net/mlx5: LAG, Fix off-by-one in single-FDB error rollback
Date: Tue, 13 Oct 2026 13:34:37 +0200
Message-ID: <20261013112927.551944344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 0f0e4ae6975c773f7854fc48932a267f6c79088f ]

On failure at index i, the reverse cleanup loop in
mlx5_lag_create_single_fdb() starts from i, so the failed index
itself is rolled back. That can operate on uninitialized state or
double-tear-down a rule the add_one path already self-rolled-back.

Start the rollback from i - 1 so only successfully-installed entries
are undone.

Fixes: ddbb5ddc43ad ("net/mlx5: LAG, Refactor lag logic")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260630112917.698313-2-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 353101dee4dcf..17b9a5078f6c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -685,7 +685,7 @@ static int mlx5_lag_create_single_fdb(struct mlx5_lag *ldev)
 	}
 	return 0;
 err:
-	mlx5_ldev_for_each_reverse(j, i, first_idx + 1, ldev)
+	mlx5_ldev_for_each_reverse(j, i - 1, first_idx + 1, ldev)
 		mlx5_eswitch_offloads_single_fdb_del_one(master_esw,
 							 ldev->pf[j].dev->priv.eswitch);
 	return err;
-- 
2.53.0



