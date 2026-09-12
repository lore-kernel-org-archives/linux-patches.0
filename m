Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352542F531B;
	Sat, 12 Sep 2026 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225939; cv=none; b=fVDGszAWovQWHJzkMJ8xyETGC2rooZj6juJ+NWC8PPTqlXnlv2R0CKfhYspbcQcioKiFB+FwtlHzTGMQYds10xhO4suV6gqlegxZXDwQuR3IDyd4d9h5CgcNpqKWagWbMTYBRQj8awHM8Kfh8YEsLhd/6eDCM/4/6NObKsePiWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225939; c=relaxed/simple;
	bh=s4w2gBZ7mhgZffLRppjqJEA9QY+cOkEItb0TKBvTIjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scGtPsXWlsFWhxppudJM9/iqz0wbwtfUDVmgEe6NcsuWAS5Gf7Mj/nmwMvisRPEAeBz7fBFZwkl9TrwX/Z0m39hAj7OXpOK/XQcmtZn1CZ0/4ds/h01hRj2SyMcrRiykDsDXVwHybHZ1WoixPCUPU2G3S60fZ7NGNn0KdB7Yz/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iItpRkAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iItpRkAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39701F000FF;
	Sat, 12 Sep 2026 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225937;
	bh=LP91/d5sHRS3rvJG0tkpVzIr6aj9KO+rIGWm7ItpI7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iItpRkAqJGmJ9eFL4YdWnd5dZ5N/kmf9KqwnuaaWcaDRpKTM232056AF2HknKb+Zj
	 tbpwtRiItlhwX1OCuc6egKwwooX+nYk7Ecq5KxyybeHrQKs9i2ODPSf9Bmn2zGQDkx
	 JzAIYW+SivNpYxPNxatCX2D4Zpnpp/ygPa21ZC4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1300/1424] bonding: initialize err for empty target lists
Date: Sat, 12 Sep 2026 09:02:12 +0200
Message-ID: <20260912065636.380811642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 8ccc9bf9afeeb46a437081c07154fbf5964682b2 ]

Empty NLA_NESTED attributes are valid, and bonding uses them to clear
the ARP and NS target lists. When either target attribute is empty,
nla_for_each_nested() does not execute, so err retains an uninitialized
value before it is tested. The request can consequently return an
unpredictable error after clearing the targets.

Initialize err to zero so an empty target list completes successfully.
Non-empty lists still propagate errors from __bond_opt_set() unchanged.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 4fb0ef585eb2 ("bonding: convert arp_ip_target to use the new option API")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260813153126.3952893-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f771d569524f3..749d51160e03c 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -217,7 +217,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct bond_opt_value newval;
 	int miimon = 0;
-	int err;
+	int err = 0;
 
 	if (!data)
 		return 0;
-- 
2.53.0



