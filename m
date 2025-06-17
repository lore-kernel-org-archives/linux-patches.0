Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF092F236B;
	Tue, 17 Jun 2025 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175543; cv=none; b=hWARUV7B8NiWxNKkcy/guf3dYyJZoksq4Fbn/ao+90gsaKgRcpw7AOAlThyfKklG+qKyzt1rdDTgvhl4soUs+zVQZJ/qYDaeuGGBLZwXnDUI63aGJkFUt/ZC4VoIUlZLcD5Jb+rtIxxP52SyMMUMT8r+YDWjWYvlyZx5yr2Iorc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175543; c=relaxed/simple;
	bh=KT5W3AMgtEDQ+EiaXe2ypTqbaIw4pF4zGFMs6xKT/yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMJ9Te9+U8VLTmqUB0i85QCMluC1zV2n7fHWOzeBMoLC2a9LXHMBKwZ0DwnS0f107StpeUKLVV0EynzH8fl0W4CV7j6puOnuuWiqGQDdUcM0WPagGvuvTyKmPdXN/C9B6H4FQYrRMPcd+DY4Nh7iR6pNgNfs0/LtDFPRUpngEaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUh4i9g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUh4i9g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC69C4CEE3;
	Tue, 17 Jun 2025 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175542;
	bh=KT5W3AMgtEDQ+EiaXe2ypTqbaIw4pF4zGFMs6xKT/yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUh4i9g7Q/MEokgIYboo6hNxUc2tjhAsZ8uNi+8Jc1Ji8G0yLlVsLh8W13/7qxWFn
	 whwI459+03LsrrC4YQZMMrW30FlxPS5rZtf9bNROsA+hHUDsJ1HkSKjiQaJ7JBkZDe
	 qGJomhn4pdVikYmRTLCQM1q/u6OqR5reB+t2YxNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/512] bonding: assign random address if device address is same as bond
Date: Tue, 17 Jun 2025 17:21:46 +0200
Message-ID: <20250617152425.272142052@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 5c3bf6cba7911f470afd748606be5c03a9512fcc ]

This change addresses a MAC address conflict issue in failover scenarios,
similar to the problem described in commit a951bc1e6ba5 ("bonding: correct
the MAC address for 'follow' fail_over_mac policy").

In fail_over_mac=follow mode, the bonding driver expects the formerly active
slave to swap MAC addresses with the newly active slave during failover.
However, under certain conditions, two slaves may end up with the same MAC
address, which breaks this policy:

1) ip link set eth0 master bond0
   -> bond0 adopts eth0's MAC address (MAC0).

2) ip link set eth1 master bond0
   -> eth1 is added as a backup with its own MAC (MAC1).

3) ip link set eth0 nomaster
   -> eth0 is released and restores its MAC (MAC0).
   -> eth1 becomes the active slave, and bond0 assigns MAC0 to eth1.

4) ip link set eth0 master bond0
   -> eth0 is re-added to bond0, now both eth0 and eth1 have MAC0.

This results in a MAC address conflict and violates the expected behavior
of the failover policy.

To fix this, we assign a random MAC address to any newly added slave if
its current MAC address matches that of the bond. The original (permanent)
MAC address is saved and will be restored when the device is released
from the bond.

This ensures that each slave has a unique MAC address during failover
transitions, preserving the integrity of the fail_over_mac=follow policy.

Fixes: 3915c1e8634a ("bonding: Add "follow" option to fail_over_mac")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 4d2e30f4ee250..2a513dbbd9756 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2113,15 +2113,26 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		 * set the master's mac address to that of the first slave
 		 */
 		memcpy(ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
-		ss.ss_family = slave_dev->type;
-		res = dev_set_mac_address(slave_dev, (struct sockaddr *)&ss,
-					  extack);
-		if (res) {
-			slave_err(bond_dev, slave_dev, "Error %d calling set_mac_address\n", res);
-			goto err_restore_mtu;
-		}
+	} else if (bond->params.fail_over_mac == BOND_FOM_FOLLOW &&
+		   BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP &&
+		   memcmp(slave_dev->dev_addr, bond_dev->dev_addr, bond_dev->addr_len) == 0) {
+		/* Set slave to random address to avoid duplicate mac
+		 * address in later fail over.
+		 */
+		eth_random_addr(ss.__data);
+	} else {
+		goto skip_mac_set;
 	}
 
+	ss.ss_family = slave_dev->type;
+	res = dev_set_mac_address(slave_dev, (struct sockaddr *)&ss, extack);
+	if (res) {
+		slave_err(bond_dev, slave_dev, "Error %d calling set_mac_address\n", res);
+		goto err_restore_mtu;
+	}
+
+skip_mac_set:
+
 	/* set no_addrconf flag before open to prevent IPv6 addrconf */
 	slave_dev->priv_flags |= IFF_NO_ADDRCONF;
 
-- 
2.39.5



