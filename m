Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7EF2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E99FC433D2;
	Tue,  7 Feb 2023 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775396;
	bh=k5IRJoPCdDvC9nVT8BVYa6KupsP9zhjCginJqZKWups=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bH6lceAICUmI5rhOeRjLspcStLcKrcNWK3Adna87Qh6qXXzUBCNFcztxrKwgGNjoc
	 hEmgdDiqkRfUFUIFBDjvuIdJJrZ6JWDX6YsvfTINviIK4ToM7JnR61HVmmk1Tdi/Jf
	 JoH/50ZD1vJGytK/bzGcr36CVZsmK/SYxERGvuO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianhao Zhao <tizhao@redhat.com>,
	=?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/120] sfc: correctly advertise tunneled IPv6 segmentation
Date: Tue,  7 Feb 2023 13:56:38 +0100
Message-Id: <20230207125619.944883455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit ffffd2454a7a1bc9f7242b12c4cc0b05c12692b4 ]

Recent sfc NICs are TSO capable for some tunnel protocols. However, it
was not working properly because the feature was not advertised in
hw_enc_features, but in hw_features only.

Setting up a GENEVE tunnel and using iperf3 to send IPv4 and IPv6 traffic
to the tunnel show, with tcpdump, that the IPv4 packets still had ~64k
size but the IPv6 ones had only ~1500 bytes (they had been segmented by
software, not offloaded). With this patch segmentation is offloaded as
expected and the traffic is correctly received at the other end.

Fixes: 24b2c3751aa3 ("sfc: advertise encapsulated offloads on EF10")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20230125143513.25841-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 43ef4f529028..b6243f03e953 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1005,8 +1005,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	/* Determine netdevice features */
 	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
 		net_dev->features |= NETIF_F_TSO6;
+		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
+			net_dev->hw_enc_features |= NETIF_F_TSO6;
+	}
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
-- 
2.39.0



