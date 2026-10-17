Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9497717BED0;
	Sat, 17 Oct 2026 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253328; cv=none; b=EKf+cFvemFzgH5phLwhUGdl768J20e+A8M7gQzDn6jZ6V4RnuYDQmrUGGELZVftnrQjQrSixgDf2AcvZQOVOH4Hrz6OMIerMd/YcCjP6Jpn6XrQzSwMbjMRCJuCbbACcx3gUyiZHYBa/e93zE4GCOB+I/gK0IdSZGtEUATJba6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253328; c=relaxed/simple;
	bh=EsRckO/23/fm9k9wXaKRRCAZRDsCc4ONLQIDmnzDVQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOxTyk6VfRH6rLlTzegJZBLjiHMOFOhy0+oFHR8vyVjWy5mhmzK5W1rQCNLajVltkSL/5ssz0Vl1icoBhZ9bmG2Jf3msvQHZG0ZWZ2UUl5Z5ZGNqG/GGa2HQyzhnKvsG/hxJH6U0k99gdd9Ybq9ka1nb3h0X/xocvLZa1KFJDa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrubGx8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrubGx8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED291F000C4;
	Sat, 17 Oct 2026 16:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253327;
	bh=bUS/Xi1CCS/CEVERx1o1ec7RJTcu3I1tyn4o2ciMZhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrubGx8/N9amVnLxVgET8OoSUn65qiRnQY7cFvQBfCu48y2LCdQef9Akl1H7RMv4R
	 k2fqrUzD0Tpsb+W2DSMwnoMp6npg3/pXu8E8xel5w5+amWYJURF/sA6XUjz8NQw+/8
	 RJukTvcipNRDMYYe8oltNuJnnxlZjmrhFIsdPaBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Mahendran P <quic_mahep@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/869] wifi: ath12k: Fix memory leak due to multiple rx_stats allocation
Date: Sat, 17 Oct 2026 17:48:44 +0200
Message-ID: <20261017160039.157111013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3a7fb0e490fa3..6a42c63307c8a 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4481,10 +4481,13 @@ static int ath12k_mac_station_add(struct ath12k *ar,
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
2.53.0



