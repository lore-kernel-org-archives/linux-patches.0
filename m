Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9BB7474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42493C433EF;
	Tue, 10 Jan 2023 18:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374865;
	bh=+Xujxti2WMXwcRIQiW0Tx9XQrp7jBeY2Dl7C+92vKC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDYktM+CsgMMd7dlbQK/V0UXGs7xXggoftWwfp+xqR7oRfVmrii10Ouhmae0LLUbR
	 oM/1KI84OYzhLdUPQzzUNQUBG1FyUjGcFajh0QMDCqJFuTLS+OqL/0mreNjRNHqlDR
	 SRViX2lbPMp+CxSKHzVLpIMZTkdgHtrx+gsom/KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 159/159] wifi: ath11k: Send PME message during wakeup from D3cold
Date: Tue, 10 Jan 2023 19:05:07 +0100
Message-Id: <20230110180023.650450201@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baochen Qiang <quic_bqiang@quicinc.com>

commit 3f9b09ccf7d5f23066b02881a737bee42def9d1a upstream.

We are seeing system stuck on some specific platforms due to
WLAN chip fails to wakeup from D3cold state.

With this flag, firmware will send PME message during wakeup
and this issue is gone.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Link: https://lore.kernel.org/r/20221010033237.415478-1-quic_bqiang@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -19,6 +19,7 @@
 #define SLEEP_CLOCK_SELECT_INTERNAL_BIT	0x02
 #define HOST_CSTATE_BIT			0x04
 #define PLATFORM_CAP_PCIE_GLOBAL_RESET	0x08
+#define PLATFORM_CAP_PCIE_PME_D3COLD	0x10
 
 #define FW_BUILD_ID_MASK "QC_IMAGE_VERSION_STRING="
 
@@ -1752,6 +1753,8 @@ static int ath11k_qmi_host_cap_send(stru
 	if (ab->hw_params.global_reset)
 		req.nm_modem |= PLATFORM_CAP_PCIE_GLOBAL_RESET;
 
+	req.nm_modem |= PLATFORM_CAP_PCIE_PME_D3COLD;
+
 	ath11k_dbg(ab, ATH11K_DBG_QMI, "qmi host cap request\n");
 
 	ret = qmi_txn_init(&ab->qmi.handle, &txn,


