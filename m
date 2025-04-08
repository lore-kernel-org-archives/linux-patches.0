Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F594265CC8;
	Tue,  8 Apr 2025 11:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110485; cv=none; b=nqEQm4cqlVttzn6ddkTzIwSmnVkZ8cbdOo5I/opRd/G56P1z7Ak4IxQcweQcxE3m6SwD17aJ1w25F5CqsZ3XOGz74DSEn4LVhWrG3znpu9de/lKQf9AsMUXllvnhyZVIxEyHUJBqHDEH71+8Sc12ZtCCaSMYoI4bZPRbau6bAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110485; c=relaxed/simple;
	bh=g/hFzIXuMryhcZST0ykU8dk1zmVibns0d1LwjU9S1vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErYy41GFf7iX1EbcsiOkZwlN0YoxLCK+2JcO36I3WNQ7d6BS28Jw+uNAxABIfPTJ4BL1CcxdYxok/iCQ2gOfbosEH0xaqsZ0Ssrwa5n8ApCkST+8zegU3pmP9pXFZibO7/pxPN6QF8bI3Q6VNOCAGnhtq8OdjDVITUq7N3h16nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnPbMxbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnPbMxbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4784C4CEE5;
	Tue,  8 Apr 2025 11:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110485;
	bh=g/hFzIXuMryhcZST0ykU8dk1zmVibns0d1LwjU9S1vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnPbMxbKQr6zPRXfCAzNFQtRGXTXad2ekc+eOGqmT6TXneiHTLef0ubjpKPJcnPZ6
	 aPCedIC+5+CpoIyDM/bKza6G+TylT9jwAdKqO60bsqc9TXGDV9xWo0BVX7Q4SDAaUV
	 EvoffI2XmSrx85MMaFFGcuzYVFsmStoS1ovg6IUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <quic_ramess@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 079/731] wifi: ath12k: Fix pdev lookup in WBM error processing
Date: Tue,  8 Apr 2025 12:39:36 +0200
Message-ID: <20250408104916.108511620@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rameshkumar Sundaram <quic_ramess@quicinc.com>

[ Upstream commit 4e635b81db9d69bbb836afae8cb402978ff966a4 ]

Currently in ath12k_dp_rx_process_wbm_err(), when processing packets
received on the WBM error ring, pdev validation is done based upon the
hw_link_id. But hw_link_id corresponds to link id of a given partner pdev
in a MLO hardware group, and is not the correct index to use to lookup a
pdev in an SoC(ab). As a result, pdev validation fails, and the reaped
packets are dropped instead of being processed.

The correct index to use is the pdev_id, which is already derived in the
function. So update the logic to validate the pdev based upon the pdev_id
instead of the hw_link_id. This matches the logic used in other Rx ring
processing functions.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 1a73acb5fba4 ("wifi: ath12k: move to HW link id based receive handling")
Signed-off-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
Link: https://patch.msgid.link/20250102043048.2596791-1-quic_ramess@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index dad35bfd83f62..68d609f2ac60e 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -4032,7 +4032,7 @@ int ath12k_dp_rx_process_wbm_err(struct ath12k_base *ab,
 						      hw_links[hw_link_id].pdev_idx);
 		ar = partner_ab->pdevs[pdev_id].ar;
 
-		if (!ar || !rcu_dereference(ar->ab->pdevs_active[hw_link_id])) {
+		if (!ar || !rcu_dereference(ar->ab->pdevs_active[pdev_id])) {
 			dev_kfree_skb_any(msdu);
 			continue;
 		}
-- 
2.39.5



