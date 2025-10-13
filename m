Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44B130F540;
	Mon, 13 Oct 2025 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369674; cv=none; b=iaj7bVF4391PLSInvyKBPl1Vk3UVlyloY7i9rpliCIrv+YROOpu3BQTq6x+TMKf5OAY3l25kIl6mwJYzYQ/LNAx77L3pX8XhGOrbC9R/ASgT5MdhNWBQrS2wwTJAr+RF879WtOeOHQCPrx+MnRlPQO7bNa1XF89BxW+QG/tTzf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369674; c=relaxed/simple;
	bh=YTg2LZFHG/8/Kj2LbIZZDOIbC7ODWi1UW6vtP3KD2Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YM9AECZLEPyn5LmeIAWrTyJFdTT8/Vw9ajwO+zG621/uQhEMI1WLIYuSEoSQX2v+x+FAJk+9MhCGuG4U7PZ4ntp+XjXyRyfMl7gZzIJPjPXvlT3SRtNbyTvGtSoJQZkuiOkNyEDy6R84cs6VVp+bKaWO/lKusMspC76R0tn9vEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2E22Eq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2E22Eq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A143C4CEFE;
	Mon, 13 Oct 2025 15:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369674;
	bh=YTg2LZFHG/8/Kj2LbIZZDOIbC7ODWi1UW6vtP3KD2Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2E22Eq+qErONmNyHtrSmVl6OIjut0h+rpDZtSUqS5B5vvWJXw/Y88B1g9kDscAWW
	 kujT+Yp27KPJcn0kaecsqkDY03YuGhxNtjBbgeTvr/Yaa5Vi+X37UAx8HYyjdI1WE4
	 1ktl7juB+erR0w4KbRjoTUUQ/sh5UUKKqx64/Bew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Ramu R <ramu.r@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 329/563] idpf: fix Rx descriptor ready check barrier in splitq
Date: Mon, 13 Oct 2025 16:43:10 +0200
Message-ID: <20251013144423.180269320@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit c20edbacc0295fd36f5f634b3421647ce3e08fd7 ]

No idea what the current barrier position was meant for. At that point,
nothing is read from the descriptor, only the pointer to the actual one
is fetched.
The correct barrier usage here is after the generation check, so that
only the first qword is read if the descriptor is not yet ready and we
need to stop polling. Debatable on coherent DMA as the Rx descriptor
size is <= cacheline size, but anyway, the current barrier position
only makes the codegen worse.

Fixes: 3a8845af66ed ("idpf: add RX splitq napi poll support")
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Ramu R <ramu.r@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index eaad52a83b04c..50f90ed3107ec 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3187,18 +3187,14 @@ static int idpf_rx_splitq_clean(struct idpf_rx_queue *rxq, int budget)
 		/* get the Rx desc from Rx queue based on 'next_to_clean' */
 		rx_desc = &rxq->rx[ntc].flex_adv_nic_3_wb;
 
-		/* This memory barrier is needed to keep us from reading
-		 * any other fields out of the rx_desc
-		 */
-		dma_rmb();
-
 		/* if the descriptor isn't done, no work yet to do */
 		gen_id = le16_get_bits(rx_desc->pktlen_gen_bufq_id,
 				       VIRTCHNL2_RX_FLEX_DESC_ADV_GEN_M);
-
 		if (idpf_queue_has(GEN_CHK, rxq) != gen_id)
 			break;
 
+		dma_rmb();
+
 		rxdid = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_RXDID_M,
 				  rx_desc->rxdid_ucast);
 		if (rxdid != VIRTCHNL2_RXDID_2_FLEX_SPLITQ) {
-- 
2.51.0



