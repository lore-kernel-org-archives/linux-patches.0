Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F229D26E;
	Wed, 20 May 2026 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298530; cv=none; b=cTJSw/4qwVEWBOChYYtvQvMkhYtJP2Bmv2ORnnabud/PL6cTeq7EqJvjz/2VrMXWgcr1tf3t14c7BbyLz50H7eG4c9G9nuZBCuLAouv1UpUId4MAwnvMUfH+lpCWjU+WsqS7KGD1K2etgD84Psq/LrmAaCBtDWeVFdwLsVFht+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298530; c=relaxed/simple;
	bh=8tiykWunJ9UjQExS2t81RPitN0vlvYx9EnEHwXb9Q8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUBkmkExf42sdGkaeOWPkL+w/e17nvLMNKbKAT09LpYkp4d5p+WsDr1eQhszE5hSXFJcYjOQjHuZj4BLsKrk5WdaluC8GUVDIedhKR324J1FDK7XfC8EJqFB9W1foZ9lFvJLQCTdNmupTUGL9zSYZaFNZGQDKF2D8RWcKNC0/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOL32bYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOL32bYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F315C1F000E9;
	Wed, 20 May 2026 17:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298528;
	bh=fYKRTCCllDr/a5gnoblQjiJZGwwjAm/1yURBg5Ove0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOL32bYtoAE+2BPqcWtUSGxulXnduiN65KcEJ7hyvxMFvwP5SugWudDvBz9ZcNKRz
	 e6YJpO+6pVERQnFzUyTIaTN7iaETErukfyOeyW/U+9z39GK/duRsOrpJ7lEUuTzAaW
	 uEF8rdm3wNiokMwkL0wNBGpgC0ieDVKYJi/ZtwMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 394/957] bus: rifsc: fix RIF configuration check for peripherals
Date: Wed, 20 May 2026 18:14:37 +0200
Message-ID: <20260520162143.072138610@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



