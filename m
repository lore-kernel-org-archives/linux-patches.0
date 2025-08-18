Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457343074AE;
	Mon, 18 Aug 2025 13:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522173; cv=none; b=O8zR2ocyIZ7SDJzgJf4Uo/GoeXP7WKwaHpN5Ci04EdfuElYaQiU3aYNVtmJLVLtpY7bGLlNRXaPTtBYYbjuKU/BDaT2d5Xq4q9bMyUe9bO323ryHeVmKwGPt7O1moYLwQo/HQl6RkYFlzYn0KsKa6qoGZkDB41ZneILGNfbGYvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522173; c=relaxed/simple;
	bh=HWFYFjO2lBCaOeVG+J/R6ofmHHPGZnw5fclJrEdLvaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBEI4W3yQwM1ONS64dWpLuwfllYEjUz335fy70G2TIiA0Qof3RtKoraBmrQAa66iNi26k5TG5/A6Tv3XdiMY8N10EvHdYekPUAmy2JlyqKQzUpyv94hSyjDNKXPcxPmcXkFvhNZ7mVu1va9gt4fUOsi6BgsR57SOa0XmlnfXCgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7Nv8U1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7Nv8U1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C119DC4CEEB;
	Mon, 18 Aug 2025 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522173;
	bh=HWFYFjO2lBCaOeVG+J/R6ofmHHPGZnw5fclJrEdLvaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7Nv8U1FBe9bWqg1N0tMHHNgZ6byqmxeqqVfr3ndu91l/QidWWqzJBg6ek+Da7ejh
	 HMbfCBza/oK04zLxj/K91nft8/zTgHuEIpLoFNxLznK8KnX15jDt1OxbYstz947S+H
	 NwQnhG0Hj3OX0eRVaZ9xq75mtdkX1NfkMrLBM9q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/444] wifi: ath12k: Decrement TID on RX peer frag setup error handling
Date: Mon, 18 Aug 2025 14:44:23 +0200
Message-ID: <20250818124457.718932761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index cfb17f16b081..3244f7c3ca4f 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -79,6 +79,7 @@ int ath12k_dp_peer_setup(struct ath12k *ar, int vdev_id, const u8 *addr)
 	ret = ath12k_dp_rx_peer_frag_setup(ar, addr, vdev_id);
 	if (ret) {
 		ath12k_warn(ab, "failed to setup rx defrag context\n");
+		tid--;
 		goto peer_clean;
 	}
 
-- 
2.39.5



