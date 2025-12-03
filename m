Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D60131B812;
	Wed,  3 Dec 2025 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780554; cv=none; b=EK7hQtxMFJPh9mMUFX7BoB2i/qmGxxraC7igz5Rw5zGg/8x4I5w8EYDkJ7urDakTUnhsOSvygbsA4nWI3g1q9dcd0cC6S4HU2gMzz8fd2/anj6vSvLfco4Su1Oe1TRKWbhR9Phw2anxo1WucjC4Kr268OQVEn0JTKS1qeexlOPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780554; c=relaxed/simple;
	bh=R9KMQA8BkLk+3aNByB4XnBxSCZpnp0/eVPrjgn6qtok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKons5EOBwvII9M/A+Ucqw3X/vhwJPQM38+TaFdHszwB2bX6Gaj1sc4+Z9Qkxm0OZCSAnIQBz3gpzwKrphDAta+Bm2rCoLomXbcefaTY1KsxHyR1OMdklW6hemkZblpQvKoUB9I1uNndlUDD+nTciFSP4CvKiEseV2ZK5t7PlKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9gmLRxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9gmLRxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9510C4CEF5;
	Wed,  3 Dec 2025 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780554;
	bh=R9KMQA8BkLk+3aNByB4XnBxSCZpnp0/eVPrjgn6qtok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9gmLRxBsgYseBCYsxgLnKmw/p304DrIncVkQMTy5uprm3DCdB4V+suy46eLQhV5x
	 a7Zs9qGkxfcoucPc5udgKZlARPyjuefK7biQjPb2koBjk9RLMDrEq4LnECqFxYgLME
	 ow1TwfzGkH6cKyQim3OMEdIcZoRR/QbXlNaaiOxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a2a3b519de727b0f7903@syzkaller.appspotmail.com,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/132] team: Move team device type change at the end of team_port_add
Date: Wed,  3 Dec 2025 16:28:19 +0100
Message-ID: <20251203152344.046360337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit 0ae9cfc454ea5ead5f3ddbdfe2e70270d8e2c8ef ]

Attempting to add a port device that is already up will expectedly fail,
but not before modifying the team device header_ops.

In the case of the syzbot reproducer the gre0 device is
already in state UP when it attempts to add it as a
port device of team0, this fails but before that
header_ops->create of team0 is changed from eth_header to ipgre_header
in the call to team_dev_type_check_change.

Later when we end up in ipgre_header() struct ip_tunnel* points to nonsense
as the private data of the device still holds a struct team.

Example sequence of iproute2 commands to reproduce the hang/BUG():
ip link add dev team0 type team
ip link add dev gre0 type gre
ip link set dev gre0 up
ip link set dev gre0 master team0
ip link set dev team0 up
ping -I team0 1.1.1.1

Move team_dev_type_check_change down where all other checks have passed
as it changes the dev type with no way to restore it in case
one of the checks that follow it fail.

Also make sure to preserve the origial mtu assignment:
  - If port_dev is not the same type as dev, dev takes mtu from port_dev
  - If port_dev is the same type as dev, port_dev takes mtu from dev

This is done by adding a conditional before the call to dev_set_mtu
to prevent it from assigning port_dev->mtu = dev->mtu and instead
letting team_dev_type_check_change assign dev->mtu = port_dev->mtu.
The conditional is needed because the patch moves the call to
team_dev_type_check_change past dev_set_mtu.

Testing:
  - team device driver in-tree selftests
  - Add/remove various devices as slaves of team device
  - syzbot

Reported-by: syzbot+a2a3b519de727b0f7903@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a2a3b519de727b0f7903
Fixes: 1d76efe1577b ("team: add support for non-ethernet devices")
Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20251122002027.695151-1-zlatistiv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 6cfafaac1b4fb..94c40c5cebdd6 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1190,10 +1190,6 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		return -EPERM;
 	}
 
-	err = team_dev_type_check_change(dev, port_dev);
-	if (err)
-		return err;
-
 	if (port_dev->flags & IFF_UP) {
 		NL_SET_ERR_MSG(extack, "Device is up. Set it down before adding it as a team port");
 		netdev_err(dev, "Device %s is up. Set it down before adding it as a team port\n",
@@ -1211,10 +1207,16 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	INIT_LIST_HEAD(&port->qom_list);
 
 	port->orig.mtu = port_dev->mtu;
-	err = dev_set_mtu(port_dev, dev->mtu);
-	if (err) {
-		netdev_dbg(dev, "Error %d calling dev_set_mtu\n", err);
-		goto err_set_mtu;
+	/*
+	 * MTU assignment will be handled in team_dev_type_check_change
+	 * if dev and port_dev are of different types
+	 */
+	if (dev->type == port_dev->type) {
+		err = dev_set_mtu(port_dev, dev->mtu);
+		if (err) {
+			netdev_dbg(dev, "Error %d calling dev_set_mtu\n", err);
+			goto err_set_mtu;
+		}
 	}
 
 	memcpy(port->orig.dev_addr, port_dev->dev_addr, port_dev->addr_len);
@@ -1289,6 +1291,10 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		}
 	}
 
+	err = team_dev_type_check_change(dev, port_dev);
+	if (err)
+		goto err_set_dev_type;
+
 	if (dev->flags & IFF_UP) {
 		netif_addr_lock_bh(dev);
 		dev_uc_sync_multiple(port_dev, dev);
@@ -1307,6 +1313,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 
 	return 0;
 
+err_set_dev_type:
 err_set_slave_promisc:
 	__team_option_inst_del_port(team, port);
 
-- 
2.51.0



