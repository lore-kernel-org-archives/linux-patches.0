Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E9B21D3DD;
	Mon, 23 Jun 2025 21:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714507; cv=none; b=CbyZd+8hYWBmonREurOOHgH9VZrfI2Ydi2a/tKnZdrVS+kasK7dZ7VgWwp9bMDquoEiUtvFAPL9Ca9AWxwcQJsiqXZGivIpoq56XCXMLzpYMEfGNvdjOCGIdmRnAI9lRvgP6Qx59CNlNpc8sMz7DqA7zpgCxQd48f5bJbIcMTS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714507; c=relaxed/simple;
	bh=GVfZN3DzujjFZWlRk2Eok/VXNZewO+70ju66OmuBX58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+gTDGXvxL5XoVkNo73WAMYWzud9mEv1037YGph1GaCfSuRjTMF9F/9Q+kG7eJmnJjnC64bkJL1oeP0SldHD0rowKh4F2YLalr570jVH9hPOoZaZ28xMNrM/+DmCddrwKCIVmWDNDNrbG1XBa3hh4eOGABpkMCNdDSmqE43S8Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHVOYe8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHVOYe8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA2DC4CEEA;
	Mon, 23 Jun 2025 21:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714507;
	bh=GVfZN3DzujjFZWlRk2Eok/VXNZewO+70ju66OmuBX58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHVOYe8P7nLLAQxNfFihB/HZBVSKanYseFoA6LA3qM4IY48cqpG6mnlQ05GmtXDfF
	 49Qs5UJ/U4SlAZONIhwNBGVMI79ui5TI4zfRbiBaxp6mnOwgeyqVA0B6+3WcvGb3dG
	 CV/io7DZAei9D+3bsfVNnSslwO3zecpf57qNeFrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Mahendran P <quic_mahep@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 419/592] wifi: ath12k: Fix memory leak due to multiple rx_stats allocation
Date: Mon, 23 Jun 2025 15:06:17 +0200
Message-ID: <20250623130710.402442669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>

[ Upstream commit c426497fa2055c8005196922e7d29c41d7e0948a ]

rx_stats for each arsta is allocated when adding a station.
arsta->rx_stats will be freed when a station is removed.

Redundant allocations are occurring when the same station is added
multiple times. This causes ath12k_mac_station_add() to be called
multiple times, and rx_stats is allocated each time. As a result there
is memory leaks.

Prevent multiple allocations of rx_stats when ath12k_mac_station_add()
is called repeatedly by checking if rx_stats is already allocated
before allocating again. Allocate arsta->rx_stats if arsta->rx_stats
is NULL respectively.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
Signed-off-by: Muna Sinada <muna.sinada@oss.qualcomm.com>
Reviewed-by: Mahendran P <quic_mahep@quicinc.com>
Link: https://patch.msgid.link/20250326213538.2214194-1-muna.sinada@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 922901bab3e39..d1d3c9f34372d 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5560,10 +5560,13 @@ static int ath12k_mac_station_add(struct ath12k *ar,
 			    ar->max_num_stations);
 		goto exit;
 	}
-	arsta->rx_stats = kzalloc(sizeof(*arsta->rx_stats), GFP_KERNEL);
+
 	if (!arsta->rx_stats) {
-		ret = -ENOMEM;
-		goto dec_num_station;
+		arsta->rx_stats = kzalloc(sizeof(*arsta->rx_stats), GFP_KERNEL);
+		if (!arsta->rx_stats) {
+			ret = -ENOMEM;
+			goto dec_num_station;
+		}
 	}
 
 	peer_param.vdev_id = arvif->vdev_id;
-- 
2.39.5



