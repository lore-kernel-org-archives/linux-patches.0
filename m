Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5623CE;
	Wed,  7 Aug 2024 15:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042920; cv=none; b=kIWjdndVJEr5g/jiwz6lUsfFIHjkyGYiYwo54RusCt47bue0FONolXvm1ygsTqZS8V79tFu1Nji6NZcG/D/a+nBU1ehlJ/5igxDynbtGhM19ywj/VBVLd+yA57ZxT4gc99apxOCnImkb1Q9FrhJPPiT9HKp0EtDWC8z6mIZiQtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042920; c=relaxed/simple;
	bh=vdAhi7xH1E9+O+rpZ1qPOB4Tz/CxnOCdgr4v+OOMDHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd80uRshJnfqIjDoG0oT3PPPlTLnTwnIr3m7OU2htUkF8GOQtigrEfmD+d3T8NK1vjAW69PTymrBC/g1Vz8QiECMj2/JT7EmWGQ9nEz0uHoecOA7Kr38NNvqTGewVPPkAiBXN+u/bHY+IWCcLeVEcPLV9SMGLLuebenZR4ouaaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7jm5l87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7jm5l87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176BFC4AF0D;
	Wed,  7 Aug 2024 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042920;
	bh=vdAhi7xH1E9+O+rpZ1qPOB4Tz/CxnOCdgr4v+OOMDHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7jm5l87ox/bXrIYJRtIMWI9Fux1BoXiReFho+TuU3ou+OwCUSYGjQF4EowLealxP
	 KUrWIQSv8bB9BLeKnEyKYo34rOj2JjYIkSioraLgP4az5gP5o/0jX/oDJ5CJJVhaF9
	 qXpY7SkbpUEANpdCuqptS0SLsJCAFeXZsOMWRWsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 024/123] bnxt_en: Fix RSS logic in __bnxt_reserve_rings()
Date: Wed,  7 Aug 2024 16:59:03 +0200
Message-ID: <20240807150021.599850494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 98ba1d931f611e8f8f519c0405fa0a1a76554bfa ]

In __bnxt_reserve_rings(), the existing code unconditionally sets the
default RSS indirection table to default if netif_is_rxfh_configured()
returns false.  This used to be correct before we added RSS contexts
support.  For example, if the user is changing the number of ethtool
channels, we will enter this path to reserve the new number of rings.
We will then set the RSS indirection table to default to cover the new
number of rings if netif_is_rxfh_configured() is false.

Now, with RSS contexts support, if the user has added or deleted RSS
contexts, we may now enter this path to reserve the new number of VNICs.
However, netif_is_rxfh_configured() will not return the correct state if
we are still in the middle of set_rxfh().  So the existing code may
set the indirection table of the default RSS context to default by
mistake.

Fix it to check if the reservation of the RX rings is changing.  Only
check netif_is_rxfh_configured() if it is changing.  RX rings will not
change in the middle of set_rxfh() and this will fix the issue.

Fixes: b3d0083caf9a ("bnxt_en: Support RSS contexts in ethtool .{get|set}_rxfh()")
Reported-and-tested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/20240625010210.2002310-1-kuba@kernel.org
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20240724222106.147744-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 43952689bfb0c..23627c973e40f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7491,8 +7491,8 @@ static int bnxt_get_avail_msix(struct bnxt *bp, int num);
 static int __bnxt_reserve_rings(struct bnxt *bp)
 {
 	struct bnxt_hw_rings hwr = {0};
+	int rx_rings, old_rx_rings, rc;
 	int cp = bp->cp_nr_rings;
-	int rx_rings, rc;
 	int ulp_msix = 0;
 	bool sh = false;
 	int tx_cp;
@@ -7526,6 +7526,7 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 	hwr.grp = bp->rx_nr_rings;
 	hwr.rss_ctx = bnxt_get_total_rss_ctxs(bp, &hwr);
 	hwr.stat = bnxt_get_func_stat_ctxs(bp);
+	old_rx_rings = bp->hw_resc.resv_rx_rings;
 
 	rc = bnxt_hwrm_reserve_rings(bp, &hwr);
 	if (rc)
@@ -7580,7 +7581,8 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 	if (!bnxt_rings_ok(bp, &hwr))
 		return -ENOMEM;
 
-	if (!netif_is_rxfh_configured(bp->dev))
+	if (old_rx_rings != bp->hw_resc.resv_rx_rings &&
+	    !netif_is_rxfh_configured(bp->dev))
 		bnxt_set_dflt_rss_indir_tbl(bp, NULL);
 
 	if (!bnxt_ulp_registered(bp->edev) && BNXT_NEW_RM(bp)) {
-- 
2.43.0



