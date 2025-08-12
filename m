Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BE52DE1E2;
	Tue, 12 Aug 2025 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021286; cv=none; b=Zrg5k0WWnNoFVYsNTqyBVlsvNLdGM3XFK0rC+EsoCew9ocqUUJcCqimfcNn02rQ/vchv8O+Z6La8PaS9AYe4C9wSLpT3elrnOIe2av9ijGJvNbZyVQC8XTlMk92NH+QZPIEceCBcVo0pZkdV0L39oHOcvv0MxjkTHrOthunPs4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021286; c=relaxed/simple;
	bh=cn3ylJkNaMZT3UKSVdGvZvzFNATvzwUSrkl5jJcYo1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teEirNpVEliW5SXFKRuPWZ5UIwND6XTmIE/WSWtmTtO+fKZnep+wRN7gvrmupoEFrezlM0y+eybaOxtHLiZLEl5EeNGPMq5H+lk0hGOgzsrVplSIt+TC/gBqHYrhwPl946dxDRFVqT2j8msJORQy1nihOVfe5BSrNswg12FDehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpc+ozGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpc+ozGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3005DC4CEF0;
	Tue, 12 Aug 2025 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021284;
	bh=cn3ylJkNaMZT3UKSVdGvZvzFNATvzwUSrkl5jJcYo1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpc+ozGZ2+ODyReqnNPDWqtBEnAM8Wer967+CzYXNJmZEtFeQXQVJxXFXYUJFwuLU
	 r9rfRCvM+syKQtOjWNY0xebJ34KR19CQfpfvh54hHhRzQDlnowlKJd1wy5CctSCdNn
	 HlqlqP6+LklQ5gu7MAzI8xle4nCQncIB3pfaCDKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/262] wifi: ath12k: fix endianness handling while accessing wmi service bit
Date: Tue, 12 Aug 2025 19:27:56 +0200
Message-ID: <20250812172956.807168433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

[ Upstream commit 8f1a078842d4af4877fb686f3907788024d0d1b7 ]

Currently there is no endian conversion in ath12k_wmi_tlv_services_parser()
so the service bit parsing will be incorrect on a big endian platform and
to fix this by using appropriate endian conversion.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00217-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 342527f35338 ("wifi: ath12k: Add support to parse new WMI event for 6 GHz regulatory")
Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250717173539.2523396-2-tamizh.raja@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 958ac4ed5c34..e918218ce2d6 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -6303,7 +6303,7 @@ static int ath12k_wmi_tlv_services_parser(struct ath12k_base *ab,
 					  void *data)
 {
 	const struct wmi_service_available_event *ev;
-	u32 *wmi_ext2_service_bitmap;
+	__le32 *wmi_ext2_service_bitmap;
 	int i, j;
 	u16 expected_len;
 
@@ -6335,12 +6335,12 @@ static int ath12k_wmi_tlv_services_parser(struct ath12k_base *ab,
 			   ev->wmi_service_segment_bitmap[3]);
 		break;
 	case WMI_TAG_ARRAY_UINT32:
-		wmi_ext2_service_bitmap = (u32 *)ptr;
+		wmi_ext2_service_bitmap = (__le32 *)ptr;
 		for (i = 0, j = WMI_MAX_EXT_SERVICE;
 		     i < WMI_SERVICE_SEGMENT_BM_SIZE32 && j < WMI_MAX_EXT2_SERVICE;
 		     i++) {
 			do {
-				if (wmi_ext2_service_bitmap[i] &
+				if (__le32_to_cpu(wmi_ext2_service_bitmap[i]) &
 				    BIT(j % WMI_AVAIL_SERVICE_BITS_IN_SIZE32))
 					set_bit(j, ab->wmi_ab.svc_map);
 			} while (++j % WMI_AVAIL_SERVICE_BITS_IN_SIZE32);
@@ -6348,8 +6348,10 @@ static int ath12k_wmi_tlv_services_parser(struct ath12k_base *ab,
 
 		ath12k_dbg(ab, ATH12K_DBG_WMI,
 			   "wmi_ext2_service_bitmap 0x%04x 0x%04x 0x%04x 0x%04x",
-			   wmi_ext2_service_bitmap[0], wmi_ext2_service_bitmap[1],
-			   wmi_ext2_service_bitmap[2], wmi_ext2_service_bitmap[3]);
+			   __le32_to_cpu(wmi_ext2_service_bitmap[0]),
+			   __le32_to_cpu(wmi_ext2_service_bitmap[1]),
+			   __le32_to_cpu(wmi_ext2_service_bitmap[2]),
+			   __le32_to_cpu(wmi_ext2_service_bitmap[3]));
 		break;
 	}
 	return 0;
-- 
2.39.5



