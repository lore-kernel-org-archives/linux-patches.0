Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9888140E38;
	Tue, 17 Dec 2024 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456174; cv=none; b=uRUnSalw+mn7yY0BNp8qRiyNfBtOrOgUFtNGIqbrLtdJQT3DsHHTkbijwRiq0gWcPX4ihO1jwJmBBnS8SaMd1ZIaXfAF+1vxAnRLP0KYG9J81UM3Sk9aGXCvtosccBGtdMmReKBMv00r8YtBdxjyIMlRXk3VdKyYWdqPqGoTfU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456174; c=relaxed/simple;
	bh=0DUwQB8ZWjG3bLR7b9f66oATNbw3meR176SykuYK6Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlFQsEMZERiEXNwVXVVrJlBKQOYtD5q6Iby1BlB9HZ33UbL7SzZTDQEJnxkjUhdJd8kLbDVHJvSlZl64BANHEqASR40KmT+erNuvB7TcQ+t+tYig9gQydWGMBb7B+vNVPD4lMNI/rUl/I3sRbUNEGcxgS4DIZxkynhnqIPrKQyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDGnBIpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDGnBIpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC0FC4CED7;
	Tue, 17 Dec 2024 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456174;
	bh=0DUwQB8ZWjG3bLR7b9f66oATNbw3meR176SykuYK6Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDGnBIpGQWEXYdicMH9hiHDb6wP3yZZjCCg9lQPl4BqNOl5NKcAZj61Tjf13eCtJc
	 9D1a8sdY85fAL4xirdTCyTLgzafH8X+ha1Aq2nSlkIpgtPwwiEGOLbHHnnsGnGXWtT
	 L85EpTacWfXwbxk4eWsFH+KdERLOS94Y8HD1ey54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@idosch.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/109] bonding: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL
Date: Tue, 17 Dec 2024 18:08:07 +0100
Message-ID: <20241217170536.847025507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 77b11c8bf3a228d1c63464534c2dcc8d9c8bf7ff ]

Drivers like mlx5 expose NIC's vlan_features such as
NETIF_F_GSO_UDP_TUNNEL & NETIF_F_GSO_UDP_TUNNEL_CSUM which are
later not propagated when the underlying devices are bonded and
a vlan device created on top of the bond.

Right now, the more cumbersome workaround for this is to create
the vlan on top of the mlx5 and then enslave the vlan devices
to a bond.

To fix this, add NETIF_F_GSO_ENCAP_ALL to BOND_VLAN_FEATURES
such that bond_compute_features() can probe and propagate the
vlan_features from the slave devices up to the vlan device.

Given the following bond:

  # ethtool -i enp2s0f{0,1}np{0,1}
  driver: mlx5_core
  [...]

  # ethtool -k enp2s0f0np0 | grep udp
  tx-udp_tnl-segmentation: on
  tx-udp_tnl-csum-segmentation: on
  tx-udp-segmentation: on
  rx-udp_tunnel-port-offload: on
  rx-udp-gro-forwarding: off

  # ethtool -k enp2s0f1np1 | grep udp
  tx-udp_tnl-segmentation: on
  tx-udp_tnl-csum-segmentation: on
  tx-udp-segmentation: on
  rx-udp_tunnel-port-offload: on
  rx-udp-gro-forwarding: off

  # ethtool -k bond0 | grep udp
  tx-udp_tnl-segmentation: on
  tx-udp_tnl-csum-segmentation: on
  tx-udp-segmentation: on
  rx-udp_tunnel-port-offload: off [fixed]
  rx-udp-gro-forwarding: off

Before:

  # ethtool -k bond0.100 | grep udp
  tx-udp_tnl-segmentation: off [requested on]
  tx-udp_tnl-csum-segmentation: off [requested on]
  tx-udp-segmentation: on
  rx-udp_tunnel-port-offload: off [fixed]
  rx-udp-gro-forwarding: off

After:

  # ethtool -k bond0.100 | grep udp
  tx-udp_tnl-segmentation: on
  tx-udp_tnl-csum-segmentation: on
  tx-udp-segmentation: on
  rx-udp_tunnel-port-offload: off [fixed]
  rx-udp-gro-forwarding: off

Various users have run into this reporting performance issues when
configuring Cilium in vxlan tunneling mode and having the combination
of bond & vlan for the core devices connecting the Kubernetes cluster
to the outside world.

Fixes: a9b3ace44c7d ("bonding: fix vlan_features computing")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241210141245.327886-3-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index bee93a437f99..7eb62fe55947 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1462,6 +1462,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 
 #define BOND_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
+				 NETIF_F_GSO_ENCAP_ALL | \
 				 NETIF_F_HIGHDMA | NETIF_F_LRO)
 
 #define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-- 
2.39.5



