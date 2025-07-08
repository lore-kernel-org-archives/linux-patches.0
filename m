Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E251D2E0B45;
	Tue,  8 Jul 2025 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992338; cv=none; b=P751MpqMP3EmzuJLVwa9HLXD1eUCRpX5w7HSDDpSrmyuSh5lxI2DMiFLDemxtIuouwgzaCyccafkwdhgtLGnn5toktoDFpWvblxtK24oLVzWZdDqaeJaA7WZOwbN3j2sBK9LgXi/ZIP42/yCPgTd7d3ekL8pU9xnKuWhZEB9SoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992338; c=relaxed/simple;
	bh=b8jsxxUKARn0FsnFk0PC8LLao3VhGIgcZNE4M7Cf+fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPPy2an36Ux06TCKR75uUoJN+z8AKhhyYnO+2mIVlfVwm+LH8TTXLKVxBQvXA8PFCL4dEVrwJhGfN/Gfbe4tH2PGeVyjum2/J+kAxQQIU0AN20Tel3X3CI8X2a3pv/OAL0eE2/P6PyL/Bf7dCTekliskIhGfktYu9KdHXkavlp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAbZ2SZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAbZ2SZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6900DC4CEED;
	Tue,  8 Jul 2025 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992337;
	bh=b8jsxxUKARn0FsnFk0PC8LLao3VhGIgcZNE4M7Cf+fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAbZ2SZCLyr/xi3sp6zhu16Z8hZpPYbadHOOPFI8yYIHVf+t6WlW8co6pHcNl+P19
	 ERIrSlNUsHt5ZdQUVvm2WkfbXb9vO18lz9IWodtNV6pvpuc4JGQ+aCSXlEzSBXeIkw
	 fsbApuikoQIXC62GUR3yC4vT6JD1yaadTXRWkKbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	John Daley <johndale@cisco.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/132] enic: fix incorrect MTU comparison in enic_change_mtu()
Date: Tue,  8 Jul 2025 18:22:49 +0200
Message-ID: <20250708162232.355934160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cccf0db2fb4e5..48701032c20c5 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2057,10 +2057,10 @@ static int enic_change_mtu(struct net_device *netdev, int new_mtu)
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



