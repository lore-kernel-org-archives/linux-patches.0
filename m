Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505B37C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB29AC433EF;
	Mon, 24 Apr 2023 13:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343067;
	bh=CsZUTYThaUcUai9Mzhw0OJ1Z+IWYiXzIMD0q1IS2XQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqmPsTJEmQb93OzQZt3xSmjRt0FPjWcg0gjiUTcPROCCNXGnCXJwmCcJW22ea/aKk
	 pBBs0i5B8VahflzYk4wnsgbhzMtjrOELeTjC2MVTR/ibN/oATGOmQqq1RIWRl1PbBX
	 2rjH8JW9gZumwUnClyv84fvC15GwhJMsSbuIzbDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadfed@meta.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 035/110] bnxt_en: fix free-runnig PHC mode
Date: Mon, 24 Apr 2023 15:16:57 +0200
Message-Id: <20230424131137.470340311@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 8c154d272c3e03b100baaf1df473f22a78fa403e ]

The patch in fixes changed the way real-time mode is chosen for PHC on
the NIC. Apparently there is one more use case of the check outside of
ptp part of the driver which was not converted to the new macro and is
making a lot of noise in free-running mode.

Fixes: 131db4991622 ("bnxt_en: reset PHC frequency in free-running mode")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230418202511.1544735-1-vadfed@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index beab68e22e371..47617a95034c6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2388,7 +2388,7 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	case ASYNC_EVENT_CMPL_EVENT_ID_PHC_UPDATE: {
 		switch (BNXT_EVENT_PHC_EVENT_TYPE(data1)) {
 		case ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_RTC_UPDATE:
-			if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
+			if (BNXT_PTP_USE_RTC(bp)) {
 				struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 				u64 ns;
 
-- 
2.39.2



