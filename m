Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577ED4E532F;
	Fri,  9 Oct 2026 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555672; cv=none; b=M4YrbMQCBY15Drq2RUrkhAwN3uaQs79NUPBmvbCBteOgGCjb1i8oNuePd4Ha8mWHHZmpu42+ythisseM5PhrIj74sfxzckK/PqElN4vnzIp06pwYosdr3GZQQOAieBnEmXOQKgSHZLMraJpByguOKCrHJS0jlUE0y58ztxum3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555672; c=relaxed/simple;
	bh=XbLUZ+yF59suHVZCQIZBFpfhhg6JbJ0l7cIOnCxc5Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTgQzRgwRyuzSS1tNUOznO07vsWFTraPtQ1i4EMwLfmDjPcivizkMIzjYVCLp+LY3tB/qpkxw9+qMSCA8KNviBBCI24jQeQxZqwQ1EeVj8v9H6N+znN3Arh22N7e6yN0wUz1G27fhOScxy8/6kiuNgzPjw7DvK1kx0V04UcSyTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x69hSS/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x69hSS/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03BD1F000FF;
	Fri,  9 Oct 2026 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555671;
	bh=2J3c3AcvIteXx5lEAhxlSK75ks/hkD9NgpICJLWKqnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x69hSS/d8XIjrd05jAQy2KH22ePaewQO2Oe619xHh0k9Dp0VQTa5Fu7MSucxn+Xs4
	 k7Rb1+2PH3gDPHCgWBC0S938kC2F9TZ8qvalEv65lOJ1ksRtpQTQu7n9egpj3B4Fh1
	 wXezn/urr81yFJECxZTmPMC743nv+OJN5XEoiGe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Anirudh Virdi <avirdi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/403] net/mlx5: Fix slab-out-of-bounds when handling team device events
Date: Fri,  9 Oct 2026 16:07:38 +0200
Message-ID: <20261009140954.356523584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
index d20f9d3e30c79..353101dee4dcf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1333,9 +1333,11 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
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
 
@@ -1419,7 +1421,7 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	bool has_inactive = 0;
 	int idx;
 
-	if (!netif_is_lag_master(ndev))
+	if (!netif_is_bond_master(ndev))
 		return 0;
 
 	rcu_read_lock();
-- 
2.53.0



