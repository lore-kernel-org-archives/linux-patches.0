Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C92F3DC4DA;
	Wed, 20 May 2026 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300724; cv=none; b=vCg31aMtwLWca8Jf59OEwbgxTpRYi7g0BKs73/dMNjpKaUEoQWJlc6w5+oAYE6+xWl6mrFmYiWsSP8h0q3SQBNdEEV4qGzcLlNgLh9uStmAjqTpPWHnD10Zbgax6PJEDGypOQo9eq9W+tyyJu6nIiwBwmGZotfisjzQAhmzwEUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300724; c=relaxed/simple;
	bh=cQGWmRWNKrjT2QAPjqXKUGMPrQA5EYl0P/ejHDVD0DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbMYnrLPqwiJVUdo5vKoxuMaQSKVC5tIcmAJPuaV1EaUHdoxscDbOPBfx2uLEOimFWmhrWnq2aWCsgqGQEr0fjASwIrlQCbEK6s0Vg0mxHryhGtjbeOd+EMyMfUkQK3tmg9zMAXzyhwPt/AKLRocgf3J/P0QH/hFQQU80jEp1lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZPqFHqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZPqFHqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD5B1F000E9;
	Wed, 20 May 2026 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300722;
	bh=mZGOw65GtQSvqIZhqqdoYRvACAaeoMS5h6pjeBOvqyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZPqFHqRWYwYRiGf8FcqYqsIgW84dN+fR6zUh4fFla/5zi7OIUxT9rBKsnDDcDxho
	 zb5OyFodpLT2FH8uH3rNgShQfiLCEeKrAKfSno+OeovyZfNcRff6Mz2Md86VC+LueZ
	 wWJsriDjoSL7bfBi/DXiKxzThE++gsWzFp42cP4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/666] bus: rifsc: fix RIF configuration check for peripherals
Date: Wed, 20 May 2026 18:18:13 +0200
Message-ID: <20260520162117.327509773@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4cf1b60014b77..59872134c3224 100644
--- a/drivers/bus/stm32_rifsc.c
+++ b/drivers/bus/stm32_rifsc.c
@@ -126,34 +126,6 @@ static int stm32_rifsc_grant_access(struct stm32_firewall_controller *ctrl, u32
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
@@ -161,19 +133,31 @@ static int stm32_rifsc_grant_access(struct stm32_firewall_controller *ctrl, u32
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



