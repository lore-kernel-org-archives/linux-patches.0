Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3802222B2;
	Mon,  2 Jun 2025 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873649; cv=none; b=jwRbG1LuLOP2Dvd92uRuOR9lPQs14/Gg5OWydEFJPZmbMRp+ZVAyAJM3OGvF2EAxZXPAKdUTgmeGqb2ald99+wHFNvXLXCbE9XSu77WcnsremJ5jUZkqELSo9fV6nULP5ZDeK82n9kR3oC4m2iUtiZ/WJtQVohLiCevt3LsLL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873649; c=relaxed/simple;
	bh=NeIDUaEsvTY1/9Gw8KicCkC3tJI1ygNhbkW9cTJt5pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tza60AvUoThnzdI9d2FcQwKbhKQtU0dWStnAJLBINICntXpjhiMOaNNarVVcs3L1WbsYZTFQjiT0kNpXdaiCDMlQdLSL/qRLbKzly12oAFavtZPUzUe3CwJKQRKNIdxu8HhYCu+NBcBX5FV5cFSiP2N+hLQK+jc+cEHCVehnSR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7EyiMoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7EyiMoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463CDC4CEEB;
	Mon,  2 Jun 2025 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873648;
	bh=NeIDUaEsvTY1/9Gw8KicCkC3tJI1ygNhbkW9cTJt5pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7EyiMoaCFnsxC7YFDeuIAZd78EQ/Bwi0zYtaffT8rXP5zFNQrEnqMzM8ehPMP2ze
	 qT5lKPwnH+FIMNvB95Nv1KVz7nh1pev/+hDm4GC+zXFHTvHqRh5F1af0ewkwPkbKEu
	 xi7W2W6j2yEwxnFXTgPqIoaWjTuiWjj6AFqk58mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/444] bonding: report duplicate MAC address in all situations
Date: Mon,  2 Jun 2025 15:44:02 +0200
Message-ID: <20250602134348.116521228@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7eb62fe55947f..56c241246d1af 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2469,7 +2469,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 
 	RCU_INIT_POINTER(bond->current_arp_slave, NULL);
 
-	if (!all && (!bond->params.fail_over_mac ||
+	if (!all && (bond->params.fail_over_mac != BOND_FOM_ACTIVE ||
 		     BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)) {
 		if (ether_addr_equal_64bits(bond_dev->dev_addr, slave->perm_hwaddr) &&
 		    bond_has_slaves(bond))
-- 
2.39.5



