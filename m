Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D02A3B8409;
	Mon, 17 Aug 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976724; cv=none; b=HTzOsaLV2W1h7uhtNmIyDt5L3HR+Yx3y5+FbhoUY/CGB+Ja+c9uuXTZVSAPSafFHX6kZoua9E8C+9aJybRfrfw2P0q6ORup/muUWm/e2Mh157BUcb24uSDn2NbLWDrCIhSxa9x+PsCR/GOSKwNjyvdg7/9IjpaGscORA+7/MEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976724; c=relaxed/simple;
	bh=VkYzvwaxIxp2bezcVbflXzTQeFv5ebLfJ8aF1Gd0iUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoYhbC8ZwJzjCkBpjwFTcs5snAU2hSbh1eiQaa55liqrL8gK3DGzS0mHeKaDIJlUCuzEapunxBGFcjaimvId6wRfOHmF1gtV46kzu5gd4+U1U361TOBTmz87IbDjCGf3284oMRIQDshxrPdkGrGM2PM4+v1CUb8tTsuO4DpXXes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvJo1KJh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvJo1KJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F991F000E9;
	Mon, 17 Aug 2026 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976723;
	bh=VwS+VMOCXUJrBZB0MQz64dPuzlEMnfAzEUt6SHsm7Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvJo1KJhvFukrIN2pYtXqM6Lcu/N3cHmExaMUSsGvggo6P+A3943M1vDAZPIs0+7+
	 XbqP87UjR3LFw6rouize+TOKaw52l8IoKKJKEFyeC8CkDnNaMjwwdvdPPkbCkmFKY0
	 8sQdHseFyNZj7qHen6BHX8RnnH+pyjwXXja3X9U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/456] wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()
Date: Mon, 17 Aug 2026 15:27:52 +0200
Message-ID: <20260817132543.322256327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 318c3bfd45fdd2..c075ab49345643 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4470,6 +4470,9 @@ static void ath11k_hal_rx_msdu_list_get(struct ath11k *ar,
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



