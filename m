Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325B0D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD290C433EF;
	Mon, 12 Jun 2023 10:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566880;
	bh=BIySfnQjW+8GlHbTbEHMyiLsNeg1KOjuV/GMDreL8z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkTBkGlySK3/+u3HvyMPuDAbl7WZWvsws86U1YUM7uMwZ3MlGaLeSANqYlYd35qso
	 mbP4xTsfovnaRzUDZe7Htwu+qs5/8Ld2T2uFo/UpVak3aYuVd+yeRebrwDpfgHERrO
	 mZYSQHIwsRvcjAbBHHr/Wzt8RtTXFdXfLS3o7Ri8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 067/160] bnxt_en: Prevent kernel panic when receiving unexpected PHC_UPDATE event
Date: Mon, 12 Jun 2023 12:26:39 +0200
Message-ID: <20230612101718.070622004@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 319a7827df9784048abe072afe6b4fb4501d8de4 ]

The firmware can send PHC_RTC_UPDATE async event on a PF that may not
have PTP registered. In such a case, there will be a null pointer
deference for bp->ptp_cfg when we try to handle the event.

Fix it by not registering for this event with the firmware if !bp->ptp_cfg.
Also, check that bp->ptp_cfg is valid before proceeding when we receive
the event.

Fixes: 8bcf6f04d4a5 ("bnxt_en: Handle async event when the PHC is updated in RTC mode")
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 6 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 48753ebe79c37..f14519aa6d4f6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2392,6 +2392,9 @@ static int bnxt_async_event_process(struct bnxt *bp,
 				struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 				u64 ns;
 
+				if (!ptp)
+					goto async_event_process_exit;
+
 				spin_lock_bh(&ptp->ptp_lock);
 				bnxt_ptp_update_current_time(bp);
 				ns = (((u64)BNXT_EVENT_PHC_RTC_UPDATE(data1) <<
@@ -4789,6 +4792,9 @@ int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap, int bmap_size,
 		if (event_id == ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY &&
 		    !(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
 			continue;
+		if (event_id == ASYNC_EVENT_CMPL_EVENT_ID_PHC_UPDATE &&
+		    !bp->ptp_cfg)
+			continue;
 		__set_bit(bnxt_async_events_arr[i], async_events_bmap);
 	}
 	if (bmap && bmap_size) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index a3a3978a4d1c2..af7b4466f9520 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -946,6 +946,7 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
 		bnxt_ptp_timecounter_init(bp, true);
 		bnxt_ptp_adjfine_rtc(bp, 0);
 	}
+	bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, true);
 
 	ptp->ptp_info = bnxt_ptp_caps;
 	if ((bp->fw_cap & BNXT_FW_CAP_PTP_PPS)) {
-- 
2.39.2



