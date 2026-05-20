Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3671CDFCA;
	Wed, 20 May 2026 16:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295675; cv=none; b=f+cXer8OZQk2RH1Op/LOZzHLGIkFqNoBhK+/HEq2R8sBjYrMDtkZDJSjtxBnjZxAuWdHKcLXwHd1vaHDhtnEN9+XJMTcwkQlVYhrf4nF4iwIjAReOz1XNtMrdoUD/H8umKPvkRDaXJg1FlI7r6mc4qZq/wBvl3xkvzuONrdCo7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295675; c=relaxed/simple;
	bh=7MVTeSLb6uZWSGXUd5g0jgmMfWVVaMhaVr9BHsiue9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvcbRpaRx7sndWy6/3EW+5gh9oo/z/1K+Jyrede9m4B/NDlMK2/Tq4Tuc9w8xhNls6pG5gpcYtMpSc4EuXCD6Fj0XtQtYFcq2e8rSRWWTg/x6gFRR/YjWmdyBHY4o7csM9o2V+XAnRm3PDQ0PD19TvmnF9XRVNs8lV1kGFqSAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dP2wCwae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dP2wCwae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904DF1F000E9;
	Wed, 20 May 2026 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295674;
	bh=gPYr8ygwSSoS4Rp3SPUQt3Wiodni0T2Zrcb8WMKV6ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP2wCwaecX4fP1TtVdd+gW5zEU4cvcwHiwLgmUnpibLRSsVykD+l+umGZ9w8IZREI
	 e/FSTeGiGjA5Sd98kSPg0/YXNmRNG8w+QaMXn2ApKrdYLjotHr7YSDUzCNtlhpAMtQ
	 oJbfQWme3YgUGILJKE/5kTQiMez5vsUgl4aokppU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0508/1146] bus: rifsc: fix RIF configuration check for peripherals
Date: Wed, 20 May 2026 18:12:38 +0200
Message-ID: <20260520162159.684661843@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gatien Chevallier <gatien.chevallier@foss.st.com>

[ Upstream commit d5ce3b4e951bc41a6ce877c8500bb4fe42146669 ]

Peripheral holding CID0 cannot be accessed, remove this completely
incorrect check. While there, fix  and simplify the semaphore checking
that should be performed when the CID filtering is enabled.

Fixes: a18208457253 ("bus: rifsc: introduce RIFSC firewall controller driver")
Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Link: https://lore.kernel.org/r/20260129-fix_cid_check_rifsc-v1-1-ef280ccf764d@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/stm32_rifsc.c | 52 ++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/bus/stm32_rifsc.c b/drivers/bus/stm32_rifsc.c
index debeaf8ea1bd2..5682c086ba1e8 100644
--- a/drivers/bus/stm32_rifsc.c
+++ b/drivers/bus/stm32_rifsc.c
@@ -688,34 +688,6 @@ static int stm32_rifsc_grant_access(struct stm32_firewall_controller *ctrl, u32
 	sec_reg_value = readl(rifsc_controller->mmio + RIFSC_RISC_SECCFGR0 + 0x4 * reg_id);
 	cid_reg_value = readl(rifsc_controller->mmio + RIFSC_RISC_PER0_CIDCFGR + 0x8 * firewall_id);
 
-	/* First check conditions for semaphore mode, which doesn't take into account static CID. */
-	if ((cid_reg_value & CIDCFGR_SEMEN) && (cid_reg_value & CIDCFGR_CFEN)) {
-		if (cid_reg_value & BIT(RIF_CID1 + SEMWL_SHIFT)) {
-			/* Static CID is irrelevant if semaphore mode */
-			goto skip_cid_check;
-		} else {
-			dev_dbg(rifsc_controller->dev,
-				"Invalid bus semaphore configuration: index %d\n", firewall_id);
-			return -EACCES;
-		}
-	}
-
-	/*
-	 * Skip CID check if CID filtering isn't enabled or filtering is enabled on CID0, which
-	 * corresponds to whatever CID.
-	 */
-	if (!(cid_reg_value & CIDCFGR_CFEN) ||
-	    FIELD_GET(RIFSC_RISC_SCID_MASK, cid_reg_value) == RIF_CID0)
-		goto skip_cid_check;
-
-	/* Coherency check with the CID configuration */
-	if (FIELD_GET(RIFSC_RISC_SCID_MASK, cid_reg_value) != RIF_CID1) {
-		dev_dbg(rifsc_controller->dev, "Invalid CID configuration for peripheral: %d\n",
-			firewall_id);
-		return -EACCES;
-	}
-
-skip_cid_check:
 	/* Check security configuration */
 	if (sec_reg_value & BIT(reg_offset)) {
 		dev_dbg(rifsc_controller->dev,
@@ -723,19 +695,31 @@ static int stm32_rifsc_grant_access(struct stm32_firewall_controller *ctrl, u32
 		return -EACCES;
 	}
 
-	/*
-	 * If the peripheral is in semaphore mode, take the semaphore so that
-	 * the CID1 has the ownership.
-	 */
-	if ((cid_reg_value & CIDCFGR_SEMEN) && (cid_reg_value & CIDCFGR_CFEN)) {
+	/* Skip CID check if CID filtering isn't enabled */
+	if (!(cid_reg_value & CIDCFGR_CFEN))
+		goto skip_cid_check;
+
+	/* First check conditions for semaphore mode, which doesn't take into account static CID. */
+	if (cid_reg_value & CIDCFGR_SEMEN) {
+		if (!(cid_reg_value & BIT(RIF_CID1 + SEMWL_SHIFT))) {
+			dev_dbg(rifsc_controller->dev,
+				"Invalid bus semaphore configuration: index %d\n", firewall_id);
+			return -EACCES;
+		}
+
 		rc = stm32_rif_acquire_semaphore(rifsc_controller, firewall_id);
 		if (rc) {
-			dev_err(rifsc_controller->dev,
+			dev_dbg(rifsc_controller->dev,
 				"Couldn't acquire semaphore for peripheral: %d\n", firewall_id);
 			return rc;
 		}
+	} else if (FIELD_GET(RIFSC_RISC_SCID_MASK, cid_reg_value) != RIF_CID1) {
+		dev_dbg(rifsc_controller->dev, "Invalid CID configuration for peripheral: %d\n",
+			firewall_id);
+		return -EACCES;
 	}
 
+skip_cid_check:
 	return 0;
 }
 
-- 
2.53.0



