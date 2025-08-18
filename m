Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C1721FF3B;
	Mon, 18 Aug 2025 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525615; cv=none; b=n8+VOZk5cumByF0WgeQzJwOjtotonlLgggEwHLgz6R92sSzi0K6ZF8ZUKzdAP4FfXgrEM+BDrH1BDfB3gSdDL+LAZW+tnpZiYk4B+22zXpGVWbk5qsA3I1lKKUVIlcFimAuxSonI9APQBSi33e++mqOwsFtNeVmyJO4bEiLIQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525615; c=relaxed/simple;
	bh=eTk6Gs/nZL57WyJNaacvQ4q9KsLHq6PhQirwkpsun3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erp8xmk5xjVw0xYCvSX/fA4458UiNuLht/UDp+xBBnVc7NXmTKZT3JYlRjCx50jD4oyqSUsuTjtsE0YN2mHSLm3WqgU3RK71HUGqDZKQM2VqO18cgzpQ4AWY92pwtuMrBnXJQPkOQ0CGKrP2vQspZxdCkKS3OP5Lp3lIP/rmfcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5MTU/z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5MTU/z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1876EC4CEEB;
	Mon, 18 Aug 2025 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525614;
	bh=eTk6Gs/nZL57WyJNaacvQ4q9KsLHq6PhQirwkpsun3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5MTU/z4eYmHM3vhLHb0i46N3QFATl1ZXIPDnUtdKcaO1UMEsbjSODnM5HGAmxmAf
	 I8Q7LIDM9ekgko3alX8F8iuy2Dhkkw7CsybX/qXg7xeSLmds5eiQokN2hOeTcCvK3g
	 9cYYnddQJgjtC2HpzEKmeu3cIJww9B6GBrDbUar0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 316/570] wifi: ath12k: Decrement TID on RX peer frag setup error handling
Date: Mon, 18 Aug 2025 14:45:03 +0200
Message-ID: <20250818124518.038980643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>

[ Upstream commit 7c0884fcd2ddde0544d2e77f297ae461e1f53f58 ]

Currently, TID is not decremented before peer cleanup, during error
handling path of ath12k_dp_rx_peer_frag_setup(). This could lead to
out-of-bounds access in peer->rx_tid[].

Hence, add a decrement operation for TID, before peer cleanup to
ensures proper cleanup and prevents out-of-bounds access issues when
the RX peer frag setup fails.

Found during code review. Compile tested only.

Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250526034713.712592-1-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index dd26ed8d7d96..12e35d5a744e 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -84,6 +84,7 @@ int ath12k_dp_peer_setup(struct ath12k *ar, int vdev_id, const u8 *addr)
 	ret = ath12k_dp_rx_peer_frag_setup(ar, addr, vdev_id);
 	if (ret) {
 		ath12k_warn(ab, "failed to setup rx defrag context\n");
+		tid--;
 		goto peer_clean;
 	}
 
-- 
2.39.5



