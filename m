Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5642C381D8;
	Fri, 24 Nov 2023 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsfzL35S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861F1C433C8;
	Fri, 24 Nov 2023 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848760;
	bh=p0A7+05LVx1nDbXamfzaps/KtbAg1KbD+5oE8bdGecw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsfzL35SVP7DVsUgA0VqsVAv8Cv980wX5bTGp7EIQVDniGXC2icIhuvitfWIK1+4Y
	 ZeISFM55fjaBaQzTpf66Y2U2hoOBcW+svX1493mCB5XCvcs8MPDy2ZILe8P1Qr6K5j
	 4m50PUed7y5SznL4HiGtNvrHUSnwiRri23TDzReQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/97] macvlan: Dont propagate promisc change to lower dev in passthru
Date: Fri, 24 Nov 2023 17:50:19 +0000
Message-ID: <20231124171935.881220586@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e1f95fd08d721..29d5fd46c09a0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -769,7 +769,7 @@ static void macvlan_change_rx_flags(struct net_device *dev, int change)
 	if (dev->flags & IFF_UP) {
 		if (change & IFF_ALLMULTI)
 			dev_set_allmulti(lowerdev, dev->flags & IFF_ALLMULTI ? 1 : -1);
-		if (change & IFF_PROMISC)
+		if (!macvlan_passthru(vlan->port) && change & IFF_PROMISC)
 			dev_set_promiscuity(lowerdev,
 					    dev->flags & IFF_PROMISC ? 1 : -1);
 
-- 
2.42.0



