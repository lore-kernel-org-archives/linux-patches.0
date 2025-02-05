Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23619155333;
	Wed,  5 Feb 2025 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768470; cv=none; b=qWj85rgvoYXz4P5eWklLyI5x+TZKJvGC1wPtzJwYv8wZ1vYSHqkWYUlYT99OEsnwZamqq00x1WpQxW82MTKGPEvHqVCSMcZSwbr+NWPF5/XL9nZrx9PgqbZdEwQAxnRLG5fi4hczV61IkcHgJF4tZWae3I4rnirc+DmdrUjWYBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768470; c=relaxed/simple;
	bh=vSM4XzR0ONvn4R/7+BDjBR1pEr+CjEPggoWkWrDO8qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKNXjBKMQEIXB3YakEd7sO6S6ZTZ5/3P7DPOLGXrLUPeZtZQiUpIOw06l7lLFSToFu++7RPF/47eXUDqX7x2r1iHgdYhp2XvIugOGBrgKpArMFJCrixe/AaFgRAfavMiuhYfX3bVaJa2HQMwpiazCvbWSc38ubH+jb+3wuszGeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jJmPAMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jJmPAMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3201CC4CED1;
	Wed,  5 Feb 2025 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768469;
	bh=vSM4XzR0ONvn4R/7+BDjBR1pEr+CjEPggoWkWrDO8qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jJmPAMdKiCmh9NBAqELaatsjn3et0C9gLUDEpEpqNir8tRowT3JAhxnx26B2IWD9
	 8Kxgz0Roi6c0IMbJRR/Mb7KJKk1evjpv9M2jW0/GOJ9e7rQX2+Vjdxcg0CEwoaRnM2
	 1qejYmf71kHP/7zziPX9boawz84IJQLYVVxbJDBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 549/623] net: ravb: Fix missing rtnl lock in suspend/resume path
Date: Wed,  5 Feb 2025 14:44:51 +0100
Message-ID: <20250205134517.224385486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/renesas/ravb_main.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index bc395294a32df..c9f4976a35275 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -3217,10 +3217,15 @@ static int ravb_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
-	if (priv->wol_enabled)
-		return ravb_wol_setup(ndev);
+	rtnl_lock();
+	if (priv->wol_enabled) {
+		ret = ravb_wol_setup(ndev);
+		rtnl_unlock();
+		return ret;
+	}
 
 	ret = ravb_close(ndev);
+	rtnl_unlock();
 	if (ret)
 		return ret;
 
@@ -3245,19 +3250,20 @@ static int ravb_resume(struct device *dev)
 	if (!netif_running(ndev))
 		return 0;
 
+	rtnl_lock();
 	/* If WoL is enabled restore the interface. */
-	if (priv->wol_enabled) {
+	if (priv->wol_enabled)
 		ret = ravb_wol_restore(ndev);
-		if (ret)
-			return ret;
-	} else {
+	else
 		ret = pm_runtime_force_resume(dev);
-		if (ret)
-			return ret;
+	if (ret) {
+		rtnl_unlock();
+		return ret;
 	}
 
 	/* Reopening the interface will restore the device to the working state. */
 	ret = ravb_open(ndev);
+	rtnl_unlock();
 	if (ret < 0)
 		goto out_rpm_put;
 
-- 
2.39.5



