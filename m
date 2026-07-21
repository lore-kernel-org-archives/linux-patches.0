Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B84133A9D6;
	Tue, 21 Jul 2026 20:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664763; cv=none; b=WawlgZgmJ3Q9HAAnLhv0k7Nmb5VQkXMcIGma/tx0yLQ9s/R56SSB7xULaff0cIUFHn3iH2BCRSImUu8L4yIlpj0EhO8FiKjiwL4kPXf1QHbIgvmFw35FuubJ+f6bvrR9DLfHz3rIdiBaO3AJxNwK2QQjFEckPeL6m6dfDPnCSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664763; c=relaxed/simple;
	bh=gf6NsxuU6bPpVFRQkUw3Tr4LlUikRLJ3Vw83ZWco96k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhGIxzpkiWJorCmfB0xQmYfaKoPcxe5lfp8lufSL2l4VRJHopm35aF/f1yHCuvVfMnJGJV7dBi6lF/32JnYRbqekEedHLXSNhgsbmfduIaQXy3Y42WSac1vA8EubaZ2zuzsmEOBD7HWN24mJQCKJTpQ9c//5wk3o6nN61RuuJ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nd2qmFxj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nd2qmFxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8220C1F000E9;
	Tue, 21 Jul 2026 20:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664762;
	bh=xwdQ3Z81q7pl5Dh4ZmPvZl94jpnbobV1w83o5Wu2jbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nd2qmFxjciDttNj1v6BT8Og3ZqqUAj40meRECNdDubRXM2KxxuGUkf9YFrmUgi/Ec
	 TgVqt3EuRrD7hEc5/TayMQX77jGxEUUNcPLN3LGJOyW/4rndHQxNBhAsBv5yZ3NoqV
	 hc77dbZ6GtFVxe1rYXDlYB+UIa0qLExkVIqqxP/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0050/1266] bonding: fix xfrm offload feature setup on active-backup mode
Date: Tue, 21 Jul 2026 17:08:07 +0200
Message-ID: <20260721152442.921738633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    |  2 +-
 drivers/net/bonding/bond_netlink.c | 16 +++++++++-------
 include/net/bonding.h              |  1 +
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4f2c03f52a310b..8c156f71c70667 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4260,7 +4260,7 @@ void bond_work_init_all(struct bonding *bond)
 	INIT_DELAYED_WORK(&bond->slave_arr_work, bond_slave_arr_handler);
 }
 
-static void bond_work_cancel_all(struct bonding *bond)
+void bond_work_cancel_all(struct bonding *bond)
 {
 	cancel_delayed_work_sync(&bond->mii_work);
 	cancel_delayed_work_sync(&bond->arp_work);
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 0eaf4b0e06ffb2..f771d569524f3e 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -596,18 +596,20 @@ static int bond_newlink(struct net *src_net, struct net_device *bond_dev,
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



