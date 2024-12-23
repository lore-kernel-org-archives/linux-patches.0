Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048D012D1F1;
	Mon, 23 Dec 2024 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969830; cv=none; b=cH5Yxjo1hWaxALI1JGCjnVEByAx9nvHzBSYTBbKMStkULuGDOPUu5mHG7fyboNX+8fMdhkC5L/gmjfN0IDVSpbiwuW58QUI2HxhmfpVfg5Pi5V1CEP6wrMcF68kNZKU4rK4wqAmby+3d/TT5cqcYu8O3Ftm27tRzxlA1zpaQuzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969830; c=relaxed/simple;
	bh=htIJliPNJbYaKpf26269lnDHkWxSME7Zy3yFtxXelzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz3q8uZMT2dBG+90Bo0eayfdLYh8V6LqA6ZVSDDVE/xQoYc4sQJ+uhUFM5G00Sa0d5p04MBCNSddSpVqU1fPzT9+e5CBKGJKeATmEiopleDM1gpogPg1Wf7bH9AEBsc6Jcj6c3SkvIcF7KK4UIIwrj+6ldG0FVeGDPWKI+ZoTmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kq2WdqiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kq2WdqiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74557C4CED3;
	Mon, 23 Dec 2024 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969829;
	bh=htIJliPNJbYaKpf26269lnDHkWxSME7Zy3yFtxXelzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kq2WdqiVEOLfTixMWrzg7QGrtnV9gsxt/mMIAxVpH/3M7FjNPirtRMIDkL228rwjP
	 yR0zDIvvRLqNC0TFJEHhOvho6XT/+sr+nxpLXjuHUpPUMMhQ/hpY56LSkLaowqtA4A
	 hJG+ollM8mUEhSpljb+c1b8xtjQcifayrRASg2s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 066/160] EDAC/amd64: Simplify ECC check on unified memory controllers
Date: Mon, 23 Dec 2024 16:57:57 +0100
Message-ID: <20241223155411.223865716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 747367340ca6b5070728b86ae36ad6747f66b2fb upstream.

The intent of the check is to see whether at least one UMC has ECC
enabled. So do that instead of tracking which ones are enabled in masks
which are too small in size anyway and lead to not loading the driver on
Zen4 machines with UMCs enabled over UMC8.

Fixes: e2be5955a886 ("EDAC/amd64: Add support for AMD Family 19h Models 10h-1Fh and A0h-AFh")
Reported-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Avadhut Naik <avadhut.naik@amd.com>
Reviewed-by: Avadhut Naik <avadhut.naik@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20241210212054.3895697-1-avadhut.naik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/amd64_edac.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3362,36 +3362,24 @@ static bool dct_ecc_enabled(struct amd64
 
 static bool umc_ecc_enabled(struct amd64_pvt *pvt)
 {
-	u8 umc_en_mask = 0, ecc_en_mask = 0;
-	u16 nid = pvt->mc_node_id;
 	struct amd64_umc *umc;
-	u8 ecc_en = 0, i;
+	bool ecc_en = false;
+	int i;
 
+	/* Check whether at least one UMC is enabled: */
 	for_each_umc(i) {
 		umc = &pvt->umc[i];
 
-		/* Only check enabled UMCs. */
-		if (!(umc->sdp_ctrl & UMC_SDP_INIT))
-			continue;
-
-		umc_en_mask |= BIT(i);
-
-		if (umc->umc_cap_hi & UMC_ECC_ENABLED)
-			ecc_en_mask |= BIT(i);
+		if (umc->sdp_ctrl & UMC_SDP_INIT &&
+		    umc->umc_cap_hi & UMC_ECC_ENABLED) {
+			ecc_en = true;
+			break;
+		}
 	}
 
-	/* Check whether at least one UMC is enabled: */
-	if (umc_en_mask)
-		ecc_en = umc_en_mask == ecc_en_mask;
-	else
-		edac_dbg(0, "Node %d: No enabled UMCs.\n", nid);
-
-	edac_dbg(3, "Node %d: DRAM ECC %s.\n", nid, (ecc_en ? "enabled" : "disabled"));
-
-	if (!ecc_en)
-		return false;
-	else
-		return true;
+	edac_dbg(3, "Node %d: DRAM ECC %s.\n", pvt->mc_node_id, (ecc_en ? "enabled" : "disabled"));
+
+	return ecc_en;
 }
 
 static inline void


