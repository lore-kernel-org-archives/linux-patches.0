Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508F8374E60;
	Sat, 17 Oct 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257818; cv=none; b=ZwtMl9YE4EEtA2QutkWf1+J5Q8+6wDM3EobO+5qM73wB5zBIfv26mZ7yC5uU2PSW4EFT/hVHUMyINgcFB+JzVL15ADC5bOFsjCl7GL6tjQvUR2x7uUaHsYeP6jSxwJZ97nl4o7WiJWIVr/NbnBZRPykSr0OonbCzcE9GlwicJSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257818; c=relaxed/simple;
	bh=3hslou7/p6QDewCXA2bT6BzJj/qw2F9vhG9oAPnuKbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5tsBXs6EihG7A+QdkUe91ZQuyPVSUPOhyVjoYocXMTejPjxa/P5XkhR+WItFzr9SRDL6inmdC3nskbw4tamaj+nWCSYYIjzW8WtOiQVHG7koxYDvK8w9UgLXpFLPkPsh2GIf24k7kcn1zEtCdOXxmuguhksbOipU+/m9r6MaF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p29Lqlhg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p29Lqlhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D67D1F000C4;
	Sat, 17 Oct 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257817;
	bh=yVzSWYpPinCk/ZzYQ405//fSMVUdsWIgYpdhG3BRwuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p29LqlhgHvQoFxFj9RuT3v69jtL7aR7E2Owsf4RaWnxU6pQyfGXx0SllV/+VPK9c8
	 UVjlD6JhSwmBu/AJczEN37WCFXcoYdo0PAE6GsJRMdFw9/JyiPk6swL+i4hs2gaem3
	 00Z6CW7wLjzAHNVOLVtfzTWatE8aw9qUVCXCM0Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0680/1674] net: ravb: Fix missing rtnl lock in suspend/resume path
Date: Sat, 17 Oct 2026 17:49:12 +0200
Message-ID: <20261017160448.562161197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 2c2ebb2b49573e5f8726112ad06b1dffc3c9ea03 ]

Fix the suspend/resume path by ensuring the rtnl lock is held where
required. Calls to ravb_open, ravb_close and wol operations must be
performed under the rtnl lock to prevent conflicts with ongoing ndo
operations.

Without this fix, the following warning is triggered:
[   39.032969] =============================
[   39.032983] WARNING: suspicious RCU usage
[   39.033019] -----------------------------
[   39.033033] drivers/net/phy/phy_device.c:2004 suspicious
rcu_dereference_protected() usage!
...
[   39.033597] stack backtrace:
[   39.033613] CPU: 0 UID: 0 PID: 174 Comm: python3 Not tainted
6.13.0-rc7-next-20250116-arm64-renesas-00002-g35245dfdc62c #7
[   39.033623] Hardware name: Renesas SMARC EVK version 2 based on
r9a08g045s33 (DT)
[   39.033628] Call trace:
[   39.033633]  show_stack+0x14/0x1c (C)
[   39.033652]  dump_stack_lvl+0xb4/0xc4
[   39.033664]  dump_stack+0x14/0x1c
[   39.033671]  lockdep_rcu_suspicious+0x16c/0x22c
[   39.033682]  phy_detach+0x160/0x190
[   39.033694]  phy_disconnect+0x40/0x54
[   39.033703]  ravb_close+0x6c/0x1cc
[   39.033714]  ravb_suspend+0x48/0x120
[   39.033721]  dpm_run_callback+0x4c/0x14c
[   39.033731]  device_suspend+0x11c/0x4dc
[   39.033740]  dpm_suspend+0xdc/0x214
[   39.033748]  dpm_suspend_start+0x48/0x60
[   39.033758]  suspend_devices_and_enter+0x124/0x574
[   39.033769]  pm_suspend+0x1ac/0x274
[   39.033778]  state_store+0x88/0x124
[   39.033788]  kobj_attr_store+0x14/0x24
[   39.033798]  sysfs_kf_write+0x48/0x6c
[   39.033808]  kernfs_fop_write_iter+0x118/0x1a8
[   39.033817]  vfs_write+0x27c/0x378
[   39.033825]  ksys_write+0x64/0xf4
[   39.033833]  __arm64_sys_write+0x18/0x20
[   39.033841]  invoke_syscall+0x44/0x104
[   39.033852]  el0_svc_common.constprop.0+0xb4/0xd4
[   39.033862]  do_el0_svc+0x18/0x20
[   39.033870]  el0_svc+0x3c/0xf0
[   39.033880]  el0t_64_sync_handler+0xc0/0xc4
[   39.033888]  el0t_64_sync+0x154/0x158
[   39.041274] ravb 11c30000.ethernet eth0: Link is Down

Reported-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Closes: https://lore.kernel.org/netdev/4c6419d8-c06b-495c-b987-d66c2e1ff848@tuxon.dev/
Fixes: 0184165b2f42 ("ravb: add sleep PM suspend/resume support")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 1f479bcda8be0..f5c3f88cee971 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -3012,10 +3012,12 @@ static int __maybe_unused ravb_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
+	rtnl_lock();
 	if (priv->wol_enabled)
 		ret = ravb_wol_setup(ndev);
 	else
 		ret = ravb_close(ndev);
+	rtnl_unlock();
 
 	if (priv->info->ccc_gac)
 		ravb_ptp_stop(ndev);
@@ -3067,12 +3069,16 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	if (netif_running(ndev)) {
+		rtnl_lock();
 		if (priv->wol_enabled) {
 			ret = ravb_wol_restore(ndev);
-			if (ret)
+			if (ret) {
+				rtnl_unlock();
 				return ret;
+			}
 		}
 		ret = ravb_open(ndev);
+		rtnl_unlock();
 		if (ret < 0)
 			return ret;
 		ravb_set_rx_mode(ndev);
-- 
2.53.0



