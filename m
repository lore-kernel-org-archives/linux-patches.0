Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA7428DBA;
	Fri, 24 Nov 2023 18:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykCyt+QV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB62C433C9;
	Fri, 24 Nov 2023 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851941;
	bh=VQ0iiccIZuqDOaZx8N7TrgdcLPLJjZbWQXDWy9mixe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykCyt+QVRHQRJFG/KTqxjkgdaJe1toHVgobUBGtFAYixA2/Eydmlwt3o3fsZsnTbB
	 vvmKy06DIirDs9EaCdhTwbJ0V++pNlxBHgsLeZvzDRvzyW0/zLTE51XURubkKjhxn1
	 sUV5OXNGPRhh3GA4o4NBcS7zcxEGldG5WsvU2oAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/372] macvlan: Dont propagate promisc change to lower dev in passthru
Date: Fri, 24 Nov 2023 17:49:03 +0000
Message-ID: <20231124172015.681817589@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 7e1caeace0418381f36b3aa8403dfd82fc57fc53 ]

Macvlan device in passthru mode sets its lower device promiscuous mode
according to its MACVLAN_FLAG_NOPROMISC flag instead of synchronizing it to
its own promiscuity setting. However, macvlan_change_rx_flags() function
doesn't check the mode before propagating such changes to the lower device
which can cause net_device->promiscuity counter overflow as illustrated by
reproduction example [0] and resulting dmesg log [1]. Fix the issue by
first verifying the mode in macvlan_change_rx_flags() function before
propagating promiscuous mode change to the lower device.

[0]:
ip link add macvlan1 link enp8s0f0 type macvlan mode passthru
ip link set macvlan1 promisc on
ip l set dev macvlan1 up
ip link set macvlan1 promisc off
ip l set dev macvlan1 down
ip l set dev macvlan1 up

[1]:
[ 5156.281724] macvlan1: entered promiscuous mode
[ 5156.285467] mlx5_core 0000:08:00.0 enp8s0f0: entered promiscuous mode
[ 5156.287639] macvlan1: left promiscuous mode
[ 5156.288339] mlx5_core 0000:08:00.0 enp8s0f0: left promiscuous mode
[ 5156.290907] mlx5_core 0000:08:00.0 enp8s0f0: entered promiscuous mode
[ 5156.317197] mlx5_core 0000:08:00.0 enp8s0f0: promiscuity touches roof, set promiscuity failed. promiscuity feature of device might be broken.

Fixes: efdbd2b30caa ("macvlan: Propagate promiscuity setting to lower devices.")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20231114175915.1649154-1-vladbu@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index b8cc55b2d721c..012830d12fde6 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -771,7 +771,7 @@ static void macvlan_change_rx_flags(struct net_device *dev, int change)
 	if (dev->flags & IFF_UP) {
 		if (change & IFF_ALLMULTI)
 			dev_set_allmulti(lowerdev, dev->flags & IFF_ALLMULTI ? 1 : -1);
-		if (change & IFF_PROMISC)
+		if (!macvlan_passthru(vlan->port) && change & IFF_PROMISC)
 			dev_set_promiscuity(lowerdev,
 					    dev->flags & IFF_PROMISC ? 1 : -1);
 
-- 
2.42.0



