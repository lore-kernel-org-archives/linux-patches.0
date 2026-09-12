Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBCD3A7839;
	Sat, 12 Sep 2026 20:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243383; cv=none; b=d7Qa5F3ZsqoR8yoXK26BO36jLwkAWZM3xnq/f3yIk24lMK9JD2XaJXZabNPC5R03a5acGfKtrmCtQZEPMdGsucbhWHv42qYBt5DXRpF8NiFSrK2RSfjVMTN01797DcELTL6R3E5JX+k4BlfTT0vB1Hu8yH12LfCT3taA366GP+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243383; c=relaxed/simple;
	bh=4NpmbN0LL11m/Ye918QQEsV2wrpPibONcyRaQlUDzOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ0kzcPl+CryCAl84P91XKpvxdAmYa5H7NZavqFP/TDkKPat6SBkPb9zWy6EZA9vQ0elj62ryape5qKyQih/dAwSZKPts5a9TbebpGkjnUi0MDgJ3IcSHIoB7AzBlaraZffytQZstKngSxZUnrTBJNBRDkbiSsDW4a/umOgJ6Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbJZSQ32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbJZSQ32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692571F00898;
	Sat, 12 Sep 2026 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243381;
	bh=11XE1Y1JPh/HuQXMZtR9Dt0hFzP+2feuhP+MbWHBZyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbJZSQ32j6IOH2IfDnOzF1naDSU5gYX3AA6L9eFWekcDv+ZoJgo0qgPNIVOmP2F9N
	 VLzGSPJAV2atQVhe7ISNU575mGarXXWypYBgOgqGqtpRfR2UnIAgxQTz4Qn7ozFYMc
	 deShODEWhEMlRMuAjzXXSbqdnwt4KlPcC/A+/9b4=
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
Subject: [PATCH 5.10 734/798] bonding: initialize err for empty target lists
Date: Sat, 12 Sep 2026 09:06:02 +0200
Message-ID: <20260912065533.900225442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f0f9138e967f3..6a766306b3d26 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -162,7 +162,7 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct bond_opt_value newval;
 	int miimon = 0;
-	int err;
+	int err = 0;
 
 	if (!data)
 		return 0;
-- 
2.53.0



