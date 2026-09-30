Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158EC374A16;
	Wed, 30 Sep 2026 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786988; cv=none; b=QDhfwnp455GhjStJB/3XXVWBwELVqTKRvNclnUGmvQXfymsTBGp6oZiBrQHrOQj+tEm3Wunkpt3A1h91wDxYYivoLujBjq74z6t7cpZdGU+AkASOlsiiKg/Dt/hYtDHGt5l+YxWvpGl3UovRlnZttYHzdoRVGs+VrNsjTWoyR3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786988; c=relaxed/simple;
	bh=13OWvOf3MR9BTL6XBZ+NUXCkrXi9YqryvL4TxCe8M4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o71bK45W/e/3ueEzXxO3aWi7YgDoYOsTkDeGhijBF1552yEjzeeWQAUpaRkrig6YPyKo8UlPh9SI0YtNQZQ1QERwGMy0WlW5WdeVpe42xaHf/mXyecAIUp8a3CYxPAAO+RXFODSVG4VDzDzSRxCUpJzq2YxB0e/TrtWDRdIzeXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAx2Qgzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAx2Qgzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709FE1F000FF;
	Wed, 30 Sep 2026 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786987;
	bh=tBo8Kkab0HHzhLCRb8SBE+qZ4AkZr3Wj9gp0Cw/+m3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAx2QgzxMgwSv4ngPh/lf0qrQwyjJzW8r60468ibROy5wVl3W+b3gtZmE6Gcr3E3K
	 H+sc1rj7mCoOSIj6+UV//qGYauhIjFeNrAcgJ2hfNblEe4Bn+OnzjEGl4uCspRAOT2
	 9Q/+JG3m2faF1WLkORGeCUQ86HW0Pj6QiG7f+Pk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 073/457] net/mlx5: SD, unload reps on shared FDB create error path
Date: Wed, 30 Sep 2026 17:22:58 +0200
Message-ID: <20260930152347.623728368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit e1e29ada2b938b13ba689a06a8bd8604564da2b3 ]

mlx5_lag_shared_fdb_create() sets sd_fdb_active on every group member
before reloading the representors, so mlx5_lag_is_active() is already
true and the guard in mlx5_esw_offloads_rep_load() does not skip the
VF/SF reps. If the reload then fails, the error path clears
sd_fdb_active and destroys the shared FDB, leaving the reps loaded
while SD LAG is inactive - the state cited commit was written
to prevent.

Unload the reps in the error path as well.

Fixes: 68c2dd59a6c7 ("net/mlx5: E-Switch, Tie rep load/unload to SD LAG state")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260915113459.3934760-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 6b4ad3c53f2f3..424040918fa37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -270,6 +270,7 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 			pf->sd_fdb_active = false;
 		}
 		mlx5_lag_destroy_single_fdb_filter(ldev, group_id);
+		mlx5_lag_unload_reps_from_locked(ldev, filter);
 	}
 err_add_devices:
 	mlx5_lag_add_devices_filter(ldev, filter);
-- 
2.53.0



