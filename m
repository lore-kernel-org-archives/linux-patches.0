Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87B33128CC;
	Thu, 16 Jul 2026 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211654; cv=none; b=IPsEqUCOb/iJTfLOUuyQgePj0v3GDQs+cW3M5g35IOyCW/mk/2BZSXf80UVZSUHPCTCIXgguYPads+6FItEvFKRsaFXdIAe7dPStMnuUG4MZ33WT71jat4hX0fgP1nNGY91KOVGWtiUgmSQZzGONJsWIDRIHp1Q0Wfgkcn16/Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211654; c=relaxed/simple;
	bh=EWAlPIf+BKRdQ8tBCNDozHq4p88EpcB9T6krFNJvbXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldUKVFM6MSmYpD6bZfWn8J+Ia6jzLpqZau7HrF64an96yWSn+aAfdVXuAUk6/UimswWj3mOe208zcXGtM+yDMOmj2vMY5KB5wTzwBbOjzxI8DIPY1ZM1th/tghskMBXs0VJtxZPbLlYCnT0PDd58P16w1+KtXLZSLvbPrtUvrqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9gxCQTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9gxCQTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298161F000E9;
	Thu, 16 Jul 2026 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211653;
	bh=QWs2UEFPuadcO5ZT7fbGGyCO3ZfX6vEhFrGb5n4lCkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9gxCQTXaY5f9G07XNFJKLYhEjJlAN2zWRNNEsVT3m6Y4ZNAriYS/TakLY1OPchUp
	 /0ultfQ15OCR0pSN8EJNTiCtraBMbiCLL0f/rISY53Ne5RKK2sCV6U2fZ5ivckPUsR
	 wFsaXNHRd/Nos3C4SGTKzokTRblAeGe2RUc1TlWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/349] bonding: fix xfrm offload feature setup on active-backup mode
Date: Thu, 16 Jul 2026 15:29:23 +0200
Message-ID: <20260716133033.962679739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 5b66169f6be4847008c0aea50885ff0632151479 ]

The active-backup bonding mode supports XFRM ESP offload. However, when
a bond is added using command like `ip link add bond0 type bond mode 1
miimon 100`, the `ethtool -k` command shows that the XFRM ESP offload is
disabled. This occurs because, in bond_newlink(), we change bond link
first and register bond device later. So the XFRM feature update in
bond_option_mode_set() is not called as the bond device is not yet
registered, leading to the offload feature not being set successfully.

To resolve this issue, we can modify the code order in bond_newlink() to
ensure that the bond device is registered first before changing the bond
link parameters. This change will allow the XFRM ESP offload feature to be
correctly enabled.

Fixes: 007ab5345545 ("bonding: fix feature flag setting at init time")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250925023304.472186-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    |  2 +-
 drivers/net/bonding/bond_netlink.c | 16 +++++++++-------
 include/net/bonding.h              |  1 +
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 69e79b22e31909..7d71cfc2c93741 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4388,7 +4388,7 @@ void bond_work_init_all(struct bonding *bond)
 	INIT_DELAYED_WORK(&bond->slave_arr_work, bond_slave_arr_handler);
 }
 
-static void bond_work_cancel_all(struct bonding *bond)
+void bond_work_cancel_all(struct bonding *bond)
 {
 	cancel_delayed_work_sync(&bond->mii_work);
 	cancel_delayed_work_sync(&bond->arp_work);
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index d7fc781b642ca2..a754bad4c5d668 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -597,18 +597,20 @@ static int bond_newlink(struct net *src_net, struct net_device *bond_dev,
 			struct nlattr *tb[], struct nlattr *data[],
 			struct netlink_ext_ack *extack)
 {
+	struct bonding *bond = netdev_priv(bond_dev);
 	int err;
 
-	err = bond_changelink(bond_dev, tb, data, extack);
-	if (err < 0)
+	err = register_netdevice(bond_dev);
+	if (err)
 		return err;
 
-	err = register_netdevice(bond_dev);
-	if (!err) {
-		struct bonding *bond = netdev_priv(bond_dev);
+	netif_carrier_off(bond_dev);
+	bond_work_init_all(bond);
 
-		netif_carrier_off(bond_dev);
-		bond_work_init_all(bond);
+	err = bond_changelink(bond_dev, tb, data, extack);
+	if (err) {
+		bond_work_cancel_all(bond);
+		unregister_netdevice(bond_dev);
 	}
 
 	return err;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 0d9c1eb40d12b6..8f5507ef5c0dac 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -713,6 +713,7 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave);
 void bond_slave_arr_work_rearm(struct bonding *bond, unsigned long delay);
 void bond_work_init_all(struct bonding *bond);
+void bond_work_cancel_all(struct bonding *bond);
 
 #ifdef CONFIG_PROC_FS
 void bond_create_proc_entry(struct bonding *bond);
-- 
2.53.0



