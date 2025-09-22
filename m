Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C349222590;
	Mon, 22 Sep 2025 19:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570136; cv=none; b=i/e6SXnqyuNCK7Nk2ywoNT0NLxgm0QyGB+53l0rAq0sDzXs6W1LssRgy7QJcfLHaGkB0T0O3R4hCARKku0KtkJWu7IhxOzAvsQ88Bj5X23B6cQp4XVn1AS9bN1E6HzBU8p1JJ1HXlLDMHraUMoWDgkdWXr0dLHX/GU9s35XP0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570136; c=relaxed/simple;
	bh=LKJ11LYvVMffzwiowfrbccMYWA2hoqE/cc8Js4HKt9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsQYAZ8D2AyA47HGnW0tXbxPEq8tv5VIzoE3mlEo+ISo2B6VY/CYE4s5g27TNr9LAUkUunbzdKEt2okhs2iSSJC0lIS85IVzmqQpbbvduFptU6FkWnznI2kgZnr3MocSs/Ctuz4BkhEIsGh3i+HWgbgGI/3OKPUMK9CBkqmi/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnRL1gw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnRL1gw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A8CC4CEF0;
	Mon, 22 Sep 2025 19:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570135;
	bh=LKJ11LYvVMffzwiowfrbccMYWA2hoqE/cc8Js4HKt9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnRL1gw3enWbgjM5YMzgqBB5Vlo2oLThOEM31Dsc5e4r8I8PFdHiMJiM9Sc2cRcbg
	 HMgj8V/4/Y4pVFLFYrQIXEM3wk9tTWSBPOdtkTZeNhfZU/JWVrfLIxTP+1m7l2SWNH
	 TPS2fgJt+GOflfB/0vBYAQUfjHuBqN8sOWpAuDEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuling Ren <qren@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 024/149] bonding: set random address only when slaves already exist
Date: Mon, 22 Sep 2025 21:28:44 +0200
Message-ID: <20250922192413.481608433@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c4d53e8e7c152..e413340be2bff 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2115,6 +2115,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		memcpy(ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
 	} else if (bond->params.fail_over_mac == BOND_FOM_FOLLOW &&
 		   BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP &&
+		   bond_has_slaves(bond) &&
 		   memcmp(slave_dev->dev_addr, bond_dev->dev_addr, bond_dev->addr_len) == 0) {
 		/* Set slave to random address to avoid duplicate mac
 		 * address in later fail over.
-- 
2.51.0



