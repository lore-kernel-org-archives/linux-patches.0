Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071521F76AD;
	Tue,  3 Dec 2024 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242102; cv=none; b=t45HyhyGlk1nJCiziMTyEQmyutr62uWD6sOZZqEJymPfmTfIVJ3UufCi1j8+SSrAfvjyZ18JHfLbrJQWfdbdygofcXB18KPUyooFxvk4j7ohA+UyByYgCBPitwjQBJy5Ocg8d5r6OhrNDQT6Mpe1YS6Wgv61MNnvGuLq4fI6K94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242102; c=relaxed/simple;
	bh=oj0BEKeV8TbzCXMKvar+d7ph1mrP2Q9V1D5opZ5IL/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSyPoJV8AIFora+LrE0hyo5at+c3vnMLtmPtjN0zV0jcF6LAMwVzpb0B2991wpL8bjSBfGwVsYqum07Ay419kohcPkqxPadgZ7r0YSp+OORwzv1HqzcdTCQkZ06/xz9Mscb1vidTpLLr2K54iqYkGmFekfwfMui4VQ+2vq9D7FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MccE3ISl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MccE3ISl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AA5C4CECF;
	Tue,  3 Dec 2024 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242101;
	bh=oj0BEKeV8TbzCXMKvar+d7ph1mrP2Q9V1D5opZ5IL/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MccE3ISlL+p19tPqx5wnrN3y3yUEy5wApnI7BPj/cNFlP8cOP3cu/B8XDI+H2pSod
	 9EM/KLxaILWg5h2H3fRQ6eU0+0t5faPgbfS8pUDnpwhTadczcT29t41Rt2In775yIb
	 VHYaTKwZHzge23QjuSbyapXkDsMTnfXbOEn7P4JU=
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
Subject: [PATCH 6.12 581/826] bnxt_en: Refactor bnxt_ptp_init()
Date: Tue,  3 Dec 2024 15:45:08 +0100
Message-ID: <20241203144806.413388296@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 913acd80d6483..015ad2b0bcd1c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9053,7 +9053,6 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 	struct hwrm_port_mac_ptp_qcfg_output *resp;
 	struct hwrm_port_mac_ptp_qcfg_input *req;
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
-	bool phc_cfg;
 	u8 flags;
 	int rc;
 
@@ -9100,8 +9099,9 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
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
index fa514be876502..781225d3ba8ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -1024,7 +1024,7 @@ static void bnxt_ptp_free(struct bnxt *bp)
 	}
 }
 
-int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
+int bnxt_ptp_init(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 	int rc;
@@ -1047,7 +1047,7 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
 
 	if (BNXT_PTP_USE_RTC(bp)) {
 		bnxt_ptp_timecounter_init(bp, false);
-		rc = bnxt_ptp_init_rtc(bp, phc_cfg);
+		rc = bnxt_ptp_init_rtc(bp, ptp->rtc_configured);
 		if (rc)
 			goto out;
 	} else {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index f322466ecad35..61e89bb2d2690 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -133,6 +133,7 @@ struct bnxt_ptp_cfg {
 					 BNXT_PTP_MSG_PDELAY_REQ |	\
 					 BNXT_PTP_MSG_PDELAY_RESP)
 	u8			tx_tstamp_en:1;
+	u8			rtc_configured:1;
 	int			rx_filter;
 	u32			tstamp_filters;
 
@@ -180,6 +181,6 @@ void bnxt_tx_ts_cmp(struct bnxt *bp, struct bnxt_napi *bnapi,
 		    struct tx_ts_cmp *tscmp);
 void bnxt_ptp_rtc_timecounter_init(struct bnxt_ptp_cfg *ptp, u64 ns);
 int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg);
-int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg);
+int bnxt_ptp_init(struct bnxt *bp);
 void bnxt_ptp_clear(struct bnxt *bp);
 #endif
-- 
2.43.0



