Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8460A53E16;
	Tue, 23 Jan 2024 00:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970367; cv=none; b=amKaIFGnhQGq4CLHuBsbFXpyOgJznltsgSpjG0GU1CXoJXJrUSXbSvjbosKnWinTezTWq51BvbykX8D8cdHiIhcJ7v2ZjPk/7veYYWheCCe8v+xpwOy8y9BzQw/YGIdfbLHqw9nnKQfTSPxMTKjTuZWsRCHhDPgs839aX1quuzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970367; c=relaxed/simple;
	bh=HIwQPb6kEYUqFr8sJkA72PNXLnd8qhiI2wrhQGFMOu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plFgIh7W6jEBliJG/CVEphRk1B2QgUSS8jrk1jxSC8k++8KaZweL1iMzM38rakjb/GDW94mdYlPjmZdkHVd3vSk43wqF9TjvKsRVR0U2NiqWO7kSb56WJBWGQBt4/2jqYWUmZEnE0WsWE+W2i9QjazAJF3TTJg+UhAPpfonO3Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTcwRwrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTcwRwrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8842DC433C7;
	Tue, 23 Jan 2024 00:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970367;
	bh=HIwQPb6kEYUqFr8sJkA72PNXLnd8qhiI2wrhQGFMOu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTcwRwrmJBI1wnaqogAMzY/PPJ9ENjSnHSn0XfRmoXn1TrTKp8crCsA1DxHzYhIK9
	 GntmRSSJTLXAc0NVhWIpNh5Hea+TjlTRpCFX/CrAXMDKArHrM43hb+0gUHybGi7xH3
	 CzUCPsmDeyUu70oJK04GTnDOcC+yBhSiyuq9fO0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksym Yaremchuk <maksymy@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 637/641] mlxsw: spectrum_router: Register netdevice notifier before nexthop
Date: Mon, 22 Jan 2024 15:59:01 -0800
Message-ID: <20240122235838.209034309@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 62bef63646c194e0f82b40304a0f2d060b28687b ]

If there are IPIP nexthops at the time when the driver is loaded (or the
devlink instance reloaded), the driver looks up the corresponding IPIP
entry. But IPIP entries are only created as a result of netdevice
notifications. Since the netdevice notifier is registered after the nexthop
notifier, mlxsw_sp_nexthop_type_init() never finds the IPIP entry,
registers the nexthop MLXSW_SP_NEXTHOP_TYPE_ETH, and fails to assign a CRIF
to the nexthop. Later on when the CRIF is necessary, the WARN_ON in
mlxsw_sp_nexthop_rif() triggers, causing the splat [1].

In order to fix the issue, reorder the netdevice notifier to be registered
before the nexthop one.

[1] (edited for clarity):

    WARNING: CPU: 1 PID: 1364 at drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3245 mlxsw_sp_nexthop_rif (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3246 (discriminator 1)) mlxsw_spectrum
    Hardware name: Mellanox Technologies Ltd. MSN4410/VMOD0010, BIOS 5.11 01/06/2019
    Call Trace:
    ? mlxsw_sp_nexthop_rif (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3246 (discriminator 1)) mlxsw_spectrum
    __mlxsw_sp_nexthop_eth_update (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3637) mlxsw_spectrum
    mlxsw_sp_nexthop_update (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3679 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3727) mlxsw_spectrum
    mlxsw_sp_nexthop_group_update (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3757) mlxsw_spectrum
    mlxsw_sp_nexthop_group_refresh (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:4112) mlxsw_spectrum
    mlxsw_sp_nexthop_obj_event (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:5118 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:5191 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:5315 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:5500) mlxsw_spectrum
    nexthops_dump (net/ipv4/nexthop.c:217 net/ipv4/nexthop.c:440 net/ipv4/nexthop.c:3609)
    register_nexthop_notifier (net/ipv4/nexthop.c:3624)
    mlxsw_sp_router_init (drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:11486) mlxsw_spectrum
    mlxsw_sp_init (drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3267) mlxsw_spectrum
    __mlxsw_core_bus_device_register (drivers/net/ethernet/mellanox/mlxsw/core.c:2202) mlxsw_core
    mlxsw_devlink_core_bus_device_reload_up (drivers/net/ethernet/mellanox/mlxsw/core.c:2265 drivers/net/ethernet/mellanox/mlxsw/core.c:1603) mlxsw_core
    devlink_reload (net/devlink/dev.c:314 net/devlink/dev.c:475)
    [...]

Fixes: 9464a3d68ea9 ("mlxsw: spectrum_router: Track next hops at CRIFs")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/74edb8d45d004e8d8f5318eede6ccc3d786d8ba9.1705502064.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 82a95125d9ca..39e6d941fd91 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -11458,6 +11458,13 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_register_netevent_notifier;
 
+	mlxsw_sp->router->netdevice_nb.notifier_call =
+		mlxsw_sp_router_netdevice_event;
+	err = register_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
+					      &mlxsw_sp->router->netdevice_nb);
+	if (err)
+		goto err_register_netdev_notifier;
+
 	mlxsw_sp->router->nexthop_nb.notifier_call =
 		mlxsw_sp_nexthop_obj_event;
 	err = register_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
@@ -11473,22 +11480,15 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_register_fib_notifier;
 
-	mlxsw_sp->router->netdevice_nb.notifier_call =
-		mlxsw_sp_router_netdevice_event;
-	err = register_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
-					      &mlxsw_sp->router->netdevice_nb);
-	if (err)
-		goto err_register_netdev_notifier;
-
 	return 0;
 
-err_register_netdev_notifier:
-	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
-				&mlxsw_sp->router->fib_nb);
 err_register_fib_notifier:
 	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &mlxsw_sp->router->nexthop_nb);
 err_register_nexthop_notifier:
+	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
+					  &router->netdevice_nb);
+err_register_netdev_notifier:
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 err_register_netevent_notifier:
 	unregister_inet6addr_validator_notifier(&router->inet6addr_valid_nb);
@@ -11536,11 +11536,11 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_router *router = mlxsw_sp->router;
 
-	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
-					  &router->netdevice_nb);
 	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp), &router->fib_nb);
 	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &router->nexthop_nb);
+	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
+					  &router->netdevice_nb);
 	unregister_netevent_notifier(&router->netevent_nb);
 	unregister_inet6addr_validator_notifier(&router->inet6addr_valid_nb);
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
-- 
2.43.0



