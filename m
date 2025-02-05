Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42111519AA;
	Wed,  5 Feb 2025 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764564; cv=none; b=b2FjCIkLrIsBEpQBG2vD7zb30On40zJocxU1PY6cHVoPbVcALlfqA+PQhpFjERveuOPPWIdpWsQSw1yDhNsZ3mhBdUFzclm6J0V9K3qijyRdwM+Eb5asRo7BhrRZxOUkjNm8kbPzLov3SiKN7Ya7kHoheS8yKK1UYy4M9HkPrsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764564; c=relaxed/simple;
	bh=t4dYbrtxt31LTAvDg9i1lCOmbkcQn42o1BJbaV0otLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flHhbdDUx5DvsK90LIMFs3sJ2G5xHlj6att/TWnxHnAQN3s/hXs5UXFAEkQFux3gHmT9MS42B0+xFFtNoMwAYku0902pIHqk2XKoHBKUeNMYPUzjmb9kroqykEySrhxJKw7ziKeNQPcU6lTz1fI1OUKl+/9BBYgeLaDPvUobzsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIJ83WZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIJ83WZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1097DC4CED1;
	Wed,  5 Feb 2025 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764564;
	bh=t4dYbrtxt31LTAvDg9i1lCOmbkcQn42o1BJbaV0otLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIJ83WZ+c1NSY9Av1d/VXQOqtXAEJM1fH+feIhKSbLvTKbYgATF+OfqEtKlC6F9f0
	 mrvqNUmkQrdSd728otEDackn6jBxxU75CIvGPWVTxDYnCZvqWMx3MtpVfbvZ+YOzPh
	 8+ignU7gjTpm90oUOMO59JujERqLkF11G5Nd3Eh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Santhosh Ramesh <quic_santrame@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/590] wifi: ath12k: fix tx power, max reg power update to firmware
Date: Wed,  5 Feb 2025 14:38:13 +0100
Message-ID: <20250205134500.549883981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathishkumar Muruganandam <quic_murugana@quicinc.com>

[ Upstream commit 3540bba855b4b422e8b977d11aa8173ccb4f089d ]

Currently, when the vdev start WMI cmd is sent from host, vdev related
parameters such as max_reg_power, max_power, and max_antenna_gain are
multiplied by 2 before being sent to the firmware. This is incorrect
because the firmware uses 1 dBm steps for power calculations.

This leads to incorrect power values being used in the firmware and
radio, potentially causing incorrect behavior.

Fix the update of max_reg_power, max_power, and max_antenna_gain values
in the ath12k_mac_vdev_start_restart function, ensuring accurate
power settings in the firmware by sending these values as-is,
without multiplication.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00214-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Sathishkumar Muruganandam <quic_murugana@quicinc.com>
Signed-off-by: Santhosh Ramesh <quic_santrame@quicinc.com>
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Acked-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240909073049.3423035-1-quic_santrame@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 8946141aa0dce..fbf5d57283576 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7220,9 +7220,9 @@ ath12k_mac_vdev_start_restart(struct ath12k_vif *arvif,
 							chandef->chan->band,
 							arvif->vif->type);
 	arg.min_power = 0;
-	arg.max_power = chandef->chan->max_power * 2;
-	arg.max_reg_power = chandef->chan->max_reg_power * 2;
-	arg.max_antenna_gain = chandef->chan->max_antenna_gain * 2;
+	arg.max_power = chandef->chan->max_power;
+	arg.max_reg_power = chandef->chan->max_reg_power;
+	arg.max_antenna_gain = chandef->chan->max_antenna_gain;
 
 	arg.pref_tx_streams = ar->num_tx_chains;
 	arg.pref_rx_streams = ar->num_rx_chains;
-- 
2.39.5



