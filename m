Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BC643AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hk5sebWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F814C433C9;
	Wed, 15 Nov 2023 20:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081193;
	bh=PjWYrNU5Tim2B2JA9OUcxor8SVaQFBZc29cAFG58G5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hk5sebWCx8XqRzu6+iDND6RqO+yty/t3z9fEmAvqo8x4GiksuFxWMKVlSUHVz+a+Q
	 4W+RQzzCUMwH6+BkFoeV4qpWnpVO5YpOwLnfSEZCYxXG+Ddivtry1mNH25wRHdNYX2
	 XYm1Iu7L0MygOqsHpDrDBK3UBLkhW/joxNS/OWlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 82/88] r8169: respect userspace disabling IFF_MULTICAST
Date: Wed, 15 Nov 2023 15:36:34 -0500
Message-ID: <20231115191430.983577597@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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
index 69d01b68cf6b7..d6b01f34cfa4f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4624,6 +4624,8 @@ static void rtl_set_rx_mode(struct net_device *dev)
 		/* Unconditionally log net taps. */
 		netif_notice(tp, link, dev, "Promiscuous mode enabled\n");
 		rx_mode |= AcceptAllPhys;
+	} else if (!(dev->flags & IFF_MULTICAST)) {
+		rx_mode &= ~AcceptMulticast;
 	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
 		   dev->flags & IFF_ALLMULTI ||
 		   tp->mac_version == RTL_GIGA_MAC_VER_35 ||
-- 
2.42.0



