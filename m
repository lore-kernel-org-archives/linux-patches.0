Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9973B4F85A2;
	Thu, 17 Sep 2026 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664329; cv=none; b=d5PK+mFXW2unGhJfNtpZ3uQC9wjfZPzvqpF5rYsX68SUqcZvOTKfsax85n0nsOZKRNMM2E7DnAJ1CB1RBpD9PeMJ03hchGX0c7Bmwp7VR5txQ+UItuKpjG3lz+e6DeuT83LUAMDeAancJE/FQpf7hAzpXbDXJbtS9XRdEHDxlhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664329; c=relaxed/simple;
	bh=hAYLsLj+v84mS2wHyBcUJSHG19aPogUHpfSj/j4WJjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8BCfuwwUPT9JL5/2mK6SQL+hcqWvS1uDXfvU+AhfUMmhthTXkxMkSQbS3STSqh5zFD4WXuhEFzFNw0l7bMECSBtgKspEGmM8pYsHxFgX6QqA/5Np9XQab5MXDHrRA5K2LbrQP1ZURRZoRRElTFLDD+Ug2QlBa4dw3PvGDJJ5zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhjISxeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhjISxeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBFA1F000FF;
	Thu, 17 Sep 2026 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664327;
	bh=zD4Np/vVJlNWAbevMZlIbYzVOPeEVMIAcR10Wh5lKIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhjISxeA37RM5ZcVFeRE9UjTAWKHiKl+HrgSPWuGkRyoEHsd19lqEs0uC339/AK22
	 zFyr60NsP5hwPXhRW1kxpnbCbYdyb2nvWtzuhcQZyQlzZcV9bunaRd7VviB1mLJHn7
	 ROoJfHjMMvclJJKS0+wn/Bs+HY9FrpViv/8abiTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0333/1250] net: ethtool: cmis_cdb: hold instance lock for ops locked devices
Date: Thu, 17 Sep 2026 16:02:08 +0100
Message-ID: <20260917151601.113778599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1d3964e29e53b02a7c61ed6d6e4aeccba3275ebc ]

FW module flashing was written so that the flashing happens
without holding rtnl_lock. This allows flashing multiple modules
at once. Current drivers can handle that well, but we should
let drivers depend on the netdev instance lock. Instance lock
is per netdev, and so is the module so we won't break parallel
updates.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260603012840.2254293-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netdev_lock.h    | 6 ++++++
 net/ethtool/cmis_cdb.c       | 3 +++
 net/ethtool/cmis_fw_update.c | 8 ++------
 net/ethtool/module.c         | 2 ++
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/net/netdev_lock.h b/include/net/netdev_lock.h
index 3d3aef80beac1..849b91ab4e28b 100644
--- a/include/net/netdev_lock.h
+++ b/include/net/netdev_lock.h
@@ -80,6 +80,12 @@ netdev_ops_assert_locked_or_invisible(const struct net_device *dev)
 		netdev_ops_assert_locked(dev);
 }
 
+static inline void netdev_assert_locked_ops(const struct net_device *dev)
+{
+	if (netdev_need_ops_lock(dev))
+		netdev_assert_locked(dev);
+}
+
 static inline void netdev_lock_ops_compat(struct net_device *dev)
 {
 	if (netdev_need_ops_lock(dev))
diff --git a/net/ethtool/cmis_cdb.c b/net/ethtool/cmis_cdb.c
index fe156991d0bec..b39c7d47580da 100644
--- a/net/ethtool/cmis_cdb.c
+++ b/net/ethtool/cmis_cdb.c
@@ -2,6 +2,7 @@
 
 #include <linux/ethtool.h>
 #include <linux/jiffies.h>
+#include <net/netdev_lock.h>
 
 #include "common.h"
 #include "module_fw.h"
@@ -179,6 +180,7 @@ cmis_cdb_validate_password(struct ethtool_cmis_cdb *cdb,
 
 	pe_pl = *((struct cmis_password_entry_pl *)page_data.data);
 	pe_pl.password = params->password;
+	netdev_assert_locked_ops(dev);
 	err = ops->set_module_eeprom_by_page(dev, &page_data, &extack);
 	if (err < 0) {
 		if (extack._msg)
@@ -546,6 +548,7 @@ __ethtool_cmis_cdb_execute_cmd(struct net_device *dev,
 	if (!page_data->data)
 		return -ENOMEM;
 
+	netdev_assert_locked_ops(dev);
 	err = ops->set_module_eeprom_by_page(dev, page_data, &extack);
 	if (err < 0) {
 		if (extack._msg)
diff --git a/net/ethtool/cmis_fw_update.c b/net/ethtool/cmis_fw_update.c
index 291d04d2776a5..dff83807e975c 100644
--- a/net/ethtool/cmis_fw_update.c
+++ b/net/ethtool/cmis_fw_update.c
@@ -435,13 +435,9 @@ cmis_fw_update_commit_image(struct ethtool_cmis_cdb *cdb,
 static int cmis_fw_update_reset(struct net_device *dev)
 {
 	__u32 reset_data = ETH_RESET_PHY;
-	int ret;
 
-	netdev_lock_ops(dev);
-	ret = dev->ethtool_ops->reset(dev, &reset_data);
-	netdev_unlock_ops(dev);
-
-	return ret;
+	netdev_assert_locked_ops(dev);
+	return dev->ethtool_ops->reset(dev, &reset_data);
 }
 
 void
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 9a11e7def0029..8a313c975e2f5 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -226,7 +226,9 @@ static void module_flash_fw_work(struct work_struct *work)
 	module_fw = container_of(work, struct ethtool_module_fw_flash, work);
 	dev = module_fw->fw_update.dev;
 
+	netdev_lock_ops(dev);
 	ethtool_cmis_fw_update(&module_fw->fw_update);
+	netdev_unlock_ops(dev);
 
 	module_flash_fw_work_list_del(&module_fw->list);
 
-- 
2.53.0



