Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749401C68C;
	Sun,  1 Sep 2024 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209249; cv=none; b=KGSopL1/ZXS3N0NeyoBqapa8NnBvt+tCggd+V9TiXTG+oEnO+Ai2mfDctuoH/4Jp42s48cjcAYZsLwnVa541r1hk0wDPPQgQU+ZbEuPk6PS9gJohjQ9u2NstijikZ8jYvPxliaD19HGsRRvqSx6jK4HR5I9k3x0kYfHNFC8si08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209249; c=relaxed/simple;
	bh=1vS6b1KcBs3cSa07fFj9k50LoREQi+9JmJHmllSQGaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wrox4X7HNbR73RIkKKNqaPeK7mh/pP7/IEinGrmwow1FbMGrzNWGgvCCklQ0j0L1pDNzf4PTFf8Fv9qffXXotu+Gz6M0UaoVtlmbblblN3aunIrTwt3OwhSb5mSfIwhyxBa5aRCAJ8mVVeC/cztXJa3Zb+oSenioJRpX9O2taeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BckyaKJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BckyaKJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00590C4CEC3;
	Sun,  1 Sep 2024 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209249;
	bh=1vS6b1KcBs3cSa07fFj9k50LoREQi+9JmJHmllSQGaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BckyaKJOqdKm/n4WVrBUN92Xx0KnR1kUvombW2rpqxtp3KaZbdkD+ztjWyf/7OIuz
	 mqvXJSh3LGbFjcruMlLo+iTl5laEwcRNvSc8j26blVfY1AI5VGK+H9CHDwZcocyjqN
	 80v26P69Uc8Le9842bshxGDMX3mhozslxRcYxZns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/71] ethtool: check device is present when getting link settings
Date: Sun,  1 Sep 2024 18:17:51 +0200
Message-ID: <20240901160803.628894335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

From: Jamie Bainbridge <jamie.bainbridge@gmail.com>

[ Upstream commit a699781c79ecf6cfe67fb00a0331b4088c7c8466 ]

A sysfs reader can race with a device reset or removal, attempting to
read device state when the device is not actually present. eg:

     [exception RIP: qed_get_current_link+17]
  #8 [ffffb9e4f2907c48] qede_get_link_ksettings at ffffffffc07a994a [qede]
  #9 [ffffb9e4f2907cd8] __rh_call_get_link_ksettings at ffffffff992b01a3
 #10 [ffffb9e4f2907d38] __ethtool_get_link_ksettings at ffffffff992b04e4
 #11 [ffffb9e4f2907d90] duplex_show at ffffffff99260300
 #12 [ffffb9e4f2907e38] dev_attr_show at ffffffff9905a01c
 #13 [ffffb9e4f2907e50] sysfs_kf_seq_show at ffffffff98e0145b
 #14 [ffffb9e4f2907e68] seq_read at ffffffff98d902e3
 #15 [ffffb9e4f2907ec8] vfs_read at ffffffff98d657d1
 #16 [ffffb9e4f2907f00] ksys_read at ffffffff98d65c3f
 #17 [ffffb9e4f2907f38] do_syscall_64 at ffffffff98a052fb

 crash> struct net_device.state ffff9a9d21336000
    state = 5,

state 5 is __LINK_STATE_START (0b1) and __LINK_STATE_NOCARRIER (0b100).
The device is not present, note lack of __LINK_STATE_PRESENT (0b10).

This is the same sort of panic as observed in commit 4224cfd7fb65
("net-sysfs: add check for netdevice being present to speed_show").

There are many other callers of __ethtool_get_link_ksettings() which
don't have a device presence check.

Move this check into ethtool to protect all callers.

Fixes: d519e17e2d01 ("net: export device speed and duplex via sysfs")
Fixes: 4224cfd7fb65 ("net-sysfs: add check for netdevice being present to speed_show")
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Link: https://patch.msgid.link/8bae218864beaa44ed01628140475b9bf641c5b0.1724393671.git.jamie.bainbridge@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 2 +-
 net/ethtool/ioctl.c  | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index fdf3308b03350..8a06f97320e04 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -215,7 +215,7 @@ static ssize_t speed_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (netif_running(netdev) && netif_device_present(netdev)) {
+	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd))
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e31d1247b9f08..442c4c343e155 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -445,6 +445,9 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 	if (!dev->ethtool_ops->get_link_ksettings)
 		return -EOPNOTSUPP;
 
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
 	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
 }
-- 
2.43.0



