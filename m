Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DAC3AAF76;
	Mon, 17 Aug 2026 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975551; cv=none; b=NLY5l3PcmCno99WNvV7o/2fJ9Aidu+FYMrEOV17hG0sx6fr34kALTA9/fkc3++gsgmdUQ5y5my2JIS2/9x6SNi4qhVhn7rALw+8zww6FZx4AzQemlt+2yoO8qajchwW/HsPVX+ILcT8Q1k8LbA0PZihgHMMx0fzt3AShuUUkQUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975551; c=relaxed/simple;
	bh=zo9ChCpoZOHxo/Qk60MlZCSXCYfZxsNN7O9TNZNF5G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEv2WSHG/NkHXTr3WndjVVAAZ7FnzDc917SWaJ4AdlyZThKF7Dcy2y5SJN5rQQ3k+8lnWVrN15j0WUhVK4Dm7VPIT68Nw4VTDbd1necNc4IQ9i86DBhMPMgPjve8X5MeOeeb+tlfBjONLaPVMLNJituvu7VZ69LC7HGiCJW+Oh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYJhnGBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYJhnGBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B59A1F000E9;
	Mon, 17 Aug 2026 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975550;
	bh=0g3fgRBQhLDzF/jh7ZCfOGT+yu/cqXeWvEfVLlsalWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYJhnGBRGXDAm847+M9sqXpBLEz+mxWIoKcICkZOYTdF5N+NshOUuOXrloQm9XhKh
	 kKZqNVwbPSszUvWLXfHpFaNyGbcfGmJ/+VAuGp2qXnmYRQKzeRWJlY6DWMqof+kzwd
	 tfzYSOikwUuUj9QtR3pHkBBi3cJcGT2TFmRYMz00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/389] wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()
Date: Mon, 17 Aug 2026 15:28:23 +0200
Message-ID: <20260817132541.596449564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 720c94806e1a18..54edf4a61c61aa 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4441,6 +4441,9 @@ static void ath11k_hal_rx_msdu_list_get(struct ath11k *ar,
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



