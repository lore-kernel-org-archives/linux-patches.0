Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA4651EE10;
	Wed, 30 Sep 2026 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793196; cv=none; b=XGJC2G8Rl2bYOvrqrIrcTPeMwJssm8jLGJhSHSawIVtQTgwQNNEn+pT5/UOWoWYduV4GypchpMOd1bc9xVPJyeBQghXu3s5Cf6euvnnC1VqRxcTqpyS9oiI8w+5VqN8zlu2bqudwmPSyxXFkFanS4RlKUXn3miqQHi2ziCOGAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793196; c=relaxed/simple;
	bh=cpceh1ex4zbMHPwIczo6Gqsex6CeXJW5YG6Yrz+rljY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrIWDX6G+yDlkSs057/+qBwYKirkiHSOI6LDeyg+SZWgq6x0nMaEFz75AOWD2v9oNLBLNFWYfhLt+AUneOTrpGsoqNp4a4LMyOVs/yxaqFI72ex2q+csT7ldPVROFSl5bPETFNVSAguNQbJnVEoGeLklB6ohrvIPnA0m2AwnfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9EHrLCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9EHrLCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979EE1F000FF;
	Wed, 30 Sep 2026 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793195;
	bh=sD9bZTdrFRYCSKlE7nEmteLFH3LxtSDMlc1J93zlwiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9EHrLCgAszF/FbhJMP9jAZDAoGhfhZS3fScbOKhs1MOtiJPv4IV8dkaC9HVdrO6j
	 e/D3StrOOFi3qe2BZlwuI4Yjlff61q50g6H+5JZahzV53kJ55FR+QGo3OGJtMbnxDM
	 PC6fj4f6ibWJt7HN48cyRp4EK2sfWiZxrVIgE6HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/395] net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr
Date: Wed, 30 Sep 2026 17:27:09 +0200
Message-ID: <20260930152344.272805437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index 96308c85899f7..c18702f3dd766 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3633,6 +3633,9 @@ static int bcmgenet_set_mac_addr(struct net_device *dev, void *p)
 	if (netif_running(dev))
 		return -EBUSY;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
-- 
2.53.0



