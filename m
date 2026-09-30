Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8FF3E0C44;
	Wed, 30 Sep 2026 19:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796872; cv=none; b=KgDQGC4Y4/qf9RDxH8T9Bv1otWWK6epPB17kt8shLYuQCIzPfgZ2Qq7vJKx9JfvaaL7jQsHzXaVaKOKi/MjJvN+y7WsOzzmH26JAI8fRz/KvIB0uD1EIpiUQJq39rBM2kaFYE76Rvvut/C1F10ZFpnP/gYJSIdXlFgLZMIik24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796872; c=relaxed/simple;
	bh=2wc53CYP+RnLrmR116x43Y3wvfSgwRgG0+0fIJcaep8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKFrwfnqg46vDDjV3yCvEZhcp6xDwu9z7TzJPqoSYazv14TH4jowkgNeSfoFleR8XSHZSVCqbYxT4iQVTRgsvgjhT5CAOMJpRCSv+grW4eQR+pSRp7On8P9+Mq6/E+vgnpsJ4J7E0zHo9n81Oc2yccMeU+KxIR5hW04HzKMlHB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xs2X2sba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xs2X2sba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607291F000FF;
	Wed, 30 Sep 2026 19:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796870;
	bh=Te8odQGjnL7r+lLmjdf4GYfxLG/Npfo17oPDBs5ZGjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xs2X2sbaBjJrzOwcZ62qeyxx1l7V2neZD/f5UlFnV/t513lt0/4jlwrXUZqQeINTA
	 oI4Fe6m49p48oM1m/jAIGP5rvrxiznyEejtgSI5mfwlNz7VpmflshXIj1CmcowzWbb
	 uNQ2EoQ3SwGwn6NgOqlm7zV98UEnefginEed3GBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1066/1193] net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr
Date: Wed, 30 Sep 2026 17:29:10 +0200
Message-ID: <20260930152457.908116773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index ce76946c4444b..0d3deb246afba 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3571,6 +3571,9 @@ static int bcmgenet_set_mac_addr(struct net_device *dev, void *p)
 	if (netif_running(dev))
 		return -EBUSY;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
-- 
2.53.0



