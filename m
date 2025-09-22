Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A014527B320;
	Mon, 22 Sep 2025 19:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569854; cv=none; b=jffbrwy8/2t4K7DHAajpnlEVXjspDB+G8fJ6qAHg1X3IAYSXwiVg+NzP+ooRj38Aik1SmxLch9S2FKqVNhDak64n6nbjt0mgfCJWS7cQ7k0IhWnwpD8ROmMBweH1skph4rlhB3NuBVQjtV5hA+PHboXRMMLqOp04CEmRcPpMgx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569854; c=relaxed/simple;
	bh=vmwxmg6W46GnV8Toc2QjaFDzRyv3nrFLt/DnmO+06K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0OsyFm+eZEbmgf8KuLYKMV5H5xRjMR+iEUnpw9RMlfUrMgOkzGVNH/FaEjGInn99GShJuErOndA+hIh95Que5InuVQ7EYiSdu3u/GJzFrcTADYxOKqcLa0u1cHqa1bO+4Xsif+Xoe861JBd7ALb8gKmbUuREENPORZrA6MJTVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vjh795dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vjh795dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383AAC4CEF0;
	Mon, 22 Sep 2025 19:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569854;
	bh=vmwxmg6W46GnV8Toc2QjaFDzRyv3nrFLt/DnmO+06K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vjh795dnH7CB+X49DZRhGxBJrdPKzdnbIDdWQQzjpEPktoASaSOvHKkLvGM4ankQt
	 VQQguGY0xZUHWYAKtc0Vhz72GHLQ4Ber+xPtvdooEMm5i/bTQGx1MQhxf8PGf0oooa
	 Lx6U46sf6MR1+IN/9uKLzW4H/pHPCJTpCY1Zk9PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuling Ren <qren@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/105] bonding: set random address only when slaves already exist
Date: Mon, 22 Sep 2025 21:28:57 +0200
Message-ID: <20250922192409.277234794@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

[ Upstream commit 35ae4e86292ef7dfe4edbb9942955c884e984352 ]

After commit 5c3bf6cba791 ("bonding: assign random address if device
address is same as bond"), bonding will erroneously randomize the MAC
address of the first interface added to the bond if fail_over_mac =
follow.

Correct this by additionally testing for the bond being empty before
randomizing the MAC.

Fixes: 5c3bf6cba791 ("bonding: assign random address if device address is same as bond")
Reported-by: Qiuling Ren <qren@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250910024336.400253-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 52ff0f9e04e07..952737a98751e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2117,6 +2117,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		memcpy(ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
 	} else if (bond->params.fail_over_mac == BOND_FOM_FOLLOW &&
 		   BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP &&
+		   bond_has_slaves(bond) &&
 		   memcmp(slave_dev->dev_addr, bond_dev->dev_addr, bond_dev->addr_len) == 0) {
 		/* Set slave to random address to avoid duplicate mac
 		 * address in later fail over.
-- 
2.51.0



