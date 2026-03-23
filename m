Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8243BBA04;
	Mon, 23 Mar 2026 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282453; cv=none; b=bbNDUPKR+4xuCQPjgORUXVEuI2iMd3OygdpD6UeLcEs4j/IpNtjtlRB1UF0Dw76xhmx0RHsOk9WomPkiiR3gZe6Xia/az4aEEY260ICwvc1vnVT0UPXVNyhAOT8C08hFNMmtaLNWg3TRQ7wtVRrFGEjOT9qLwTD67Nf0Wy/G1Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282453; c=relaxed/simple;
	bh=LTKGobxeC8/8bYFUn9sQ5yychc3qL6MvdqZiA+J3J5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1zh5yLXtJbeUsPmobpFBOKAZrvmToocpbORl3SIneqR3ZXqCqNesI7FcVK6JecL6tI6iwQUrLz3MmGKL/akm20BvplrxNHdpEXWhfQAcSCGec4k0TB17DA367riXFFxXNA/2eQwS4R3wgC+X6mzjRc7mFFuFpsIzyoOJ/zXy2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBkzf8MD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBkzf8MD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA40C2BC9E;
	Mon, 23 Mar 2026 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282453;
	bh=LTKGobxeC8/8bYFUn9sQ5yychc3qL6MvdqZiA+J3J5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBkzf8MDMxL+sQ7dSl5YzPL3kmx94pSG6QRBqkQ9bftDZGxHbZnxhCAT4MPBST1Ow
	 5AaWmSaDcIcfCpy0QtYyFuFZyZ/G2feq+s1oZpR2fsWoNfXKwi7fC/AAqBRyQ1+kfg
	 pz8JOeCLBLSs2cyhdteHboG1cnmzWE5Uvz0MJoUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/481] bonding: handle BOND_LINK_FAIL, BOND_LINK_BACK as valid link states
Date: Mon, 23 Mar 2026 14:42:24 +0100
Message-ID: <20260323134529.181693629@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3348be7978f450ede0c308a4e8416ac716cf1015 ]

Before the fixed commit, we check slave->new_link during commit
state, which values are only BOND_LINK_{NOCHANGE, UP, DOWN}. After
the commit, we start using slave->link_new_state, which state also could
be BOND_LINK_{FAIL, BACK}.

For example, when we set updelay/downdelay, after a failover,
the slave->link_new_state could be set to BOND_LINK_{FAIL, BACK} in
bond_miimon_inspect(). And later in bond_miimon_commit(), it will treat
it as invalid and print an error, which would cause confusion for users.

[  106.440254] bond0: (slave veth2): link status down for interface, disabling it in 200 ms
[  106.440265] bond0: (slave veth2): invalid new link 1 on slave
[  106.648276] bond0: (slave veth2): link status definitely down, disabling slave
[  107.480271] bond0: (slave veth2): link status up, enabling it in 200 ms
[  107.480288] bond0: (slave veth2): invalid new link 3 on slave
[  107.688302] bond0: (slave veth2): link status definitely up, 10000 Mbps full duplex

Let's handle BOND_LINK_{FAIL, BACK} as valid link states.

Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260304-b4-bond_updelay-v1-2-f72eb2e454d0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8ff1c34b4db63..2296ca9003016 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2801,8 +2801,14 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			continue;
 
+		case BOND_LINK_FAIL:
+		case BOND_LINK_BACK:
+			slave_dbg(bond->dev, slave->dev, "link_new_state %d on slave\n",
+				  slave->link_new_state);
+			continue;
+
 		default:
-			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
+			slave_err(bond->dev, slave->dev, "invalid link_new_state %d on slave\n",
 				  slave->link_new_state);
 			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
-- 
2.51.0



