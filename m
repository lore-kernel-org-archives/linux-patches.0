Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A812DC34C;
	Tue,  8 Jul 2025 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994091; cv=none; b=m7leJomOGJ3oOtslXcaLRy1HVB7DLNiips0f6q8FOA2QCvdBYB9hIQ8KXdYHws4/vrWYLXmRCTdRkfxjjZty5EnbvRZvnHgoFdiFDLqyop2QR4H4u5kopqyFNnca1V8z8+JL8m4x2mJZlWvWRTAVTRXLi7p4q3h/jyqrgSapRIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994091; c=relaxed/simple;
	bh=dqAR/r5i1GtTr8E+DcbhwYH5kKy0mg7wvOU2bQV1IFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcxCsVmq4D7L8fVHRKn2LzHBs7wiycTdBDo6Xmj0fFbrm6RF6u4rNIrHjyTONH5VBan4lStf9e/7HNtcJO72JTeNOoHmIzzh1oDdqfrnJT3Mlp3bsDJlEAEtm5svs8CKSr9eDmUjYLSWN1G0Zk7m+6N3zXiVGG6aG3GytzCCcfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2Ox51Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2Ox51Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0156BC4CEED;
	Tue,  8 Jul 2025 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994091;
	bh=dqAR/r5i1GtTr8E+DcbhwYH5kKy0mg7wvOU2bQV1IFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2Ox51HvmXDXVKvU2KV1r4l8i8fnouA03dD/XeShsrEu8bwUy1x3hPpp9X7FLLqB5
	 z0heTANmqsy8UN+xhL98ztlTP29WXm20i81iUuFtoQGsHrvcn/UAZ1DVFsAgBYO/Sm
	 84fczgLRWfdzNx3z5+CKjrgmN6CFPW1yMio15H64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	John Daley <johndale@cisco.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/160] enic: fix incorrect MTU comparison in enic_change_mtu()
Date: Tue,  8 Jul 2025 18:22:39 +0200
Message-ID: <20250708162234.817705684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 52bc164a1cfbc..a3f57069e972b 100644
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



