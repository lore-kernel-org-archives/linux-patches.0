Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7FA4BEE32;
	Sat, 12 Sep 2026 11:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211929; cv=none; b=QycvNrLJO29TyUFcDnaqhHbbADPOSyKvUVBSPXm4DUPEU/8UfDt2JlFfC/xrXyNaNab4Gehw3Q0C3KkecqIuZnZzq5E97ZwsChuYJL3isCWYQu1gJOImBuOlEUL/UAkNge24CSg8GYIly5SVUl98eV6/J4hTSoH/EoZL+7DCfMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211929; c=relaxed/simple;
	bh=2flth+WZoSnXqa/2m6UkXlcgvTZ1or8xRbRHIY2vIY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz4SG2TqsPPrPmBZzjsIwIMSXyLxeQM4cWWKW3CFJiOrOgk5OFMBnCaBbnUXp8DpGAl2UNtyvkez7f+OnR4MuqfsMyjYjF/XYTfLEcXGTXUPZuHQXMiiAu2Fi+/OohgguM7qAjwbUeewvl9OIRCIe1EYcJdLd9gMJMPYNGDAeZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjdVmnSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjdVmnSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932191F000FF;
	Sat, 12 Sep 2026 11:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211928;
	bh=jSLzEVD0BuwfKlpzaBqnT4JdbW4XdxeuZv6XyMIaEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjdVmnSKHUUqbfhItDXCl+kbRhmvl3DOcKIrREATKVz91g117kinTp/Z4izQ/drEm
	 gFy1Y8s1NcjVXPXjtiqTLugmZBZvUPuePmYgrncAXwRU/Y8ra/uM5er5U6fOnZjLUw
	 2lIgC3u7+H4y24lu6CxqXWgGK1xrfaivoQCtkuf4=
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
Subject: [PATCH 6.18 1289/1518] bonding: initialize err for empty target lists
Date: Sat, 12 Sep 2026 08:57:38 +0200
Message-ID: <20260912065652.672731310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 08d4d0814f67a..4367cac1f4e80 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -220,7 +220,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct bond_opt_value newval;
 	int miimon = 0;
-	int err;
+	int err = 0;
 
 	if (!data)
 		return 0;
-- 
2.53.0



