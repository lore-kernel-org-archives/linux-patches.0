Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8013DBD48;
	Wed, 30 Sep 2026 19:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797041; cv=none; b=Y03pvQETGC5D4lH0KMkhBS1GARm734y2QlEvKrCQcYNYp0Zw60EgQgfqAZmFcGXc6u/+BUeUl5GbCtra5uQU33DhKdsWQeifzjOJj9TP0mIrnOhU3SluDhmhuEUpa9fv7ZCFgXMbAoemcBBI0Tr1sGPz5yGM4vUf72Ldr41w8bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797041; c=relaxed/simple;
	bh=QRJ+RfHTzGGB353G/PJ9holS9vi8YIpdwQOpeRuIceY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFdA1auBxXRHGqabF1K17VXU0Xqqiat/2YjXTqwy7RhPNK5q+cZzj2tGPqmVa4lnME4frdCkeNIexY8Xf0w6bln7hZgzKVP4nd/3S2+zaTecBEOADPXgOWa22I6AmijaJRa2YFbKuBnkRDLeCQNiLiV9ePonLh+XaE01mUFO19A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeIHzBPV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeIHzBPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0031F000FF;
	Wed, 30 Sep 2026 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797040;
	bh=cNYgJOJcIaTRS30owdc2Tb7U7tlfQfqNbVG6PaKpkFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeIHzBPVippA92rY+vIyrbYpkqDt2K7LS+FYmKaCaW3vWFEx+sVoIWERdS/p5YEo1
	 WMWlhkpJulJEy/AMKGBsdlgXStZQYbxZz9nXIYxFm5xsdZ9VpkuCU1wBO3Bf0BeTZ6
	 wXXf0LmN4uBGjqd3axVPusjbvnGf+omCSFlBbvxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Ralf Lici <ralf@mandelbit.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1125/1193] net/mlx5e: advertise MACsec offload only when supported
Date: Wed, 30 Sep 2026 17:30:09 +0200
Message-ID: <20260930152459.233417326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1727,6 +1727,8 @@ void mlx5e_macsec_build_netdev(struct ml
 	mlx5_core_dbg(priv->mdev, "mlx5e: MACsec acceleration enabled\n");
 	netdev->macsec_ops = &macsec_offload_ops;
 	netdev->features |= NETIF_F_HW_MACSEC;
+	netdev->hw_features |= NETIF_F_HW_MACSEC;
+	netdev->vlan_features |= NETIF_F_HW_MACSEC;
 	netif_keep_dst(netdev);
 }
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5135,7 +5135,6 @@ static void mlx5e_build_nic_netdev(struc
 
 	netdev->vlan_features    |= NETIF_F_SG;
 	netdev->vlan_features    |= NETIF_F_HW_CSUM;
-	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
 	netdev->vlan_features    |= NETIF_F_GRO;
 	netdev->vlan_features    |= NETIF_F_TSO;
 	netdev->vlan_features    |= NETIF_F_TSO6;


