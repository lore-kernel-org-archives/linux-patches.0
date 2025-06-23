Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2DC19CC11;
	Mon, 23 Jun 2025 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714647; cv=none; b=uB8KCHE78gtQd2EczWDx+PlPWmr4fdgDm2OlmsJgFR4qzNf5el6Q7mft/5RnOvr51OPLrb+UeWdOZo78GEz0mqvztghLerkmrexhnVvFDKHVWa17PGFT5XxUypQtd/KOkQNR+SNk1d1gWMlt2KFfM8CwGlOCyxyZdHTxZfGgiNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714647; c=relaxed/simple;
	bh=cpbNPYuJFq6rJMXYLNHt/u4YJkDc4mRLvTplvfL+s6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPBwrGPkRFZINTDfZa/bcVujrEKpaCL/8thkNNonpHtJ3120a/vng0+RkN1GoTqFwg0JK5X7wXrQH0qFWyxw9OLvzNOZFqJb0hC9CHVrekLeZNlRFxm1Z3jcvwD5uYACFbVaXO8UPDG/W9YHB5xAL3szYrqqqS0oxnJcdMzDEds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXyYvVZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXyYvVZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C82C4CEEA;
	Mon, 23 Jun 2025 21:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714647;
	bh=cpbNPYuJFq6rJMXYLNHt/u4YJkDc4mRLvTplvfL+s6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXyYvVZ/Y9Z+w42xNg1E+ahn6nw+oJpLoAQuCkucYlzNyg5qP4g0w19M2OXdp8JbR
	 mzaERIgwEw0GeBJOqVL5Zn6KP+0bTcsapSa9wQS/66j9Jf3TM0/x0rsON11qU7kHV3
	 S6rM4P+mtHk7ssPy8QodHlunylk1H5kARzEcln4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 398/592] wifi: ath12k: using msdu end descriptor to check for rx multicast packets
Date: Mon, 23 Jun 2025 15:05:56 +0200
Message-ID: <20250623130709.910486001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit cb7433cc5cd4d07175dbc41f5a19966e9fae48be ]

Currently, the RX multicast broadcast packet check is performed using
bit 15 from the info6 field of the MPDU start descriptor. This check
can also be done using bit 9 from the info5 field of the MSDU end
descriptor. However, in some scenarios multicast bit is not set when
fetched from MPDU start descriptor.
Therefore, checking the RX multicast broadcast packet from the MSDU
end descriptor is more reliable as it is per MSDU.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250411061523.859387-2-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hal.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index 49b4c5648aed3..faf74b5459410 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -449,8 +449,8 @@ static u8 *ath12k_hw_qcn9274_rx_desc_mpdu_start_addr2(struct hal_rx_desc *desc)
 
 static bool ath12k_hw_qcn9274_rx_desc_is_da_mcbc(struct hal_rx_desc *desc)
 {
-	return __le32_to_cpu(desc->u.qcn9274.mpdu_start.info6) &
-	       RX_MPDU_START_INFO6_MCAST_BCAST;
+	return __le16_to_cpu(desc->u.qcn9274.msdu_end.info5) &
+	       RX_MSDU_END_INFO5_DA_IS_MCBC;
 }
 
 static void ath12k_hw_qcn9274_rx_desc_get_dot11_hdr(struct hal_rx_desc *desc,
@@ -902,8 +902,8 @@ static u8 *ath12k_hw_qcn9274_compact_rx_desc_mpdu_start_addr2(struct hal_rx_desc
 
 static bool ath12k_hw_qcn9274_compact_rx_desc_is_da_mcbc(struct hal_rx_desc *desc)
 {
-	return __le32_to_cpu(desc->u.qcn9274_compact.mpdu_start.info6) &
-	       RX_MPDU_START_INFO6_MCAST_BCAST;
+	return __le16_to_cpu(desc->u.qcn9274_compact.msdu_end.info5) &
+	       RX_MSDU_END_INFO5_DA_IS_MCBC;
 }
 
 static void ath12k_hw_qcn9274_compact_rx_desc_get_dot11_hdr(struct hal_rx_desc *desc,
-- 
2.39.5



