Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACD2E5B19;
	Tue,  8 Jul 2025 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992807; cv=none; b=SWQK7lofc4Jw1vc0SHmeJ89nwXarusF+pigB4jVPUjgIK/Pcu/Doie9JL2SJcRdoO0+kZCU5vvc/eJCZpeiqz40ipIID+Wmb6WYElair5pGdU6sqCiQQzTlXFE5104SK4HD6Hfk2UPVaMVBYrpTgrOxiKvZFMIOF2I4ou8KiI+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992807; c=relaxed/simple;
	bh=NC7EgCcL8AQw42II8N9L7yhpUpbjyy2iBRdhKpUGy+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APX+ORgnem+XQ3U/NUhnbAFViM6tHRv4/XBG59+H6B4FK36ShyewC6KomUy5XJMQSFQBFEEajpL4bFYNsmOPm+YTVSkNY3Hds53I8Ba9HrQ1Lnm8FUaykGhHFF/gU6tI9lUxDu3FweQ7r/5xRbHtRABlgurWTn0dhPxY3lgGygY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkgTStNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkgTStNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C394C4CEF0;
	Tue,  8 Jul 2025 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992807;
	bh=NC7EgCcL8AQw42II8N9L7yhpUpbjyy2iBRdhKpUGy+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkgTStNICD5x3uNGILKbut6jSUauMOeVvty6q9epaZzXGGNYCBepdGoydTMNjd0Gh
	 OXq61qvGhEff3JvWKRAVdqEaYTx2NCO1VlvnnDDpEcUsALjC4HZr18GFBxEJLPTPkg
	 bFGQYgq27H5nAoTkqkdI6qEfADnifN78cUGxbvvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	John Daley <johndale@cisco.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/232] enic: fix incorrect MTU comparison in enic_change_mtu()
Date: Tue,  8 Jul 2025 18:21:23 +0200
Message-ID: <20250708162243.726383444@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit aaf2b2480375099c022a82023e1cd772bf1c6a5d ]

The comparison in enic_change_mtu() incorrectly used the current
netdev->mtu instead of the new new_mtu value when warning about
an MTU exceeding the port MTU. This could suppress valid warnings
or issue incorrect ones.

Fix the condition and log to properly reflect the new_mtu.

Fixes: ab123fe071c9 ("enic: handle mtu change for vf properly")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: John Daley <johndale@cisco.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250628145612.476096-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index ffed14b63d41d..a432783756d8c 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2127,10 +2127,10 @@ static int enic_change_mtu(struct net_device *netdev, int new_mtu)
 	if (enic_is_dynamic(enic) || enic_is_sriov_vf(enic))
 		return -EOPNOTSUPP;
 
-	if (netdev->mtu > enic->port_mtu)
+	if (new_mtu > enic->port_mtu)
 		netdev_warn(netdev,
 			    "interface MTU (%d) set higher than port MTU (%d)\n",
-			    netdev->mtu, enic->port_mtu);
+			    new_mtu, enic->port_mtu);
 
 	return _enic_change_mtu(netdev, new_mtu);
 }
-- 
2.39.5



