Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6801FA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43A7C433EF;
	Tue, 10 Jan 2023 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374162;
	bh=LolvUDwdmMy6uXD2MfeDzzgWrtgUtC7qWzba5APy6ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y382+W7bAT98gLXJIm96vFPcT05NB61Ose8x2cWtn1HOuSSz46uO9WsCf1jTf2GXl
	 VHC5rCzWSpAAww/lpXhXiYCb0YOsCvQqiuv65zpM+p3FD5JprbpL1xhyVyGAOlRId9
	 JTOkwC98LG8feNzmhP7aDR6P/eb4dFSbXkXuvuls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Shuab Siddique <mohammad-shuab.siddique@broadcom.com>,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 038/148] bnxt_en: Fix HDS and jumbo thresholds for RX packets
Date: Tue, 10 Jan 2023 19:02:22 +0100
Message-Id: <20230110180018.429858414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit a056ebcc30e2f78451d66f615d2f6bdada3e6438 ]

The recent XDP multi-buffer feature has introduced regressions in the
setting of HDS and jumbo thresholds.  HDS was accidentally disabled in
the nornmal mode without XDP.  This patch restores jumbo HDS placement
when not in XDP mode.  In XDP multi-buffer mode, HDS should be disabled
and the jumbo threshold should be set to the usable page size in the
first page buffer.

Fixes: 32861236190b ("bnxt: change receive ring space parameters")
Reviewed-by: Mohammad Shuab Siddique <mohammad-shuab.siddique@broadcom.com>
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index be82464e1a77..1b38295254e2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5371,15 +5371,16 @@ static int bnxt_hwrm_vnic_set_hds(struct bnxt *bp, u16 vnic_id)
 	req->flags = cpu_to_le32(VNIC_PLCMODES_CFG_REQ_FLAGS_JUMBO_PLACEMENT);
 	req->enables = cpu_to_le32(VNIC_PLCMODES_CFG_REQ_ENABLES_JUMBO_THRESH_VALID);
 
-	if (BNXT_RX_PAGE_MODE(bp) && !BNXT_RX_JUMBO_MODE(bp)) {
+	if (BNXT_RX_PAGE_MODE(bp)) {
+		req->jumbo_thresh = cpu_to_le16(bp->rx_buf_use_size);
+	} else {
 		req->flags |= cpu_to_le32(VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV4 |
 					  VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV6);
 		req->enables |=
 			cpu_to_le32(VNIC_PLCMODES_CFG_REQ_ENABLES_HDS_THRESHOLD_VALID);
+		req->jumbo_thresh = cpu_to_le16(bp->rx_copy_thresh);
+		req->hds_threshold = cpu_to_le16(bp->rx_copy_thresh);
 	}
-	/* thresholds not implemented in firmware yet */
-	req->jumbo_thresh = cpu_to_le16(bp->rx_copy_thresh);
-	req->hds_threshold = cpu_to_le16(bp->rx_copy_thresh);
 	req->vnic_id = cpu_to_le32(vnic->fw_vnic_id);
 	return hwrm_req_send(bp, req);
 }
-- 
2.35.1



