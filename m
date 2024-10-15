Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F0F1C07FF;
	Tue, 15 Oct 2024 13:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997954; cv=none; b=hwlK96L3nofUcKXj/09pG9BeF2mXdreM0BUdWoWNcBCBb7ndh78xJSZnAihLUqvrpQ4Q+bAjQNHaBltNuHc2tSD2Avbf/LgyOwjxRUPSIqtkSAy9ZtxIqUl6bzDCn4hIdC4SD+fFaHRWEUDCmh91w/Je8VZFkBqPwsqXcwIYUmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997954; c=relaxed/simple;
	bh=fiJRlgMaXidg5nH05EcUO4tD0f2I1iuOlReLSvtdvvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmXqj2Lf+hDUpAyZlvbeP3iqa3dSmO/ptTHp1E9OfZuqNGXi2jG0xrmh1CXXBvUaPifqd7+jrNzVXFlLpE4peknVjACiOz7NPP+I8YkRJ6sqhB0lWUxp4QCvr3saI4+BdAYixvwZ3iRt/GM8sZTClVChefr9RhDlJ3CHFzOKQjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onrT4mFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onrT4mFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709A2C4CEC6;
	Tue, 15 Oct 2024 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997953;
	bh=fiJRlgMaXidg5nH05EcUO4tD0f2I1iuOlReLSvtdvvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onrT4mFXVvkhnLG9ZGnU4PLZ6LBO2fJz2dN2ujPpccqQOeGWBIfsUvBCcL2MliOo4
	 3LkDVXahMFnEM+yM3KB9nbheuE1gdQijnuT0FeoknZoq7PA8ThxDbYupeCMMDg/v/G
	 OZKNNCYugmdOL7YJJIGlZRqYdGWK4YMu8sNHW59A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/518] wifi: ath11k: fix array out-of-bound access in SoC stats
Date: Tue, 15 Oct 2024 14:43:29 +0200
Message-ID: <20241015123928.758727089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit 69f253e46af98af17e3efa3e5dfa72fcb7d1983d ]

Currently, the ath11k_soc_dp_stats::hal_reo_error array is defined with a
maximum size of DP_REO_DST_RING_MAX. However, the ath11k_dp_process_rx()
function access ath11k_soc_dp_stats::hal_reo_error using the REO
destination SRNG ring ID, which is incorrect. SRNG ring ID differ from
normal ring ID, and this usage leads to out-of-bounds array access. To fix
this issue, modify ath11k_dp_process_rx() to use the normal ring ID
directly instead of the SRNG ring ID to avoid out-of-bounds array access.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240704070811.4186543-3-quic_periyasa@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 6c4b84282e44c..720c94806e1a1 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2621,7 +2621,7 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 		if (push_reason !=
 		    HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION) {
 			dev_kfree_skb_any(msdu);
-			ab->soc_stats.hal_reo_error[dp->reo_dst_ring[ring_id].ring_id]++;
+			ab->soc_stats.hal_reo_error[ring_id]++;
 			continue;
 		}
 
-- 
2.43.0



