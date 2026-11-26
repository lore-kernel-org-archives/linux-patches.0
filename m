Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704944;
	b=Q9xe6wMqoQoYUyzHiO3y8Jo9QSVNkxYWD++cpei4Pr7jQQW90qqVHKF2YmnUmWVkV9wI
	 BCQkxhRAHxqHXIROvaLMCe3GF8rqcA5165Xe773WhDzofTKY1nVIEjK1kVSSJRmwZOZBm
	 lPVMzE4k69hGxdUIboc8dtl/H1JyUlVuKsMpGbzzuO9cwhVcja6VTlPCU5AhW1yqd8bmT
	 +pcoAWEtN2i58v2b6wJ0PcrPwNxGyniscQb+uBokC2ACSStsYu9f7QczXsAWDGBJL2zCL
	 +8eGIGUA7SVNmh9TukG26cygNTmg9C5k3cxzzzwmhXlLIj4PWeUBJNcqY4TCGusbHnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WyV0tVNHazGIyoM9J7h7Cvl/74Rwa/6sV3JcsUxDRH8=;
	b=zF6O2Vee/S8lV8Ij/fJzyAGPUTMjbll57D9eZu7zVCA+hfGtXD5bGWjmk7+8dXhu9z3w
	 5b24Bm8LDdiMvznNfEREzGjetAE38kbc72m2XyQbXgqMScXIkqhsK0eJapSbufVOZqgIA
	 5yEic3dsFMTl+wua93CMsY1lgbbiZabuRl1VqlQeK55cyhXTSqzPEQs3Obi/DjCNMoD+5
	 ik+ZFjoP8l0hyyq1NRllPhxRj+vJmJWtR3vxeiGGQf/HD1Q1kexhHcdWiyXBc3vZs7A3i
	 cJ4914nlL18UcIBbqIr4nm9SxMlVLUPvFm9KBaStGZka9GP+6bl7RVtDdBBzBLy0PBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09D2otsG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B93606A31E;
	Thu, 26 Nov 2026 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09D2otsG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE911F000C4;
	Thu, 26 Nov 2026 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704943;
	bh=WyV0tVNHazGIyoM9J7h7Cvl/74Rwa/6sV3JcsUxDRH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09D2otsG6+P79h1KLXBBU4hFBt3s1qJT5MdDbKjjEG9Z3c8HigFxoEa8beSLJm4St
	 P3spDGDbpAXLLSf4EpmMEe4aUDrMsoIY7dLnebQcPGxQ59pjaA5KtrDEefCvnPw6qJ
	 5Tb88xANjr0HSNMkikEX8T+houkUIqT0p10vgexA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paolo Abeni <pabeni@redhat.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/319] net: ravb: Fix missing rtnl lock in suspend/resume path
Date: Thu, 26 Nov 2026 15:36:14 +0100
Message-ID: <20261126144006.884316328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4f115058eba19..0a8f651523693 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2502,10 +2502,12 @@ static int __maybe_unused ravb_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
+	rtnl_lock();
 	if (priv->wol_enabled)
 		ret = ravb_wol_setup(ndev);
 	else
 		ret = ravb_close(ndev);
+	rtnl_unlock();
 
 	if (priv->info->ccc_gac)
 		ravb_ptp_stop(ndev);
@@ -2552,12 +2554,16 @@ static int __maybe_unused ravb_resume(struct device *dev)
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



