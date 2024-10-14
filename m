Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E959A1C82E2;
	Mon, 14 Oct 2024 15:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918940; cv=none; b=XB5vhbsxTfw3942gaJuUPXk3LsccSZ5LbKx0Xg0g89Lx/d4D67q8fA8rFf8II02yd24GMp7TjfvAbiQqZ3EVP5IMtKk4aS86SFbK6WSuUlNsaPzydy0ufyt5CTSsQsJ1MBD/UOcWiAYTk0Xs1n3EPV1xXEKmonqZvnTeqgNvO1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918940; c=relaxed/simple;
	bh=aQQtfK0IbQ0wyG+bbf2XkD3bEYCPMkdL2kk/x4TKM5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oiha9SqUmcvnqJAW0A8hn4qrrt6Th7W8G5Bt4EZme781fGsFImFUW2Hjr8lDVGZv0xZ/g+lHhn8D74Ez3r6IHXKlekjHu71IySx/jZpf6l6Zu2PjGiP6wSCqhNNIS4UIzkxCmdNvuJe4m0eeLi3UecJFiE0vcjlST6szLQQLJkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cY+kTIAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cY+kTIAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3E1C4CEC3;
	Mon, 14 Oct 2024 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918939;
	bh=aQQtfK0IbQ0wyG+bbf2XkD3bEYCPMkdL2kk/x4TKM5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cY+kTIABebwO+U3PFVffAcbJRSVlx8fznMsG2sa45CTaNDE7uIUqEYtxcldNORtYI
	 G5M2ecRTIIZTTwXwoIxdmnSfHrlNShqPjULp11dj1C8ue+uNHlsMwbr2gp8rdjLBXx
	 AjSTl+ZHnlXPIfFSkAjBYBVEvzp6ZfxqblaxjTCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 435/798] wifi: ath11k: fix array out-of-bound access in SoC stats
Date: Mon, 14 Oct 2024 16:16:29 +0200
Message-ID: <20241014141235.053480052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3746f9c956969..73f299f65e2eb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2699,7 +2699,7 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 		if (unlikely(push_reason !=
 			     HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION)) {
 			dev_kfree_skb_any(msdu);
-			ab->soc_stats.hal_reo_error[dp->reo_dst_ring[ring_id].ring_id]++;
+			ab->soc_stats.hal_reo_error[ring_id]++;
 			continue;
 		}
 
-- 
2.43.0



