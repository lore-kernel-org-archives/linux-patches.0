Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401BD4F7CCF;
	Wed, 30 Sep 2026 17:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789299; cv=none; b=q7Gdvpw/s3dBPoQuwqTDRsPCMMGMFenhVTqJa3335UmBGMKHA4m8huVc2+nRaELuS7Ew95Z746+crJuRpl+8QIbEJ6kssimlDqFVqZUH23GjHD5CriXPK4CCDL2FH1G0FOIrv55G8cRLQUjJNb9IwcX/C6ARmXPn8X5Or0/rVMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789299; c=relaxed/simple;
	bh=bVotDYIO9o/KjPbW5ABHJ0IbytWj0w19FN9MNq0yuR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOIYxapBWsIb+PBPY+gt142jqzLqyMO4oupPRApqKJA2voYqVvqrJTTSVGu7UJGtQ41/aIEEaP7cJZSFjqWeyp2NVds8shYcwyG0+/62TnX5aayecEs4yrJb5G+3laP27uaCmHMvpum78BnYPvfg31Bt6Vb/e4xn2Ma+fNmc70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2or0HP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2or0HP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483DF1F000FF;
	Wed, 30 Sep 2026 17:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789297;
	bh=1RpqeyNobUJkqFLIbrosLrYwopfUxYRATDqzoidSL/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2or0HP1EC9hinZESLXCE1+A4vnVHS9sZV5+dxU+H9z/sUkJLYrJuvlpLQ7zXM3XK
	 wZaQq7T8nX4T7HDghFfJwB/82ixQkDfNCh/R1eMvI0MdpsY8ArM/EreGAv2HVfE6I4
	 ElKEWkuowXbUF03hJMNOywo8/MzP2hyOdRSTvtA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/877] net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr
Date: Wed, 30 Sep 2026 17:22:19 +0200
Message-ID: <20260930152423.924347990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dad5adfadb76d..a326ee63c1b7c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3562,6 +3562,9 @@ static int bcmgenet_set_mac_addr(struct net_device *dev, void *p)
 	if (netif_running(dev))
 		return -EBUSY;
 
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
-- 
2.53.0



