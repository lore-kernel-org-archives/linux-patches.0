Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421FB188CC1;
	Tue, 10 Sep 2024 10:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964420; cv=none; b=JXLeE7Hi3nRO99Lo3qiRY3e9A7PSV1/baJb2qUC286TYYDAvEy97c8SU7iuVBNjHxfcWb2haPYpNitF3VbXnb5RcWKGzhiZqv72qLxqQ34ONQOF51lDIvFGhvYiR7Vzai3cci15p9/TzF+cvLsviB684aE13lUfljzMQB2mSXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964420; c=relaxed/simple;
	bh=/2bwFQU0qcwQi/ESdckhZgNcnQM/IPc7hMcfOzrdbzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSywDMCC/FOnkcFKFwoLNeBkt9unKs7/fxbsxfeW49W+SWw2sjED6NzTqUCrhtQ0B/9/2N9eAadVAYio5qpWFsCjgFyEaHHE0e82WhSEyd2YkkZqgQg/zY19/LxcUOyCrDXpIakJVUnDYfWYkPnowQryAe6BZs+6i/hMNFbAh2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPAbGIuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPAbGIuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC048C4CEC3;
	Tue, 10 Sep 2024 10:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964420;
	bh=/2bwFQU0qcwQi/ESdckhZgNcnQM/IPc7hMcfOzrdbzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPAbGIuFMDP1St7gSQW8SqYITWEH5VX2uIId+Tk6Yo8mU0nSiQ4yGbSa4ZujiD/Xu
	 fLc7vDuSpNeJQbQ83L1RFpC2bgxdxtO2dCbC93m/tZIkSLtywoafcFn3QVCBqLiSCu
	 KIa3rYWG21GUA0UPJrMtL/zwa0VYJVPH6zmYfCTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/269] scsi: pm80xx: Set phy->enable_completion only when we wait for it
Date: Tue, 10 Sep 2024 11:32:17 +0200
Message-ID: <20240910092613.572411854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit e4f949ef1516c0d74745ee54a0f4882c1f6c7aea ]

pm8001_phy_control() populates the enable_completion pointer with a stack
address, sends a PHY_LINK_RESET / PHY_HARD_RESET, waits 300 ms, and
returns. The problem arises when a phy control response comes late.  After
300 ms the pm8001_phy_control() function returns and the passed
enable_completion stack address is no longer valid. Late phy control
response invokes complete() on a dangling enable_completion pointer which
leads to a kernel crash.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
Link: https://lore.kernel.org/r/20240627155924.2361370-2-tadamsjr@google.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a5a31dfa4512..ee2da8e49d4c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -166,7 +166,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	unsigned long flags;
 	pm8001_ha = sas_phy->ha->lldd_ha;
 	phy = &pm8001_ha->phy[phy_id];
-	pm8001_ha->phy[phy_id].enable_completion = &completion;
 
 	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
 		/*
@@ -190,6 +189,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 				rates->maximum_linkrate;
 		}
 		if (pm8001_ha->phy[phy_id].phy_state ==  PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -198,6 +198,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_HARD_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -206,6 +207,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_LINK_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
-- 
2.43.0



