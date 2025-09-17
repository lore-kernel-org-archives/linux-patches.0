Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C6718A6CF;
	Wed, 17 Sep 2025 12:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112980; cv=none; b=QoUEbcDDNiSlYZyhIF/jPLg0hdsw3Djapb1EWA4LQeGapSXDh4t+03DjuNAw4JtvtWu3Qg+f0I3OfwyCbDcdCTDQ+MCLPZ7a6emDVnKp6Jwp23zZM1wobRWImqPjMSpmxASEZMxzEXzionnHxvIUICNAmyFCUcXonbh9I5IpWqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112980; c=relaxed/simple;
	bh=WEyXEe9XR805AcKy6apFS8zMbQxJBljmdv790w1KDts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ner/aY2EP7bHN7mpWQZtcv0NyKbbmt36ddMHaZTNC6i2FPt62MR4Ho2ZHyNxoUmZL0cZbh4zsVACSaKmoQdw0tlbmfTr3nTOvCM48H8TdceogreT9T/Sg4pjVApHx8cp075wvxcypkKraGUr65kVoFy5nyvyZC5aPxIkMyqt4RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC7hlVgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC7hlVgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EFDC4CEF5;
	Wed, 17 Sep 2025 12:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112979;
	bh=WEyXEe9XR805AcKy6apFS8zMbQxJBljmdv790w1KDts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YC7hlVgfhM/tnnvlsHBc6fL0zqp+vXTKuPQpLbD1kGytcxkbQg3w+BF0wzycUbuIl
	 OZZqI+1sMS5F62tA9jsL0o/lQNrm57zzNlaSkMUiANbPNcJQzzKyImUxR5U79M8pLL
	 vvVI1b26s5cNFWjqb33Gia13WJS6tB07TVPywmAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 133/189] wifi: ath12k: fix WMI TLV header misalignment
Date: Wed, 17 Sep 2025 14:34:03 +0200
Message-ID: <20250917123355.109245236@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 82e2be57d544ff9ad4696c85600827b39be8ce9e ]

When buf_len is not 4-byte aligned in ath12k_wmi_mgmt_send(), the
firmware asserts and triggers a recovery. The following error
messages are observed:

ath12k_pci 0004:01:00.0: failed to submit WMI_MGMT_TX_SEND_CMDID cmd
ath12k_pci 0004:01:00.0: failed to send mgmt frame: -108
ath12k_pci 0004:01:00.0: failed to tx mgmt frame, vdev_id 0 :-108
ath12k_pci 0004:01:00.0: waiting recovery start...

This issue was observed when running 'iw wlanx set power_save off/on'
in MLO station mode, which triggers the sending of an SMPS action frame
with a length of 27 bytes to the AP. To resolve the misalignment, use
buf_len_aligned instead of buf_len when constructing the WMI TLV header.

Tested-on: WCN7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00011-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20250908015139.1301437-1-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d333f40408feb..d740326079e1d 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -840,7 +840,7 @@ int ath12k_wmi_mgmt_send(struct ath12k_link_vif *arvif, u32 buf_id,
 	cmd->tx_params_valid = 0;
 
 	frame_tlv = (struct wmi_tlv *)(skb->data + sizeof(*cmd));
-	frame_tlv->header = ath12k_wmi_tlv_hdr(WMI_TAG_ARRAY_BYTE, buf_len);
+	frame_tlv->header = ath12k_wmi_tlv_hdr(WMI_TAG_ARRAY_BYTE, buf_len_aligned);
 
 	memcpy(frame_tlv->value, frame->data, buf_len);
 
-- 
2.51.0



