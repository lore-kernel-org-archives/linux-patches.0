Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A53951AFF5;
	Wed, 30 Sep 2026 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793612; cv=none; b=rSI11M/TPIgv3TH1xZtdxUaf1nb+Xs0/rpD4xtzUSbLK4QWmuoH8EOYWpSZXw40Mli6TDL29QjERklM06sND05TBD5jO68sk1Hr8gkB8Uq5ZVeUITipmRiygeLB2RPyvy5OzTxDN71oQQmZX6pC6fYMaX2wl55zthC44CnFSiD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793612; c=relaxed/simple;
	bh=87Zq0BD+UAx1dMWBBGhydSBB2SRHZARnK2lA93MT6uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj6gHLm3tPFPoHil/KWZqGQbpn5kNmsAaMedGU5dhK+qbyBioBmAIcd+XUsi+GKCJ9IVcMGre0SQ3nXncTrgRsdyjHKX013qP2TwOB1p117vRb+OQw78isIPzzNliB5A1LfUpHQSKCxxdnpUcg8hN8xymGcBE2ReRDlDTfHIlFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odjzB46J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odjzB46J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852F71F00899;
	Wed, 30 Sep 2026 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793611;
	bh=hdCV45clKsKxShETo5+B7DSOBK6EQF0lBj5HCzLo8LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odjzB46Jtf/h7GVX3qZUx3H+rB+ejlAba29XbNYo9G/OKKJQuqnGcmFAEtzY6EnSK
	 Ij/EUrtc9q0v3D12Gg52XfAawQO2PFfnCghj5UeIgSth5MbqSzrL4V1BdsBzdhJFa7
	 3NbYXL+5hXsTsB5ccllLWFvJUpHoO3iq310c/1qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Ralf Lici <ralf@mandelbit.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 271/395] net/mlx5e: advertise MACsec offload only when supported
Date: Wed, 30 Sep 2026 17:28:53 +0200
Message-ID: <20260930152346.538521897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5685,7 +5685,6 @@ static void mlx5e_build_nic_netdev(struc
 
 	netdev->vlan_features    |= NETIF_F_SG;
 	netdev->vlan_features    |= NETIF_F_HW_CSUM;
-	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
 	netdev->vlan_features    |= NETIF_F_GRO;
 	netdev->vlan_features    |= NETIF_F_TSO;
 	netdev->vlan_features    |= NETIF_F_TSO6;


