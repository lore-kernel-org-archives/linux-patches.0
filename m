Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00B71DE88F;
	Tue,  8 Oct 2024 13:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393197; cv=none; b=dy9Eosck4c2j+otwtROX+WZBmwENOFlacuhHbqKWvXhTamapa6wmO/pBB83eCKMbezWipoy8JlUo5JiM7wqsVl2WvL/USILTIh16IDUwzbLgzrXNLMmon+SmuEXSlsuOnBm6kK6UWKM9yDUmV/W7s+ghWl/U2a0EoZxVlxQyTvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393197; c=relaxed/simple;
	bh=FmQ8/0QGFIXAaAtsnGymYGky+z4Akv870a+h5VyS/PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ5Zze2LtSOc43uG/Dzmtf0WLahDY1kh6UjW/MG3fpoa+QlDhRty8xkcdcNY3nhLx7zJjMBj7OHwvH/HNH0Y1La3GYgaElpmTbOvi457NymBurpBnZ3zqXpu+RlgDouMN+PXkywiI1fexToctrKOtoIBGxIAzfYujraHVSRtK2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2aKO+qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2aKO+qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA38C4CEC7;
	Tue,  8 Oct 2024 13:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393196;
	bh=FmQ8/0QGFIXAaAtsnGymYGky+z4Akv870a+h5VyS/PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2aKO+qpfN94ZJNznRc53YnodT9ti101M/k1BbOo2svyyKFOz4uNVcr76AHIG+L88
	 C5JGS1bgmvhnfbfRJ85PTRwXrRVr99xSKHsWHgZZXCNuU6Nj/1V4sSFkPWgLzDL3ql
	 i15mS41lyqeXosGMOFnB8r2dMU0dsP7JroTCanwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/386] wifi: ath12k: fix array out-of-bound access in SoC stats
Date: Tue,  8 Oct 2024 14:05:26 +0200
Message-ID: <20241008115632.647917301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit e106b7ad13c1d246adaa57df73edb8f8b8acb240 ]

Currently, the ath12k_soc_dp_stats::hal_reo_error array is defined with a
maximum size of DP_REO_DST_RING_MAX. However, the ath12k_dp_rx_process()
function access ath12k_soc_dp_stats::hal_reo_error using the REO
destination SRNG ring ID, which is incorrect. SRNG ring ID differ from
normal ring ID, and this usage leads to out-of-bounds array access. To
fix this issue, modify ath12k_dp_rx_process() to use the normal ring ID
directly instead of the SRNG ring ID to avoid out-of-bounds array access.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240704070811.4186543-2-quic_periyasa@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index d9bc07844fb71..70ad035acac75 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2670,7 +2670,7 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int ring_id,
 		if (push_reason !=
 		    HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION) {
 			dev_kfree_skb_any(msdu);
-			ab->soc_stats.hal_reo_error[dp->reo_dst_ring[ring_id].ring_id]++;
+			ab->soc_stats.hal_reo_error[ring_id]++;
 			continue;
 		}
 
-- 
2.43.0



