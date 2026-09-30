Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FD751AEEE;
	Wed, 30 Sep 2026 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792467; cv=none; b=MvH7WYVJYg/0AEo3aS8PQDQeZaqgnKA1DAZUblvymgCmNqT+VOiNqRtkXcYWWaKe5lCkRf8w7N0gSJqXTj+o9ftSLK0WmCXAZTkVYXeil63ZQqb2lppOYTvKV8R6T6B0a/nwCAB/RoD1tFXE9ZZlQ1sfP5V8oWQJR/6N9KRpt34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792467; c=relaxed/simple;
	bh=bnpJgqGzjgmKFTNhrhpKgE//5mPc3oBdtjgYdsjtHIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE3f4rLJ0SconRPeuhSCfYE/DaRsOY9LoxJq8/JRAQUHGW93uDIeyEXN5STFV2Jm8yi2hDtFlDwkNu3bfaqe++h0tQDCxted2bWEvUbZeNf3EL2I0PLFHC7/nZlsrAocix3F8mRkc6hOGtNsNM71IPjcFQ41RAINozsEgt+xams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ai63v3uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ai63v3uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845CC1F000FF;
	Wed, 30 Sep 2026 18:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792466;
	bh=w5md/WINhKU9yUoi7HFY9k9N5Izg0e5UD6AnBSK3KNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ai63v3ujw5EbZieejqDoHbnoJSxvv1o6CD/d1iEmfust4qMElJe0kl4HdL43g9x/o
	 H7l/ksjgq/SMxmMFRLo7pmRKUOXZmoANtVHxYDHpU8d4R+zD2xe2I/mY74US2yJFT2
	 GXRwuHi3PeDBt+JIrai/RscMhuYX5LIhkElNWbgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 666/752] net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr
Date: Wed, 30 Sep 2026 17:28:56 +0200
Message-ID: <20260930152412.667772973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index bafb8c56a5497..abd4a99b9a5dd 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3627,6 +3627,9 @@ static int bcmgenet_set_mac_addr(struct net_device *dev, void *p)
 	if (netif_running(dev))
 		return -EBUSY;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
-- 
2.53.0



