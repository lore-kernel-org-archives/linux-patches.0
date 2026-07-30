Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D512E9EC7;
	Thu, 30 Jul 2026 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421799; cv=none; b=AFgCx40NnFVyPSVIy9DfRj3A4mpwQRnm7A/cAxRiWy+oAQq60+LTrrCICKDbHfzDTa9igEwMetSeQt8jdbY93jnorlS4qMBQwinT+iPaFA5nhnJfqwpl/B8UfFWpmsRNzjNLJORtPFvaPtne1XBZBnrYOQNfHeIvbxVqTqlKlvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421799; c=relaxed/simple;
	bh=OUHFzRTyEYeaHx1vPQxK/gaCoWEpnXbcDBL1nvI2tIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocTW+4srq+bNdOnxuSIo933nXS29wJkVSyFFT0L/7wgN6JCtHVGjAyoVyNqsFOk6WTeqA7+1+czpo+41RIEc84ldFHiORAAiWuuIHxDrXqC8SyIzGNB4Q02qcvc0TuaC+zBA4tRTEubj6z0G0uZKJiUDj+XMUYa1zAg1kiMcGC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1gEqinK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1gEqinK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914FC1F000E9;
	Thu, 30 Jul 2026 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421798;
	bh=tYFEK0ED1JkQnTtd6+P+fa2Vu+kBOc8eOxz3NTzCsNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1gEqinKyg6/t93hGoDhd1xB8VJT0jzpV69JwFvlMSLb9BeIaBKcNcKnFsxt6DBzs
	 Z6sVI81iE10PWt2P7o3GNC4oJlwIv+bO/s0G7x477Mb6vR26Tb//V5FJc4PfPW4MMj
	 r4/TgayS1DIFNhIbpLzyVwYvVhYfiFWaYUYf5/KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 179/744] wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()
Date: Thu, 30 Jul 2026 16:07:32 +0200
Message-ID: <20260730141448.091006191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Morgun <d.morgun@ispras.ru>

[ Upstream commit 7f11e70629650ff6ea140984e5ce188b775b2683 ]

When the first entry in msdu_details has a zero buffer address,
the code accesses msdu_details[i - 1] with i == 0, causing a
buffer underflow.

Fix similarly to ath12k_wifi7_hal_rx_msdu_list_get() by adding
a separate check for i == 0 before the main condition to prevent
the out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260530114252.42615-1-d.morgun@ispras.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 2a413e3a07a78c..c9f520c2a93583 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4565,6 +4565,9 @@ static void ath11k_hal_rx_msdu_list_get(struct ath11k *ar,
 	msdu_details = &msdu_link->msdu_link[0];
 
 	for (i = 0; i < HAL_RX_NUM_MSDU_DESC; i++) {
+		if (!i && FIELD_GET(BUFFER_ADDR_INFO0_ADDR,
+				    msdu_details[i].buf_addr_info.info0) == 0)
+			break;
 		if (FIELD_GET(BUFFER_ADDR_INFO0_ADDR,
 			      msdu_details[i].buf_addr_info.info0) == 0) {
 			msdu_desc_info = &msdu_details[i - 1].rx_msdu_info;
-- 
2.53.0



