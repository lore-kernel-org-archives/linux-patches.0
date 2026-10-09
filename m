Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E601846AA8C;
	Fri,  9 Oct 2026 14:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556110; cv=none; b=bQJOAp6ZvJW+lGXRZPWKQx2e8mZmWcEJHxj9qC2M+d6SrGcBnM4v6hEV7Ng5wBZMuzmCPnAToHb69HGaQfKsUYCC7y+p+CrNyy52gLAIrt6Mn+ZmkI6+DXuAQ43DZF1MMqBaYkYjz34dFT+SFo/41r26U+gf2bYocEuKtnuj0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556110; c=relaxed/simple;
	bh=4IWQNB7Tql0OsLIOLdVO6OAy9gfOzp1CFszEBwUAu3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7yw6YlhARjMv7cAun+ewMUxNcAW2u2QfagaSkaif5r4LiqA1rGfCn3iJwOe4ujV7aeNwQ06Y/dwQJIWzwFcOc3+QYAh6jYcGVS6YxPZRz+JNHIdhlmW8Mr3QVVsXe4glMwYhV716BnR3xxnvCokqisxYPHPFVEIjrTUj0D7ZWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PidnLrEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PidnLrEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD381F000FF;
	Fri,  9 Oct 2026 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556109;
	bh=kEr2L9IoRD0LTHZcFL34U04vlFPAAw3WYUdWwO5nuJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PidnLrEkxxapv10T+p9ZxnRr7szA8uxrqpPLy4VLMZlGvv1svkdnGhW8pYJ49gfGR
	 roORjxnUiezKu9IfGVw2l2ADDGtDZ4rPE9gZMzfGmt0DihQMBuWyw4GmprF8X/VHUV
	 P7f47JAL8I4jvXIppkTSV1UUOP7wl4xxIqMPdtVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Anirudh Virdi <avirdi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 122/428] net/mlx5: Fix slab-out-of-bounds when handling team device events
Date: Fri,  9 Oct 2026 16:07:39 +0200
Message-ID: <20261009140948.871654857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
index dd14cdc378de0..3b34bec559e08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1943,9 +1943,11 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
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
 
@@ -2029,7 +2031,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	bool has_inactive = 0;
 	int idx;
 
-	if (!netif_is_lag_master(ndev))
+	if (!netif_is_bond_master(ndev))
 		return 0;
 
 	rcu_read_lock();
-- 
2.53.0



