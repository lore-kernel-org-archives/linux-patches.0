Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E14FECCF;
	Wed, 30 Sep 2026 17:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787719; cv=none; b=Yw236UayWndiGOHRzSrpAc2ajI/vWMeQyoUDbOHNfppyAzcItvqyyeWDoiJ6B2JKnux5TzfcRrKL02QahhkRK4KnwsDUXVreB8qIiZ1KpBTgyQEJ0XVpQ+MURwVdoCik59e8UvJoXaQXx8xxnHc8T16Ium2mD90R+8jWz0QPJtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787719; c=relaxed/simple;
	bh=dbg/GgCUxx70ps3sVOXEOoywxHcoMcyRsCypDBryvUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkegmIFR7Mm1Ml9rC87/WhIqw/Y2LZAB48G11Hmr3m7DZy7AFa0F26y9iXMmrkJE2vIJvgj/CWBeoACHkMeXCFakyx7nO6e/CkAkVhQtuHYnQrbOkgZJGg9F0hy0D0lXzm7hpXZB+ygN/kPUzfFKAjrCyzX1ui/lOOWzf5dDT78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=np8F2MnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="np8F2MnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854C91F000FF;
	Wed, 30 Sep 2026 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787718;
	bh=PZH7eZK3eirimMdRx5xyWruteX1tGM8Knf01EemD5NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=np8F2MnJm5L7fiSWE0XbhdwTbeEMu9AwbqAWinh5AychY80yvMom8TWR+xPEtJL6f
	 Z/JU84GKSk0Q9Ycr8jmgBD/QRr0OnnAK+ClAlVyO8wbw6VJQ8eATn48ThyFr4T7shL
	 8JSPFhJouM51iAT1Lu4GinZoZrsn9PDYR7PX+qvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Ralf Lici <ralf@mandelbit.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 328/457] net/mlx5e: advertise MACsec offload only when supported
Date: Wed, 30 Sep 2026 17:27:13 +0200
Message-ID: <20260930152353.099507911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

commit 4581c3d2adc3c73a019bc38db64ca11f28bbd7fd upstream.

Commit 339ccec8d43d ("net/mlx5: Enable MACsec offload feature for VLAN
interface") added NETIF_F_HW_MACSEC unconditionally to vlan_features so
that VLAN devices could inherit MACsec offload support.

mlx5e_build_nic_netdev subsequently copies vlan_features into
hw_features and features. As a result, all mlx5e NIC netdevices
advertise MACsec hardware offload, even when the firmware does not
support it and the driver does not install macsec_ops.

Set the MACsec feature bits in mlx5e_macsec_build_netdev, after device
capabilities have been validated. This preserves MACsec-over-VLAN
support and the ethtool feature control on capable devices, without
advertising either on unsupported hardware.

Fixes: 339ccec8d43d ("net/mlx5: Enable MACsec offload feature for VLAN interface")
Cc: stable@vger.kernel.org
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Link: https://patch.msgid.link/20260917122724.654639-1-ralf@mandelbit.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c |    2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1724,6 +1724,8 @@ void mlx5e_macsec_build_netdev(struct ml
 	mlx5_core_dbg(priv->mdev, "mlx5e: MACsec acceleration enabled\n");
 	netdev->macsec_ops = &macsec_offload_ops;
 	netdev->features |= NETIF_F_HW_MACSEC;
+	netdev->hw_features |= NETIF_F_HW_MACSEC;
+	netdev->vlan_features |= NETIF_F_HW_MACSEC;
 	netif_keep_dst(netdev);
 }
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5851,7 +5851,6 @@ static void mlx5e_build_nic_netdev(struc
 
 	netdev->vlan_features    |= NETIF_F_SG;
 	netdev->vlan_features    |= NETIF_F_HW_CSUM;
-	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
 	netdev->vlan_features    |= NETIF_F_GRO;
 	netdev->vlan_features    |= NETIF_F_TSO;
 	netdev->vlan_features    |= NETIF_F_TSO6;


