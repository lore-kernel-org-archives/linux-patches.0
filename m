Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685A7207A07;
	Fri,  6 Dec 2024 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497961; cv=none; b=bPYyg/ogIirYXI5hBRzB4dU1tIbZUtucGPdKtAeR6oCeyxZVQGZhyISv5Ut83B6QzSfp4EIdQICh3mGwYaO1JSUzHVxIBCNDhO5lTC2VcSNfGxt6BsYUwfbw528glAifgcxL/XJ7C2jFY8JjWktOT61AKtRUAvBE0rlDDeDajBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497961; c=relaxed/simple;
	bh=zeunuCxYMirkXYxp+4fXdTV7/XGuexvIYmPYVTRutqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4hOE8o4vkSkxTjoZYX8Q4xpj62dDnn3CIPEv6eozT2cp2jhlDs0KfG2Z+WwvvThhk2+qTYyLUL378R9w2ptRoBQuT2lVWsXX46LXYb8MT76wa6E7KpSXRrEXjz25frXoS7KbFHuksjaV9WBWbNiNTubCICGDVysKciAPFY2hX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNmOEqx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNmOEqx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD159C4CED1;
	Fri,  6 Dec 2024 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497961;
	bh=zeunuCxYMirkXYxp+4fXdTV7/XGuexvIYmPYVTRutqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNmOEqx0A9ywYL+ybMxlcIoOckUgZT0RI3zrb19l/2T8ttrFPXe5GF7U9+FvJL0oT
	 19RjKsbC0H7jUPPn7W5VgbD1lXJJlSj73+TTZOO8eFzchT5zd6lkOSHo7BLDPYlH83
	 JohRzoP9oePPxIUptPO+rPT3AI5ubqtOnX+CYx20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 417/676] bnxt_en: Refactor bnxt_ptp_init()
Date: Fri,  6 Dec 2024 15:33:56 +0100
Message-ID: <20241206143709.637341465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 1e9614cd956268e10a669c0593e7e54d03d0c087 ]

Instead of passing the 2nd parameter phc_cfg to bnxt_ptp_init().
Store it in bp->ptp_cfg so that the caller doesn't need to know what
the value should be.

In the next patch, we'll need to call bnxt_ptp_init() in bnxt_resume()
and this will make it easier.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3661c05c54e8 ("bnxt_en: Unregister PTP during PCI shutdown and suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index bc6206543e8e9..c216d95809282 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7597,7 +7597,6 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 	struct hwrm_port_mac_ptp_qcfg_output *resp;
 	struct hwrm_port_mac_ptp_qcfg_input *req;
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
-	bool phc_cfg;
 	u8 flags;
 	int rc;
 
@@ -7640,8 +7639,9 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 		rc = -ENODEV;
 		goto exit;
 	}
-	phc_cfg = (flags & PORT_MAC_PTP_QCFG_RESP_FLAGS_RTC_CONFIGURED) != 0;
-	rc = bnxt_ptp_init(bp, phc_cfg);
+	ptp->rtc_configured =
+		(flags & PORT_MAC_PTP_QCFG_RESP_FLAGS_RTC_CONFIGURED) != 0;
+	rc = bnxt_ptp_init(bp);
 	if (rc)
 		netdev_warn(bp->dev, "PTP initialization failed.\n");
 exit:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 6e3da3362bd61..bbe8657f6545b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -922,7 +922,7 @@ static void bnxt_ptp_free(struct bnxt *bp)
 	}
 }
 
-int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
+int bnxt_ptp_init(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 	int rc;
@@ -944,7 +944,7 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
 
 	if (BNXT_PTP_USE_RTC(bp)) {
 		bnxt_ptp_timecounter_init(bp, false);
-		rc = bnxt_ptp_init_rtc(bp, phc_cfg);
+		rc = bnxt_ptp_init_rtc(bp, ptp->rtc_configured);
 		if (rc)
 			goto out;
 	} else {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 34162e07a1195..7d6a215b10b1f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -115,6 +115,7 @@ struct bnxt_ptp_cfg {
 					 BNXT_PTP_MSG_PDELAY_REQ |	\
 					 BNXT_PTP_MSG_PDELAY_RESP)
 	u8			tx_tstamp_en:1;
+	u8			rtc_configured:1;
 	int			rx_filter;
 	u32			tstamp_filters;
 
@@ -145,6 +146,6 @@ int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
 void bnxt_ptp_rtc_timecounter_init(struct bnxt_ptp_cfg *ptp, u64 ns);
 int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg);
-int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg);
+int bnxt_ptp_init(struct bnxt *bp);
 void bnxt_ptp_clear(struct bnxt *bp);
 #endif
-- 
2.43.0



