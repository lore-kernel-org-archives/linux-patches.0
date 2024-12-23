Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCA113BC0C;
	Mon, 23 Dec 2024 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970366; cv=none; b=anlrMZO2kb2+BM1KwwWjuo9NIHn4DyTc1NSLFLxdWWDwUSwx1ht32tfXLD0XWnn8deO6FpZ1YqhOCeIxUsYX7318NpzK6jEQPufduK0Zhn8UzRBBUuvcgvcsa3mkgwwtyRjBqlm6gumjSbsuwdv5aODVS/B/yttLa2QcFk52UJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970366; c=relaxed/simple;
	bh=YtRn3dB3TJ1s/QL/IMYMVW8nZDl9LPsPizDc+oStKeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS7uRxXylOiwXjy0mmyPoGWvWph6QjfvpvCfBCq5FP5fX95ci+F48KNUm+Kw7X/3SbZlcAPJ5ewMirNaDmy5Hhxe4rkxRespvrX8+4V+vif29qW14MyMQ2QS5VdWOl5HQpWzAFke1REZi/dfbsRBYyqGUow4AzqjItAZgueOnuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Chpo8G39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Chpo8G39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D1DC4CED3;
	Mon, 23 Dec 2024 16:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970366;
	bh=YtRn3dB3TJ1s/QL/IMYMVW8nZDl9LPsPizDc+oStKeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Chpo8G39GcTWDwOfZrhWyTo73aEkljVn9A8fG03RIzEzFbhTftiqXV8kD3BEQqRGz
	 EhCimS5rJQ/z/2RNgPIAFtz2RnKdwZJzL3C1aoePRfSrlKZ3dawRb5zMG1HM1qIOF5
	 BnRMFIuPeQZNwSWzhtI/Ip0fAuC4xEZUl89L0f60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 060/116] EDAC/amd64: Simplify ECC check on unified memory controllers
Date: Mon, 23 Dec 2024 16:58:50 +0100
Message-ID: <20241223155401.898552194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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
@@ -3620,36 +3620,24 @@ static bool dct_ecc_enabled(struct amd64
 
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


