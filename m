Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59ABF1D0427;
	Wed,  2 Oct 2024 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877227; cv=none; b=dP5N+D5ejmIkGVb4sLnmFNvLLXMReZHsP1K7zGqump2fHEI2wuo4uLB0H2wJZsE+Ehwr6GUJ4YsICZBwuw36E5vJ866cWeHLRC0mjmQQi7BFOYzjpS0itChqoFP7Hr0xxuQmOiEBE+crXhsAlGLfHJGjqnALu/CILDJbdv1nJxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877227; c=relaxed/simple;
	bh=iooflxP0iIsHGz1lmAboJ7dGa3Ms0pqMgY2RkHd7fYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0lww0JcCiQuF1C9gRnbBLjSbOA6P0BTv2ERGxnbH7fEwTUk3hPIs0qWaTqJqI9rJxEasjMcAm8xGWd0Bfbz5JZkgY9zGkfcbxQZr86BEqh1Lp4qxMhnQ9YMzBWzJFH48j1PtR/+LjU8qCwqO1or88jXotK3jQ35LrWGrqH+Ebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PClADkf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PClADkf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72A2C4CED3;
	Wed,  2 Oct 2024 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877227;
	bh=iooflxP0iIsHGz1lmAboJ7dGa3Ms0pqMgY2RkHd7fYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PClADkf9MX9nFojjx+oAwfm5GQHOS7QutCKmSsc+yBADrcS9DpTy1tviBL8HrDivI
	 kgdwMGWkrpIfBE0rntnLd0XYBFy+rqCCeBjj3ul9cPVBMjCyJVSkb2B7+v6dWK1I8n
	 FXyonWYyKdm9uDb3ODuABHKBtUA1uTz2FkxcO0dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 012/634] wifi: ath12k: fix BSS chan info request WMI command
Date: Wed,  2 Oct 2024 14:51:52 +0200
Message-ID: <20241002125811.577765477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 59529c982f85047650fd473db903b23006a796c6 ]

Currently, the firmware returns incorrect pdev_id information in
WMI_PDEV_BSS_CHAN_INFO_EVENTID, leading to incorrect filling of
the pdev's survey information.

To prevent this issue, when requesting BSS channel information
through WMI_PDEV_BSS_CHAN_INFO_REQUEST_CMDID, firmware expects
pdev_id as one of the arguments in this WMI command.

Add pdev_id to the struct wmi_pdev_bss_chan_info_req_cmd and fill it
during ath12k_wmi_pdev_bss_chan_info_request(). This resolves the
issue of sending the correct pdev_id in WMI_PDEV_BSS_CHAN_INFO_EVENTID.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240331183232.2158756-2-quic_kathirve@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 1 +
 drivers/net/wireless/ath/ath12k/wmi.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index ef775af25093c..55230dd00d0c7 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -1528,6 +1528,7 @@ int ath12k_wmi_pdev_bss_chan_info_request(struct ath12k *ar,
 	cmd->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_PDEV_BSS_CHAN_INFO_REQUEST,
 						 sizeof(*cmd));
 	cmd->req_type = cpu_to_le32(type);
+	cmd->pdev_id = cpu_to_le32(ar->pdev->pdev_id);
 
 	ath12k_dbg(ar->ab, ATH12K_DBG_WMI,
 		   "WMI bss chan info req type %d\n", type);
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 742fe0b36cf20..e26fe504ce28b 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3104,6 +3104,7 @@ struct wmi_pdev_bss_chan_info_req_cmd {
 	__le32 tlv_header;
 	/* ref wmi_bss_chan_info_req_type */
 	__le32 req_type;
+	__le32 pdev_id;
 } __packed;
 
 struct wmi_ap_ps_peer_cmd {
-- 
2.43.0



