Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3A719409E;
	Wed,  2 Oct 2024 14:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879180; cv=none; b=apNy3vlHIaUb5q2iPk2vjiLE4Wqn8B0QCXOEjXCWpzGQZVy9oGRHd8YDySxZlSCsaY4s5FD8NdUEO6rCqi7O3u8TkSYF5Pw837uactETEbIYslOZh6UDE0f836R16znT365SD1zuH25Z0H1r348Ac67Pf1xbkVupWKs3yEBbMuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879180; c=relaxed/simple;
	bh=BS+vKGyVHHb8x/i5SNLJtYbj6pfnBsxpus9vAmJhsCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ax2o4JQ3+vXhuimSfqmVT8bfmZWEqgKJy6oQWvezVQAoTqIXJlUFW4rV5uAepJ9LoQecoNvBq6Nz7hMlSYXrHAK30zKo6OY9QW/aBk5EmoCT6XFNP60bnHW7IahoSiPKXJMTGiFFKElUbqfJj1J5t9l0AG9gvPK/SfqABVhIu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXSSF8nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXSSF8nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F57BC4CEC2;
	Wed,  2 Oct 2024 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879180;
	bh=BS+vKGyVHHb8x/i5SNLJtYbj6pfnBsxpus9vAmJhsCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXSSF8ndKIuixRhrpQ07MgHCHGXFIrdjmuI11FqmOLoq5Ee9170a7EtfAtdXUZYDT
	 3L0Q0b9zkZLfGimiW3tytIULKTgf8i4J5Zbhxizn6pAMW8VvuT0kS49IdiAA3ieuay
	 TpM1Jp/m3D3Qt2kzOWNm9Bj9unsT/8WzuWp6QHPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/538] wifi: ath12k: fix BSS chan info request WMI command
Date: Wed,  2 Oct 2024 14:54:08 +0200
Message-ID: <20241002125752.356815957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 21399ad233c02..9105fdd14c667 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -1501,6 +1501,7 @@ int ath12k_wmi_pdev_bss_chan_info_request(struct ath12k *ar,
 	cmd->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_PDEV_BSS_CHAN_INFO_REQUEST,
 						 sizeof(*cmd));
 	cmd->req_type = cpu_to_le32(type);
+	cmd->pdev_id = cpu_to_le32(ar->pdev->pdev_id);
 
 	ath12k_dbg(ar->ab, ATH12K_DBG_WMI,
 		   "WMI bss chan info req type %d\n", type);
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index c75a6fa1f7e08..6549c3853be46 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3058,6 +3058,7 @@ struct wmi_pdev_bss_chan_info_req_cmd {
 	__le32 tlv_header;
 	/* ref wmi_bss_chan_info_req_type */
 	__le32 req_type;
+	__le32 pdev_id;
 } __packed;
 
 struct wmi_ap_ps_peer_cmd {
-- 
2.43.0



