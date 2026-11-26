Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704219;
	b=zhHVyTb9R/E3rIIGApdMQqO5pFuWbdeDy5dwQJABgPi8tekABNRv1g2ywY2JtC+yQZBM
	 6gfdV3rFnF4v+GOBGy+hOe/ClkXVJMhDNPpkT8ZG6O518OI6x/bxsxfGvOk/UN4tAvm8K
	 g9KQ2UUJAvOgaOP89g9+wnm9zD80eQYqjdMUr/MwgRPcNjcvAD6pM3d2aq4hXMi6R/oP/
	 qLLjmHqipUdB/fA6ZdOxVSdfdqMNmxUkD5G9IQELUnpSZy+I01DRpNR++SoGTAt+2lFvq
	 5aa//PVn+heklI20IK5sFxw9uWr/Z6T37YcQ8OQDePQveUbVk8NcCE+6QvS0m6exNCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9e70BE7rwoPPNuU4D6Jk1zfb75x/q7wd2uCBFJ+rxM0=;
	b=dEAkB7T12UpO6boVyXgrDuZ+dn04kDsdplpPUhqNCSqQeSqZHnpphqJxWhKjBnsU5Kdc
	 ngyriFtjcKl2nTFfUcaEBeuTQyhYr+iWM/alY79dx2BPJ2vPH6FtvMCLzrxeS+VBi8F8g
	 xai73QcXPO202yTPRk5IAn1ZGoYIsNxLTwOvbaLbMHtTs3/56V5OvXojBO0bgVfxAzBV/
	 TA00Mu4Fl0BVwyRM0vy8lecHGo4C30F5jcK8oWJqdZt+1JveYpaiUQlr+Y30LG1g80xkD
	 1/LXb7DEMjsvmShMQzmcGQZ4OaCJwUeFTC8CMgbkj7jZ1OLUuqfh+IovS3KCeRtHgvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmUOQrRt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD0B606A31C;
	Thu, 26 Nov 2026 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmUOQrRt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BFE1F000C4;
	Thu, 26 Nov 2026 14:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704219;
	bh=9e70BE7rwoPPNuU4D6Jk1zfb75x/q7wd2uCBFJ+rxM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmUOQrRtFpjJVMOuVS8a3G90FL0z37rLAqUyOwZh4j/c4eWExslu0bCPbtV4TYjPj
	 NuqjwGjGLAx03RMs9d6VLIianM/HH5cT8pXqfy59x+RHnOXslkYtVd9TN41JhF/J+2
	 bsmt1kdFxygL4uNL4AScwwO4W4S5c1rw/KH11c9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paolo Abeni <pabeni@redhat.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/265] net: ravb: Fix missing rtnl lock in suspend/resume path
Date: Thu, 26 Nov 2026 15:35:36 +0100
Message-ID: <20261126143605.519813874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

commit 2c2ebb2b49573e5f8726112ad06b1dffc3c9ea03 upstream.

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
[iwamatsu: Adjust context]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 3e131788a4a3c..1e7ff7f9cd4dd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2352,10 +2352,12 @@ static int __maybe_unused ravb_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
+	rtnl_lock();
 	if (priv->wol_enabled)
 		ret = ravb_wol_setup(ndev);
 	else
 		ret = ravb_close(ndev);
+	rtnl_unlock();
 
 	return ret;
 }
@@ -2393,12 +2395,16 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	ravb_write(ndev, priv->desc_bat_dma, DBAT);
 
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



