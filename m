Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AED02E2EFF;
	Tue, 15 Jul 2025 13:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586521; cv=none; b=Io5XcyqA+fYvtnKGiFEDpDNbiKTOF0xzehyosKELjGLlD3EoRO3nmqNA+pwvnfIEFM7kLd94ty42cCNuAyq9nl90SW6FWLrQ+8GJkrViJ+5Se+/trDaZK7ORXUUMU23J6XKZD6CffUDrIp6Obz6i6+Uy3H5iq5IUOcHIh4ir96M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586521; c=relaxed/simple;
	bh=Gz4Sh3pl2uEfgWc94iDxgcpHLIyiChKdOODFQTpJg8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCDEfX+36U8ZubgDFbcW+yPQuUVN38dQVzX7W8v8P6ogEVZCbbnDpEH9aSpX0qg5a6EIljsHPgb/tbRzVYv7x6oCJVJU99S5o7exbSrZ3rIE6Zb7B6fH7/G0kuD/nZ4RlU21OF2CQB4ySuPnNHslfkTKGq/Tt6KUcNuUZrothf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B8f4e9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B8f4e9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADA0C4CEE3;
	Tue, 15 Jul 2025 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586520;
	bh=Gz4Sh3pl2uEfgWc94iDxgcpHLIyiChKdOODFQTpJg8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B8f4e9OPO6cToNH6mvV09LTfHk4s1Y462YrLKf4M9Ouc0vmhdBSEfqZzQ7C3v+9d
	 3uqCggxi65JjU5+tr7fptt9hs30dY87NaYQwrES5/xscZ5GyH/gkbU93R0EpEeQEVk
	 +L/zMyizQnGleuN/gTreUtpZ5ZImICzpcnw717FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	John Daley <johndale@cisco.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/148] enic: fix incorrect MTU comparison in enic_change_mtu()
Date: Tue, 15 Jul 2025 15:13:11 +0200
Message-ID: <20250715130803.087935435@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 892c4b5ff3036..1101f1416d076 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2093,10 +2093,10 @@ static int enic_change_mtu(struct net_device *netdev, int new_mtu)
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



