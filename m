Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A0B1DE4F8;
	Tue,  8 Oct 2024 12:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389793; cv=none; b=s2FfqwbO5FTywg3D7IHxwACb2KSyDOgIR2HQrpSsVXfNj2ppMhG5SLjHvWB1xQr7QglwycUOWpm5SUTFtzc5K9pe8ekkY2+dIIRbgmdmWNlVhZwLhOMryU3crDrGOZHTkoXxR4fUcsJtwDfQoThVbcjH454vWPI+D8wyg3glD5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389793; c=relaxed/simple;
	bh=Eta6ZhZfAe0P1E1D/Ve6YeDnUZn6VsYsNcDL6LapRNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8IDtsuv2xzCOnNOvYYzaLGikxHgIfxAZcZX9ar26rxSelCWVbEjnOGqbJBsPvU/S6pcSzBr91d8l6hLYJrfNew5WQiTmkUxMAELQjVOmMXAJUQ0rd0T3w7RDQx1vk9E6uyQ8r2Jx17obhY3Ox94K6jNoHD3iOfHFnihfW2e8aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRI6KJ/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRI6KJ/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1204C4CECE;
	Tue,  8 Oct 2024 12:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389793;
	bh=Eta6ZhZfAe0P1E1D/Ve6YeDnUZn6VsYsNcDL6LapRNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRI6KJ/BRXvv3s9AbWPU68kXIGxh+5z1kGZmnn9Qo//csieHVyoBM8i3y0UPR+15/
	 /aA7vqqtgf5WzPV45hs1pFpd/nte8BgePXqzUFVJrBxEPBltsuE2vxceNKB+ppCa7O
	 +aSG8CPVtknfw+zh+cGnRXilPj04aKvPYownjFK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 098/482] wifi: ath12k: fix array out-of-bound access in SoC stats
Date: Tue,  8 Oct 2024 14:02:41 +0200
Message-ID: <20241008115652.166624990@linuxfoundation.org>
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
index 3cdc4c51d6dfe..f8767496fa543 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2702,7 +2702,7 @@ int ath12k_dp_rx_process(struct ath12k_base *ab, int ring_id,
 		if (push_reason !=
 		    HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION) {
 			dev_kfree_skb_any(msdu);
-			ab->soc_stats.hal_reo_error[dp->reo_dst_ring[ring_id].ring_id]++;
+			ab->soc_stats.hal_reo_error[ring_id]++;
 			continue;
 		}
 
-- 
2.43.0



