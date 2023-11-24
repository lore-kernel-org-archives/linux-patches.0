Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B32E655;
	Fri, 24 Nov 2023 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/wsA0cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C4DC433C7;
	Fri, 24 Nov 2023 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850903;
	bh=8tiTggMb3brTZ1Y1TV+P9Rboi1yQHGKUzxyRyqO046M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/wsA0cM6UNiAev4Ge8XE1L73GPygYBQHtcLmNmrdY7yGa7+37O4nai5ldFiDhR0d
	 eCK1+SQCHHeyykQYc53OLnxv+DefJdJAOPZFFYlqWcgmm//AgQdEWnhXuZUI4bAFML
	 +ctzC7+M+xShH2dZDk1yFdqqjLWmyNy9IPN1/q28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 217/491] macvlan: Dont propagate promisc change to lower dev in passthru
Date: Fri, 24 Nov 2023 17:47:33 +0000
Message-ID: <20231124172031.062217664@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index ed908165a8b4e..347f288350619 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -780,7 +780,7 @@ static void macvlan_change_rx_flags(struct net_device *dev, int change)
 	if (dev->flags & IFF_UP) {
 		if (change & IFF_ALLMULTI)
 			dev_set_allmulti(lowerdev, dev->flags & IFF_ALLMULTI ? 1 : -1);
-		if (change & IFF_PROMISC)
+		if (!macvlan_passthru(vlan->port) && change & IFF_PROMISC)
 			dev_set_promiscuity(lowerdev,
 					    dev->flags & IFF_PROMISC ? 1 : -1);
 
-- 
2.42.0



