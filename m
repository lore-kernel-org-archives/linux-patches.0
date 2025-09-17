Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386022FBE19;
	Wed, 17 Sep 2025 12:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113076; cv=none; b=eyIkvGv+MpszqT0S0LWNr9d7LDPYqM0c25hLO8o8J5EkjNQN/fr034fdNMaJ78aUi0BftDsXs4OEGBX3ykkzqBy9UMD1mGb88OrPvqG3a/3hYHrhkXAiX6nsv0oN6oa4DhmCFVw98mXX7K0eOJ/QKn68k/Lj0yybZ0GeLoEnuu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113076; c=relaxed/simple;
	bh=chNlZdPQrP0qlBj0EhAjyBNJgKixF0+OjeynNy4ETOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxGKP0/7Z4/RODu4Uj8ch0poAi8MtC45BIYb2WLYszhxC90PuExp+tj5eq3mA2osIm9q4d2RaMc57WX/1G/iFWE0ZfB030Ey/tPDed43auYA3CbrQFtQ9tKo2dfdX/74WFy+YM/ACPOQDReDcAavGS71BOITnOesDUMMC9Lf/kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Upj/QTuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Upj/QTuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44D7C4CEF0;
	Wed, 17 Sep 2025 12:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113076;
	bh=chNlZdPQrP0qlBj0EhAjyBNJgKixF0+OjeynNy4ETOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Upj/QTuMdJyIebRkEv6qotTWAhd4zT/N1nQwdlZUYYL5Y6kZXFMd1CEZdJXbRoegB
	 yo4ccGfpNGRL0AHNpyiFabj0x9n5f9/WDorM66T61ibHdsYC9CmW3Zaei/rGGEQL4+
	 PiASdP5AxwTD45JB0PN8IjshjS7lOF4VZzQQkmVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 165/189] hsr: hold rcu and dev lock for hsr_get_port_ndev
Date: Wed, 17 Sep 2025 14:34:35 +0200
Message-ID: <20250917123355.908335442@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 847748fc66d08a89135a74e29362a66ba4e3ab15 ]

hsr_get_port_ndev calls hsr_for_each_port, which need to hold rcu lock.
On the other hand, before return the port device, we need to hold the
device reference to avoid UaF in the caller function.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Fixes: 9c10dd8eed74 ("net: hsr: Create and export hsr_get_port_ndev()")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250905091533.377443-4-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 20 ++++++++++++++------
 net/hsr/hsr_device.c                         |  7 ++++++-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index f436d7cf565a1..1a9cc8206430b 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -691,7 +691,7 @@ static void icssg_prueth_hsr_fdb_add_del(struct prueth_emac *emac,
 
 static int icssg_prueth_hsr_add_mcast(struct net_device *ndev, const u8 *addr)
 {
-	struct net_device *real_dev;
+	struct net_device *real_dev, *port_dev;
 	struct prueth_emac *emac;
 	u8 vlan_id, i;
 
@@ -700,11 +700,15 @@ static int icssg_prueth_hsr_add_mcast(struct net_device *ndev, const u8 *addr)
 
 	if (is_hsr_master(real_dev)) {
 		for (i = HSR_PT_SLAVE_A; i < HSR_PT_INTERLINK; i++) {
-			emac = netdev_priv(hsr_get_port_ndev(real_dev, i));
-			if (!emac)
+			port_dev = hsr_get_port_ndev(real_dev, i);
+			emac = netdev_priv(port_dev);
+			if (!emac) {
+				dev_put(port_dev);
 				return -EINVAL;
+			}
 			icssg_prueth_hsr_fdb_add_del(emac, addr, vlan_id,
 						     true);
+			dev_put(port_dev);
 		}
 	} else {
 		emac = netdev_priv(real_dev);
@@ -716,7 +720,7 @@ static int icssg_prueth_hsr_add_mcast(struct net_device *ndev, const u8 *addr)
 
 static int icssg_prueth_hsr_del_mcast(struct net_device *ndev, const u8 *addr)
 {
-	struct net_device *real_dev;
+	struct net_device *real_dev, *port_dev;
 	struct prueth_emac *emac;
 	u8 vlan_id, i;
 
@@ -725,11 +729,15 @@ static int icssg_prueth_hsr_del_mcast(struct net_device *ndev, const u8 *addr)
 
 	if (is_hsr_master(real_dev)) {
 		for (i = HSR_PT_SLAVE_A; i < HSR_PT_INTERLINK; i++) {
-			emac = netdev_priv(hsr_get_port_ndev(real_dev, i));
-			if (!emac)
+			port_dev = hsr_get_port_ndev(real_dev, i);
+			emac = netdev_priv(port_dev);
+			if (!emac) {
+				dev_put(port_dev);
 				return -EINVAL;
+			}
 			icssg_prueth_hsr_fdb_add_del(emac, addr, vlan_id,
 						     false);
+			dev_put(port_dev);
 		}
 	} else {
 		emac = netdev_priv(real_dev);
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 702da1f9aaa90..fbbc3ccf9df64 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -675,9 +675,14 @@ struct net_device *hsr_get_port_ndev(struct net_device *ndev,
 	struct hsr_priv *hsr = netdev_priv(ndev);
 	struct hsr_port *port;
 
+	rcu_read_lock();
 	hsr_for_each_port(hsr, port)
-		if (port->type == pt)
+		if (port->type == pt) {
+			dev_hold(port->dev);
+			rcu_read_unlock();
 			return port->dev;
+		}
+	rcu_read_unlock();
 	return NULL;
 }
 EXPORT_SYMBOL(hsr_get_port_ndev);
-- 
2.51.0



