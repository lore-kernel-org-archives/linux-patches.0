Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B452E718E;
	Tue, 15 Jul 2025 13:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587708; cv=none; b=PAbGmWHt56zofIXAlkwF4NdP0000rSR1yZFzn8ljOnyJ1tkluYxu3P9AwE9dSzr9IWx245F4fAurwRBV9McZdpJISE6ns+nhconSWorWSHgG+4P2eIak1uI1eFJIQllb8zvFaYbbO7n0ACoHuhZhAziDk17DzVwCkn8M7XPngUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587708; c=relaxed/simple;
	bh=Wf3Q4h2y2eD/33JBOSt0GI7Xjm93F/uQYPCY0KQXOhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UV8eFUEVxPEyKt96A1TCX5vLK6pfO2669FQ15L9p7ZWySp3Rg5berBxDs6WHKtFymYx4zEps8BJD6tK3FC2mPQ4HLXDeW7/Q+kV3zHjCLe219p05e/L3DCbUmOn9pHF2gdFYBb9PlcS2x4UWC6eIQ82/NaJEfyyvgtZOVNVOOWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNHzgehB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNHzgehB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B9AC4CEE3;
	Tue, 15 Jul 2025 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587708;
	bh=Wf3Q4h2y2eD/33JBOSt0GI7Xjm93F/uQYPCY0KQXOhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNHzgehBitWiZd4SwDZprQr4qtIy/bzbnRkml3RLiOlpk1e6THUDOkNjDPo4kKhUq
	 5059htgDqSwpxtwruAwxy4NPDfLtPr6ApUMG3fm1WJ1MeXnUxO9jPOYNuymHzpF6Oc
	 XC49QTfpBPkFnPiWlNlvTt2HuJ/k+Wo9kptnv7zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	John Daley <johndale@cisco.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/208] enic: fix incorrect MTU comparison in enic_change_mtu()
Date: Tue, 15 Jul 2025 15:13:25 +0200
Message-ID: <20250715130814.789292165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b695f3f233286..f59d658d624f5 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2058,10 +2058,10 @@ static int enic_change_mtu(struct net_device *netdev, int new_mtu)
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



