Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C95E1DF251;
	Tue,  8 Oct 2024 12:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389797; cv=none; b=WNr1nXSGytOmben8S/Gk0FcFKvBhFElb5t3cEHpYwi4Ka/tZQQYOVKg97z6No/n1xFE4UvjpKOTDXER9jEfENfQrH25oB14aDMWM2r9djWt+9JeJDaamMLzbpzUG1cGZzuj3JJrgRX3uwP5pj5qQhgB+4MU4T23DfFK3H+SscWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389797; c=relaxed/simple;
	bh=APOlS0HOEBcDo2UR7IgB2/MGLBNAP4bPXpgdaEOpEpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTWtNsUBQQ/WeVAVdcDf6i+DTMtmzOUHIwBpNIQkseDqYKCXyDk8bG9fqqJVmjEtlBs7HJxlU7yRowhizdISDIBDLiRsH+5cv4OVHWTWqxxSnDQazqDMmcqrta+/NIfdmL2pjC4C2iih5BBk6nWCEqyqkUYI2n47WX5WNOazM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+5ExkgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+5ExkgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E100C4CEC7;
	Tue,  8 Oct 2024 12:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389796;
	bh=APOlS0HOEBcDo2UR7IgB2/MGLBNAP4bPXpgdaEOpEpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+5ExkgL7v+1jwcmNGVk1igAWvQ2j2GYJly0bjdEKaMnKz7aj7HEJUOvhpwhTv+WO
	 v2KJXs2OBwZzxLGEw3Era//a5WH2Qjma2gmEvRPKbXX0JZSmDzwk5ZKYWgyqGqDlQY
	 zPQQPI+2YINB41q7zmjW8S3HDGE+FcBip2PPFhqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 099/482] wifi: ath11k: fix array out-of-bound access in SoC stats
Date: Tue,  8 Oct 2024 14:02:42 +0200
Message-ID: <20241008115652.205702448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index aabde24d87632..88c7a7289d06e 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2697,7 +2697,7 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 		if (unlikely(push_reason !=
 			     HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION)) {
 			dev_kfree_skb_any(msdu);
-			ab->soc_stats.hal_reo_error[dp->reo_dst_ring[ring_id].ring_id]++;
+			ab->soc_stats.hal_reo_error[ring_id]++;
 			continue;
 		}
 
-- 
2.43.0



