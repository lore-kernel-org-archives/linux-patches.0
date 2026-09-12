Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB5481A81;
	Sat, 12 Sep 2026 19:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240379; cv=none; b=UBAWZLZvEVWQZZzR05dzLFG0XvwbMSqdZO+quGUVUwknS2oSGszJCp486TMS2tTwHf6I4hY7T+Coke3IOaXMt1eHLlZmqcGEBiNtejBuA9ME+gb0VyFaGqmYdhtKe7QpptaKyERssUpHKgCjz4Y6yoXe1hYpNVb7cO3YU3MSTqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240379; c=relaxed/simple;
	bh=cSaO+1qmqtqLVgw64KTnS3nE4ruKmc9KvPrAT/6o9P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECkv1OLXeckjpTcJVdz/bDoC7T5PMa8CMFunz+jI38gWlvZFqCtQ3+oFosQQaA/cLmCQH3N0f3THP34jL77NV0zRQACwZsrahZEuZmbXTX6TjGQdrTa9iaL8mpYpr4rO6pvraDjeV66eMd0lhqv0zqMQfP0DbnT4JG/VaHFaqZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeb6/7T7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeb6/7T7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F381F0089A;
	Sat, 12 Sep 2026 19:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240377;
	bh=Dtmry1y2p7HrAIS1GuIfo5xbGsQfgR6BLaZ31cjdp3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeb6/7T7kzX+rudn1gazgzBa8CawHhDhTCS8N3kwLUwoBx8XJrPGLbgGqz7Dlykrk
	 6ofhI9X1JkFIV7wxI31pNtxT17jTDDrAaGq34VnBs12DQ9dX3rjihD6uPdLQLBAuZC
	 fa2ekrypr/lvUEyxQbybInyDS5sLku7yH2bEIwC8=
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
Subject: [PATCH 5.15 854/935] bonding: initialize err for empty target lists
Date: Sat, 12 Sep 2026 09:04:44 +0200
Message-ID: <20260912065546.414542167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7398accd46805..ae5f2e6638d97 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -169,7 +169,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct bond_opt_value newval;
 	int miimon = 0;
-	int err;
+	int err = 0;
 
 	if (!data)
 		return 0;
-- 
2.53.0



