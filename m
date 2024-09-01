Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431C1C68C;
	Sun,  1 Sep 2024 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209058; cv=none; b=L+pbVGrLC2RjgPC74M/21DNI4rBdtokBVMQ11CH6Mpkz0wQKCfXYjkItiYDr3LK7qNF7i4NYr2Rhxkf8/7M8MGw1m4nlNSPlCNoK9Uq4JG/7ixJAijEb1Fq10BUTCUPXsGZNix8PQXY+O22ayKqAXhSyFCqah0J+xDKuIYRW9Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209058; c=relaxed/simple;
	bh=q0HBfc2Z1bSH9A5fXrvNwGzeWPeLGyrY4WukfStV6fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYVZULA9MZjM0D/G+epT05yXRe1zkAch3poD9Ff4S7ejCdmsemMqQoSuR7pQvBlXMUnUga2iOHh8pYD785uRp+7fbVvDba/uew4VeXKa8gQnXmhXG636B/Z9PMtyXytr1UPb8HFwCZ0hPL/jyMxRB4sIWGREPRdSU0zH8PQWVEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+27Pz3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+27Pz3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A9CC4CEC3;
	Sun,  1 Sep 2024 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209058;
	bh=q0HBfc2Z1bSH9A5fXrvNwGzeWPeLGyrY4WukfStV6fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+27Pz3DXutAWwJcP7VuHb+bplP0pAySQUCA4jNyANHbyvDmhQP7s27xydbcjmEYS
	 NyMadROu8XDJLqPM6+C/Y2skbUw/m4EEB7iKQkeLcXPRN2GHEUxQzHwpnQvhL4taaf
	 Oq8pvbNd6orE6L4hDP2qfhQ8W+SNrAsc7lemCxAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/134] ethtool: check device is present when getting link settings
Date: Sun,  1 Sep 2024 18:17:45 +0200
Message-ID: <20240901160814.558081285@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 net/core/ethtool.c   | 3 +++
 net/core/net-sysfs.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 9ae38c3e2bf0a..f0346cf4462e0 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -549,6 +549,9 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 	if (!dev->ethtool_ops->get_link_ksettings)
 		return -EOPNOTSUPP;
 
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
 	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
 }
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ad45f13a0370b..bcad7028bbf45 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -212,7 +212,7 @@ static ssize_t speed_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (netif_running(netdev) && netif_device_present(netdev)) {
+	if (netif_running(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd))
-- 
2.43.0



