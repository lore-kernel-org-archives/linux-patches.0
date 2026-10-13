Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8D233A9CF;
	Tue, 13 Oct 2026 12:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894862; cv=none; b=Fw2xhCKHNxb9FNxTCXK3TM71Qp7ezaOWq06MmjL373rKGORyFRpNT5hGEHNQ4Dj301JtlhSwFOmzcpowkTxqP+b7UlSEgAdAmr3KDiWWDGk7Hb9gxzhWpynrxvFp/ztJjVtiwMODaC+DTwRcr802Azzj6Y3TJbw4ADc8J3DTmOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894862; c=relaxed/simple;
	bh=g+ULOqAkBrGKgVE8GPLexMl60HoOqFiiF1LvLjo1ha0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuiEdorWoou/9+rwA/yMpy/drODlw3GS65Rz5QKTZjkygPQla7Sb6cpcerjwfOBSZyqJj0MeYcBGlKu1OYFcl+yLK/JZFxLg6WUMtIIJbR8lNNnT/2riAYF7lgNQZoKRqmdkRzB+tpDWV6TLXkz4QxE677abQ8xD8MBWk/A7Zdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TT83FbPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TT83FbPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143201F000FF;
	Tue, 13 Oct 2026 12:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894860;
	bh=V/txuGBO3JFP2dpup4ZozzhazIwOtdthe7O0bGOYXIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TT83FbPZB2LSWgFA9zzN3M61oRrOP7w2KQhm9CL/fzOGtJAk27aRjNtmNHUg9Jb3d
	 TmZ0kj4hqcBafmH8IRQvGzzPo8RY+l1Ewcd2GuPTOXM9dpiOH4s+LAXtK8c415fWBB
	 +PRSnM4f/rK9uYlVz3OBvfhK09+DF/o/K7pByjCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Anirudh Virdi <avirdi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/497] net/mlx5: Fix slab-out-of-bounds when handling team device events
Date: Tue, 13 Oct 2026 13:34:06 +0200
Message-ID: <20261013112909.762187649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Virdi <avirdi@redhat.com>

[ Upstream commit 04c824940d52871c49866a4ac67b504146f7cf35 ]

The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
functions check for LAG masters (which includes both bonding and team
devices) but only call bonding-specific APIs. When processing team device
events, calling bond_slave_get_rcu() and bond_is_slave_inactive() on
team_port structures causes KASAN to detect an out-of-bounds memory access
since team_port is smaller than bond slave.

Fix this by wrapping the bond-specific API calls with a check for bonding
devices. This allows the function to still process LAG events for both
bonding and teams but only calls bond-specific functions when dealing with
actual bonding devices.

For mlx5_handle_changeinfodata_event(), keep the explicit bond check as
mlx5 doesn't handle state information for team ports anyway.

Tested with Mellanox ConnectX-5 on Linux 7.2.0-rc6:
- Bonding: PASS (no regressions)
- Team device: PASS (no KASAN errors)

Fixes: 54493a08e21f ("net/mlx5: Lag, record inactive state of bond device")
Suggested-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Anirudh Virdi <avirdi@redhat.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20260924064244.94045-1-avirdi@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 8f6c8a60a1dd3..f055aac1b436a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1076,9 +1076,11 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 			}
 		}
 		if (i < MLX5_MAX_PORTS) {
-			slave = bond_slave_get_rcu(ndev_tmp);
-			if (slave)
-				has_inactive |= bond_is_slave_inactive(slave);
+			if (netif_is_bond_master(upper)) {
+				slave = bond_slave_get_rcu(ndev_tmp);
+				if (slave)
+					has_inactive |= bond_is_slave_inactive(slave);
+			}
 			bond_status |= (1 << idx);
 		}
 
@@ -1162,7 +1164,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	bool has_inactive = 0;
 	int idx;
 
-	if (!netif_is_lag_master(ndev))
+	if (!netif_is_bond_master(ndev))
 		return 0;
 
 	rcu_read_lock();
-- 
2.53.0



