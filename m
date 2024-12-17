Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C011F76D5;
	Tue, 17 Dec 2024 17:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455646; cv=none; b=ZoT+F98ZsHGY1UF/smzwcDoHcJ97304nzrIDqgJAhk9naWdgxSi/m2p8VLxZP6ezFihOrynoM72fH982wyzaL8QCPQ7thtw1RiMsNCPwhFspdFtRANpc1xPKe3WyZfwrd8pXlyomy1PiBaPd546HaDw7easwx1hFLEvjLo3T7IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455646; c=relaxed/simple;
	bh=+MomiyeYeIgB8dTQrRBqJ3zc/Rj30/8FxLt+51fxyZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XozbjMArjmGc3aMpb8L0s8fSgdFJ7eb0Z6AdQJ+CRsBl+5KDA4lh2GlFj406pQJstKhWWI+2ZU/f2gdkFmlfH8UHJLXa/nYw/wGxdPv7lSulIpQ01nJZS/fAGRRFsZK1YTNSu2XrBWelmmASsFaQsTT7wew0PodkHAuEXfmyTyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeFYeMcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeFYeMcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ECBC4CED3;
	Tue, 17 Dec 2024 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455646;
	bh=+MomiyeYeIgB8dTQrRBqJ3zc/Rj30/8FxLt+51fxyZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeFYeMcPPaAg0JEdwobStzx6bTRIB/eca084PHEnjfTE+/LFghkKkO7+lw8HUHW2x
	 p+IAXIUDQwYzEr+QtOvExyclyw/Wg0z63yMSKbVTBsb81ZzB36EWt467bvO63dA3i4
	 iHA6R6VDmTBjMXDNVssDJzqerGdemuRFzGcQJYs8=
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
Subject: [PATCH 5.15 36/51] bonding: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL
Date: Tue, 17 Dec 2024 18:07:29 +0100
Message-ID: <20241217170521.824020062@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 67d153cc6a6c..75499e2967e8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1384,6 +1384,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 
 #define BOND_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
+				 NETIF_F_GSO_ENCAP_ALL | \
 				 NETIF_F_HIGHDMA | NETIF_F_LRO)
 
 #define BOND_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
-- 
2.39.5



