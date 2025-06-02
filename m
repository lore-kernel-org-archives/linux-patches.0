Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F2230D14;
	Mon,  2 Jun 2025 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875583; cv=none; b=VIlAxFSIlhHI1lPdPxJ+wuo4+fNhCq3CcFKckwZuuTJ9cLQTXFQDCMcTqq1UoZ2T3FSRWP5rSJZDlSoHE3cxdvXEcNKJc3A+yRUqQXGdJfHkjUe9E3viZAhOQhc0P18fM3R1xlGM6cV5v9A7IiEeDCjIqGgHJWCbm+htJE2cQNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875583; c=relaxed/simple;
	bh=cDQ+5eTGsiwLxBdl8iXFuU6fD+Pj6OiVbyG5Mynf8UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDJo+krwQkFsXX2ez8LasaOM78+/IWKqvM7H4iciDByiZoT06pOL8dyj5pdQQkXnBeNPqHM8PAG2832dPjzfjoqrJDl5sX3XoX8vS4uQjnT8Q0CCulvvoDrmiK+SXEslbFaSHkDM0DzON4TZCfdQdDpTteLxTIW/yAjHNqh2nXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4xwCQio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4xwCQio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E553C4CEF0;
	Mon,  2 Jun 2025 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875582;
	bh=cDQ+5eTGsiwLxBdl8iXFuU6fD+Pj6OiVbyG5Mynf8UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4xwCQioD7sHfBExVEXY7b+vrHUacvBANaJcpJu0LFD8ojaVup/eNtHt5i2J9tsMM
	 oWLZP0bDOXg/vWmvOp6ETwyAETm7asKs62t5Ogb8OExP8ffspt20pA+b743ElOglb2
	 d5bCJKyPh5lZ5kNn/Wv44ly2qL4XhoxYIZfOeu9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/270] bonding: report duplicate MAC address in all situations
Date: Mon,  2 Jun 2025 15:47:44 +0200
Message-ID: <20250602134314.529617370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 28d68d396a1cd21591e8c6d74afbde33a7ea107e ]

Normally, a bond uses the MAC address of the first added slave as the bond’s
MAC address. And the bond will set active slave’s MAC address to bond’s
address if fail_over_mac is set to none (0) or follow (2).

When the first slave is removed, the bond will still use the removed slave’s
MAC address, which can lead to a duplicate MAC address and potentially cause
issues with the switch. To avoid confusion, let's warn the user in all
situations, including when fail_over_mac is set to 2 or not in active-backup
mode.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250225033914.18617-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7caaf5b49c7b5..c5ccd42af528e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2239,7 +2239,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 
 	RCU_INIT_POINTER(bond->current_arp_slave, NULL);
 
-	if (!all && (!bond->params.fail_over_mac ||
+	if (!all && (bond->params.fail_over_mac != BOND_FOM_ACTIVE ||
 		     BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)) {
 		if (ether_addr_equal_64bits(bond_dev->dev_addr, slave->perm_hwaddr) &&
 		    bond_has_slaves(bond))
-- 
2.39.5



