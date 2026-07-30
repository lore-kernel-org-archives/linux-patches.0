Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6108643FD01;
	Thu, 30 Jul 2026 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425773; cv=none; b=K9fCbCXTJasi/GZU21JyulQgrKjs9z8f090cwxP6C2QVwNt5ny2KWVkV3SYd6VqBorwDfsfaSo7Z6Ed62BKKJ2mYHSqQ+8pEfT0DURCGhaH7w80AN9uwWd1bv3MhXkSFTZhpiEEw4RLOBjdweHaOySadNzOykDHDdsxE6ds7T2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425773; c=relaxed/simple;
	bh=G3mtNvxu9PMnvdyOx/rLNguSb2tFvjTc8+XvjWsRLwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4Yj22yXOT264MaCNGnhLjD/m5arEe5fk/LqrK6EkIe33h0OvDFrUbCnOQ3Z6O6fYi5WkmETagduJVKo4531LbgYh8wuMfZHzIgRozaU4pQNQnii4eR0w+s8nUur0FpR2pNHeMz6zva6hR1DwjZzHWAd5XpMz2YLLlXD9mI1mvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhnsRJVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhnsRJVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E031F000E9;
	Thu, 30 Jul 2026 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425772;
	bh=v+FWRQxERIGqzW7Piq0LJ5guV0lwcgOU+Bm3XwkpUys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhnsRJVFOMdwL+TUux75BBG+YE7SWtCPN2RjnwfCSSjrk3uoWi/5fNvv4n6MYsHdJ
	 t0SvDyRecrgl2g5qmrISx/aB0JkqzR4FGhQM6/byBIlDdJK9UlR+F8yu73Qtzi/6KJ
	 gDgA/Crqz07gkkPR6O7MB2Agdx7ybKq7UmqC23PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/602] wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()
Date: Thu, 30 Jul 2026 16:08:54 +0200
Message-ID: <20260730141438.963343670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 78b0fa8d4f3391..6cc252d00ef130 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4614,6 +4614,9 @@ static void ath11k_hal_rx_msdu_list_get(struct ath11k *ar,
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



