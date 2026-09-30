Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4DD50EC11;
	Wed, 30 Sep 2026 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787347; cv=none; b=GHE9cN2DwW70YtO19AlKS5ldf4cAZRh9oM88avL8wR3B1oCT2MOvDZOo439Sdx0Nt29v2MPQwt3uVGdHPoxXaZwobQPUlK1EbIjpXOV/dFSUQq0U2Ln0OOSp1KnbTdkwbiksJkwCniae/0u54C0splrORNu6LOXiWeohQKUgAZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787347; c=relaxed/simple;
	bh=YmYIWnmJlWyxMbm51NeaIsnKPRn1N7X+HxWCFM6wE3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsP52gPo2zC040iqRdtAmPxOUB/+RZbBqV3km+jvkytQ9tPmSgEXhmu7Sp8DCiYcWf396e1CoGthMBVJ4raVoCCQpYbhc5VXzOLmYygo6mPgtzmPhx4rAcHfDQdNyKmxYYyTgJeQDib/PWJx1u6L/PLorAxVf+VKSY2MCI+srcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6Ktz90O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6Ktz90O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DFB1F0089B;
	Wed, 30 Sep 2026 16:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787345;
	bh=F/z14ETUfn2XHzjc8YBTal8gW6mauVrDO2l3GzScPgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6Ktz90OnoCnt7vinvVhUpUBH7GFEQJ9HK/nMGpy+gQr3jYIZsQipRNfmJBRbTx7x
	 bxfASUZDZnAxSnsFx8Ey2mJhTkc5f174rSwZM1gR5sUzpmiXYXITcwbQqrqypiyH5u
	 lTcbKh5mLnZ9LKR+SAgmAexpLgZKSkV5+BRzEbrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 196/457] net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr
Date: Wed, 30 Sep 2026 17:25:01 +0200
Message-ID: <20260930152350.285843451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 273941c85fc2632cd3e56ddff737b9245de7697d ]

bcmgenet_set_mac_addr() did not check whether the provided MAC address is a
valid Ethernet address before applying it. Userspace could configure an
invalid address (such as all zeroes or a multicast address) while the
interface is down.

Add a call to is_valid_ether_addr() and return -EADDRNOTAVAIL if the MAC
address is not valid.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260921220021.281418-5-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 07032e4193ea1..011376a1678a1 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3635,6 +3635,9 @@ static int bcmgenet_set_mac_addr(struct net_device *dev, void *p)
 	if (netif_running(dev))
 		return -EBUSY;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
-- 
2.53.0



