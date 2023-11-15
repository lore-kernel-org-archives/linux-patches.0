Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AD0249E2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpXW4hWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57BEC43397;
	Wed, 15 Nov 2023 20:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081871;
	bh=ntsHQnnaVZ2gFhgsMbAIHFivI5Po+/qSxAVb1rLYojY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpXW4hWtosr6t0HLIfRIxssCTDJx1UD3z3r/KnTAPuufQw9ar8nng89xV+q+xPxBb
	 0k8x6xephP7oK6JcijlX1JVRmnz6P7YMqHtWkySsna6jH0GxlNOpzlvfoDmn52VvyQ
	 qGWBMH12g19ab75fTNBCEv+G6fruDLzTEB2qCC10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/191] r8169: respect userspace disabling IFF_MULTICAST
Date: Wed, 15 Nov 2023 15:47:33 -0500
Message-ID: <20231115204655.121209698@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 8999ce4cfc87e61b4143ec2e7b93d8e92e11fa7f ]

So far we ignore the setting of IFF_MULTICAST. Fix this and clear bit
AcceptMulticast if IFF_MULTICAST isn't set.

Note: Based on the implementations I've seen it doesn't seem to be 100% clear
what a driver is supposed to do if IFF_ALLMULTI is set but IFF_MULTICAST
is not. This patch is based on the understanding that IFF_MULTICAST has
precedence.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/4a57ba02-d52d-4369-9f14-3565e6c1f7dc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6886402add4c4..6e0fe77d1019c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2577,6 +2577,8 @@ static void rtl_set_rx_mode(struct net_device *dev)
 
 	if (dev->flags & IFF_PROMISC) {
 		rx_mode |= AcceptAllPhys;
+	} else if (!(dev->flags & IFF_MULTICAST)) {
+		rx_mode &= ~AcceptMulticast;
 	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
 		   dev->flags & IFF_ALLMULTI ||
 		   tp->mac_version == RTL_GIGA_MAC_VER_35 ||
-- 
2.42.0



