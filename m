Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E152E88A5;
	Tue, 17 Jun 2025 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174678; cv=none; b=RTrJswcAW+U7E7Nj7KIijdnL8i8jctoTw/Z+LBARI2DgLmXY6GalUBGmPjeir6zDClZMjSKm+KnjpvS2T38J2rvcNh2dx8cXnS+Nfn+RP1F7WAaqzz6NUt18R4YV1XGI5RO4p04AHmCm1HEPqvgEtGRatOExc7Vry745PXwVOr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174678; c=relaxed/simple;
	bh=EsIakKAO2GdpiDIeAWZ1Ig5Pdwt7xukD9VHw+pLINpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZGENAxp96Ia7FHnTH3YU0/G+pO716AU/0yKBxvwkSMEhEbSK9ZWfnOPMNOfSLldan3RMsoR+j8mefY/o/b07oE0SpcASDtekSCGo41VL/IMnSPEwfW0of32qs3BsPCxcW4ZK2uvi/c5kbQ42aJItoYH87ykw8hAW7TfbciJXYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGZchP5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGZchP5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3825CC4CEF1;
	Tue, 17 Jun 2025 15:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174678;
	bh=EsIakKAO2GdpiDIeAWZ1Ig5Pdwt7xukD9VHw+pLINpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGZchP5pkhpNwRa7Seh8855i08QYXp9AU6xfe9N5ax8ZBd+NG8XDLSHQAj5Oo3f33
	 2yg/aDb1pOs+rYuB3OnBJgzxsDqwwSI701dnkE1v6RPo7bnN77U82CVvJE1zZ3nzl1
	 66Agr3Wb6TkbrkeZfQiqnR/HoDBfK/wHiAD5WkMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/356] bonding: assign random address if device address is same as bond
Date: Tue, 17 Jun 2025 17:23:36 +0200
Message-ID: <20250617152342.293626336@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 56c241246d1af..85ab692571627 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2040,15 +2040,26 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
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



