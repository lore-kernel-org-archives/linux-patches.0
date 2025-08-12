Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364532E9EDE;
	Tue, 12 Aug 2025 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024083; cv=none; b=d0mK/PyszFSN+yvl4ZrBAmt9EgcHIWbnnmLSUYxCGHJsk6mMyciGXQ4Wj/JF+OPDSi95ES05ZUlRywFqh50zUcXjt9URUf8i3eoppp1/CjQQbVCZ3n4B6PdQQh9urj2i6r1cFx8zhqex9CB+9kRItaBmFwnj3hgP2ciAcqHXlO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024083; c=relaxed/simple;
	bh=QLGKUq3UaOclg+gRxcqi0UmcvguF+taFouN4D97ugzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pucDZSBBHb+4dEhv0X4HT8v2nsYPl4IbM4SCwiRv2t8HAUma6LovotVTZqiRNDic7of3TyaCDQn+jV4ge1OPzYnuueF77gGEhpfWqNixNer5shtJHcGKNVJuzdJ3Tsax6ro3iKSNQVArvU1j9LqGzrxpFexC0wPosmClFV0Qyik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FioOQRq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FioOQRq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB39C4CEF0;
	Tue, 12 Aug 2025 18:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024083;
	bh=QLGKUq3UaOclg+gRxcqi0UmcvguF+taFouN4D97ugzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FioOQRq3PGRwZ/pk7zzSiNhySXC7p1gDo58rSQBMdu9PdeovRcYR+jgGzywREVN0Z
	 Wevx25XVPYrkLu8/7ONuJcbv3dK8CEhGDCsz6MwXkEnfHvM7ADV7yDZ5TtFGkoQeUX
	 BsiUys1gVQ4xVRiEY5NXi/XI2DdFF/hggbXL8ViU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 241/627] wifi: ath12k: fix endianness handling while accessing wmi service bit
Date: Tue, 12 Aug 2025 19:28:56 +0200
Message-ID: <20250812173428.466998248@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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
index e19803bfba75..745d017c5aa8 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -7491,7 +7491,7 @@ static int ath12k_wmi_tlv_services_parser(struct ath12k_base *ab,
 					  void *data)
 {
 	const struct wmi_service_available_event *ev;
-	u32 *wmi_ext2_service_bitmap;
+	__le32 *wmi_ext2_service_bitmap;
 	int i, j;
 	u16 expected_len;
 
@@ -7523,12 +7523,12 @@ static int ath12k_wmi_tlv_services_parser(struct ath12k_base *ab,
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
@@ -7536,8 +7536,10 @@ static int ath12k_wmi_tlv_services_parser(struct ath12k_base *ab,
 
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



